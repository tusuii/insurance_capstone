# Insurance Management System - DevOps Capstone Project.

## Project Overview
This project implements a comprehensive insurance management system with a modern DevOps infrastructure. It demonstrates the implementation of a full CI/CD pipeline and infrastructure as code using industry-standard tools and best practices.

![Project Architecture](project_images/Screenshot%20From%202025-05-23%2014-33-40.png)
*Complete DevOps Architecture of the Insurance Management System*

## Technology Stack

- **Backend**: Java/Spring Boot
- **Build Tool**: Maven
- **Containerization**: Docker
- **Container Orchestration**: Kubernetes (K8s)(Minikube local) / docker-compose(AWS)
- **CI/CD**: Jenkins
- **Infrastructure as Code**: Terraform
- **Configuration Management**: Ansible

![Technology Stack](project_images/Screenshot%20From%202025-05-23%2010-51-14.png)
*Ansible Playbooks for Infrastructure Management*

![CI/CD Pipeline](project_images/Screenshot%20From%202025-05-23%2010-03-08.png)
*ansible playbooks*
- **Monitoring Stack**:
  - Prometheus: Metrics collection and alerting
  - Grafana: Metrics visualization and dashboards

## CI/CD Pipeline

### Jenkins Build Process
![Jenkins Build](project_images/Screenshot%20From%202025-05-23%2014-31-08.png)
*Successful Jenkins Build Pipeline Execution*

## Project Structure
- `/infrastructure`: Contains all infrastructure-related code and configurations
  - Terraform configurations
  - Kubernetes manifests
  - Ansible playbooks
- `/star-agile-insurance-project`: Main application codebase

## monitoring dashboard Interface
![Application Dashboard](project_images/Screenshot%20From%202025-05-24%2018-10-23.png)
*Insurance Management System Dashboard*

## Features
- Automated build and deployment pipeline
- Infrastructure as Code (IaC) implementation
- Containerized application deployment
- Scalable Kubernetes architecture
- Automated configuration management
- Continuous Integration and Continuous Deployment

## Monitoring and Observability

### Infrastructure Monitoring
![Infrastructure Monitoring](project_images/Screenshot%20From%202025-05-24%2018-59-44.png)
*Prometheus Endpoints*

### Monitoring Architecture
- **Prometheus Server**:
  - Scrapes metrics from application and infrastructure
  - Stores time-series data
  - Handles alerting rules
  - Endpoint: `http://prometheus:9090`

- **Grafana Dashboards**:
  - Application metrics visualization
  - Infrastructure health monitoring
  - Resource utilization tracking
  - Endpoint: `http://grafana:3000`

### Monitored Metrics
1. **Application Metrics**:
   - Request latency
   - Throughput (requests/second)
   - Error rates
   - JVM metrics
   - Custom business metrics

2. **Infrastructure Metrics**:
   - CPU utilization
   - Memory usage
   - Disk I/O
   - Network traffic
   - Kubernetes cluster health

### Alert Configuration
- **High CPU Usage**: > 80% for 5 minutes
- **High Memory Usage**: > 85% for 5 minutes
- **High Error Rate**: > 5% errors in 2 minutes
- **Service Down**: Instance unavailable for > 1 minute

### Monitoring Setup
```bash
# Deploy Prometheus
kubectl apply -f infrastructure/monitoring/prometheus/

# Deploy Grafana
kubectl apply -f infrastructure/monitoring/grafana/

# Verify deployments
kubectl get pods -n monitoring
```

### Accessing Dashboards
```bash
# Port forward Grafana
kubectl port-forward svc/grafana 3000:3000 -n monitoring

# Port forward Prometheus
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
```

## Setup and Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/insurance_capstone.git
   ```

2. Infrastructure Setup:
   ```bash
   cd infrastructure
   terraform init
   terraform apply
   ```

3. Application Deployment:
   - Configure Jenkins pipeline using the provided Jenkinsfile
   - Run the pipeline to build and deploy the application

## CI/CD Pipeline
The project implements a comprehensive CI/CD pipeline that includes:
1. Code compilation and testing
2. Docker image building and pushing
3. Infrastructure provisioning with Terraform
4. Kubernetes deployment and service configuration
5. Configuration management with Ansible
6. Automated testing and quality checks

## Infrastructure Components
- **VPC and Networking**: Secure network infrastructure
- **Kubernetes Cluster**: For container orchestration
- **Jenkins Server**: For CI/CD pipeline execution
- **Monitoring Stack**: For application and infrastructure monitoring

## Contributing
Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## Application Features
- User registration and authentication
- Insurance policy management
- Policy creation and updates
- Premium calculations
- Claims processing
- Policy document generation

## Development Guidelines
### Code Standards
- Follow Java code conventions
- Write unit tests for new features
- Document API endpoints using Swagger
- Use meaningful commit messages

### Local Development
1. Set up local environment:
   ```bash
   # Install Java and Maven
   sudo apt update
   sudo apt install openjdk-11-jdk maven

   # Verify installations
   java -version
   mvn -version
   ```

2. Build the application:
   ```bash
   cd star-agile-insurance-project
   mvn clean install
   ```

3. Run locally:
   ```bash
   mvn spring-boot:run
   ```

### Docker Development
```bash
# Build Docker image
docker build -t insurance-app .

# Run container
docker run -p 8080:8080 insurance-app
```

## Monitoring and Logging
- **Metrics Collection**: 
  - Prometheus for real-time metrics gathering
  - Custom exporters for application-specific metrics
  - Node exporter for hardware/OS metrics
  - kube-state-metrics for Kubernetes metrics
- **Visualization**: 
  - Grafana for creating interactive dashboards
  - Custom dashboards for business KPIs
  - Real-time alerting and notifications
  - Prometheus Alert Manager for alert routing
- **Log Management**:
  - Loki for log aggregation
  - Promtail for log collection
  - Grafana for log visualization and querying
- **Cluster Monitoring**: 
  - Kubernetes dashboard
  - Resource metrics server
  - Custom resource metrics
  - Prometheus Operator for CRDs

## Troubleshooting
### Common Issues
1. Jenkins Pipeline Failures
   - Check Git credentials
   - Verify Docker daemon is running
   - Ensure Kubernetes cluster is accessible

2. Application Issues
   - Check application logs
   - Verify database connectivity
   - Validate environment variables

### Health Checks
- Application: 
  - Spring Boot Actuator: `http://localhost:8080/actuator/health`
  - Metrics Endpoint: `http://localhost:8080/actuator/prometheus`
- Kubernetes: 
  - Pods: `kubectl get pods -n insurance-app`
  - Services: `kubectl get svc -n insurance-app`
  - Deployments: `kubectl get deployments -n insurance-app`
- Monitoring:
  - Prometheus: `http://prometheus:9090/targets`
  - Grafana: `http://grafana:3000/dashboards`
- Jenkins: 
  - Build logs: View in Jenkins UI
  - Pipeline visualization: Blue Ocean plugin

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Star Agile for project guidance and support
- DevOps community for tools and best practices
- Spring Boot community for framework support
- Kubernetes community for container orchestration expertise
- Jenkins community for CI/CD pipeline best practices

## Running with Minikube
![Kubernetes Deployment](project_images/Screenshot%20From%202025-05-23%2014-33-40.png)
*Kubernetes Cluster Deployment on port 30036*

### Prerequisites
1. Install Minikube:
   ```bash
   # For Linux
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

2. Install kubectl:
   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install kubectl /usr/local/bin/kubectl
   ```

### Starting Minikube
1. Start Minikube cluster:
   ```bash
   minikube start --driver=docker
   ```

2. Verify cluster status:
   ```bash
   minikube status
   kubectl cluster-info
   ```

### Deploying the Application
1. Build and push Docker image:
   ```bash
   # Point shell to minikube's Docker daemon
   eval $(minikube docker-env)
   
   # Build the image
   docker build -t insurance-app:latest .
   ```

2. Apply Kubernetes manifests:
   ```bash
   # Create namespace
   kubectl create namespace insurance-app
   
   # Apply deployments and services
   kubectl apply -f infrastructure/k8s/deployment.yaml
   kubectl apply -f infrastructure/k8s/service.yaml
   ```

3. Verify deployment:
   ```bash
   kubectl get pods -n insurance-app
   kubectl get services -n insurance-app
   ```

4. Access the application:
   ```bash
   # Get the URL to access the application
   minikube service insurance-service -n insurance-app --url
   ```

### Monitoring the Application
1. Enable Minikube dashboard:
   ```bash
   minikube dashboard
   ```

2. View application logs:
   ```bash
   # Get pod name
   kubectl get pods -n insurance-app
   
   # View logs
   kubectl logs <pod-name> -n insurance-app
   ```

### Cleanup
```bash
# Delete the application resources
kubectl delete namespace insurance-app

# Stop Minikube cluster
minikube stop

# Delete Minikube cluster (optional)
minikube delete
```
