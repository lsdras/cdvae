FROM nvidia/cuda:11.0.3-base-ubuntu20.04

MAINTAINER lsdras96@gm.gist.ac.kr

# set bash as current shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    g++ gcc ssh openssh-client openssh-server vim locales tzdata htop \
    wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone
RUN locale-gen ko_KR.UTF-8 en_US.UTF-8

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/anaconda.sh && \
        /bin/bash ~/anaconda.sh -b -p /opt/conda && \
        rm ~/anaconda.sh && \
        ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
        echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
        find /opt/conda/ -follow -type f -name '*.a' -delete && \
        find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
        /opt/conda/bin/conda clean -afy

# set path to conda
ENV PATH /opt/conda/bin:$PATH
RUN conda update -n base -c defaults conda && conda config --set ssl_verify false


WORKDIR /workspace
RUN mkdir hydra && mkdir wandb
RUN git clone https://github.com/lsdras/cdvae.git && cd cdvae && git checkout origin/lsdras/dockerized
WORKDIR /workspace/cdvae

RUN conda env create --name cdvae --file env_sub_docker.yml
RUN /bin/bash -c "source activate cdvae && conda install -y ipywidgets jupyterlab matplotlib pylint && conda install -y -c conda-forge matminer=0.7.3 nglview pymatgen=2020.12.31 torchmetrics=0.7.3 && pip install setuptools==59.5.0 && pip install -e ."

#SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]
#RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
#    echo "conda activate base" >> ~/.bashrc

#RUN /bin/bash -c "source activate base && conda env update --file env_sub_docker.yml"
#RUN /bin/bash -c "source activate base && conda install -y ipywidgets jupyterlab matplotlib pylint"
#RUN /bin/bash -c "source activate base && conda install -y -c conda-forge matminer=0.7.3 nglview pymatgen=2020.12.31 torchmetrics=0.7.3"
#RUN /bin/bash -c "source activate base && pip install setuptools==59.5.0 && pip install -e ."
#RUN /bin/bash -c "source activate base && conda env update --file env_sub_docker.yml && conda install -y ipywidgets jupyterlab matplotlib pylint && conda install -y -c conda-forge matminer=0.7.3 nglview pymatgen=2020.12.31 torchmetrics=0.7.3 && pip install setuptools==59.5.0 && pip install -e ."


#ENTRYPOINT /bin/bash -c "source activate base"

#RUN /bin/bash -c "source activate my_env && pip install torch" 
#CMD [ "/bin/bash" ]
#SHELL ["/bin/bash", "-c"]
