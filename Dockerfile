# Builder for building odoo and external source
FROM quay.io/akretion/odoo-builder:latest as builder
ARG BUILD_MODE=production

# Build odoo source
COPY odoo-spec.yaml /builder/odoo-spec.yaml
COPY odoo-frozen.yaml /builder/odoo-frozen.yaml
ENV ODOO_VERSION=12.0 BUILD_MODE=${BUILD_MODE} BUILD_RESTRICT_LANG=fr.po
RUN build-odoo

# Build external source
COPY spec.yaml /builder/spec.yaml
COPY frozen.yaml /builder/frozen.yaml
RUN build-odoo-external

# Copy odoo source from builder stage and install dependency
FROM camptocamp/odoo-project:12.0-latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && apt-get install  -y vim \
    && /install/dev_package.sh

COPY --from=builder /builder/src /odoo/src
RUN pip install -e /odoo/src

# Install project dependency
COPY ./requirements.txt /odoo/
RUN cd /odoo && pip install -r requirements.txt

# Copy external code source
COPY --from=builder /builder/external-src /odoo/stable-src

COPY entrypoint/002_check_pending_jobs /start-entrypoint.d/002_check_pending_jobs
COPY ./setup.py /odoo/

# Set a default ADDONS_PATH with everything
ENV ADDONS_PATH /odoo/local-src,/odoo/links,/odoo/src/addons,/odoo/stable-src/account-financial-reporting,/odoo/stable-src/account-financial-tools,/odoo/stable-src/account-fiscal-rule,/odoo/stable-src/account-invoice-reporting,/odoo/stable-src/account-invoicing,/odoo/stable-src/account-payment,/odoo/stable-src/account-reconcile,/odoo/stable-src/bank-payment,/odoo/stable-src/bank-statement-import,/odoo/stable-src/community-data-files,/odoo/stable-src/connector,/odoo/stable-src/connector-ecommerce,/odoo/stable-src/connector-telephony,/odoo/stable-src/contract,/odoo/stable-src/crm,/odoo/stable-src/delivery-carrier,/odoo/stable-src/e-commerce,/odoo/stable-src/edi,/odoo/stable-src/hr,/odoo/stable-src/hr-timesheet,/odoo/stable-src/intrastat,/odoo/stable-src/l10n-france,/odoo/stable-src/manufacture,/odoo/stable-src/partner-contact,/odoo/stable-src/pos,/odoo/stable-src/product-attribute,/odoo/stable-src/product-variant,/odoo/stable-src/project,/odoo/stable-src/project-reporting,/odoo/stable-src/purchase-reporting,/odoo/stable-src/purchase-workflow,/odoo/stable-src/queue,/odoo/stable-src/reporting-engine,/odoo/stable-src/rest-framework,/odoo/stable-src/sale-financial,/odoo/stable-src/sale-reporting,/odoo/stable-src/sale-workflow,/odoo/stable-src/search-engine,/odoo/stable-src/server-auth,/odoo/stable-src/server-backend,/odoo/stable-src/server-brand,/odoo/stable-src/server-env,/odoo/stable-src/server-tools,/odoo/stable-src/server-ux,/odoo/stable-src/social,/odoo/stable-src/stock-logistics-barcode,/odoo/stable-src/stock-logistics-reporting,/odoo/stable-src/stock-logistics-warehouse,/odoo/stable-src/stock-logistics-workflow,/odoo/stable-src/storage,/odoo/stable-src/web,/odoo/stable-src/shopinvader,/odoo/stable-src/shopinvader-payment,/odoo/stable-src/shopinvader-misc,/odoo/stable-src/bank-statement-reconcile-simple,/odoo/stable-src/odoo-usuability,/odoo/stable-src/profiloo,/odoo/stable-src/support
