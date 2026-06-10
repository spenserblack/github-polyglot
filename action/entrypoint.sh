#!/bin/sh -l
OUTPUT="$(github-polyglot "$@")"
echo "output=$OUTPUT" >> $GITHUB_OUTPUT
