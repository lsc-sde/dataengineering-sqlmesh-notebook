# Docker Image for Data Engineering using SQLMesh

Custom image for Data Engineering using SQLMesh for the Lancashire and South Cumbria Secure Data Environment

This image extends Jupyter Docker Stacks [minimal notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook) with additional features.

## IDE Options

- Jupyter Lab
- Code Server

## Python Environments, Conda and UV

The default conda environment from the base notebook has been retained. 

Additionally, [**uv**](https://docs.astral.sh/uv/), both uv and uvx, are installed and available on path.

SQLMesh with additional dependencies for UI, Microsoft SQL Server, Databricks and Postgres has been installed using uv into the conda base environment (`/opt/conda`).


