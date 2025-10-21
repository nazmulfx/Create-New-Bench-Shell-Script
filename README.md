# Create-New-Bench-Shell-Script
Interactive Bash script to quickly set up a Frappe/ERPNext bench. Initialize a bench, add apps with optional branches, create a site, install apps on it (ERPNext first if added), and start the bench—all via a guided, step-by-step interactive process for developers.


# Frappe Bench Interactive Setup Script

Interactive Bash script to quickly set up a Frappe/ERPNext bench. Initialize a bench, add apps with optional branches, create a site, automatically install apps on the site (ERPNext first if added), and start the bench—all via a guided, step-by-step interactive process for developers.

---

## Features

- Initialize a Frappe bench with custom **name, branch, and path**.
- Add multiple apps interactively with optional branches.
- Create a new site and switch to it.
- Automatically install all added apps on the site, ensuring `erpnext` installs first if available.
- Start the bench at the end for immediate use.

---

## Prerequisites

Before running the script, ensure you have the following installed:

- [Python 3.11+](https://www.python.org/downloads/)
- [Node.js & npm](https://nodejs.org/)
- [Yarn](https://yarnpkg.com/)
- [MariaDB / MySQL](https://mariadb.org/)
- [Redis](https://redis.io/)
- [wkhtmltopdf](https://wkhtmltopdf.org/)
- [Bench CLI](https://github.com/frappe/bench)

> Make sure the `bench` command is globally accessible in your shell.

---

## Usage

1. **Clone this repository**:

```bash
git clone https://github.com/nazmulfx/Create-New-Bench-Shell-Script.git
cd frappe-bench-setup


2. **Make the script executable:**:

```bash
chmod +x create_bench_script.sh


3. **Run the script:**:

```bash
./create_bench_script.sh


4. **Follow the interactive prompts:**:

- Enter bench name.
- Choose a Frappe branch (default: version-15).
- Optionally provide a path for the bench (default: current directory).
- Add apps one by one (optional). Leave branch empty for default.
- Create a new site (optional). Apps will be installed automatically, erpnext first if added.
- Script will start the bench at the end.

## Frappe Bench Interactive Setup Script

1. Enter bench name: my-bench
2. Enter Frappe branch [version-15]: 
3. Enter path to create bench [/home/user]: 

4. Do you want to add an app? [y/n]: y
   Enter app name: erpnext
   Enter app branch (leave empty for default): 

   Do you want to add an app? [y/n]: y
   Enter app name: custom_app
   Enter app branch (leave empty for default): 

   Do you want to add an app? [y/n]: n

5. Do you want to create a new site? [y/n]: y
   Enter site name (e.g., site1.local): site1.local

✅ Site created and apps installed.
Starting bench...


## Notes

- If erpnext is added among apps, it will always be installed first on the site.

- You can run the script multiple times to create multiple benches or sites.

- The script is interactive and intended for development/testing purposes.