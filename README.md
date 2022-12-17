# jekyll-last-commit

[Jekyll](https://jekyll.rb) plugin to access the last commit information for a file. Uses [libgit2/rugged](https://github.com/libgit2/rugged) rather than spawning a process to access `git` repository information. Inspired by the work done at [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at) and aimed at improved performance.

Especially useful to get `page.last_modified_at` for Jekyll sites with very large page counts (100s+).

## Installation

Add to your `Gemfile`:

```
group :jekyll_plugins do
  gem "jekyll-last-commit"
end
```

and run `bundle install`.

## Example Usage

The following is the last (most recent) commit from a repo:

```
main 5fde57927efdb2f440dd40c802687b60384e5d9d
Author:     Kip Landergren <klandergren@users.noreply.github.com>
AuthorDate: Fri Dec 16 18:30:53 2022 -0800
Commit:     Kip Landergren <klandergren@users.noreply.github.com>
CommitDate: Fri Dec 16 18:30:53 2022 -0800

add new pages to the site
```

Its information can be accessed via:

| usage | rendered |
| --- | --- |
| `{{ page.last_commit.sha }}` | 5fde57927efdb2f440dd40c802687b60384e5d9d |
| `{{ page.last_commit.author.name }}` | Kip Landergren |
| `{{ page.last_commit.author.time }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_commit.author.email }}` | klandergren@users.noreply.github.com |
| `{{ page.last_commit.committer.name }}` | Kip Landergren |
| `{{ page.last_commit.committer.time }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_commit.committer.email }}` | klandergren@users.noreply.github.com |
| `{{ page.last_modified_at_formatted }}` | December 16, 2022 |
| `{{ page.last_modified_at \| date: '%F' }}` | 2022-12-16 |
| `{% last_modified_at %}` | December 16, 2022 |
| `{% last_modified_at %F %}` | 2022-12-16 |

## Documentation

### `page.last_commit`

Gives access to the underlying rugged commit object.

| field | type | usage |
| --- | --- | --- |
| message | `String` | `{{ page.last_commit.message }}` |
| sha | `String` | `{{ page.last_commit.sha }}` |
| time | `Time` object | `{{ page.last_commit.time }}` |
| time_epoch | `Integer` | `{{ page.last_commit.time_epoch }}` |
| committer | `Hash` object | see below |
| author | `Hash` object | see below |

Note:

- key symbols replaced with strings (to prevent `liquid` exceptions)
- field `time_epoch` is added
- field `tree` removed
- field `parents` removed

### `page.last_commit.committer`

Information about the committer of the last commit for this file.

| field | type | usage |
| --- | --- | --- |
| name | `String` | `{{ page.last_commit.committer.name }}` |
| email | `String` | `{{ page.last_commit.committer.email }}` |
| time | `Time` object | `{{ page.last_commit.committer.time }}` |

### `page.last_commit.author`

Information about the author of the last commit for this file.

| field | type | usage |
| --- | --- | --- |
| name | `String` | `{{ page.last_commit.author.name }}` |
| email | `String` | `{{ page.last_commit.author.email }}` |
| time | `Time` object | `{{ page.last_commit.author.time }}` |

### `page.last_modified_at`

The `Time` object associated with the last commit for this file.

Example default output: `2022-12-11 19:54:26 -0800`

Can be formatted using a liquid `date` filter:
```
{{ page.last_modified_at | date: '%B' }}
```
output:
```
December
```

### `page.last_modified_at_formatted`

The formatted `string` of the `Time` object associated with the last commit for this file. Format controlled via `_config.yml`.

Default format: `%B %d, %Y`

Example default output: `December 11, 2022`

Specify in `_config.yml` via:

```
jekyll-last-commit:
  date_format: '%F'
```

If you need a per-page date format, use `{{ page.last_modified_at | date: '%F }}'` with whatever format string you want.

### `last_modified_at`

A liquid tag that renders the formatted date using either the passed date format string, what was specified in `_config.yml`, or the default `%B %d, %Y`:

```
<p>{% last_modified_at %}</p>
<p>{% last_modified_at "%F %D" %}</p>
```

Added solely to be drop-in replacement with [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at).

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

See [improving render performance via PATH_CACHE usage and bulk git log ... call #85](https://github.com/gjtorikian/jekyll-last-modified-at/issues/85) which includes two PRs more in line with that repository’s architecture and conventions.

### Why not fork gjtorikian/jekyll-last-modified-at ?

Grabbing data via [libgit2/rugged](https://github.com/libgit2/rugged) would be too big of a rewrite for what is a very popular plugin. If folks have performance issues getting `page.last_modified_at` they can safely compare their options using this!
