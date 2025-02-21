# Cloud & DevOps Development Docker Image

## Overview
This Docker image provides a fully equipped development environment tailored for working with AWS, Terraform, Terragrunt, Kubernetes, Go, and Python. It includes essential CLI tools, package managers, and autocompletion to streamline infrastructure and cloud development workflows.

## Installed Software

### **System Utilities**
- Ubuntu (latest)
- `curl`, `git`, `jq`, `unzip`, `bash-completion`, `software-properties-common`
- `ca-certificates`, `gnupg`, `build-essential`, `gcc`, `g++`, `libc6-dev`

### **Cloud & DevOps Tools**
- **AWS CLI** (v2) - `aws`
- **Azure CLI** - `az`
- **Terraform** - `terraform`
- **Terragrunt** - `terragrunt`
- **kubectl** - Kubernetes CLI
- **Helm** - Kubernetes package manager

### **Programming & Development Tools**
- **Python** (latest) - `python3`, `pip3`, `venv`
  - Installed Python packages: `boto3`, `azure-cli`, `requests`, `pyyaml`
- **Go** (latest stable) - `go`, `gofmt`
  - Installed Go tools: `godoc`, `gopls`, `golangci-lint`
- **Oh My Bash** for an improved shell experience

## How to Use

### **Build and Run the Container**
To build and start the container in the background:
```sh
docker compose up -d --build
```

### **Access the Container**
To enter an interactive shell inside the running container:
```sh
docker exec -it cloud-dev bash
```

### **Using AWS Credentials**
The container automatically mounts `~/.aws` from your host machine. If AWS CLI does not detect credentials, verify inside the container:
```sh
ls -lah /root/.aws
aws sts get-caller-identity
```
If needed, manually set the profile:
```sh
export AWS_PROFILE=default
```

### **Working with Terraform & Terragrunt**
- Initialize Terraform: `terraform init`
- Plan and apply: `terraform plan && terraform apply`
- Use Terragrunt for remote state management: `terragrunt run-all apply`

### **Using Go Tools**
- Verify Go installation: `go version`
- Format Go code: `gofmt -w filename.go`
- Run `golangci-lint`: `golangci-lint run`
- Start Go Language Server: `gopls`

### **Enable Kubernetes Autocompletion**
Autocompletion for `kubectl`, `helm`, and `terraform` is enabled by default. If not working, source `.bashrc`:
```sh
source ~/.bashrc
```

## Mounted Volumes
- `~/.aws:/root/.aws:ro` → AWS credentials (read-only)
- `${HOME}/workspace:/workspace` → Project workspace

## Stopping & Removing the Container
To stop the container:
```sh
docker compose down
```

## Troubleshooting
### **AWS Credentials Not Found**
Ensure `~/.aws` is mounted correctly:
```sh
docker exec -it cloud-dev ls -lah /root/.aws
```
If empty, restart Docker and rebuild the container:
```sh
sudo systemctl restart docker
docker compose down && docker compose up -d --build
```

### **Go Installation Issues**
Ensure Go is installed correctly by running:
```sh
go version
```
If Go tools fail, ensure `GOPATH` is set:
```sh
echo $GOPATH
```

## Future Enhancements
- Add Google Cloud SDK (commented out for now)
- Expand language support (Node.js, Rust, etc.)

## Contributing
If you encounter issues or have suggestions, feel free to open a PR or report an issue in the repository.


