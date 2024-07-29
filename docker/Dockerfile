FROM ubuntu:23.10
  # PITFALL: This is the latest version of Ubuntu
  # with Python 3.11. As of today (2024 07 27)
  # TypeDB has no driver for Python 3.12.

RUN echo "2024 07 28"
RUN apt update  -y --fix-missing && \
    apt upgrade -y


###
### For the TypeDB server
###

RUN apt install -y \
  software-properties-common apt-transport-https gpg
RUN gpg --keyserver \
  hkp://keyserver.ubuntu.com:80 --recv-key 17507562824cfdcc
RUN gpg --export 17507562824cfdcc \
  | tee /etc/apt/trusted.gpg.d/typedb.gpg \
  > /dev/null
RUN echo "deb https://repo.typedb.com/public/public-release/deb/ubuntu trusty main" \
  | tee /etc/apt/sources.list.d/typedb.list \
  > /dev/null
RUN apt update  -y --fix-missing && \
    apt upgrade -y
RUN apt install -y default-jre
RUN apt install -y typedb


###
### For the TypeDB Python client
###

RUN apt install -y python3 python3-pip
RUN apt install -y python3.11-venv
COPY requirements-for-pip.txt /root/
SHELL ["/bin/bash", "-c"] # `source` below fails without this.
RUN python3 -m venv /root/.venv              && \
    source          /root/.venv/bin/activate && \
    pip3 install -r /root/requirements-for-pip.txt


###
### Interface
###

EXPOSE 1729
CMD ["/bin/bash"]
