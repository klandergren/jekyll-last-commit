# jekyll-last-commit

[Jekyll](https://jekyll.rb) [generator plugin](https://jekyllrb.com/docs/plugins/generators/) and [liquid tag](https://jekyllrb.com/docs/plugins/tags/) to access the last commit information for a file.

Use cases:

- accessing the last commit date for a site page or document
- getting the last committer name or email for a site page or document
- performant access to `page.last_modified_at` for Jekyll sites with very large page counts (100s+)

Inspired by the work done at [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at) and aimed at improved performance. Seeks to be drop-in replacement. Uses [libgit2/rugged](https://github.com/libgit2/rugged) rather than spawning a process.

**Important:**

- ignores commits where a file has been renamed without content changes
- has not been tested on Windows

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
| `{{ page.last_commit.author.email }}` | klandergren@users.noreply.github.com |
| `{{ page.last_commit.author.time }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_commit.committer.name }}` | Kip Landergren |
| `{{ page.last_commit.committer.email }}` | klandergren@users.noreply.github.com |
| `{{ page.last_commit.committer.time }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_commit.message }}` | add new pages to the site |
| `{{ page.last_commit.time }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_commit.time_epoch }}` | 1671244253 |
| `{{ page.last_modified_at }}` | 2022-12-16 18:30:53 -0800 |
| `{{ page.last_modified_at \| date: '%F' }}` | 2022-12-16 |
| `{{ page.last_modified_at_formatted }}` | December 16, 2022 |
| `{{ site.data.meta[data_file].last_modified_at_formatted }}` | December 16, 2022 |
| `{% last_modified_at %}` | December 16, 2022 |
| `{% last_modified_at %F %}` | 2022-12-16 |


## Installation

Add to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-last-commit"
end
```

and run `bundle install`.

## Configuration

All of the following are optional:
```yml
jekyll-last-commit:
  date_format: '%F'        # default: `%B %d, %Y`
  # if a commit is not found `File.mtime` is used
  should_fall_back_to_mtime: false # default: `true`
  # information about data files is stored in a seperate site.data hash
  data_files_key: 'meta'           # default: meta
```

The use case for `should_fall_back_to_mtime` is so that rendering of a file that is not yet tracked by `git` looks correct (e.g. a new, uncommitted blog post).

## Date Format Directives

See [Time#strftime](https://ruby-doc.org/3.1.3/Time.html#method-i-strftime) documentation for available date format directives.

### Data files

Information about data files is stored in `site.data.meta`. The name of the key in `site.data` can be configured in `_config.yml`.

### Examples

| format | example output |
| --- | --- |
| default (`%B %d, %Y`), via `{{ page.last_modified_at_formatted }}` | December 11, 2022 |
| `{{ page.last_modified_at \| date: '%c' }}` | Fri Dec 16 18:30:53 2022 |
| `{{ page.last_modified_at \| date: '%F' }}` | 2022-12-16 |
| `{{ page.last_modified_at \| date: '%D' }}` | 12/16/22 |
| `{{ page.last_modified_at \| date: '%v' }}` | 16-DEC-2022 |
| `{{ page.last_modified_at \| date: '%r' }}` | 06:30:53 PM |
| `{{ page.last_modified_at \| date: '%R' }}` | 18:30 |
| `{{ page.last_modified_at \| date: '%T' }}` | 18:30:53 |

## Documentation

-   [`page.last_commit`](#pagelast_commit)
    -   [`page.last_commit.author`](#pagelast_commitauthor)
        -   [`page.last_commit.author.email`](#pagelast_commitauthor)
        -   [`page.last_commit.author.name`](#pagelast_commitauthor)
        -   [`page.last_commit.author.time`](#pagelast_commitauthor)
    -   [`page.last_commit.committer`](#pagelast_commitcommitter)
        -   [`page.last_commit.committer.email`](#pagelast_commitcommitter)
        -   [`page.last_commit.committer.name`](#pagelast_commitcommitter)
        -   [`page.last_commit.committer.time`](#pagelast_commitcommitter)
    -   [`page.last_commit.message`](#pagelast_commit)
    -   [`page.last_commit.sha`](#pagelast_commit)
    -   [`page.last_commit.time`](#pagelast_commit)
    -   [`page.last_commit.time_epoch`](#pagelast_commit)
-   [`page.last_modified_at`](#pagelast_modified_at)
-   [`page.last_modified_at_formatted`](#pagelast_modified_at_formatted)
-   [`last_modified_at`](#last_modified_at)

### `page.last_commit`

Gives access to the underlying rugged commit object information.

**Important: ignores commits where a file has been renamed without content changes**

| field | type | usage |
| --- | --- | --- |
| author | `Hash` object | see [`page.last_commit.author`](#pagelast_commitauthor) |
| committer | `Hash` object | see [`page.last_commit.committer`](#pagelast_commitcommitter) |
| message | `String` | `{{ page.last_commit.message }}` |
| sha | `String` | `{{ page.last_commit.sha }}` |
| time | `Time` object | `{{ page.last_commit.time }}` |
| time_epoch | `Integer` | `{{ page.last_commit.time_epoch }}` |

### `page.last_commit.author`

Information about the author of the last commit for this file.

| field | type | usage |
| --- | --- | --- |
| email | `String` | `{{ page.last_commit.author.email }}` |
| name | `String` | `{{ page.last_commit.author.name }}` |
| time | `Time` object | `{{ page.last_commit.author.time }}` |

### `page.last_commit.committer`

Information about the committer of the last commit for this file.

| field | type | usage |
| --- | --- | --- |
| email | `String` | `{{ page.last_commit.committer.email }}` |
| name | `String` | `{{ page.last_commit.committer.name }}` |
| time | `Time` object | `{{ page.last_commit.committer.time }}` |

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

Override in `_config.yml` via:

```yml
jekyll-last-commit:
  date_format: '%F'
```

If you need a per-page date format, use `{{ page.last_modified_at | date: '%F }}'` with whatever format string you want.

### `last_modified_at`

A liquid tag that renders the formatted date using either the passed date format string, what was specified in `_config.yml`, or the default `%B %d, %Y`:

```html
<p>{% last_modified_at %}</p>
<p>{% last_modified_at %F %D %}</p>
```

Added solely to be drop-in replacement with [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at).

## Performance

Comparison made to [gjtorikian/jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at) on a 2017 MacBook Pro running a 3.1 GHz Quad-Core Intel Core i7

### site with ~1400 pages and ~2500 commits

generation command (note: no use of `---incremental`):

```shell
$ JEKYLL_ENV=development bundle exec --gemfile=./static-site/Gemfile jekyll serve --port 4001 --source ./static-site --destination /tmp/_site_development
```

| case | baseline | jekyll-last-modified-at | jekyll-last-commit | improvement |
| --- | --- | --- | --- | --- |
| initial generation | 16.480 s | 79.601 s | 22.447 s | ~71% improvement |
| subsequent generation | 15.727 s | 78.200 s | 20.739 s | ~73% improvement |  |

## How It Works

Walks the commit history until all documents and pages are matched to a commit. Falls back to `File.mtime` when no commit found. Runs fresh on each site generation.

## FAQ

### Why not just improve gjtorikian/jekyll-last-modified-at ?

See [improving render performance via PATH_CACHE usage and bulk git log ... call #85](https://github.com/gjtorikian/jekyll-last-modified-at/issues/85) which includes two PRs more in line with that repository’s architecture and conventions.

### Why not fork gjtorikian/jekyll-last-modified-at ?

Grabbing data via [libgit2/rugged](https://github.com/libgit2/rugged) would be too big of a rewrite for what is a very popular plugin. If folks have performance issues getting `page.last_modified_at` they can safely compare their options using this!

### Will this work with GitHub Pages?

I don’t think so: my understanding is that GitHub Pages performs a shallow clone. I have not tried!
