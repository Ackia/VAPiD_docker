FROM continuumio/miniconda3:4.8.2

RUN apt-get update --fix-missing && apt install -yq make gcc g++ gfortran git

COPY environment.yml /

RUN pip install -U pip

RUN pip install numpy biopython

RUN conda env create -f environment.yml
RUN echo "source activate VAPiD" > ~/.bashrc
ENV PATH /opt/conda/envs/VAPiD/bin:$PATH

RUN git clone https://github.com/rcs333/VAPiD.git

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]