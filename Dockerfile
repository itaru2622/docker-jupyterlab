ARG base=python:3.13-trixie
FROM ${base}
ARG base

SHELL ["/bin/bash", "-c"]

# add apt repo for nodejs
ARG node_ver=22
RUN apt  update; apt install -y ca-certificates curl gnupg; \
    curl -fsSL https://deb.nodesource.com/setup_${node_ver}.x |  bash - ; \
    apt update

RUN if [[ ${base} != python* ]] ; \
    then \
        apt install -y python3-pip; \
    fi

# add packages for jupyterlabs...
RUN apt  install -y  bash-completion nodejs; \
    pip3 install     jupyterlab ipywidgets plotly dash jupyterlab_widgets jupyterlab-git itables matplotlib matplotlib-fontja \
                     pandas openpyxl pydantic python-dotenv langdetect

ARG workdir=/work
ARG token=''

RUN mkdir -p ${workdir}
WORKDIR      ${workdir}
VOLUME       ${workdir}
#ENV JUPYTER_ROOT=${workdir}
ENV JUPYTER_TOKEN=${token}
ENV SHELL=/bin/bash

CMD jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root --no-browser --ServerApp.token=${JUPYTER_TOKEN}
