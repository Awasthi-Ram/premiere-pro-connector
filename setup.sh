#!/usr/bin/env bash
# ==============================================================================
# Premiere Pro MCP Bridge - Automated Setup Script (macOS / Linux)
# ==============================================================================
set -e

echo "=== Adobe Premiere Pro MCP Connector Setup ==="

# Check Node.js
if ! command -v node >/dev/null 2>&1; then
    echo "Error: Node.js is not installed. Please install Node.js >= 18."
    exit 1
fi

NODE_VERSION=$(node -v | tr -d 'v')
MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d'.' -f1)
if [ "$MAJOR_VERSION" -lt 18 ]; then
    echo "Error: Node.js >= 18 is required. Found v$NODE_VERSION."
    exit 1
fi
echo "✓ Node.js v$NODE_VERSION found."

# Check npm
if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm is not installed."
    exit 1
fi
echo "✓ npm $(npm -v) found."

# Install package globally
echo "Installing premiere-pro-mcp globally..."
npm install -g premiere-pro-mcp

# Install CEP plugin
echo "Installing CEP plugin and enabling debug mode..."
premiere-pro-mcp --install-cep

# Configure MCP
mkdir -p .agents
cat <<EOF > .agents/mcp_config.json
{
  "mcpServers": {
    "premiere-pro": {
      "command": "premiere-pro-mcp"
    }
  }
}
EOF
echo "✓ Configured .agents/mcp_config.json"

# Doctor check
echo "Running diagnostics..."
premiere-pro-mcp --doctor

echo "=== Setup complete! Restart Premiere Pro and open Window > Extensions > MCP for Adobe Premiere Pro ==="
