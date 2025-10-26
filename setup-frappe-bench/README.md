# Frappe/ERPNext Full Setup Script for Ubuntu 24.04

This repository contains a bash script to **fully set up a Frappe/ERPNext development environment** on Ubuntu 24.04. It installs all necessary dependencies and optionally applies a **custom MariaDB configuration optimized for Frappe**.

---

## Features

- Updates and upgrades Ubuntu packages
- Installs **Git**
- Installs **Python 3.12** with dev packages
- Installs **MariaDB** and optionally runs `mysql_secure_installation`
- Applies **custom MariaDB configuration for Frappe** (optional)
- Installs **Redis**
- Installs **Node.js 18 via NVM**
- Installs **Yarn**
- Installs **wkhtmltopdf** for PDF generation
- Installs **frappe-bench**
- Initializes **Frappe Bench version 15**
- Non-blocking setup; shows step-by-step progress

---

## Prerequisites

- Ubuntu 24.04
- Internet connection
- Sudo privileges

---

## Usage

1. **Download the script** or clone the repository:

```bash
git clone <your-repo-url>
cd <repo-folder>
```

2. **Make the script executable:

```bash
chmod +x setup-frappe.sh
```

3. **Run the script:

```bash
chmod +x setup-frappe.sh
```

4. **Follow the prompts:

STEP 4: Decide whether to run `mysql_secure_installation`.

STEP 6: Decide whether to replace MariaDB configuration with Frappe-optimized settings.


5. **Wait for the script to finish.

At the end, you will have frappe-bench initialized in the current directory.

## Notes

The script creates a backup of the original MariaDB configuration file at:
```bash
/etc/mysql/mariadb.conf.d/50-server.cnf.bak
```
* If MariaDB is restarted or fails, you can restore the original configuration using the backup.

* The script installs Python 3.12 in the system environment. Make sure no conflicting Python versions are active.

* bench init uses python3.12 to ensure correct version compatibility.

