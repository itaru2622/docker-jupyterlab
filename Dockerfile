ARG base=python:3-bookworm
FROM ${base}
ARG base

SHELL ["/bin/bash", "-c"]

RUN apt  update; apt install -y ca-certificates curl gnupg
# add apt repo
ARG node_ver=18
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add - ;\
    echo "deb https://deb.nodesource.com/node_${node_ver}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list;
RUN apt update

RUN if [[ ${base} != python* ]] ; \
    then \
        apt install -y python3-pip; \
    fi

RUN apt  install -y  bash-completion nodejs
RUN pip3 install     jupyterlab ipywidgets plotly  jupyterlab_widgets jupyter-dash   jupyterlab-git   

ARG workdir=/work
ARG token=''

RUN mkdir -p ${workdir}
WORKDIR      ${workdir}
VOLUME       ${workdir}
ENV JUPYTER_ROOT=${workdir}
ENV JUPYTER_TOKEN=${token}
ENV SHELL=/bin/bash

CMD jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root --no-browser --notebook-dir=${JUPYTER_ROOT} --ServerApp.token=${JUPYTER_TOKEN}
