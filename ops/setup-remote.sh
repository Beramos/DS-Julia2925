#!/bin/bash
set -e

# Default values
JULIA_VERSION="1.11.5"
SSH_KEY_PATH=""
DEFAULT_USERNAME="user"

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS] SERVER_ADDRESS [NEW_USERNAME]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 Show this help message"
    echo "  -k, --ssh-key PATH         Path to public SSH key to add to the new user (optional)"
    echo "  -v, --julia-version VER    Julia version to install (default: $JULIA_VERSION)"
    echo ""
    echo "Arguments:"
    echo "  SERVER_ADDRESS             Address of the server to connect to (required)"
    echo "  NEW_USERNAME               Username to create (default: $DEFAULT_USERNAME)"
    echo ""
    echo "Example:"
    echo "  $0 -k ~/.ssh/id_rsa.pub -v 1.11.5 example.com newuser"
    echo "  $0 example.com             # Creates default user '$DEFAULT_USERNAME'"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -k|--ssh-key)
            SSH_KEY_PATH="$2"
            shift 2
            ;;
        -v|--julia-version)
            JULIA_VERSION="$2"
            shift 2
            ;;
        *)
            if [[ -z "$SERVER_ADDRESS" ]]; then
                SERVER_ADDRESS="$1"
                shift
            elif [[ -z "$NEW_USERNAME" ]]; then
                NEW_USERNAME="$1"
                shift
            else
                echo "Error: Unknown parameter: $1"
                show_help
                exit 1
            fi
            ;;
    esac
done

# Set default username if not provided
if [[ -z "$NEW_USERNAME" ]]; then
    NEW_USERNAME="$DEFAULT_USERNAME"
    echo "No username specified, using default: $NEW_USERNAME"
fi

# Validate required parameters
if [[ -z "$SERVER_ADDRESS" && -z "$REMOTE_EXECUTION" ]]; then
  echo "Error: SERVER_ADDRESS is required."
  show_help
  exit 1
fi

# Check if SSH key exists if specified
if [[ -n "$SSH_KEY_PATH" && ! -f "$SSH_KEY_PATH" ]]; then
    echo "Error: SSH key file not found: $SSH_KEY_PATH"
    exit 1
fi

# Determine if running locally or on remote server
if [[ -z "$REMOTE_EXECUTION" ]]; then
    # Running locally - prepare to copy to server and execute
    
    # Encode SSH key content if provided
    SSH_KEY_CONTENT=""
    if [[ -n "$SSH_KEY_PATH" ]]; then
        SSH_KEY_CONTENT=$(cat "$SSH_KEY_PATH" | base64 -w 0)
    fi
    
    echo "Connecting to server $SERVER_ADDRESS..."
    # Copy this script to the server
    scp "$0" "root@$SERVER_ADDRESS:/tmp/setup_julia_pluto.sh"
    
    # Execute the script on the remote server
    echo "Executing setup on server..."
    ssh "root@$SERVER_ADDRESS" "chmod +x /tmp/setup_julia_pluto.sh && REMOTE_EXECUTION=1 NEW_USERNAME='$NEW_USERNAME' JULIA_VERSION='$JULIA_VERSION' SSH_KEY_CONTENT='$SSH_KEY_CONTENT' /tmp/setup_julia_pluto.sh"
    
    echo "Setup completed successfully!"
    echo "Access Pluto at http://$SERVER_ADDRESS:1234/"
    exit 0
else
    # Rest of the script remains the same...
    # Running on remote server - perform setup
    echo "Running setup on server..."
    
    # Create the user with home directory
    echo "Creating user: $NEW_USERNAME"
    useradd -m -s /bin/bash "$NEW_USERNAME"
    # Generate a random password
    RANDOM_PASSWORD=$(openssl rand -base64 12)
    echo "$NEW_USERNAME:$RANDOM_PASSWORD" | chpasswd
    echo "User created with password: $RANDOM_PASSWORD"
    
    # Set up SSH key if provided
    if [[ -n "$SSH_KEY_CONTENT" ]]; then
        echo "Setting up SSH key for $NEW_USERNAME"
        mkdir -p /home/$NEW_USERNAME/.ssh
        echo "$SSH_KEY_CONTENT" | base64 -d > /home/$NEW_USERNAME/.ssh/authorized_keys
        chmod 700 /home/$NEW_USERNAME/.ssh
        chmod 600 /home/$NEW_USERNAME/.ssh/authorized_keys
        chown -R $NEW_USERNAME:$NEW_USERNAME /home/$NEW_USERNAME/.ssh
    fi
    
    # Install Julia
    echo "Installing Julia..."
    su - $NEW_USERNAME -c "curl -fsSL https://install.julialang.org | sh"
    
    # Add specified Julia version using juliaup
    echo "Adding Julia version $JULIA_VERSION..."
    su - $NEW_USERNAME -c "source ~/.bashrc && juliaup add $JULIA_VERSION"
    su - $NEW_USERNAME -c "source ~/.bashrc && juliaup default $JULIA_VERSION"
    
    # Create startPluto.jl
    echo "Creating startPluto.jl..."
    cat << 'EOF' > /home/$NEW_USERNAME/startPluto.jl
using Pluto
Pluto.run(host="0.0.0.0")
EOF
    chown $NEW_USERNAME:$NEW_USERNAME /home/$NEW_USERNAME/startPluto.jl
    
    # Install Pluto
    echo "Installing Pluto..."
    su - $NEW_USERNAME -c "source ~/.bashrc && julia -e 'using Pkg; Pkg.add(\"Pluto\")'"
    
    # Find julia path
    JULIA_PATH=$(su - $NEW_USERNAME -c "source ~/.bashrc && which julia")
    if [[ -z "$JULIA_PATH" ]]; then
        # Fallback path
        if [[ -f /home/$NEW_USERNAME/.juliaup/bin/julia ]]; then
            JULIA_PATH="/home/$NEW_USERNAME/.juliaup/bin/julia"
        else
            echo "Warning: Could not find Julia executable. Using 'julia' in PATH."
            JULIA_PATH="julia"
        fi
    fi
    
    # Create systemd service file
    echo "Creating systemd service for Pluto..."
    cat << EOF > /etc/systemd/system/pluto-server.service
[Unit]
Description=Pluto Notebook Server
After=network.target

[Service]
Type=simple
User=$NEW_USERNAME
WorkingDirectory=/home/$NEW_USERNAME
ExecStart=$JULIA_PATH /home/$NEW_USERNAME/startPluto.jl
Restart=on-failure
Environment=PATH=/home/$NEW_USERNAME/.juliaup/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd, enable and start the service
    systemctl daemon-reload
    systemctl enable pluto-server
    systemctl start pluto-server
    
    # Display service status
    echo "Checking service status..."
    systemctl status pluto-server --no-pager
    
    echo "✅ Setup complete!"
    echo "Pluto server is now running and configured to start on boot"
    echo "You can access it at http://SERVER_IP:1234/"
    
    exit 0
fi