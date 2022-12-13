Gem::Specification.new do |s|
  s.name        = 'jekyll-last-commit'
  s.version     = '0.0.1'
  s.summary     = "Jekyll plugin to access the last git commit for a file."
  s.description = "Gives access to a file's most recent commit date, message, sha, and author/committer information."
  s.authors     = ["Kip Landergren"]
  s.email       = 'kip@kip.land'
  s.license     = "MIT"
  s.homepage    = 'https://github.com/klandergren/jekyll-last-commit'
  s.files       = ["lib/jekyll-last-commit.rb"]

  s.add_runtime_dependency "rugged", '~> 1.1'

end
