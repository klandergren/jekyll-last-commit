require 'jekyll'

module JekyllLastCommit
  class Generator < Jekyll::Generator

    def generate(site)
      repo_man = JekyllLastCommit::RepoMan.new(site.source)
      repo_man.discover_repo()
      repo_man.discover_commits(site.documents.map {|d| d.relative_path })
      repo_man.discover_commits(site.pages.map {|p| p.relative_path })

      date_format = site.config.dig('jekyll-last-commit', 'date-format')
      date_format ||= '%B %d, %Y'

      site.documents.each do |document|
        commit = repo_man.find_commit(document.relative_path)

        unless commit.nil?
          raw_time = Time.at(commit["time"].to_i)

          document.data['last_commit'] = commit
          document.data['last_modified_at'] = raw_time
          document.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
        end
      end

      site.pages.each do |page|
        commit = repo_man.find_commit(page.relative_path)

        unless commit.nil?
          raw_time = Time.at(commit["time"].to_i)

          page.data['last_commit'] = commit
          page.data['last_modified_at'] = raw_time
          page.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
        end
      end
    end

  end
end
