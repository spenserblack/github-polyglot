# github-polyglot

[![CI](https://github.com/spenserblack/github-polyglot/actions/workflows/ci.yml/badge.svg)](https://github.com/spenserblack/github-polyglot/actions/workflows/ci.yml)

Linguist, but for the user instead of the repository.

This scans all of the repositories that the user has and compiles the language stats.
The stats can be output as...

- A human-readable terminal output
- JSON
- An SVG file resembling the language bar

If the `GITHUB_TOKEN` environment variable is set, it can use that token to get more
accurate stats and avoid rate-limiting. You can also avoid needing to pass `--username`
if you have the token set.

## Building

### Prerequisites

This project depends on [Linguist][github-linguist], which has some dependencies that
may require extra steps. Read their documentation for more details.

#### On Ubuntu

```shell
sudo apt install build-essential cmake pkg-config libicu-dev zlib1g-dev libcurl4-openssl-dev libssl-dev ruby-dev
```

[dotenv-gem]: https://github.com/bkeepers/dotenv
[github-linguist]: https://github.com/github-linguist/linguist
