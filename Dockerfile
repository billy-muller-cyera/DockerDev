# Base Image - Use an official lightweight image with dependencies
# Use X86_64 architecture
FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    jq \
    bash-completion \
    software-properties-common \
    ca-certificates \
    gnupg \
    python3 \
    python3-pip \
    python3-venv \
    vim \
    tmux \
    wget \
    curl \
    neovim \
    && apt-get clean

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# # Install Google Cloud SDK
# RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     apt-get update && apt-get install -y google-cloud-cli

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install -y terraform

# Install Terragrunt
RUN curl -fsSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 && \
    chmod +x /usr/local/bin/terragrunt

# Install kubectl (for Kubernetes CLI interactions)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Helm (Kubernetes Package Manager)
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install additional Python packages
RUN pip3 install --break-system-packages boto3 azure-cli requests pyyaml

# Install Oh My Bash
RUN git clone --depth=1 https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash && \
    cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc && \
    echo 'export PATH=$PATH' >> ~/.bashrc

# Set the Oh My Bash theme
RUN sed -i 's/OSH_THEME=.*/OSH_THEME="agnoster"/' ~/.bashrc

# Enable useful plugins
RUN echo "OSH_LOAD_PRIORITY=(git aws docker kubectl terraform tmux python vagrant)" >> ~/.bashrc

# Add handy aliases
RUN echo "alias ll='ls -lah'" >> ~/.bashrc && \
    echo "alias k=kubectl" >> ~/.bashrc && \
    echo "alias tf=terraform" >> ~/.bashrc && \
    echo "alias tg=terragrunt" >> ~/.bashrc && \
    echo "alias gco='git checkout'" >> ~/.bashrc

# Enable autocompletion for Terraform, AWS, and Kubernetes
RUN terraform -install-autocomplete && \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc && \
    echo 'source <(kubectl completion bash)' >> ~/.bashrc && \
    echo 'source <(helm completion bash)' >> ~/.bashrc


# Install Go dependencies
RUN apt-get update && apt-get install -y \
build-essential \
gcc \
g++ \
libc6-dev \
&& apt-get clean

# Install Go
ENV GOLANG_VERSION=1.24.0

RUN curl -fsSL "https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# Set Go environment variables
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Install Go tools
RUN go install golang.org/x/tools/cmd/godoc@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Create a Go workspace directory
RUN mkdir -p $GOPATH/src $GOPATH/bin $GOPATH/pkg

# Default working directory
WORKDIR /workspace

# Entry point
CMD [ "bash" ]
