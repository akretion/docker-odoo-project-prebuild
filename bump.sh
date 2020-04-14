#!/bin/bash
set -e
TAG="12.0-`date +%Y%m%d`"
MESSAGE="Automatic release $TAG"
git commit -m "$MESSAGE"
git tag -a "$TAG" -m "$MESSAGE"
echo "bump done, check result the run"
echo "git push origin 12.0 --tag"
