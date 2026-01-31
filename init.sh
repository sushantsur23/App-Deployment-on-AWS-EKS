
mkdir -p docs
touch docs/01-project-overview.md

echo "What is EKS (Managed Control Plane) 

Kubernetes End to End project o…

Control Plane vs Data Plane

Why Fargate is used

Problem with NodePort / LoadBalancer per service

Why Ingress is better

What is AWS Load Balancer Controller

" > docs/01-project-overview.md
# The >> symbol appends text to the end of the file
echo "This file is theory + architecture understanding." >> docs/01-project-overview.md

touch docs/02-prerequisites-windows.md
echo "Step-by-step tool installation (Windows PowerShell).

Sections:

Install kubectl

Install eksctl

Install AWS CLI

Configure AWS CLI (aws configure) 

Kubernetes End to End project o…

Verify installations

Add verification commands:

```kubectl version --client
eksctl version
aws --version
```

" > docs/02-prerequisites-windows.md


touch docs/steps-to-follow.md
