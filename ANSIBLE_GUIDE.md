# E-commerce Website Ansible Automation Guide

## What is Ansible?

Ansible is like a **smart assistant** that remembers all the steps to deploy your website and does them automatically with one command.

## Quick Start Commands

### 1. Start Your Website (Deploy)

```bash
# Open WSL Ubuntu
wsl -d Ubuntu

# Go to project folder
cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible

# Run automation (this does everything!)
ansible-playbook playbooks/windows-docker.yml
```

### 2. Stop Your Website (Ansible Way)

```bash
# Stay in WSL Ubuntu (if not already there: wsl -d Ubuntu)
# Make sure you're in ansible folder
cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible

# Run stop automation
ansible-playbook playbooks/stop-website.yml
```

### 3. Alternative Stop (Manual Way)

```bash
# Exit WSL first
exit

# Go to main project folder
cd C:\Users\hp\Desktop\e-commerce-project

# Stop containers manually
docker-compose down
```

### 3. Check if Website is Running

```bash
# Check container status
docker ps

# Test website in browser
# Go to: http://localhost:8080
```

## Step-by-Step Process

### To Deploy Your Website:

1. **Open Command Prompt/PowerShell**
2. **Switch to Ubuntu WSL:**
   ```bash
   wsl -d Ubuntu
   ```
3. **Navigate to ansible folder:**
   ```bash
   cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible
   ```
4. **Run the magic command:**
   ```bash
   ansible-playbook playbooks/windows-docker.yml
   ```
5. **Wait 2-3 minutes** - Ansible will:
   - Stop old containers
   - Build new website
   - Start containers
   - Test everything
   - Show success message
6. **Open browser:** http://localhost:8080

### To Stop Your Website (Ansible Way):

1. **Stay in WSL Ubuntu (or open it):**
   ```bash
   wsl -d Ubuntu
   ```
2. **Navigate to ansible folder:**
   ```bash
   cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible
   ```
3. **Run the stop automation:**
   ```bash
   ansible-playbook playbooks/stop-website.yml
   ```
4. **Wait 30 seconds** - Ansible will:
   - Stop all containers
   - Clean up Docker resources
   - Show success message

### Alternative: Stop Manually (Without Ansible):

1. **Exit WSL (if you're in it):**
   ```bash
   exit
   ```
2. **Go to project folder:**
   ```bash
   cd C:\Users\hp\Desktop\e-commerce-project
   ```
3. **Stop containers:**
   ```bash
   docker-compose down
   ```

### Complete Cleanup (removes everything):

```bash
docker-compose down --rmi all --volumes --remove-orphans
docker system prune -f
```

## What Each Command Does

| Command                                         | What it Does                         |
| ----------------------------------------------- | ------------------------------------ |
| `wsl -d Ubuntu`                                 | Switch to Ubuntu where Ansible lives |
| `ansible-playbook playbooks/windows-docker.yml` | Run the START automation recipe      |
| `ansible-playbook playbooks/stop-website.yml`   | Run the STOP automation recipe       |
| `docker-compose down`                           | Stop website containers manually     |
| `docker ps`                                     | Show running containers              |
| `docker system prune -f`                        | Clean up unused Docker stuff         |

## Troubleshooting

### If Ansible doesn't work:

1. Make sure Docker Desktop is running
2. Check WSL integration is enabled in Docker Desktop
3. Run: `docker --version` in Ubuntu WSL

### If website doesn't load:

1. Wait 30 seconds after deployment
2. Check containers: `docker ps`
3. Try: http://localhost:8080

### If you get permission errors:

1. Make sure Docker Desktop is running as administrator
2. Restart Docker Desktop

## Files You Need (Keep These)

- `ansible/` folder - Contains automation recipes
- `docker-compose.yml` - Container configuration
- `Dockerfile` - Website build instructions
- `nginx.conf` - Web server settings
- All website files (HTML, CSS, JS, images)

## Files You Can Delete (Not Needed)

- `ansible-deploy.bat` - Old manual script
- `run-ansible.ps1` - Old PowerShell script
- `quick-deploy.ps1` - Old deployment script
- `deploy.ps1` - Old deployment script
- `deploy.sh` - Old shell script
- `cleanup-demo.bat` - Old cleanup script

## Summary

### Ansible Way (Recommended):

- **Start Website:** `wsl -d Ubuntu` → `cd ansible folder` → `ansible-playbook playbooks/windows-docker.yml`
- **Stop Website:** `wsl -d Ubuntu` → `cd ansible folder` → `ansible-playbook playbooks/stop-website.yml`

### Manual Way (Backup):

- **Start:** `docker-compose up -d --build`
- **Stop:** `docker-compose down`
- **Clean:** `docker-compose down --rmi all --volumes --remove-orphans`

### Check Website:

- **URL:** http://localhost:8080
- **Status:** `docker ps`
