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

We can then access commit data within our site content:

```
<section>
  <h2>Usage</h2>
  <table><tbody>
    <tr>
      <td>sha</td>
      <td>{{ page.last_commit.sha }}</td>
    </tr>
    <tr>
      <td>Author</td>
      <td>{{ page.last_commit.author.name }}</td>
    </tr>
    <tr>
      <td>Author Time</td>
      <td>{{ page.last_commit.author.time }}</td>
    </tr>
    <tr>
      <td>Author Email</td>
      <td>{{ page.last_commit.author.email }}</td>
    </tr>
    <tr>
      <td>Committer</td>
      <td>{{ page.last_commit.committer.name }}</td>
    </tr>
    <tr>
      <td>CommitterDate</td>
      <td>{{ page.last_commit.committer.time }}</td>
    </tr>
    <tr>
      <td>Committer Email</td>
      <td>{{ page.last_commit.committer.email }}</td>
    </tr>
    <tr>
      <td>Default Date Format</td>
      <td>{{ page.last_modified_at_formatted }}</td>
    </tr>
    <tr>
      <td>Custom Date Format</td>
      <td>{{ page.last_modified_at | date: '%F' }}</td>
    </tr>
    <tr>
      <td>Default Liquid Tag</td>
      <td>{% last_modified_at %}</td>
    </tr>
    <tr>
      <td>Custom Date Format Liquid Tag</td>
      <td>{% last_modified_at "%F" %}</td>
    </tr>
  </tbody></table>
</section>
```

Rendered:

```
<section>
  <h2>Usage</h2>
  <table><tbody>
    <tr>
      <td>sha</td>
      <td>5fde57927efdb2f440dd40c802687b60384e5d9d</td>
    </tr>
    <tr>
      <td>Author</td>
      <td>Kip Landergren</td>
    </tr>
    <tr>
      <td>Author Time</td>
      <td>2022-12-16 18:30:53 -0800</td>
    </tr>
    <tr>
      <td>Author Email</td>
      <td>klandergren@users.noreply.github.com</td>
    </tr>
    <tr>
      <td>Committer</td>
      <td>Kip Landergren</td>
    </tr>
    <tr>
      <td>CommitterDate</td>
      <td>2022-12-16 18:30:53 -0800</td>
    </tr>
    <tr>
      <td>Committer Email</td>
      <td>klandergren@users.noreply.github.com</td>
    </tr>
    <tr>
      <td>Default Date Format</td>
      <td>December 16, 2022</td>
    </tr>
    <tr>
      <td>Custom Date Format</td>
      <td>2022-12-16</td>
    </tr>
    <tr>
      <td>Default Liquid Tag</td>
      <td>December 16, 2022</td>
    </tr>
    <tr>
      <td>Custom Date Format Liquid Tag</td>
      <td>"2022-12-16"</td>
    </tr>
  </tbody></table>
</section>
```

## Documentation

### `page.last_commit`

Gives access to the underlying rugged commit object, with some minor modifications.

Modifications:

- key symbols replaced with strings (to prevent `liquid` exceptions)
- field `tree` removed
- field `parents` removed

Fields available:

| field | type | usage |
| --- | --- | --- |
| message | `String` | `{{ page.last_commit.message }}` |
| sha | `String` | `{{ page.last_commit.sha }}` |
| time | `Time` object | `{{ page.last_commit.time }}` |
| time_epoch | `Integer` | `{{ page.last_commit.time_epoch }}` |
| committer | `Hash` object | |
| author | `Hash` object | |

### `page.last_commit.committer`

Information about the committer of the last commit for this file.

Fields available:

| field | type | usage |
| --- | --- | --- |
| name | `String` | `{{ page.last_commit.committer.name }}` |
| email | `String` | `{{ page.last_commit.committer.email }}` |
| time | `Time` object | `{{ page.last_commit.committer.time }}` |

### `page.last_commit.author`

Information about the author of the last commit for this file.

Fields available:

| field | type | usage |
| --- | --- | --- |
| name | `String` | `{{ page.last_commit.author.name }}` |
| email | `String` | `{{ page.last_commit.author.email }}` |
| time | `Time` object | `{{ page.last_commit.author.time }}` |

### `page.last_modified_at`

The `Time` object associated with the last commit for this file.

Example default output: `2022-12-11 19:54:26 -0800`

Use with liquid date filter:
```
{{ page.last_modified_at | date: '%B' }}
```
output:
```
December
```

### `page.last_modified_at_formatted`

The formatted `string` of the `Time` object associated with the last commit for this file.

Default format: `%B %d, %Y`

Example default output: `December 11, 2022`

Control via:

```
jekyll-last-commit:
  date_format: '%F'
```

If you need a per-page date format, use `{{ page.last_modified_at | date: '%F }}'` with whatever format string you want.

### `last_modified_at`

A liquid tag renders the formatted date using either the passed date format string, what was specified in `_config.yml`, or the default `%B %d, %Y`;

```
<p>{% last_modified_at %}</p>
<p>{% last_modified_at "%F %D" %}</p>
```

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

I did! I have two open PRs which take an approach more in line with that codebase’s architecture and conventions. See [improving render performance via PATH_CACHE usage and bulk git log ... call #85](https://github.com/gjtorikian/jekyll-last-modified-at/issues/85)

### Why not fork gjtorikian/jekyll-last-modified-at ?

I realized that all the information I wanted could be grabbed via [libgit2/rugged](https://github.com/libgit2/rugged) and not involve a complete rewrite of a very popular plugin. If folks have performance issues they can safely compare their options using this!
