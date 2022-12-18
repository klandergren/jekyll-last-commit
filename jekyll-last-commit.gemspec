Gem::Specification.new do |s|
  s.name        = 'jekyll-last-commit'
  s.version     = '0.0.2'
  s.summary     = "Jekyll plugin to access the last git commit for a file."
  s.description = "Gives access to a file's most recent commit date, message, sha, and author/committer information."
  s.authors     = ["Kip Landergren"]
  s.email       = 'kip@kip.land'
  s.license     = "MIT"
  s.homepage    = 'https://github.com/klandergren/jekyll-last-commit'
  s.files       = Dir['lib/**/*.rb']

  s.add_runtime_dependency "jekyll", '>= 3.7', ' < 5.0'
  s.add_runtime_dependency "rugged", '~> 1.1'

  s.required_ruby_version = '>= 2.3', '< 4'
end
