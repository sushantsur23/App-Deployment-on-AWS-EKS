# 🚀 End-to-End Application Deployment on AWS EKS with ALB Ingress

This project demonstrates how to deploy a containerized application on Amazon Web Services EKS (Elastic Kubernetes Service) and expose it securely to the internet using Kubernetes Ingress backed by an AWS Application Load Balancer (ALB).

It walks through the complete real-world DevOps workflow — from cluster creation to public access — using production-style architecture and best practices.

🎯 Project Objective

The goal of this project is to show how modern cloud-native applications are deployed using:

    * Managed Kubernetes (EKS)

    * Serverless compute (Fargate)

    * Kubernetes networking (Service & Ingress)

    * AWS Load Balancer Controller

    * IAM Roles for Service Accounts (IRSA)

By the end, an application running inside private subnets becomes accessible via a public ALB — just like in real production environments.

🏗 Architecture diagram (EKS + ALB + Ingress + Pods)

Traffic Flow

Internet User
      │
      ▼
AWS Application Load Balancer (Public Subnet)
      │
      ▼
Kubernetes Ingress
      │
      ▼
Kubernetes Service
      │
      ▼
Pods on AWS Fargate (Private Subnets)
      │
      ▼
Amazon EKS Managed Control Plane

Key Design Principles

✔ Control plane is fully managed by AWS
✔ Applications run serverlessly on Fargate
✔ Pods stay in private subnets
✔ Only ALB is publicly exposed
✔ Load balancer is created automatically via Kubernetes Ingress

🧠 What This Project Teaches

This repository gives hands-on experience with:
| Area          | Skills Gained                           |
| ------------- | --------------------------------------- |
| ☸️ Kubernetes | Deployments, Services, Ingress          |
| ☁️ AWS EKS    | Managed Kubernetes cluster setup        |
| ⚖️ Networking | ALB + Ingress traffic routing           |
| 🔐 Security   | IAM Roles for Service Accounts (IRSA)   |
| 🚀 DevOps     | End-to-end cloud application deployment |

These are core skills expected from DevOps & Cloud Engineers.

🛠️ Tools & Technologies Used

* Amazon EKS

* AWS Fargate

* Kubernetes

* AWS Load Balancer Controller

* Helm

* kubectl

* eksctl

* AWS CLI

🔄 Deployment Flow Summary

1️⃣ Configure AWS CLI
2️⃣ Create EKS cluster using eksctl
3️⃣ Configure IAM OIDC provider
4️⃣ Install AWS Load Balancer Controller using Helm
5️⃣ Deploy Kubernetes application (Deployment + Service + Ingress)
6️⃣ ALB is auto-provisioned
7️⃣ Application becomes accessible via public DNS


🌍 Final Outcome

After completing all steps:

✔ A Kubernetes cluster runs on AWS EKS
✔ Application pods run serverlessly on Fargate
✔ An AWS Application Load Balancer is automatically created
✔ The app is publicly accessible through a browser
✔ All infrastructure follows secure, production-style patterns


🧹 Cleanup (Important to Avoid Costs)

```
eksctl delete cluster --name app-cluster --region us-east-1
```

This removes:

* EKS Cluster

* Fargate profiles

* Load Balancer

* VPC resources

⭐ Why This Project Is Worth

This project demonstrates real-world expertise in:

✔ Managed Kubernetes (EKS)
✔ Cloud networking & load balancing
✔ Secure IAM integration with Kubernetes
✔ Infrastructure automation
✔ Production-style deployment architecture

It reflects the exact workflow used by DevOps teams deploying microservices in the cloud.

🏷️ Project Badges

![AWS](https://img.shields.io/badge/AWS-EKS-orange?logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Cluster-blue?logo=kubernetes&logoColor=white)
![Fargate](https://img.shields.io/badge/AWS-Fargate-ff9900?logo=amazon-aws&logoColor=white)
![Ingress](https://img.shields.io/badge/Kubernetes-Ingress-326ce5?logo=kubernetes&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-Charts-0f1689?logo=helm&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Project-6f42c1)
![License](https://img.shields.io/badge/License-MIT-green)
