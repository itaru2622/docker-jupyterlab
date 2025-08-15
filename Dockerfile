ARG base=python:3-bookworm
FROM ${base}
ARG base

SHELL ["/bin/bash", "-c"]

# add apt repo for nodejs
ARG node_ver=18
RUN apt  update; apt install -y ca-certificates curl gnupg; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key > /etc/apt/trusted.gpg.d/nodesource.asc ;\
    echo "deb https://deb.nodesource.com/node_${node_ver}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
    apt update

RUN if [[ ${base} != python* ]] ; \
    then \
        apt install -y python3-pip; \
    fi

# add packages for jupyterlabs...
RUN apt  install -y  bash-completion nodejs; \
    pip3 install     jupyterlab ipywidgets plotly dash jupyterlab_widgets jupyterlab-git \
                     pandas openpyxl pydantic python-dotenv

ARG workdir=/work
ARG token=''

RUN mkdir -p ${workdir}
WORKDIR      ${workdir}
VOLUME       ${workdir}
#ENV JUPYTER_ROOT=${workdir}
ENV JUPYTER_TOKEN=${token}
ENV SHELL=/bin/bash

CMD jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root --no-browser --ServerApp.token=${JUPYTER_TOKEN}
