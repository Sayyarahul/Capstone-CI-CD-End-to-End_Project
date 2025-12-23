# Docker Image Size Comparison

## Backend (Flask Application)

| Image | Size |
|-----|-----|
| python:3.11 (base image) | 923 MB |
| Backend (multi-stage build) | 226MB |

**Size reduction:** ~85%

---

## Frontend (Nginx Static Site)

| Image | Size |
|-----|-----|
| nginx:alpine | 23 MB |
| Frontend (custom image) | 81.2MB |

---

## Conclusion

Multi-stage Docker builds significantly reduced backend image size,
resulting in:
- Faster CI/CD pipeline execution
- Reduced container registry storage
- Faster container startup times
