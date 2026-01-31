# Step-by-step tool installation (Windows PowerShell).

## Sections:

Open the powershell in administrator mode and follow the below steps.

#### Install kubectl and verify as per the documentation

Follow the documentation page at https://docs.aws.amazon.com/eks/latest/eksctl/installation.html Go to the windows section download the .zip file RUn the .exe file downloaded.

##### Install eksctl and verify as per the documentation

Follow the documentation page https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/ CLick on the link mentioned as "Install on Windows using Chocolatey, Scoop or Winget.

Verify the installation using the below command.
```
kubectl version --client
```

#### Install AWS CLI and verify as per the documentation

Follow the documentation page https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html  

Go to windows section, Download the link to .msi file and run it for complete installation.
Finally you can also verify the installation by using the command "aws configure".

#### Install Helm and verify as per the documentation

Follow the documentation page https://helm.sh/docs/v2/using_helm/install/ and use the below command on powershell.

```
scoop install helm
```


