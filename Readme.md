# Kubernetes Deployment of Flask App with Terraform

This repository contains a Terraform project that automates the deployment of a Flask application to a Kubernetes cluster. This project is based on my previous project, [kubernetes-flask](https://github.com/BoraKostem/kubernetes-flask), where the same deployment was accomplished using Kubernetes manifest files. Here, Terraform is used to manage the entire deployment process, making it easier to automate and manage infrastructure as code.

## Project Overview

### Purpose

The primary goal of this project is to demonstrate how Terraform can be used to deploy a Flask application to a Kubernetes cluster. By using Terraform, you can manage Kubernetes resources in a declarative and consistent manner, ensuring that the deployment is reproducible and easily configurable.

### How It Works

- **Terraform Configuration**:
  - The `kubernetes/main.tf` file contains the Terraform code that defines the Kubernetes resources needed for the deployment, including namespaces, deployments, services, and a horizontal pod autoscaler.
  - The deployment is configured to use an image hosted on a private Harbor registry, with image pull secrets managed by Kubernetes.
  - The Flask application is exposed via a NodePort service, allowing external access to the application.

- **Kubernetes Resources**:
  - **Namespace**: A dedicated namespace is created for the deployment.
  - **Deployment**: The Flask application is deployed as a Kubernetes deployment, with 2 replicas and resource limits set for CPU and memory.
  - **Horizontal Pod Autoscaler (HPA)**: The deployment is configured with an HPA to automatically scale the number of pods based on CPU utilization.
  - **Service**: The application is exposed via a NodePort service on port 30001.

## Usage

### How This Project Was Created

1. **Defining the Namespace**:
   - The project begins by creating a dedicated namespace for the Flask application using the `kubernetes_namespace` resource.

2. **Configuring the Deployment**:
   - The Flask application is defined as a Kubernetes deployment with 2 replicas, each limited to 500m CPU and 128Mi memory. The deployment is configured to pull the Docker image from a private Harbor registry.

3. **Setting Up the Service**:
   - A NodePort service is created to expose the Flask application on port 30001. This service routes traffic to port 5000 of the pods running the Flask application.

4. **Implementing Horizontal Pod Autoscaling**:
   - The deployment is configured with a horizontal pod autoscaler that scales the number of replicas between 2 and 5 based on CPU utilization, with a target average utilization of 70%.

5. **Provisioning with Terraform**:
   - Terraform is used to provision the resources in the Kubernetes cluster. The `terraform-main/main.tf` file references the `kubernetes` module, passing in variables such as the namespace name and kubeconfig path.

### Running the Project

To deploy your Flask application using this Terraform project, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/BoraKostem/terraform-kubernetes
   cd terraform-kubernetes
   ```

2. **Configure Kubernetes Credentials**:

   Ensure your Kubernetes credentials (kubeconfig) are set up on your local machine. You can specify the path to your kubeconfig file using the `kubeconfig_path` variable.

3. **Set Terraform Variables**:

   Configure the following Terraform variables:

   - `namespace_name`: The name of the namespace where the application will be deployed.
   - `kubeconfig_path`: The path to your kubeconfig file.

4. **Initialize Terraform**:

   Initialize the Terraform working directory:

   ```bash
   terraform init
   ```

5. **Apply the Terraform Configuration**:

   Apply the configuration to deploy the Flask application to your Kubernetes cluster:

   ```bash
   terraform apply
   ```

   Confirm the plan by typing `yes` when prompted.

6. **Access Your Application**:

   Once the deployment is complete, you can access your Flask application by navigating to your Kubernetes cluster's IP address on port 30001.

7. **Destroying Resources**:

   When you're done, you can clean up the resources by running:

   ```bash
   terraform destroy
   ```

   Confirm the destruction by typing `yes`.

Author: Bora Fenari Köstem