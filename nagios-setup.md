# Nagios Monitoring Setup for Ansible-Deployed Website

## What Nagios Will Monitor

### **Website Availability:**

- ✅ HTTP response (200 OK)
- ✅ Response time monitoring
- ✅ Content verification
- ✅ DNS resolution
- ✅ Port connectivity

### **Alert Conditions:**

- ❌ Website returns 4xx/5xx errors
- ❌ Response time > 5 seconds
- ❌ Website content changes unexpectedly
- ❌ DNS resolution fails
- ❌ Connection timeout

## Nagios Configuration Files

### **1. Host Definition**

```cfg
# /etc/nagios/conf.d/ansible-website.cfg
define host {
    host_name                   docker-ecommerce-site
    alias                       Docker E-commerce Website
    address                     127.0.0.1
    check_command               check-host-alive
    check_interval              5
    retry_interval              1
    max_check_attempts          3
    check_period                24x7
    process_perf_data           1
    retain_nonstatus_information 1
    contact_groups              admins
    notification_interval       30
    notification_period         24x7
    notification_options        d,u,r
}
```

### **2. Service Definitions**

```cfg
# Website HTTP Check
define service {
    host_name                   docker-ecommerce-site
    service_description         HTTP Service
    check_command               check_http!-H 127.0.0.1 -p 8080
    check_interval              2
    retry_interval              1
    max_check_attempts          3
    check_period                24x7
    notification_interval       30
    notification_period         24x7
    notification_options        w,u,c,r
    contact_groups              admins
}

# Website Response Time Check
define service {
    host_name                   docker-ecommerce-site
    service_description         HTTP Response Time
    check_command               check_http!-H 127.0.0.1 -p 8080 -w 3 -c 5
    check_interval              2
    retry_interval              1
    max_check_attempts          3
    check_period                24x7
    notification_interval       30
    notification_period         24x7
    notification_options        w,u,c,r
    contact_groups              admins
}

# Website Content Check
define service {
    host_name                   docker-ecommerce-site
    service_description         Website Content
    check_command               check_http!-H 127.0.0.1 -p 8080 -s "E-commerce"
    check_interval              5
    retry_interval              2
    max_check_attempts          3
    check_period                24x7
    notification_interval       60
    notification_period         24x7
    notification_options        w,u,c,r
    contact_groups              admins
}
```

### **3. Command Definitions**

```cfg
# /etc/nagios/conf.d/commands.cfg (add these)
define command {
    command_name    check_http
    command_line    /usr/lib/nagios/plugins/check_http $ARG1$
}

define command {
    command_name    check-host-alive
    command_line    /usr/lib/nagios/plugins/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5
}
```

## Installation Steps

### **1. Install Nagios (Ubuntu/Debian)**

```bash
sudo apt update
sudo apt install nagios4 nagios-plugins-contrib
sudo systemctl enable nagios4
sudo systemctl start nagios4
```

### **2. Create Configuration**

```bash
# Create website monitoring config
sudo nano /etc/nagios4/conf.d/ansible-website.cfg
# (paste the host and service definitions above)

# Test configuration
sudo nagios4 -v /etc/nagios4/nagios.cfg

# Restart Nagios
sudo systemctl restart nagios4
```

### **3. Access Nagios Web Interface**

```
http://your-nagios-server/nagios4
Username: nagiosadmin
Password: (set during installation)
```

## Monitoring Dashboard

### **What You'll See:**

- 🟢 **GREEN:** Website is up and responding normally
- 🟡 **YELLOW:** Warning (slow response time)
- 🔴 **RED:** Critical (website down or error)

### **Alerts You'll Receive:**

- Email notifications when website goes down
- SMS alerts for critical issues (if configured)
- Dashboard notifications for all status changes

## Custom Checks for E-commerce

### **Shopping Cart Functionality**

```cfg
define service {
    host_name                   ansible-ecommerce-site
    service_description         Shopping Cart Page
    check_command               check_http!-H ansible-demo-1762276170.s3-website-us-east-1.amazonaws.com -u /cart.html -s "Shopping Cart"
    check_interval              5
    retry_interval              2
    max_check_attempts          3
    check_period                24x7
    notification_interval       60
    notification_period         24x7
    notification_options        w,u,c,r
    contact_groups              admins
}
```

### **Product Pages**

```cfg
define service {
    host_name                   ansible-ecommerce-site
    service_description         Shop Page
    check_command               check_http!-H ansible-demo-1762276170.s3-website-us-east-1.amazonaws.com -u /shop.html -s "Shop"
    check_interval              5
    retry_interval              2
    max_check_attempts          3
    check_period                24x7
    notification_interval       60
    notification_period         24x7
    notification_options        w,u,c,r
    contact_groups              admins
}
```

## Benefits

### **Proactive Monitoring:**

- ✅ Know about issues before customers do
- ✅ Track website performance over time
- ✅ Get detailed uptime statistics
- ✅ Monitor specific e-commerce functionality

### **Business Value:**

- ✅ Reduce downtime
- ✅ Improve customer experience
- ✅ Track SLA compliance
- ✅ Performance optimization insights

## Next Steps

1. **Test website accessibility**
2. **Install Nagios on monitoring server**
3. **Configure monitoring for your website**
4. **Set up email/SMS alerts**
5. **Create monitoring dashboard**

**Your Ansible-deployed website will be fully monitored!** 📊🚀
