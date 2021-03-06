# Bases the image on Ubuntu 18.04
FROM ubuntu:18.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Basic update/upgrade mechanism + installs necessary packages
RUN apt update && \
    apt upgrade -y && \
    apt install gnupg apt-transport-https ca-certificates nodejs wget curl bzip2 git -y

RUN wget -q -O /tmp/libpng12.deb https://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 9.0.0

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \ 
    && apt update \
    && apt install yarn

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV HO hoo

# Defines the default work directory
WORKDIR /data

# Copies AMI files to the desired directory
COPY ./ami-code /data

RUN yarn install

# Defines the default command to be run once container is up and running.
# It will probably make sense to have "run.sh" which will actually define these.
CMD ["yarn", "run start"]