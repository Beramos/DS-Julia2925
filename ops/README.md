# DS-Julia2925 Ops scripts
This folder contains operational scripts to automate the setup and management of a remote Julia/Pluto server for the Julia2925 course.

## 1. setup-remote.sh
Purpose:
Automates the installation and configuration of a Julia environment (with Pluto.jl) on a remote Debian 12 server.
It creates a user, installs Julia, sets up Pluto as a systemd service, and copies course notebooks and examples.

**Usage:** ``` ./setup-remote.sh [OPTIONS] SERVER_ADDRESS [NEW_USERNAME] ```

**Options:**

-h, --help Show help message
-k, --ssh-key PATH Path to public SSH key to add to the new user (optional)
-v, --julia-version VER Julia version to install (default: 1.11.5)
**Arguments:**

SERVER_ADDRESS Address of the server to connect to (required)
NEW_USERNAME Username to create (default: user)
Example: ``` ./setup-remote.sh -k ~/.ssh/id_rsa.pub -v 1.11.5 example.com juliauser ./setup-remote.sh example.com ```

**What it does:**

- Connects to the remote server as root.
- Creates a new user (or uses the default user).
- Optionally sets up SSH key authentication.
- Installs Julia and Pluto.
- Copies the notebooks and examples folders to the user's home.
- Configures Pluto to run as a systemd service, accessible on port 1234.

## 2. check-secret-remote.sh
**Purpose:**
Fetches the secret URL for the running Pluto server from the remote machine's systemd logs.

**Usage:** ``` check-secret-remote.sh SERVER_ADDRESS ```

**Example:** ``` check-secret-remote.sh example.com ```

What it does:

- Connects to the remote server via SSH.
- Reads the last 100 lines of the Pluto systemd service logs.
- Extracts and prints the Pluto access URL (including the secret token) in a user-friendly, colored format.

**Note:**
Make sure your remote server allows SSH root login and has outbound internet access.
The scripts are designed to be idempotent and safe to re-run.
For best results, run these scripts from the root of the course repository so the notebooks and examples folders are found.
