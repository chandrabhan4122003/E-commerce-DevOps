# Command Reference Guide

## Docker Commands

```bash
# Build and start containers
docker-compose up -d --build

# Stop containers
docker-compose down

# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container logs
docker logs e-commerce-dev

# Remove all containers and images
docker-compose down --rmi all --volumes --remove-orphans

# Clean up Docker system
docker system prune -f
```

## Ansible Commands

```bash
# Start website (deploy)
ansible-playbook playbooks/windows-docker.yml

# Stop website
ansible-playbook playbooks/stop-website.yml

# Check Ansible version
ansible --version

# Test connectivity
ansible all -m ping
```

## WSL Commands

```bash
# Switch to Ubuntu WSL
wsl -d Ubuntu

# Exit WSL
exit

# List WSL distributions
wsl --list

# Navigate to project
cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible
```

## Website URLs

- Main website: http://localhost:8080
- Container name: e-commerce-dev
- Port mapping: 8080:80

## File Structure

```
e-commerce-project/
├── ansible/
│   ├── playbooks/
│   │   ├── windows-docker.yml    # Start website
│   │   └── stop-website.yml      # Stop website
│   ├── inventory/hosts
│   └── ansible.cfg
├── docker-compose.yml
├── Dockerfile
├── nginx.conf
└── website files (HTML, CSS, JS)
```
