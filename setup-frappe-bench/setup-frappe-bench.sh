#!/bin/bash
#========================================================
# Full Ubuntu 24.04 Frappe/ERPNext Setup Script
# Installs Python, MariaDB, Redis, Node.js, Yarn, wkhtmltopdf
# and sets up frappe-bench with custom MariaDB config
#========================================================

set -e

echo "======================================================="
echo "STEP 0 : Update & Upgrade"
echo "======================================================="
sudo apt update && sudo apt upgrade -y

echo "======================================================="
echo "STEP 1 : Install Git"
echo "======================================================="
sudo apt-get install git -y

echo "======================================================="
echo "STEP 2 : Install Python 3.12 and Dev Packages"
echo "======================================================="
sudo apt install -y python3-dev python3-setuptools python3-pip python3.12-venv

echo "======================================================="
echo "STEP 3 : Install MariaDB"
echo "======================================================="
sudo apt-get install -y software-properties-common
sudo apt install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
echo "MariaDB service status:"
sudo systemctl status mariadb | grep active

echo "======================================================="
echo "STEP 4 : Secure MariaDB Installation (Optional)"
echo "======================================================="
read -p "Do you want to run mysql_secure_installation? [Y/n]: " RUN_MYSQL_SECURE
if [[ "$RUN_MYSQL_SECURE" =~ ^[Yy]$ || -z "$RUN_MYSQL_SECURE" ]]; then
    sudo mysql_secure_installation
else
    echo "Skipping mysql_secure_installation..."
    echo "You can setup mysql_secure_installation later."
fi

echo "======================================================="
echo "STEP 5 : Install MySQL Development Files"
echo "======================================================="
sudo apt-get install -y libmysqlclient-dev

echo "======================================================="
echo "STEP 6 : MariaDB Config....."
echo "======================================================="
read -p "Do you want to replace MariaDB config for Frappe? [Y/n]: " CHANGE_MARIADB_CONF

if [[ "$CHANGE_MARIADB_CONF" =~ ^[Yy]$ || -z "$CHANGE_MARIADB_CONF" ]]; then

    sudo cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bak
    sudo tee /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null <<'EOF'
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]
#############################################

user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysqld.sock
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc-messages-dir = /usr/share/mysql
bind-address = 127.0.0.1
query_cache_size = 16M
log_error = /var/log/mysql/error.log

##############################################
# this is only for the mysqld standalone daemon
[mysqld]

#
# * Basic Settings
#

#user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
basedir                 = /usr
#datadir                 = /var/lib/mysql
#tmpdir                  = /tmp

# Broken reverse DNS slows down connections considerably and name resolve is
# safe to skip if there are no "host by domain name" access grants
#skip-name-resolve

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address            = 127.0.0.1

#
# * Fine Tuning
#

#key_buffer_size        = 128M
#max_allowed_packet     = 1G
#thread_stack           = 192K
#thread_cache_size      = 8
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
#myisam_recover_options = BACKUP
#max_connections        = 100
#table_cache            = 64

#
# * Logging and Replication
#

# Note: The configured log file or its directory need to be created
# and be writable by the mysql user, e.g.:
# $ sudo mkdir -m 2750 /var/log/mysql
# $ sudo chown mysql /var/log/mysql

# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# Recommend only changing this at runtime for short testing periods if needed!
#general_log_file       = /var/log/mysql/mysql.log
#general_log            = 1

# When running under systemd, error logging goes via stdout/stderr to journald
# and when running legacy init error logging goes to syslog due to
# /etc/mysql/conf.d/mariadb.conf.d/50-mysqld_safe.cnf
# Enable this if you want to have error logging into a separate file
#log_error = /var/log/mysql/error.log
# Enable the slow query log to see queries with especially long duration
#log_slow_query_file    = /var/log/mysql/mariadb-slow.log
#log_slow_query_time    = 10
#log_slow_verbosity     = query_plan,explain
#log-queries-not-using-indexes
#log_slow_min_examined_row_limit = 1000

# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replica, see README.Debian about other
#       settings you may need to change.
#server-id              = 1
#log_bin                = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
#max_binlog_size        = 100M

#
# * SSL/TLS
#

# For documentation, please read
# https://mariadb.com/kb/en/securing-connections-for-client-and-server/
#ssl-ca = /etc/mysql/cacert.pem
#ssl-cert = /etc/mysql/server-cert.pem
#ssl-key = /etc/mysql/server-key.pem
#require-secure-transport = on

#
# * Character sets
#

# MySQL/MariaDB default is Latin1, but in Debian we rather default to the full
# utf8 4-byte character set. See also client.cnf
# character-set-server  = utf8mb4
# collation-server      = utf8mb4_general_ci

#
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
# Most important is to give InnoDB 80 % of the system RAM for buffer use:
# https://mariadb.com/kb/en/innodb-system-variables/#innodb_buffer_pool_size
#innodb_buffer_pool_size = 8G
#######################################

innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

#######################################
# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.11 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.11]
#######################################

[mysql]
default-character-set = utf8mb4

#####################################
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]
#############################################

user = mysql
pid-file = /run/mysqld/mysqld.pid
socket = /run/mysqld/mysql

##

EOF


    sudo systemctl restart mariadb
    sudo systemctl status mariadb
    echo "MariaDB configuration Changed for Frappe successfully!"
else
    echo "Keeping default MariaDB configuration..."
fi

echo "======================================================="
echo "STEP 7 : Install Redis"
echo "======================================================="
sudo apt-get install redis-server -y

echo "======================================================="
echo "STEP 8 : Install Node.js 18 via NVM"
echo "======================================================="

sudo apt install curl -y

# Install NVM (skip if already installed)
if [ ! -d "/root/.nvm" ]; then
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
fi

# Explicitly load NVM in this script
export NVM_DIR="/root/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
else
    echo "ERROR: nvm.sh not found!"
    exit 1
fi

# Optional: load bash_completion
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Install Node.js 18 and set default
nvm install 18
nvm alias default 18
nvm use 18


echo "======================================================="
echo "STEP 9 : Install Yarn"
echo "======================================================="
sudo apt-get install npm -y
sudo npm install -g yarn

echo "======================================================="
echo "STEP 10 : Install wkhtmltopdf"
echo "======================================================="
sudo apt-get install xvfb libfontconfig wkhtmltopdf -y
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -f -y
wkhtmltopdf --version

echo "======================================================="
echo "STEP 11 : Install frappe-bench"
echo "======================================================="
sudo -H pip3 install frappe-bench --break-system-packages
bench --version

echo "======================================================="
echo "STEP 12 : Initialize Frappe Bench Version 15"
echo "======================================================="
bench init frappe-bench --frappe-branch version-15
cd frappe-bench

echo "======================================================="
echo "Setup Completed!"
echo "======================================================="
