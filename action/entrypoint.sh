#!/bin/sh
OUTPUT="$(github-polyglot "$@")"

# NOTE: We still want to show the output to the user, which can be helpful if the user is using
#       the `print` format and just wants to see the output in the action log.
echo "$OUTPUT"

# NOTE: Save the output to the `output` output of the action
echo 'output<<EOF' >> "$GITHUB_OUTPUT"
echo "$OUTPUT" >> "$GITHUB_OUTPUT"
echo "EOF" >> "$GITHUB_OUTPUT"
