### 📘 Project Overview — EKS End-to-End Application Deployment

#### 🎯 Objective of This Project

This project demonstrates how to deploy a real-world containerized application on Amazon Elastic Kubernetes Service (EKS) and expose it securely to the internet using Kubernetes Ingress backed by an AWS Application Load Balancer (ALB). The project will deployed on public facing IP accessed through the load balancer. we will be creating relevant service and ingress controller which will be access through load balancer. We will also create VPC with public and private subnet and install on the private subnet. 

By completing this project, you will understand:

* How EKS simplifies Kubernetes operations

* How applications run inside pods and services

* Why Ingress is required for external access

* How the AWS Load Balancer Controller automatically provisions ALBs

* How Kubernetes workloads can securely interact with AWS services using IAM

This mirrors how production-grade applications are deployed in modern cloud environments, however in production there might be minimal changes as per the project requirements.

##### ☸️ What is Amazon EKS?

Amazon EKS (Elastic Kubernetes Service) is a managed Kubernetes control plane provided by AWS. Best way is to atleast keep 3 worker and master nodes in Data and Control Plane to set up highly available kubernetes cluster.

A typical Kubernetes cluster has two main parts:

| Component                     | Responsibility                                  |
| ----------------------------- | ----------------------------------------------- |
| **Control Plane**             | API Server, Scheduler, etcd, Controller Manager |
| **Data Plane (Worker Nodes)** | Runs your application pods                      |

Managing a self-hosted Kubernetes cluster means you must:

* Maintain the control plane

* Handle etcd failures

* Renew certificates

* Upgrade Kubernetes versions

Troubleshoot API server or scheduler issues

This becomes operationally heavy and error-prone.

##### 🚀 How EKS Helps

EKS removes this burden by fully managing the control plane for you. The EKS cluster is designed following high-availability and production best practices. AWS ensures:

* High availability of API server

* Automatic recovery of control plane components

* Managed upgrades and patches

You only focus on deploying applications, not managing Kubernetes internals

* Control Plane (Managed by AWS)

* EKS provides a managed control plane

Internally distributed across multiple Availability Zones

Handles:

1) API Server

2) Scheduler

3) Controller Manager

4) etcd

Worker Plane (Data Plane)

We deploy multiple worker nodes (EC2 or Fargate) across AZs.

Example production setup:

1) 3 worker nodes minimum

2) Spread across 3 Availability Zones

3) Pods (applications) run on these worker nodes

These nodes live inside a VPC private subnet for security.

#####  VPC Network Design

| Component      | Location               | Purpose                    |
| -------------- | ---------------------- | -------------------------- |
| **Public Subnet**  | Internet-facing        | Load Balancers             |
| **Private Subnet** | Internal               | Worker nodes & Pods        |
| **VPC**            | Encloses all resources | Secure networking boundary |

✔ Applications never run in public subnets
✔ Only load balancers are publicly exposed

### Why Fargate is used??

Instead of managing EC2 worker nodes, we use Fargate, which:

1) Runs containers without provisioning servers

2) Automatically scales compute

3) Removes the need to manage node health or auto-scaling groups

This creates a fully serverless Kubernetes data plane, ideal for learning modern cloud-native patterns.


### 🌐 Why We Use Ingress Instead of LoadBalancer Services

If every application used a LoadBalancer service: Each service would create a separate AWS load balancer, Costs would increase significantly and Management becomes complex.

Ingress Solves This :- Ingress acts like a smart traffic router.

```
User → Load Balancer → Ingress Rules → Service → Pods
```
It allows: 
* One load balancer for multiple services

* Path-based routing (e.g., /app1, /app2)

* Centralized traffic management

However, Ingress needs a component to actually create and manage the load balancer. That’s where the Ingress Controller comes in.

### What is AWS Load Balancer Controller

The AWS Load Balancer Controller is a Kubernetes controller that:

* Watches for new Ingress resources

* Automatically creates an AWS Application Load Balancer

* Configures: Target groups, Listener rules, Health checks, 

Routes traffic from ALB → Service → Pods

This removes all manual load balancer configuration. Whenever we create an Ingress YAML file, this controller translates it into real AWS infrastructure.

This file is theory + architecture understanding.


### 📦 Application Deployment (Pods)

Applications are deployed as Pods inside the worker nodes.

Pods:

1) Have internal IPs

2) Are not directly reachable from outside the cluster

3) Must be exposed using Kubernetes Services

🔌 Kubernetes Service Types

Services expose Pods and provide stable networking.

| Type             | Scope               | Use Case                         |
| ---------------- | ------------------- | -------------------------------- |
| **ClusterIP**    | Internal only       | Pod-to-pod communication         |
| **NodePort**     | Node-level exposure | Direct access via node IP + port |
| **LoadBalancer** | External            | Creates cloud load balancer      |

🔹 ClusterIP (Default)

Only accessible inside the cluster

Used for internal microservice communication

🔹 NodePort

* Exposes service on each worker node IP

* Still inside the VPC

Not directly internet-facing unless manually routed

🔹 LoadBalancer

* Creates an AWS ELB/ALB

* Assigns a public IP / DNS

* Each service = one load balancer

❗ Expensive at scale

### 💰 Problem with LoadBalancer per Service

If every microservice uses: type: LoadBalancer Then:

1) AWS creates one load balancer per service

2) Costs increase rapidly

3) Management becomes complex

This is not optimal for production microservices.

### 🚪 Solution: Kubernetes Ingress

Instead of multiple load balancers, we use Ingress.

What Ingress Does?

Ingress: Exposes multiple services using one load balancer

Routes traffic based on: Hostname and URL path.

### 🎯 Ingress Flow

```
User → AWS Load Balancer → Ingress → Service → Pod
```
1) User hits example.com/app

2) ALB receives request

3) Ingress rule matches path

4) Traffic forwarded to correct Service

5) Service routes to Pod

### ⚙️ Ingress Controller

Ingress alone is just a Kubernetes resource. It needs a controller to function.

Common Ingress Controllers
| Controller         | Cloud/Provider |
| ------------------ | -------------- |
| **NGINX Ingress**     | Generic        |
| **AWS ALB Controller** | AWS            |
| **F5 Ingress**         | F5 Networks    |

### ☁️ AWS Load Balancer Controller (ALB Controller)

When an Ingress resource is created:

1) Controller watches the cluster

2) Detects new Ingress

3) Automatically provisions:

    AWS Application Load Balancer

    Target Groups

    Listener Rules

4) Connects ALB → Kubernetes Services

This enables internet access to private cluster workloads securely.

### 🧩 Why Ingress is Best Practice

| Feature          | LoadBalancer Service | Ingress           |
| ---------------- | -------------------- | ----------------- |
| Cost             | High (per service)   | Low (shared LB)   |
| Scalability      | Poor                 | Excellent         |
| Routing          | None                 | Host & Path based |
| Production ready | ❌                    | ✅                 |

### 🔐 Why IAM OIDC Integration Is Required

The Load Balancer Controller is itself a Kubernetes pod.
To create AWS resources (ALB, target groups, security groups), it must call AWS APIs.

Instead of embedding credentials, we use:
IAM Roles for Service Accounts (IRSA)

This allows:

1) A Kubernetes service account to assume an IAM role

2) Secure, temporary AWS credentials

3) Fine-grained permission control

To enable this, we associate an OIDC identity provider with the EKS cluster. This is a key security concept in production EKS environments. 

#### 🏗 Final Architecture of This Project

```
User (Browser)
      │
      ▼
AWS Application Load Balancer (Public Subnet)
      │
      ▼
Kubernetes Ingress Resource
      │
      ▼
Kubernetes Service
      │
      ▼
Pods running on AWS Fargate (Private Subnets)
      │
      ▼
Amazon EKS Cluster (Managed Control Plane)

```