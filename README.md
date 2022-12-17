# jekyll-last-commit

[Jekyll](https://jekyll.rb) plugin to access the last commit information for a file. Uses [libgit2/rugged](https://github.com/libgit2/rugged) rather than spawning a process to query `git` repository information. Inspired by the work done at [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at) and aimed at improved performance.

## Performance

Comparison made to [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at)

### site with ~1400 pages

generation command (note: no use of `---incremental`):

```
$ JEKYLL_ENV=development bundle exec --gemfile=./static-site/Gemfile jekyll serve --port 4001 --source ./static-site --destination /tmp/_site_development
```

| case | baseline | jekyll-last-modified-at | jekyll-last-commit | improvement |
| --- | --- | --- | --- | --- |
| initial generation | 16.480 s | 79.601 s | 22.447 s | ~71% improvement |
| subsequent generation | 15.727 s | 78.200 s | 20.739 s | ~73% improvement |  |


## FAQ

### Why not just improve gjtorikian/jekyll-last-modified-at ?

I did! I have two open PRs which take an approach more inline with that existing codebase. See [improving render performance via PATH_CACHE usage and bulk git log ... call #85](https://github.com/gjtorikian/jekyll-last-modified-at/issues/85)

### Why not fork gjtorikian/jekyll-last-modified-at ?

I realized that all the information I wanted could be grabbed via [libgit2/rugged](https://github.com/libgit2/rugged) and not involve a complete rewrite of a very popular plugin. If folks have performance issues they can safely compare their options using this!
