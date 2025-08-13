# Dockerized CI/CD Pipeline with GitHub Actions

A complete DevOps project demonstrating containerization of a Flask web application with automated CI/CD pipeline using GitHub Actions, Docker, and comprehensive testing.

## Features

- **Flask Web Application**: Simple Python web app with multiple endpoints
- **Docker Containerization**: Production-ready Dockerfile with security best practices
- **Comprehensive Testing**: Unit tests with pytest and coverage reporting
- **CI/CD Pipeline**: Automated GitHub Actions workflow
- **Multi-container Setup**: Docker Compose with supporting services
- **Security Scanning**: Vulnerability scanning with Trivy and Bandit
- **Monitoring**: Prometheus and Grafana integration
- **Load Balancing**: Nginx reverse proxy configuration

## Project Structure

```
Docker_CI_CD/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # GitHub Actions CI/CD pipeline
├── tests/
│   ├── __init__.py
│   └── test_app.py            # Comprehensive test suite
├── app.py                     # Flask application
├── requirements.txt           # Python dependencies
├── Dockerfile                 # Production Docker image
├── .dockerignore             # Docker build context exclusions
├── docker-compose.yml        # Multi-container orchestration
├── docker-compose.dev.yml    # Development environment
├── nginx.conf                # Nginx configuration
├── prometheus.yml            # Prometheus monitoring config
├── pytest.ini               # Pytest configuration
├── .env.example             # Environment variables template
├── .gitignore               # Git exclusions
└── README.md                # This file
```

## Local Development Setup

### Prerequisites

- Python 3.11+
- Docker and Docker Compose
- Git

### 1. Clone and Setup

```bash
git clone <repository-url>
cd Docker_CI_CD

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Environment Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### 3. Run Locally (Development)

```bash
# Method 1: Direct Python execution
python app.py

# Method 2: Using Flask CLI
export FLASK_APP=app.py
flask run --host=0.0.0.0 --port=5000
```

### 4. Run Tests

```bash
# Run all tests
python -m pytest tests/ -v

# Run with coverage
python -m pytest tests/ -v --cov=app --cov-report=html

# Run specific test
python -m pytest tests/test_app.py::FlaskAppTestCase::test_hello_endpoint -v
```

## 🐳 Docker Usage

### Build and Run Single Container

```bash
# Build Docker image
docker build -t flask-docker-cicd .

# Run container
docker run -d -p 5000:5000 --name flask-app flask-docker-cicd

# Check health
curl http://localhost:5000/health

# View logs
docker logs flask-app

# Stop and remove
docker stop flask-app && docker rm flask-app
```

### Multi-container with Docker Compose

```bash
# Start all services (production)
docker-compose up -d

# Start development environment
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# View logs
docker-compose logs -f web

# Scale web service
docker-compose up -d --scale web=3

# Stop all services
docker-compose down

# Remove volumes (caution: deletes data)
docker-compose down -v
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) provides a complete CI/CD pipeline:

### Pipeline Stages

1. **Test Stage**
   - Checkout code
   - Setup Python environment
   - Install dependencies
   - Run linting (flake8)
   - Execute test suite with coverage
   - Upload coverage reports

2. **Security Scan Stage**
   - Run safety check for vulnerabilities
   - Execute bandit security analysis
   - Upload security scan results

3. **Build Stage**
   - Setup Docker Buildx
   - Login to Docker Hub
   - Build multi-platform images (amd64, arm64)
   - Push to Docker registry
   - Run Trivy vulnerability scan

4. **Deploy Stage** (main branch only)
   - Deploy to staging environment
   - Run smoke tests
   - Send deployment notifications

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

```
DOCKER_USERNAME=your-docker-hub-username
DOCKER_PASSWORD=your-docker-hub-password
```

### Triggering the Pipeline

```bash
# Push to main branch (triggers full pipeline)
git push origin main

# Create pull request (triggers test and security stages)
git checkout -b feature/new-feature
git push origin feature/new-feature
# Create PR via GitHub UI
```

## Monitoring and Observability

### Available Services

- **Application**: http://localhost:5000
- **Nginx**: http://localhost:80
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

### Application Endpoints

- `GET /` - Main welcome message
- `GET /health` - Health check endpoint
- `GET /info` - Application information

### Health Checks

```bash
# Application health
curl http://localhost:5000/health

# Docker health check
docker ps --format "table {{.Names}}\t{{.Status}}"

# Compose services health
docker-compose ps
```

## 🧪 Testing Strategy

### Test Categories

1. **Unit Tests** (`tests/test_app.py`)
   - Endpoint functionality
   - Response structure validation
   - Error handling
   - Performance checks

2. **Integration Tests** (in CI/CD)
   - Container health checks
   - Service connectivity
   - End-to-end workflows

3. **Security Tests**
   - Dependency vulnerability scanning
   - Code security analysis
   - Container image scanning

### Running Tests

```bash
# Local testing
python -m pytest tests/ -v --cov=app

# Docker testing
docker run --rm flask-docker-cicd python -m pytest tests/ -v

# Load testing (optional)
pip install locust
locust -f locustfile.py --host=http://localhost:5000
```

## Security Features

### Application Security

- Non-root user in Docker container
- Minimal base image (python:3.11-slim)
- Security headers and error handling
- Environment variable configuration
- Secret key management

### CI/CD Security

- Dependency vulnerability scanning (Safety)
- Code security analysis (Bandit)
- Container image scanning (Trivy)
- Multi-platform builds
- Secure secret management

## Deployment Options

### Local Development

```bash
# Quick start
docker-compose -f docker-compose.dev.yml up -d
```

### Production Deployment

```bash
# Full stack
docker-compose up -d

# With custom environment
docker-compose --env-file .env.production up -d
```

### Cloud Deployment

The application is ready for deployment to:

- **AWS ECS/Fargate**
- **Google Cloud Run**
- **Azure Container Instances**
- **Kubernetes clusters**
- **DigitalOcean App Platform**

## Configuration

### Environment Variables

Key configuration options (see `.env.example`):

```bash
# Application
FLASK_ENV=production
SECRET_KEY=your-secret-key
PORT=5000

# Database
POSTGRES_DB=flask_app
POSTGRES_USER=flask_user
POSTGRES_PASSWORD=secure-password

# Docker Registry
DOCKER_USERNAME=your-username
DOCKER_PASSWORD=your-password
```

### Customization

1. **Add new endpoints**: Modify `app.py`
2. **Add dependencies**: Update `requirements.txt`
3. **Modify tests**: Edit `tests/test_app.py`
4. **Update pipeline**: Modify `.github/workflows/ci-cd.yml`
5. **Add services**: Update `docker-compose.yml`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add/update tests
5. Ensure CI/CD passes
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Troubleshooting

### Common Issues

1. **Port conflicts**: Change ports in docker-compose.yml
2. **Permission errors**: Check Docker daemon permissions
3. **Build failures**: Clear Docker cache with `docker system prune`
4. **Test failures**: Check Python version and dependencies

### Getting Help

- Check application logs: `docker-compose logs web`
- Verify health endpoints: `curl http://localhost:5000/health`
- Review CI/CD logs in GitHub Actions tab
- Check Docker container status: `docker ps -a`

---
