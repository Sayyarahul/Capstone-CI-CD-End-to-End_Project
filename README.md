 ### Capstone-CI_CD-End-to-End_Project ###

A production-ready **CI/CD pipeline** that automatically builds, tests, scans, and deploys a containerized web application using **Docker**, using **GitHub Actions**,**Trivy**,and a **SelF-Hosted Deployment** runner.

---

##  Project Overview

## Project Overview

This project demonstrates how application changes are automatically
delivered from source code to a running environment using a secure,
automated CI/CD pipeline.

It ensures:
- Faster and reliable deployments
- Improved security through image scanning
- Consistent environments using containers
- Minimal manual intervention
* Docker image builds
* Unit testing inside containers
* Security scanning with Trivy
* Image push to Docker Hub
* Deployment-ready artifacts
* Deployment using Docker Compose
* Post-deployment health validation
  
The goal is to showcase **end-to-end CI/CD automation**,Secure container practices, and deployment readiness.

---
## Why This Project Exists

Manual deployments are slow, error-prone, and difficult to scale.
This project solves that by introducing:

- Automated build and deployment pipelines
- Security scanning before deployment
- Environment-based deployments (Staging & Production)
- Health-validated releases

This ensures stable, repeatable, and production-ready deployments.
---

## Project Structure
```
capstone-cicd-end-to-end/
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   ├── tests/
│   └── Dockerfile
│
├── frontend/
│   ├── index.html
│   ├── nginx.conf
│   ├── tests/
│   └── Dockerfile
│
├── docker-compose.yml
├── docker-compose.prod.yml
├── docker-compose.staging.yml
│
├── deploy.sh
│
├── .env.dev
├── .env.staging
├── .env.prod
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── actions-runner/        # Self-hosted GitHub runner (NOT committed ideally)
│
└── README.md
```
* Note:
  - actions-runner/ is used for local CD execution and is not required to be committed (acceptable for learning projects).
---
##  Architecture Overview

### Application Stack(2-Tier)

* **Frontend**:
  - Static web UI application
  - Served using Nginx
  - Exposed on port 8080
  - Communicates with backends via HTTP
  
* **Backend**: 
  - Python Flask application
  - Exposed on port 5000
  - Provides APls and /health endpoint
  - Connects to database
  
* **Database**:
  - PostgreSQL
  - Users Docker volume for data persistence
  
* Why 2-Tier?
  - Simple but realistic
  - Common in microservice Foundations
  - Easy to scale later
 
* **CI/CD**: GitHub Actions
  - Your pipeline runs automatically on every push to main branch 
* **Registry**: Docker Hub

```
User
  |
  v
Frontend (Nginx)  --->  Backend (Flask)  --->  PostgreSQL
```

---
### Architecture Diagram
* System Architecture Diagram 

```
User Browser
     │
     ▼
┌────────────────────┐
│  Frontend (Nginx)  │
│  Port: 8080        │
│  Static UI         │
└─────────┬──────────┘
          │ HTTP API Calls
          ▼
┌────────────────────┐
│ Backend (Flask)    │
│ Port: 8081 → 5000  │
│ REST APIs          │
│ /health endpoint   │
└─────────┬──────────┘
          │ DB Connection
          ▼
┌────────────────────┐
│ PostgreSQL DB      │
│ Port: 5432         │
│ Docker Volume      │
└────────────────────┘

```
---
## Explanation 
 - Frontend serves UI via Nginx
 - Backend handles APIs & health checks
 - Database persists data using volumes
 - All services communicate via Docker network

## Infrastructure Architecture (CI + CD)
```
Developer Machine
      │
      ▼
GitHub Repository
      │ (push to main)
      ▼
GitHub Actions (CI)
      │
      ├─ Build Docker Images
      ├─ Run Unit Tests
      ├─ Trivy Security Scan
      └─ Push Images to Docker Hub
      │
      ▼
Docker Hub Registry
      │
      ▼
Self-Hosted Windows Runner (CD)
      │
      ├─ docker compose pull
      ├─ docker compose down
      ├─ docker compose up -d
      └─ Health Check Validation
      │
      ▼
Live Application 

```
---
## Technology Stack

| Layer | Technology |
|-----|-----------|
| Source Control | GitHub |
| CI/CD | GitHub Actions |
| Containers | Docker, Docker Compose |
| Security | Trivy |
| Registry | Docker Hub |
| Backend | Python (Flask) |
| Frontend | Nginx (Static UI) |
| Database | PostgreSQL |
| Deployment | Self-Hosted Windows Runner |
---
##  Docker Implementation

### Docker Used

* **Multi-stage Docker builds**
  - Separate test, build, and runtime stages
  - Reduces final image size
  - Removes unnecessary tools from production image
    
* **Non-root users** 
  - Containers run as non-root
  - Improves security
  - Prevents privilege escalation
    
* **Layer caching optimization**
  - Dependencies installed before copying source code
  - Faster rebuilds
    
* **Environment variable configuration**
  - Uses environment variables
  - Ready for dev/staging/prod configs
    
* Why this matters?
  - This shows you understand secure & optimized container design, not just “docker build”.

### Docker Images

* `rahulsayya/capstone-frontend:latest`
* `rahulsayya/capstone-backend:latest`

---

##  Testing Strategy

### Backend (Python)

* **Framework**: Pytest
* Tests run **inside Docker build stage**

```bash
docker build -t backend-test ./backend
docker run backend-test python -m pytest
```

### Frontend (JavaScript)

* **Framework**: Jest
* Tests executed in Docker build stage

```
docker build --target frontend-test ./frontend
```

 - Only tested images are allowed to be pushed

---

##  Security Scanning

* Tool: **Trivy**
  - Scans Docker images for vulnerabilities

Results visible directly in **GitHub Actions logs**:

```
CRITICAL: x
HIGH: x
MEDIUM: x
LOW: x
```

---

##  CI/CD Pipeline (GitHub Actions)

### Pipeline Stages

1. Checkout Code
   - Pulls latest code from GitHub
  
2. Setup Docker Images
   - Builds backend and frontend images
   - Uses Docker Buildx
   
3. Login to Docker Hub
   - Builds the backend Docker image from the backend source code
   - Uses a Dockerfile with multi-stage build and tests
   - Creates a ready-to-run backend container image 
4. Build Backend Image
   - Builds the frontend Docker image using Nginx
   - Packages static UI files into a lightweight container
   - Produces a deployable frontend image
6. Build Frontend Image
   - Builds the frontend Docker image using Nginx
   - Packages static UI files into a lightweight container
   - Produces a deployable frontend image
7. Run Unit Tests (inside build)
   - Backend testes using pytest
   - Frontend tested using jest
   - Tests run during Docker build stage

8. Trivy Scan (Backend & Frontend)
   - Scans both images
   - Detects vulnerabilities
   - Generates severity report ( LOW -> CRITICAL )
   
9. Push Images to Docker Hub
   - Images tagged with Docker Hub Username
   - Pushed automatically
   - Ready for deployment

 10. Image Registry (Docker HUb)  
    - Backend image pushed
    - frontend image pushed
    - Public repositories
    - CI pipeline handles authentication securely using secrets
    - Demonstrates real production workflow

 11. Deployment Readiness (Staging)
   Deployment scripts are designed to:
     - Pull latest images
     - Stop old containers
     - Start updated containers
     - Verify application health
 * Health check endpoint:
  ```
     curl http://localhost:5000/health
  ```

 11. Unit Testing Strategy
   
   - Backend
     - Pytest
     - API response validation
     - Health endpoint test
   - Frontend
     - Jest
     - HTML content validation
     - UI smoke test
     - Shows quality control before deployment

  12. Security & Reliability
      - Trivy vulnerability scanning
      - Non-root containers
      - Minimal base images
      - Clean image sizes via multi-stage builds
---
### CI Pipeline Flow (Build,Scan,Push)   
```
Git Push
  │
  ▼
Checkout Code
  │
  ▼
Docker Build
  ├─ Backend Image
  └─ Frontend Image
  │
  ▼
Unit Testing
  ├─ Pytest (Backend)
  └─ Jest (Frontend)
  │
  ▼
Security Scan (Trivy)
  ├─ Backend Image
  └─ Frontend Image
  │
  ▼
Push Images to Docker Hub

```

---
## CD Pipline Flow (Deployment)
```
CI Success
   │
   ▼
Self-Hosted Runner Triggered
   │
   ▼
docker compose down
   │
   ▼
docker compose pull
   │
   ▼
docker compose up -d
   │
   ▼
Health Check (/health)
   │
   ▼
Deployment Success
```
---
## Environment Strategy

The project supports multiple deployment environments:

| Environment | Purpose | Compose File |
|------------|--------|-------------|
| Development | Local testing | docker-compose.yml |
| Staging | Pre-production validation | docker-compose.staging.yml |
| Production | Live environment | docker-compose.prod.yml |

Each environment uses:
- Separate Docker volumes
- Separate environment variables
- Independent deployments
---
## Environment Access
| Service  | URL                                                          |
| -------- | ------------------------------------------------------------ |
| Frontend | [http://localhost:8080](http://localhost:8080)               |
| Backend  | [http://localhost:8081](http://localhost:8081)               |
| Health   | [http://localhost:8081/health](http://localhost:8081/health) |

---
## Deployment Runbook (Step-by-Step)
1. Pre-Deployment Checks
  - Docker installed & running
  - Docker Compose installed
  - Docker Hub login successful
  - Self-hosted runner is online
 ```
   docker --version
   docker compose version
   docker ps
   ```

2. Manual Deployment( Local/Server)
```
   chmod +x deploy.sh
  ./deploy.sh
```
What deploy.sh does
```
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```
3. Post-Deployment Validation
* Bankend health check
  ```
   curl http://localhost:8081/health
  ```
* Expected output
```
{
  "status": "ok"
}
```
* Verify containers
```
docker ps
```
4. Access Application  
Service	   URL
* Frontend	 http://localhost:8080
* Backend 	http://localhost:8081
* Health	 http://localhost:8081/health

---

## Troubleshooting
* Issue 1: Deploy job fails with /bin/bash: C:\Users... not found
- Cause
  - Windows self-hosted runner uses PowerShell
  - Linux paths used in workflow
* Fix
- Use PowerShell Syntax
```
 shell: pwsh
run: |
  cd "C:\Users\Rahul Sayya\Capstone project_CICD End-to-End Project"
  ./deploy.sh
```
* Issue 2: pwsh: command not found
- Cause
  - Running PowerShell commands on Linux runner
- Fix
  - Ensure deploy job runs on:
```
 runs-on: self-hosted
```
* Issue 3: Docker pull access denied
- Cause
  - Docker Hub login missing on server
- Fix
```
docker login
```
* Issue 4: Health check fails but app is running
- Cause
  - Wrong endpoint checked
- Fix
  - Ensure /health endpoint exists:
 ```
@app.route("/health")
def health():
    return {"status": "ok"}
```
* Issue 5: Trivy scan not visible
- Cause
  - Trivy runs but logs collapsed
- Fix
- Expand steps:
```
Scan Backend
Scan Frontend
```
- Or add:
```
severity: HIGH,CRITICAL
```
---
##  Local Development

```bash
docker-compose up -d
```

Services:

* Frontend → [http://localhost:8080](http://localhost:8080)
* Backend → [http://localhost:5000](http://localhost:5000)
* Health →  [http://localhost:8081/health](http://localhost:8081/health)
* Database → PostgreSQL container

---

## ## Deployment Process

Deployments are fully automated and include:

- Pulling the latest container images
- Stopping existing services safely
- Starting updated services
- Verifying application health
   
---

### Health Validation

After deployment, the backend health endpoint is validated:

Backend exposes:

```
GET /health
```

Expected response:

```json
{
  "status": "ok"
}
```

Used for post‑deployment validation.

---
## Secrets Used (GitHub)

- DOCKER_USERNAME
- DOCKER_PASSWORD
Stored securely using GitHub Secrets.

---

##  What This Project Demonstrates

* Real CI/CD automation
* Secure container practices
* Production-ready Docker builds
* Security scanning with Trivy
* Automated deployment
* Deployment validation
* Debugging and pipeline recovery
* Production-ready workflow  

---

##  Conclusion

This project implements a full CI/CD pipeline for a containerized web application using Docker and GitHub Actions. It includes automated builds, unit testing, security scanning with Trivy, image publishing to Docker Hub, and deployment readiness using Docker Compose. The project follows best practices such as multi-stage builds, non-root containers, and environment-based configurations, making it a production-ready DevOps solution.

* CI/CD pipeline demonstrations

---

##  Author

**Rahul Sayya**
DevOps Engineer
