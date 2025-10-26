# 🐳 Install Docker & Docker Compose on Ubuntu

A simple shell script to install **Docker Engine**, **Docker CLI**, and **Docker Compose (v2)** on Ubuntu — quickly and securely.

## ✅ Supported Ubuntu Versions
- Ubuntu 20.04 (Focal Fossa)  
- Ubuntu 22.04 (Jammy Jellyfish)  
- Ubuntu 24.04 (Noble Numbat)

---

## 🚀 Features
- Removes old Docker versions automatically  
- Adds Docker’s official repository and GPG key  
- Installs Docker Engine, CLI, Buildx, and Compose plugin  
- Configures Docker to start on boot  
- Adds your user to the `docker` group (no need for `sudo` later)  
- Works for both AMD64 and ARM64 architectures  

---

## 📦 Installation

### 1️⃣ Clone the repository
```bash
git clone https://github.com/<your-username>/install-docker-ubuntu.git
cd Create-New-Bench-Shell-Script/install-Docker-on-Ubuntu
```

### 2️⃣ Make the script executable
```bash
chmod +x install-docker.sh
```

### 3️⃣ Run the script
```bash
./install-docker.sh
```
If you get a permission error:
```bash
sudo chown $USER:$USER install-docker.sh
chmod +x install-docker.sh
./install-docker.sh
```

### 🧪 Verify the Installation
```bash
docker --version
```
Check Docker Compose:
```bash
docker compose version
```
Run a test container:
```bash
docker run hello-world
```


## ⚙️ Optional: Enable Docker on Boot
(Already done by the script — but here for reference)
```bash
sudo systemctl enable docker
```


## 🧹 Uninstall Docker (if ever needed)
```bash
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker /var/lib/containerd /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.gpg
```