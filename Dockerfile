FROM nginx

FROM codercom/code-server:v2
# codeserver installs FROM node, adds vs-code for the browser, and then deploys on ubuntu

USER root
RUN apt update && apt install icu-devtools gnupg2 -y
USER 1000
RUN mkdir -p /home/coder/projects

ARG REPO_URL=https://github.com/ronin-of-beyonder/holomasterpass.git
ENV REPO_URL=$REPO_URL
RUN cd /home/coder/projects && git clone $REPO_URL

# Install nix with or without key verification
ARG NIX_VERSION=2.3.2
ENV NIX_VERSION=$NIX_VERSION
RUN curl -o install-nix-$NIX_VERSION https://nixos.org/nix/install && \
    # curl -o install-nix-$NIX_VERSION.sig https://nixos.org/nix/install.sig && \
    # gpg2 --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE && \
    # gpg2 --verify ./install-nix-$NIX_VERSION.sig && \
    sh ./install-nix-$NIX_VERSION

# in the codercom/code-server image, the user 1000 is called coder
ENV USER=coder
# test nix install and run holochain once to ensure base nix is downloaded
RUN ["/bin/bash", "-c", "source /home/coder/.nix-profile/etc/profile.d/nix.sh && nix run -f channel:nixos-18.03 hello -c hello"]
RUN ["/bin/bash", "-c", "source /home/coder/.nix-profile/etc/profile.d/nix.sh && nix-shell https://holochain.love"]
RUN ["/bin/bash", "-c", "cd /home/coder/projects/holomasterpass && ls -al && source /home/coder/.nix-profile/etc/profile.d/nix.sh && nix-shell https://holochain.love  --command 'cd /home/coder/projects/holomasterpass/hc && hc package'"]
# RUN ["/bin/bash", "-c", "source /home/coder/.nix-profile/etc/profile.d/nix.sh && nix-shell https://holochain.love  --command 'cd /home/coder/projects/holomasterpass/hc && hc package'"]

RUN sudo apt-get install curl software-properties-common -y && \
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -

RUN sudo apt-get install nodejs -y && node -v && npm -v

RUN cd /home/coder/projects/holomasterpass/gui && npm i

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]
