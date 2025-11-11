# Ansible Configuration for E-commerce Project

This directory contains Ansible playbooks and configuration for deploying and managing the e-commerce application.

## Prerequisites

- Ansible installed (version 2.19.3+)
- SSH access to target servers
- Python 3.12+ on target servers

## Directory Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── inventory/
│   └── hosts           # Server inventory
├── playbooks/
│   ├── deploy.yml      # Main deployment playbook
│   └── templates/
│       └── nginx.conf.j2  # Nginx configuration template
├── roles/              # Custom Ansible roles
├── group_vars/         # Group-specific variables
└── host_vars/          # Host-specific variables
```

## Usage

1. Update the inventory file with your server details:

   ```bash
   wsl -d Ubuntu -- nano /mnt/c/Users/hp/Desktop/e-commerce-project/ansible/inventory/hosts
   ```

2. Test connectivity to your servers:

   ```bash
   wsl -d Ubuntu -- cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible && ansible all -m ping
   ```

3. Deploy the application:
   ```bash
   wsl -d Ubuntu -- cd /mnt/c/Users/hp/Desktop/e-commerce-project/ansible && ansible-playbook playbooks/deploy.yml
   ```

## Configuration

- Edit `ansible.cfg` for Ansible-specific settings
- Update `inventory/hosts` with your server information
- Modify `playbooks/deploy.yml` for deployment customization

## Next Steps

1. Add your server IPs to the inventory file
2. Configure SSH keys for passwordless authentication
3. Customize the deployment playbook for your specific needs
4. Create additional playbooks for maintenance tasks
