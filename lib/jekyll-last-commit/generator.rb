require 'jekyll'

module JekyllLastCommit
  class Generator < Jekyll::Generator

    def generate(site)
      repo_man = JekyllLastCommit::RepoMan.new(site.source)
      repo_man.discover_repo()

      data_file_extensions = ['.yml', '.yaml', '.json', '.tsv', '.csv']
      data_files = []
      site.data.keys.each do |data_file|
        data_file_extensions.each do |data_file_extension|
          data_file_name = data_file + data_file_extension
          if File.file?('./_data/' + data_file_name)
            data_files.append(data_file_name)
            break
          end
        end
      end     

      repo_man.discover_commits(site.documents.map {|d| d.relative_path })
      repo_man.discover_commits(site.pages.map {|p| p.relative_path })
      repo_man.discover_commits(data_files.map {|df| './_data/' + df })

      date_format = site.config.dig('jekyll-last-commit', 'date_format')
      date_format ||= '%B %d, %Y'

      data_files_key = site.config.dig('jekyll-last-commit', 'data_files_key')
      data_files_key ||= 'meta'

      should_fall_back_to_mtime = site.config.dig('jekyll-last-commit', 'should_fall_back_to_mtime')
      should_fall_back_to_mtime = should_fall_back_to_mtime.nil? ? true : should_fall_back_to_mtime

      site.documents.each do |document|
        commit = repo_man.find_commit(document.relative_path)

        if commit.nil?
          if should_fall_back_to_mtime
            path_document = Jekyll.sanitized_path(site.source, document.relative_path)

            if File.file?(path_document)
              raw_time = Time.at(File.mtime(path_document).to_i)

              Jekyll.logger.warn "JekyllLastCommit: unable to find commit information for #{document.relative_path}. falling back to `mtime` for last_modified_at"
              document.data['last_modified_at'] = raw_time
              document.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
            end
          end
        else
          raw_time = Time.at(commit["time"].to_i)
          document.data['last_commit'] = commit
          document.data['last_modified_at'] = raw_time
          document.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
        end
      end

      site.data[data_files_key] = {}
      data_files.each do |data_file|
        site.data[data_files_key][data_file] = {}

        relative_path = './_data/' + data_file
        commit = repo_man.find_commit(relative_path)

        if commit.nil?
          if should_fall_back_to_mtime
            path_data_file = Jekyll.sanitized_path(site.source, relative_path)

            if File.file?(data_file)
              raw_time = Time.at(File.mtime(path_data_file).to_i)
              site.data[data_files_key][data_file]['last_modified_at'] = raw_time
              site.data[data_files_key][data_file]['last_modified_at_formatted'] = raw_time.strftime(date_format)
            end
          end
        else
          raw_time = Time.at(commit['time'].to_i)
          site.data[data_files_key][data_file]['last_commit'] = commit
          site.data[data_files_key][data_file]['last_modified_at'] = raw_time
          site.data[data_files_key][data_file]['last_modified_at_formatted'] = raw_time.strftime(date_format)
        end
      end

      site.pages.each do |page|
        commit = repo_man.find_commit(page.relative_path)

        if commit.nil?
          if should_fall_back_to_mtime
            path_page = Jekyll.sanitized_path(site.source, page.relative_path)

            if File.file?(path_page)
              raw_time = Time.at(File.mtime(path_page).to_i)
              page.data['last_modified_at'] = raw_time
              page.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
            end
          end

        else
          raw_time = Time.at(commit["time"].to_i)
          page.data['last_commit'] = commit
          page.data['last_modified_at'] = raw_time
          page.data['last_modified_at_formatted'] = raw_time.strftime(date_format)
        end
      end
    end
  end
end