#  🚀 Steps to Follow to Complete the Deployment Process

#### 🔐 1) Configure AWS Account

First step is to configure the AWS account by creating an Access Key under AWS → Security Credentials, and then running the below command in PowerShell:

```
aws configure
```

#### ☸️ 2) Create the EKS Cluster Using eksctl

Creating EKS cluster manually will take lot of time hence we want to go with command line. EKSCTL is command like utility to create and manage EKS cluster hence we will use this. Use the below command as mentioned.

```
eksctl create cluster --name app-cluster --region us-east-1 --fargate 
```
* 📌 Important Notes
    * We are using fargate unles our organization wil have specific requirements to use a EC2 instance as to keep worker nodes or they need to be on a specific distribution. It takes around 15-20 mins to get the overall process completed.

    * On looking at the aws eks cluster page we would be able to see the cluster active once this is created. On the basic kubernetes distribution unless we install a dashboard feature we wont be able to get all the relevant metrics we are able to see it on aws, this is one advantage of EKS.

    * Here we will neeed to create custom fargate profile since we want to deploy application to other namespaces other than default and kube-system which is by default setting with the deault fargate profile in our cluster.

    * Under Control plane logging we can save the logs required either for API server or Authenticator etc. 

#### 🔗 3) Download the kubeconfig File
we download the kube config file so that we can make the relevant changes to the cluster rather than doing it manually. Use the below command.

```
aws eks update-kubeconfig --name app-cluster --region us-east-1
```


#### 🧩 4) Create Fargate Profile

Use the below command
```
eksctl create fargateprofile --cluster app-cluster --region us-east-1 --name alb-sample-app --namespace game-2048 
```
⚠️ Challenge:
We are still missing the Ingress Controller. Without it, the Ingress resource is useless.

#### 📦 5) Deploy Deployment, Service, and Ingress

Deploy the deployment, ingress and service 

use the below command
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml
```
* This file includes:

    * Namespace: game-2048

    * Deployment with 5 replicas

    * Service with correct targetPort and selectors

    * Ingress resource to route traffic inside the cluster

⚠️ Challenge:
We are still missing the Ingress Controller. Without it, the Ingress resource is useless.

#### 🔍 6) Verify Resources

Use below command to see the status of the pods if they are in pending or running state
```
kubectl get pods -n game-2048
kubectl get pods -n game-2048 -w
```

Use below command to check the services
```
kubectl get svc -n game-2048
```
You will see:

    * NodePort

    * ClusterIP

    * ❌ No External IP

Use command below to check ingress

```
kubectl get ingress-n game-2048
```

#### 🛡️ 7) Configure IAM OIDC Provider
Now we need to create ingress controller. For this first we need to IAM OIDC connector because the ALB controller running will need to access load balancer.

Use the below command for next step
```
eksctl utils associate-iam-oids-provider --cluster app-cluster --approve
```

#### ⚖️ 8) Install AWS Load Balancer Controller
Download IAM Policy

We will be installing an ALB controller in kubernetes which is a pod. Also granting the pod access to AWS services as ALB.
```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```

If you want to create the IAM policy then use the below command
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```

Create IAM role and service account with the below command
```
eksctl create iamserviceaccount --cluster=app-cluster --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

⚠️ Replace <your-aws-account-id> before running. 
Please make sure to update the aws account id in the above command and then execute.


#### ⛵ 9) Install Controller Using Helm
We will use the helm chart for creating the ALB conrtroller.
```
helm repo add eks https://aws.github.io/eks-charts
```

The helm chart will create the ALB controller and use the service account for running the pod. 

Installing the Helm Chart

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=app-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=us-east-1 --set vpcId=<your-vpc-id>
```

📍 Get VPC ID from:
AWS Console → EKS → Cluster → Networking
Here we will get the VPC ID from the AWS EKS cluster under Networking section copy the VPC ID mentioned in the Info section. 

We will get the confirmation that the ALB load balancer coontroller is installed.


#### ✅ 10) Final Verification
Check Deployment Replicas

Final check we need to verify if we hav atleast 2 replicas of the Load Balancer.

```
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get deployment -n kube-system aws-load-balancer-controller -w
```

✔️ Should show 2/2 replicas

### 🧯 Troubleshooting Challenges

If replicas are not created :-
Then you may need to check if there are some stae resource which needs to be deleted. Use the below command to deug further.
```
kubectl edit deploy/aws-load-balancer-controller -n kube-system
```

Possible fixes:

    * Delete stale CloudFormation stack for service account

    * Override service account

    * Reinstall Helm chart

    * Delete and reinstall Helm chart

You may need delete the stack creating the service account and finally need to override the service acount. Once this is fixed you will need to reinstall the helm chart as per the command mentioned above.

Also try to delete and reinstall the helm chart.

Check if pods are in running state. Avaliable replicas should be in 2/2 status.
```
kubectl get deploy -n kube-system 
```

#### 🌍 11) Verify Load Balancer

Go to AWS Console → EC2 → Load Balancers

You should see an ALB created by the controller after the Ingress resource was applied.
Check in AWS Account if the ALB is created or not inside the EC2 instance page. Here we need to understand the load balancer created by the load balancer controller sinc ewe submitted an ingress resource before.

If we use the command kubectl get ingress -n game-2048 we will see an Address is the load balancer  the ingress controller has created watching the ingress resource.


⏳ Wait until Load Balancer state becomes Active
We need to wait until the load balancer state is showing as Active.

Once this is completed then open the address in the browser as http://<address> you will be able to see the application open.
You will see the application running 🎉


## 🎯 Final Outcome

✔️ Kubernetes app deployed on EKS
✔️ Running on serverless Fargate
✔️ Exposed securely via Ingress + ALB
✔️ Production-style cloud-native architecture