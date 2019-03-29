FROM ubuntu:16.04

# Use bash instead of dash as default sh
RUN ln -sf bash /bin/sh

RUN DEBIAN_FRONTEND=noninteractive \
    sed -i 's/main$/main universe/' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y \
     wget

RUN DEBIAN_FRONTEND=noninteractive \
    wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb \
 && apt-get install -y ./wkhtmltox_0.12.5-1.xenial_amd64.deb

ENTRYPOINT []
CMD ["wkhtmltopdf","-H"]

