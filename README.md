 ### Capstone-CI_CD-End-to-End_Project ###

A production-style **CI/CD pipeline** that builds, tests, scans, and deploys a **2-tier web application** using **Docker** and **GitHub Actions**.

---

##  Project Overview

This project demonstrates a real-world DevOps workflow where application code changes automatically trigger:

* Docker image builds
* Unit testing inside containers
* Security scanning with Trivy
* Image push to Docker Hub
* Deployment-ready artifacts

The goal is to showcase **end-to-end CI/CD automation**, Docker best practices, and operational readiness.

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
  - Provides APls and health endpoint
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
4. Build Backend Image
5. Build Frontend Image
6. Run Unit Tests (inside build)
   - Backend testes using pytest
   - Frontend tested using jest
   - Tests run during Docker build stage

7. Trivy Scan (Backend & Frontend)
   - Scans both images
   - Detects vulnerabilities
   - Generates severity report ( LOW -> CRITICAL )
   
8. Push Images to Docker Hub
   - Images tagged with Docker Hub Username
   - Pushed automatically
   - Ready for deployment

 9. Image Registry (Docker HUb)  
    - Backend image pushed
    - frontend image pushed
    - Public repositories
    - CI pipeline handles authentication securely using secrets
    - Demonstrates real production workflow

 10. Deployment Readiness (Staging)
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

### Pipeline Flow    
```
Git Push
   ↓
GitHub Actions
   ↓
Build → Test → Scan → Push
```

---

##  Local Development

```bash
docker-compose up -d
```

Services:

* Frontend → [http://localhost:8080](http://localhost:8080)
* Backend → [http://localhost:5000](http://localhost:5000)
* Database → PostgreSQL container

---

##  Deployment (Staging Ready)

Deployment scripts handle:

* Pull latest Docker images
* Stop old containers
* Start new containers
* Preserve database volumes

---

##  Project Structure

```
capstone-cicd-end-to-end/
├── backend/
│   ├── app.py
│   ├── tests/
│   └── Dockerfile
├── frontend/
│   ├── index.html
│   ├── tests/
│   └── Dockerfile
├── docker-compose.yml
├── docker-compose.prod.yml
├── scripts/
├── .github/workflows/ci-cd.yml
└── README.md
```

---

##  What This Project Demonstrates

* Real CI/CD automation
* Secure container practices
* Production-ready Docker builds
* Vulnerability scanning
* Debugging and pipeline recovery

---

##  Conclusion

This project implements a full CI/CD pipeline for a containerized web application using Docker and GitHub Actions. It includes automated builds, unit testing, security scanning with Trivy, image publishing to Docker Hub, and deployment readiness using Docker Compose. The project follows best practices such as multi-stage builds, non-root containers, and environment-based configurations, making it a production-ready DevOps solution.

* DevOps Engineer roles
* Cloud Engineer roles
* CI/CD pipeline demonstrations

---

##  Author

**Rahul Sayya**
DevOps Engineer
