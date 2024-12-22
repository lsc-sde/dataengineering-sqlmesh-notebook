# Docker image with JupyterLab and Code Server for data engineering with SQLMesh
# Provides the following IDEs
# - JupyterLab
# - Code Server

# https://hub.docker.com/r/jupyter/datascience-notebook/tags/
ARG OWNER=lscsde
ARG BASE_CONTAINER=quay.io/jupyter/minimal-notebook:python-3.12.8
FROM $BASE_CONTAINER
ARG TARGETOS TARGETARCH
LABEL maintainer="lscsde"
LABEL image="dataengineering-sqlmesh-notebook"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Install packages from environment.yaml including code-server
COPY environment.yaml environment.yaml

RUN mamba env update --name base --file environment.yaml \
  && rm environment.yaml \
  && mamba clean --all -f -y 

RUN code-server --install-extension charliermarsh.ruff \
  && code-server --install-extension davidanson.vscode-markdownlint \
  && code-server --install-extension ms-python.black-formatter \
  && code-server --install-extension ms-python.python \
  && code-server --install-extension njpwerner.autodocstring


# Copy custom config for jupyter
COPY jupyter_notebook_config.json /etc/jupyter/jupyter_notebook_config.json

# Install UV
# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY requirements.txt requirements.txt

RUN uv pip install --system -r requirements.txt && rm requirements.txt
# Fix folder permissions and switch back to jovyan to avoid accidental container runs as root
RUN fix-permissions "${CONDA_DIR}" \
  && fix-permissions "/home/${NB_USER}" 
USER ${NB_UID}