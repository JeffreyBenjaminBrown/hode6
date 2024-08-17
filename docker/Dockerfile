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

RUN echo "<2024-08-07 Wed>" > /root/Dockerfile-echo-date


###
### Interface
###

RUN useradd -u 1001 -g users user  && \
    mkdir               /home/user && \
    chown -R user:users /home/user && \
    chmod -R 777        /home/user

RUN mkdir /mnt/src                   \
          /mnt/data                  \
	  /mnt/write                 \
	  /mnt/write/server-data  && \
    chown -R user:users /opt /mnt && \
    chmod -R 777        /opt /mnt/write /mnt/data

USER user
SHELL ["/bin/bash", "-c"] # `source` below fails without this.
COPY requirements-for-pip.txt /home/user/
RUN python3 -m venv /home/user/.venv              && \
    source          /home/user/.venv/bin/activate && \
    pip3 install -r /home/user/requirements-for-pip.txt

EXPOSE 1729
CMD ["/bin/bash"]
