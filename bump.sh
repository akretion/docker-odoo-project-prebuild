#!/bin/bash
set -e
if [[ -d src ]]
then
    cd src
    git reset --hard 12.0
    cd ..
else
    git clone https://github.com/oca/ocb src
fi

rm -f odoo-frozen.yaml
ak build -c odoo-spec.yaml
ak freeze -c odoo-spec.yaml -o odoo-frozen.yaml
git add odoo-frozen.yaml

rm -f frozen.yaml
ak build
ak freeze
git add frozen.yaml

#TAG="12.0-`date +%Y%m%d`"
#MESSAGE="Automatic release $TAG"
#git commit -m "$MESSAGE"
#git tag -a "$TAG" -m "$MESSAGE"
#echo "bump done, check result the run"
#echo "git push origin 12.0 --tag"
