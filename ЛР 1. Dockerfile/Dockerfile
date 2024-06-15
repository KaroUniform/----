FROM jupyterhub/jupyterhub:5.0.0  

RUN apt-get update && apt-get install -y \
    git  

WORKDIR /jupyterhub

ENTRYPOINT jupyterhub
