#!/bin/bash
set -e
rm -f frozen.yaml
cd src
git reset --hard 10.0
cd ..
ak build
ak freeze
git add frozen.yaml
TAG="10.0-`date +%Y%m%d`"
MESSAGE="Automatic release $TAG"
git commit -m "$MESSAGE"
git tag -a "$TAG" -m "$MESSAGE"
echo "bump done, check result the run"
echo "git push origin 10.0 --tag"
