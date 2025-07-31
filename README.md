# APP_Helm_HTTPS_Nginx_Ingress

This repository provides a Helm chart and supporting files to deploy a sample Kubernetes application (`hello-k8s`) with HTTPS enabled via NGINX Ingress. It includes configuration for both staging and production environments, and demonstrates best practices for secure, scalable Kubernetes deployments.

---

## Table of Contents

- [Project Structure](#project-structure)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Configuration](#configuration)
- [Deployment](#deployment)
  - [Staging](#staging)
  - [Production](#production)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Project Structure

```
.
├── app.py
├── Dockerfile
├── charts/
│   └── hello-k8s/
│       ├── Chart.yaml
│       ├── kubeconfig-stage.yaml
│       ├── values/
│       │   ├── values-prod.yaml
│       │   └── values-staging.yaml
│       ├── templates/
│       │   ├── _helpers.tpl
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   └── service.yaml
│       └── addons/
│           ├── Chart.yaml
│           ├── IngressControllerHelm.txt
│           └── templates/
│               └── tls-issuer.yaml
├── IngressControllerHelm_Production.txt
├── IngressControllerHelm_Production copy.txt
├── IngressControllerHelm_Staging.txt
├── IngressControllerHelm_Staging copy.txt
├── kubeconfig-stage.yaml
```

---

## Features

- **Helm-based deployment** for easy management and upgrades.
- **NGINX Ingress Controller** for routing and HTTPS termination.
- **Let's Encrypt TLS Issuer** for automated certificate management.
- **Environment-specific configuration** for staging and production.
- **Sample Python app** (`app.py`) and Dockerfile for containerization.

---

## Prerequisites

- Kubernetes cluster (staging and/or production)
- [Helm 3.x](https://helm.sh/)
- [Docker](https://www.docker.com/)
- Access to a container registry (e.g., Docker Hub, GCR, ECR)
- (Optional) [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## Setup

### 1. Build and Push Docker Image

```sh
docker build -t <your-repo>/hello-k8s:latest .
docker push <your-repo>/hello-k8s:latest
```

Replace `<your-repo>` with your container registry path.

---

### 2. Configure Kubernetes Access

- Use `kubeconfig-stage.yaml` for staging deployments.
- For production, use your production kubeconfig.

---

## Configuration

### Example: `values/values-staging.yaml`

```yaml
replicaCount: 2
image:
  repository: <your-repo>/hello-k8s
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: staging.example.com
      paths:
        - /
  tls:
    - secretName: staging-tls
      hosts:
        - staging.example.com
```

### Example: `values/values-prod.yaml`

```yaml
replicaCount: 3
image:
  repository: <your-repo>/hello-k8s
  tag: stable
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: app.example.com
      paths:
        - /
  tls:
    - secretName: prod-tls
      hosts:
        - app.example.com
```

---

## Deployment

### 1. Install NGINX Ingress Controller and TLS Issuer

- See `charts/hello-k8s/addons/` for templates and instructions.
- Example for staging:

```sh
kubectl apply -f charts/hello-k8s/addons/templates/tls-issuer.yaml --kubeconfig kubeconfig-stage.yaml
```

- Install NGINX Ingress Controller as described in `IngressControllerHelm_Staging.txt` or `IngressControllerHelm_Production.txt`.

---

### 2. Deploy Application with Helm

#### Staging

```sh
cd charts/hello-k8s
helm upgrade --install hello-k8s . \
  -f values/values-staging.yaml \
  --kubeconfig kubeconfig-stage.yaml
```

#### Production

```sh
cd charts/hello-k8s
helm upgrade --install hello-k8s . \
  -f values/values-prod.yaml \
  --kubeconfig <your-production-kubeconfig>
```

---

## CI/CD

- Example GitHub Actions workflows are provided in `.github/workflows/deploy-staging.yaml` and `.github/workflows/deploy-production.yaml`.
- These workflows automate Docker image builds, pushes, and Helm deployments.
- Customize the workflows to match your registry and cluster access.

---

## Troubleshooting

- **Ingress not working?**  
  - Check that the NGINX Ingress Controller is running.
  - Ensure DNS points to your Ingress controller's external IP.
  - Verify TLS secrets and issuer status.

- **Pods not starting?**  
  - Run `kubectl describe pod <pod-name>` for error details.
  - Check image repository and tag.

- **Certificate issues?**  
  - Check the status of the `Certificate` and `Issuer` resources.
  - Review logs for the cert-manager pod.

---

## License

MIT (add a LICENSE file if you haven't already)

---

## References

- [Helm Documentation](https://helm.sh/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [cert-manager](https://cert-manager.io/)
