#!/bin/bash
set -e
echo "Update Odoo"
rm odoo-frozen.yaml
ak build -c odoo-spec.yaml
ak freeze -c odoo-spec.yaml -o odoo-frozen.yaml

echo "Update OCA"
rm frozen.yaml
ak build
ak freeze

echo "Update finished"
