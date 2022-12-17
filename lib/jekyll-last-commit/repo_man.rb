require 'pathname'
require 'rugged'
require 'set'

module JekyllLastCommit
  class RepoMan

    def initialize(path_site)
      @path_site = Pathname.new(path_site)
    end

    def discover_repo
      begin
        @repo = Rugged::Repository.discover(@path_site)

        path_dot_git = Pathname.new(@repo.path)
        path_repo = path_dot_git.parent

        # necessary to handle situations where site is not top level in repo
        @path_relative = @path_site.relative_path_from(path_repo)

      rescue
        Jekyll.logger.warn "JekyllLastCommit: unable to find git repository at #{@path_site}"
      end
    end

    def discover_commits(relative_file_paths)
      return if @repo.nil?

      document_paths = relative_file_paths.map {|rfp| generate_relative_path(rfp) }.to_set

      # gets updated with renames pointing to original path
      paths_lookup = document_paths.reduce({}) do |memo, original_path|
        memo[original_path] = original_path
        memo
      end

      # starting with the most recent commit, look for data on paths_undetermined
      walker = Rugged::Walker.new(@repo)
      walker.push(@repo.head.target.oid) # start with most recent commit

      find_similar_opts = {rename_limit: 1000}

      @paths_determined ||= {}

      walker.each_with_index do |commit, i|
        diff = commit.diff

        # ignore renames
        diff.find_similar!(**find_similar_opts)

        diff.deltas.each do |delta|
          new_file_path = delta.new_file[:path]

          original_path = paths_lookup[new_file_path]

          if document_paths.include?(new_file_path)
            if delta.status == :renamed
              # special case
              old_file_path = delta.old_file[:path]

              paths_lookup[old_file_path] = original_path

              # no longer looking for the new file, looking for the old file
              document_paths.delete(new_file_path)
              document_paths.add(old_file_path)
            else
              @paths_determined[original_path] = commit
              document_paths.delete(new_file_path)
            end
          end
        end

        break if document_paths.empty?
      end
    end

    def find_commit(relative_path)
      return nil if @repo.nil?

      commit = @paths_determined[generate_relative_path(relative_path)]

      return nil if commit.nil?

      commit_hash = commit.to_hash
                      .tap {|h| h.delete(:tree) }    # just reduce noise; can always add back later
                      .tap {|h| h.delete(:parents) }
                      .transform_keys(&:to_s)        # transform symbols to keys so liquid will render
                      .transform_values {|v| v.is_a?(Hash) ? v.transform_keys(&:to_s) : v.strip! }
      commit_hash['sha'] = commit.oid
      commit_hash['time'] = commit.time
      commit_hash['time_epoch'] = commit.time.to_i

      commit_hash
    end

    private

    def generate_relative_path(relative_path)
      (@path_relative + Pathname.new(relative_path)).to_s
    end

  end
end
