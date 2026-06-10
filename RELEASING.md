# Releasing

This document provides a checklist for creating a new release.

## Tasks

1. Update [`action/Dockerfile`](./action/Dockerfile) to use the soon-to-be-created tag in `FROM`.
2. Push the new tag with `git tag <TAG_NAME>` and `git push origin <TAG_NAME>`.
   - The [release workflow](./.github/workflows/release.yml) should handle creating a draft release
     and pushing a new Docker image.
3. Publish the drafted release.
4. Publish the Ruby gem.
