# 🚀 CI/CD Pipeline on AWS EKS Using Jenkins, GitHub Webhooks & Kaniko

## 📋 Overview

This project demonstrates a complete **CI/CD pipeline** deployed on AWS infrastructure:

- **Terraform** provisions AWS infrastructure (VPC, EKS, EC2, Storage)
- **Jenkins** runs inside the EKS cluster
- **GitHub Webhooks** automatically trigger builds on every push
- **Kaniko** builds Docker images inside Kubernetes (no Docker daemon required)
- **Docker Hub** stores container images
- Application deployed to EKS on dedicated nodes

---

## 📂 Project Structure

```
.
├── k8s/
│   ├── app-namespace.yaml
│   ├── jenkins-app-sa.yaml
│   ├── jenkins-namespace.yaml
│   ├── jenkins-pod.yaml
│   ├── jenkins-pvc.yaml
│   ├── jenkins-service.yaml
│   ├── setup.sh
│   └── StorageClass-EBS.yaml
├── terraform/
│   ├── aws_provider.tf
│   ├── ebs_addon.tf
│   ├── ec2.tf
│   ├── eks.tf
│   ├── sec_group.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── vpc.tf
└── README.md
```

---

## 🏗️ Infrastructure Components

### AWS Resources Created by Terraform

#### Network Layer
- **VPC** with two public subnets
- **Internet Gateway (IGW)** with route tables for internet access

#### Security
- **Security Group** configuration:
  - **Ingress:** SSH access (port 22) only
  - **Egress:** All outbound traffic allowed

#### Kubernetes Cluster
- **EKS Cluster:** Named `EKS_Cluster`
- **Worker Node Group:** Named `nodes-group` with 2 worker nodes
- **EBS CSI Driver Addon:** For dynamic Kubernetes Persistent Volumes

#### Management
- **EC2 Instance:** EC2 for EKS cluster management
- **Automated Setup:** Terraform file provisioner copies Kubernetes files to `/home/ec2-user/k8s`

---

## 🚀 Deployment Instructions

### Step 1: Deploy Infrastructure with Terraform

```bash
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve
```

### Step 2: Configure AWS CLI on EC2 Instance

SSH into the EC2 instance and configure AWS credentials:

```bash
aws configure
```

Provide the following details:

| Parameter | Description |
|-----------|-------------|
| **AWS Access Key ID** | Your IAM access key |
| **AWS Secret Access Key** | Your IAM secret key |
| **Default region** | Example: `us-east-1` |
| **Default output format** | Example: `json` |

### Step 3: Run Kubernetes Setup Script

Execute the setup script located at `/home/ec2-user/k8s`:

```bash
cd k8s
chmod +x setup.sh
./setup.sh
```

**What this script does:**
1. Configures access to the EKS cluster
2. Installs and configures `kubectl`
3. Labels worker nodes for proper pod scheduling
4. Applies all Kubernetes manifests for Jenkins and application
5. Provides colored output for progress tracking

### Step 4: Access Jenkins

#### Get Jenkins Service URL

```bash
kubectl get svc -n jenkins
```

#### Retrieve Jenkins Admin Password

```bash
kubectl -n jenkins exec -it jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## ⚙️ Jenkins Configuration

### Required Plugins

Install the following plugins in Jenkins:
- **Kubernetes Plugin**
- **BlueOcean Plugin**

### Docker Hub Credentials

Add a new credential in Jenkins:
- **Type:** Username with password
- **ID:** `dockerhub-credentials`
- **Username:** Your Docker Hub username
- **Password:** Your Docker Hub password

> This credential will be used by Kaniko to push images to Docker Hub.

### Configure Kubernetes Cloud

Navigate to **Manage Jenkins → Manage Nodes and Clouds → Configure Clouds**

| Setting | Value |
|---------|-------|
| **Cloud Name** | `Kubernetes` |
| **Kubernetes Namespace** | `jenkins` |
| **Jenkins URL** | `http://jenkins-service.jenkins.svc.cluster.local:8080` |
| **Jenkins Tunnel** | `jenkins-service.jenkins.svc.cluster.local:50000` |

---

## 🔔 GitHub Webhook Configuration

Enable automatic builds when pushing to GitHub:

1. Open your GitHub repository
2. Navigate to **Settings → Webhooks**
3. Click **Add webhook**
4. Configure the webhook:
   - **Payload URL:** `http://<JENKINS-EXTERNAL-IP>/github-webhook/`
   - **Content type:** `application/json`
   - **Events:** Select "Just the push event"
5. Click **Add webhook** to save

---

## 📦 Jenkins Pipeline Overview

### Pipeline Agent Configuration

The pipeline runs in a Kubernetes pod with multiple containers:

| Container | Purpose |
|-----------|---------|
| **kaniko** | Builds and pushes Docker images |
| **kubectl** | Interacts with EKS cluster |
| **jnlp** | Jenkins agent for SCM checkout |

### Environment Variables

- `DOCKERHUB_REPO` → Docker Hub repository name
- `DOCKERHUB` → Jenkins credentials for Docker Hub authentication

### Pipeline Stages

#### 1️⃣ Setup Docker Credentials
Configures Kaniko with Docker Hub credentials stored in Jenkins

#### 2️⃣ Source Code Checkout
Checks out application code from Git SCM

#### 3️⃣ Build Image & Push to Docker Hub
- Uses Kaniko to build Docker image from Dockerfile
- Pushes image to Docker Hub repository

#### 4️⃣ Deploy to EKS Cluster
- Applies Kubernetes manifests (`service.yaml` and `pod.yaml`)
- Deletes old pods and redeploys with updated image

### Volumes

- **kaniko-secret** → Temporary storage for Docker credentials

---

## 🔧 Create Jenkins Pipeline

1. Return to Jenkins dashboard
2. Click **New Item** → Create a **Pipeline** job
3. Configure the pipeline:

### Build Triggers
- ✅ Enable **GitHub hook trigger for GITScm polling**

### Pipeline Configuration
- **Pipeline Definition:** Pipeline script from SCM
- **SCM:** Git
- **Repository URL:** `https://github.com/MahmoudAh98/EKS-APP.git`
- **Branch:** `*/main`

---

## 🌐 Access the Application

### Step 1: Run Initial Deployment

Trigger the Jenkins pipeline for the first time to complete the full build and deployment process.

### Step 2: Get Application Service URL

Once deployment completes, run the following command on the EC2 instance:

```bash
kubectl get svc -n app
```

The output will display the external IP or LoadBalancer URL to access your application.

---

## 📝 Notes

- Ensure your AWS credentials have sufficient permissions to create EKS clusters and related resources
- The setup script provides colored output to help track progress and identify any issues
- All Jenkins and application resources run in separate Kubernetes namespaces for isolation
- Kaniko eliminates the need for Docker daemon, making builds more secure in Kubernetes

---
