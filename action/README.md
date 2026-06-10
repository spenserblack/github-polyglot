# GitHub Polyglot action

This action runs the `github-polyglot` gem in a Docker container.

## Inputs

### `token`

Optional. GitHub API token to avoid rate limits when scanning repository language details.

### `user`

Optional. The user to collect data for. Defaults to the owner of the repository that is running
the action.

### `format`

Optional. The format of the output. Defaults to `print` (a display format for terminal display).

## Outputs

### `output`

The output of the `github-polyglot` gem.

## Example

```yaml
# ...
steps:
- uses: spenserblack/github-polyglot/action@main
  id: github-polyglot
  with:
    token: ${{ secrets.PAT }}
    format: svg
- name: Create language stats image
  env:
    SVG: ${{ steps.github-polyglot.outputs.output }}
  run: echo "$SVG" > language-stats.svg
  # Commit the SVG with your favorite commands or actions
```
