FROM camptocamp/odoo-project:10.0-3.1.2-batteries AS builder
RUN /install/dev_package.sh
RUN pip install git+https://github.com/akretion/ak
RUN git config --global user.email "bot@akretion.com"
RUN git config --global user.name "Akretion Bot"
COPY spec.yaml /odoo/spec.yaml

WORKDIR /odoo

RUN ak build


FROM camptocamp/odoo-project:10.0-3.1.2-batteries

RUN apt-get update \
    && apt-get install -y --no-install-recommends git vim

COPY --from=builder /odoo /odoo
RUN pip install -e /odoo/src

#ENV ADDONS_PATH /odoo/links
