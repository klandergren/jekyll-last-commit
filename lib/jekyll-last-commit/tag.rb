module JekyllLastCommit
  class Tag < Liquid::Tag
    def initialize(tag_name, date_format, tokens)
      super
      @date_format = date_format.empty? ? nil : date_format.strip
    end

    def render(context)
      @date_format ||= default_date_format(context)

      page = context.registers[:page]

      time = page['last_modified_at']

      time.nil? ? "" : Time.at(time.to_i).strftime(@date_format)
    end

    def default_date_format(context)
      site = context.registers[:site]

      date_format = site.config.dig('jekyll-last-commit', 'date_format')
      date_format ||= '%B %d, %Y'

      date_format
    end

  end

end

Liquid::Template.register_tag('last_modified_at', JekyllLastCommit::Tag)
