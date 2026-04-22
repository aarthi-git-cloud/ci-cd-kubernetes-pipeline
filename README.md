# 🚀 CI/CD Pipeline with Docker & Kubernetes

## 📌 Project Overview

This project demonstrates an end-to-end **CI/CD pipeline** for deploying a containerized application using:

* GitHub for version control
* GitHub Actions for CI/CD automation
* Docker for containerization
* Kubernetes for orchestration

The pipeline automatically builds and tests the application whenever code is pushed.

---

## 🏗️ Architecture

```
Developer → GitHub → GitHub Actions (CI)
→ Build Docker Image → Run Tests → Deploy to Kubernetes
```

---

## ⚙️ Tech Stack

* Git & GitHub
* GitHub Actions
* Docker
* Kubernetes (K8s)
* Python (Flask app)

---

## 📂 Project Structure

```
.
├── app/                 # Application code
├── Dockerfile           # Docker configuration
├── kubernetes/          # K8s manifests
├── .github/workflows/   # CI/CD pipeline
└── README.md
```

---

## 🔄 CI/CD Pipeline Flow

1. Code is pushed to GitHub
2. GitHub Actions triggers automatically
3. Docker image is built
4. Application is tested
5. (Future) Image will be pushed to Docker Hub
6. (Future) Deployment to Kubernetes cluster

---

## 🐳 Docker Setup

Build image:

```
docker build -t devops-app .
```

Run container:

```
docker run -d -p 5000:5000 devops-app
```

---

## ☸️ Kubernetes Deployment

Apply deployment:

```
kubectl apply -f kubernetes/deployment.yaml
```

Apply service:

```
kubectl apply -f kubernetes/service.yaml
```

---

## 📊 Future Improvements

* Integrate Docker Hub for image push
* Deploy to real Kubernetes cluster (Minikube/EKS)
* Add monitoring using Prometheus & Grafana
* Implement blue-green deployment strategy

---

## 🎯 Key Learnings

* Built CI/CD pipeline using GitHub Actions
* Containerized application using Docker
* Deployed application using Kubernetes
* Understood DevOps workflow end-to-end

---

## 👩‍💻 Author

Aarthi Govindarajan
