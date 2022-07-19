
FROM pytorch/pytorch:1.8.1-cuda10.2-cudnn7-runtime

MAINTAINER lsdras96@gm.gist.ac.kr

RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    g++ gcc ssh openssh-client openssh-server vim locales tzdata htop \
    wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone

RUN locale-gen ko_KR.UTF-8 en_US.UTF-8

# set path to conda
ENV PATH /opt/conda/bin:$PATH
RUN conda init bash
SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

WORKDIR /workspace
RUN mkdir hydra && mkdir wandb
RUN git clone https://github.com/lsdras/cdvae.git && cd cdvae && git checkout origin/lsdras/dockerized
WORKDIR /workspace/cdvae

RUN conda env create -f env_sub.yml  && \
    conda activate cdvae && \
    conda install -y ipywidgets jupyterlab matplotlib pylint && \
    conda install -y -c conda-forge \
    matminer=0.7.3 nglview pymatgen=2020.12.31 torchmetrics=0.7.3 && \
    pip install setuptools==59.5.0  && \
    pip install -e .



#RUN /bin/bash -c "source activate my_env && pip install torch" 
#CMD [ "/bin/bash" ]
#SHELL ["/bin/bash", "-c"]
