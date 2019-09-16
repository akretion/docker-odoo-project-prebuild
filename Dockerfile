FROM camptocamp/odoo-project:12.0-latest-batteries AS builder
RUN /install/dev_package.sh
RUN pip install git+https://github.com/akretion/ak
RUN git config --global user.email "bot@akretion.com"
RUN git config --global user.name "Akretion Bot"
COPY spec.yaml /odoo/spec.yaml
COPY frozen.yaml /odoo/frozen.yaml
WORKDIR /odoo

RUN ak build
RUN find . -name *.po ! -name 'fr.po' -type f -exec rm -v {} +
RUN find . -name .git -type d -exec rm -rf -v {} +
WORKDIR /odoo/src
RUN find . -name l10n_* ! -name 'l10n_fr*' ! -name 'l10n_generic_coa*' ! -type d -exec rm -rf -v {} +
RUN find . -name website* -type d -exec rm -rf -v {} +
RUN find . -name theme* -type d -exec rm -rf -v {} +
RUN find . -name *survey* -type d -exec rm -rf -v {} +
RUN find . -name hw* -type d -exec rm -rf -v {} +

FROM camptocamp/odoo-project:12.0-latest-batteries

RUN apt-get update \
    && apt-get install -y --no-install-recommends git vim

COPY --from=builder /odoo /prebuild
RUN ln -s /prebuild/src /odoo/src
RUN pip install -e /odoo/src

ENV ADDONS_PATH /odoo/local-src,/odoo/src/addons,/odoo/links
