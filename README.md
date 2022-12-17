# jekyll-last-commit

[Jekyll](https://jekyll.rb) plugin to access the last commit information for a file.

## performance comparison to `jekyll-last-modified-at`

### site with ~1400 pages

generation command (note: no use of `---incremental`):

```
$ JEKYLL_ENV=development bundle exec --gemfile=./static-site/Gemfile jekyll serve --port 4001 --source ./static-site --destination /tmp/_site_development
```

| case | baseline | jekyll-last-modified-at | jekyll-last-commit | improvement |
| --- | --- | --- | --- | --- |
| initial generation | 16.480 s | 79.601 s | 22.447 s | ~71% improvement |
| subsequent generation | 15.727 s | 78.200 s | 20.739 s | ~73% improvement |  |
