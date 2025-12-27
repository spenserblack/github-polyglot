# github-polyglot

Linguist, but for the user instead of the repository.

This scans all of the repositories that the user has and compiles the language stats.

If the `GITHUB_TOKEN` environment variable is set, it can use that token to get more
accurate stats and avoid rate-limiting. You can also avoid needing to pass `--username`
if you have the token set.

[dotenv-gem]: https://github.com/bkeepers/dotenv
