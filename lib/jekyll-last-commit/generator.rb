require 'jekyll'

module JekyllLastCommit
  class Generator < Jekyll::Generator

    def generate(site)
      repo_man = JekyllLastCommit::RepoMan.new(site.source)
      repo_man.discover_repo()
      repo_man.discover_commits(site.documents.map {|d| d.relative_path })
      repo_man.discover_commits(site.pages.map {|p| p.relative_path })

      site.documents.each do |document|
        commit = repo_man.find_commit(document.relative_path)

        unless commit.nil?
          document.data['last_commit'] = commit
          document.data['last_modified_at'] = Time.at(commit["time"].to_i)
        end
      end

      site.pages.each do |page|
        commit = repo_man.find_commit(page.relative_path)

        unless commit.nil?
          page.data['last_commit'] = commit
          page.data['last_modified_at'] = Time.at(commit["time"].to_i)
        end
      end
    end

  end
end
