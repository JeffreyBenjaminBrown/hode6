FROM vaticle/typedb

RUN echo "2024 07 27"
RUN apt update --fix-missing -y && apt upgrade -y
RUN apt install -y python3 python3-pip
RUN pip install ipython
RUN pip install typedb-client
### pip install typedb-driver     # PITFALL: Does not exist.
