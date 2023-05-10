FROM ubuntu:20.04 

# Don't ask my timezone!
ENV DEBIAN_FRONTEND noninteractive 

# Dangerzone dependencies
RUN apt update && apt install -y git  dh-python build-essential fakeroot make libqt5gui5 \
     python3 python3-dev python3-venv python3-pip python3-stdeb python3-all 

# Installing pipx and poetry
RUN pip3 install pipx
RUN pipx ensurepath
RUN pipx install poetry

# Build process
RUN mkdir /app 
WORKDIR /app 
RUN git clone https://github.com/freedomofpress/dangerzone 
WORKDIR /app/dangerzone 
RUN /root/.local/bin/poetry install

# Podman is not available in Ubuntu 20.04 repos. Here's the workaround:
RUN echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" \
 | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
RUN curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key |  apt-key add -
RUN apt update && apt install -y podman

# Last Python modules needed to run the Dangerzone CLI script
RUN pip3 install colorama appdirs

RUN ./dev_scripts/dangerzone-cli --help 
