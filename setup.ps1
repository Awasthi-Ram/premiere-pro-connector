# ==============================================================================
# Premiere Pro MCP Bridge - Automated All-in-One Setup Script
# ==============================================================================
# Author: Ram Awasthi
# Description: Fully automates the installation, CEP extension registration, 
#              MCP configuration, and diagnostics for Adobe Premiere Pro MCP Bridge.
# ==============================================================================

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n[+] $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "    [OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "    [!] $Message" -ForegroundColor Yellow
}

function Write-Err {
    param([string]$Message)
    Write-Host "    [ERR] $Message" -ForegroundColor Red
}

Clear-Host
Write-Host "==========================================================" -ForegroundColor Magenta
Write-Host "   Adobe Premiere Pro MCP Connector - Automated Setup   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Magenta

# ------------------------------------------------------------------------------
# Step 1: Check Node.js and npm
# ------------------------------------------------------------------------------
Write-Step "Step 1: Checking Node.js and npm requirements..."

try {
    $nodeVersionRaw = node -v 2>$null
    if (-not $nodeVersionRaw) {
        throw "Node.js is not found in PATH."
    }
    
    $nodeVersionClean = $nodeVersionRaw.TrimStart('v')
    $majorVersion = [int]($nodeVersionClean.Split('.')[0])
    
    if ($majorVersion -lt 18) {
        throw "Node.js version $nodeVersionRaw found, but version 18 or higher is required."
    }
    Write-Ok "Node.js $nodeVersionRaw is installed (meets >= 18 requirement)."
} catch {
    Write-Err "Node.js check failed: $_"
    Write-Host "Please install Node.js 18 or newer from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

try {
    $npmVersion = npm -v 2>$null
    if (-not $npmVersion) {
        throw "npm is not found in PATH."
    }
    Write-Ok "npm v$npmVersion is available."
} catch {
    Write-Err "npm check failed: $_"
    exit 1
}

# ------------------------------------------------------------------------------
# Step 2: Install premiere-pro-mcp globally
# ------------------------------------------------------------------------------
Write-Step "Step 2: Installing premiere-pro-mcp globally..."
try {
    npm install -g premiere-pro-mcp
    Write-Ok "premiere-pro-mcp installed successfully."
} catch {
    Write-Err "Failed to install premiere-pro-mcp: $_"
    exit 1
}

# ------------------------------------------------------------------------------
# Step 3: Install CEP extension & enable player debug mode
# ------------------------------------------------------------------------------
Write-Step "Step 3: Installing local CEP extension and enabling OS debug mode..."
try {
    premiere-pro-mcp --install-cep
    Write-Ok "CEP extension installed and OS player debug mode enabled."
} catch {
    Write-Err "Failed to install CEP extension: $_"
    exit 1
}

# ------------------------------------------------------------------------------
# Step 4: Configure Antigravity MCP Settings
# ------------------------------------------------------------------------------
Write-Step "Step 4: Configuring MCP configuration files..."

$mcpConfigData = @{
    "mcpServers" = @{
        "premiere-pro" = @{
            "command" = "premiere-pro-mcp"
        }
    }
}

# 4a: Local Workspace configuration (.agents/mcp_config.json)
$localConfigDir = Join-Path -Path $PSScriptRoot -ChildPath ".agents"
$localConfigFile = Join-Path -Path $localConfigDir -ChildPath "mcp_config.json"

if (-not (Test-Path $localConfigDir)) {
    New-Item -ItemType Directory -Path $localConfigDir -Force | Out-Null
}

$localJson = $mcpConfigData | ConvertTo-Json -Depth 5
Set-Content -Path $localConfigFile -Value $localJson -Encoding UTF8
Write-Ok "Updated workspace MCP config at $localConfigFile"

# 4b: Global configuration (~/.gemini/config/mcp_config.json)
$userProfile = [System.Environment]::GetFolderPath('UserProfile')
$globalConfigDir = Join-Path -Path $userProfile -ChildPath ".gemini\config"
$globalConfigFile = Join-Path -Path $globalConfigDir -ChildPath "mcp_config.json"

if (-not (Test-Path $globalConfigDir)) {
    New-Item -ItemType Directory -Path $globalConfigDir -Force | Out-Null
}

if (Test-Path $globalConfigFile) {
    try {
        $existing = Get-Content -Path $globalConfigFile -Raw | ConvertFrom-Json
        if (-not $existing.mcpServers) {
            $existing | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value (New-Object PSObject)
        }
        $existing.mcpServers | Add-Member -MemberType NoteProperty -Name "premiere-pro" -Value (@{ "command" = "premiere-pro-mcp" }) -Force
        $updatedJson = $existing | ConvertTo-Json -Depth 10
        Set-Content -Path $globalConfigFile -Value $updatedJson -Encoding UTF8
        Write-Ok "Updated global MCP config at $globalConfigFile"
    } catch {
        Set-Content -Path $globalConfigFile -Value $localJson -Encoding UTF8
        Write-Ok "Created global MCP config at $globalConfigFile"
    }
} else {
    Set-Content -Path $globalConfigFile -Value $localJson -Encoding UTF8
    Write-Ok "Created global MCP config at $globalConfigFile"
}

# ------------------------------------------------------------------------------
# Step 5: Run Diagnostics
# ------------------------------------------------------------------------------
Write-Step "Step 5: Running diagnostics (premiere-pro-mcp --doctor)..."
premiere-pro-mcp --doctor

# ------------------------------------------------------------------------------
# Check if Premiere Pro is currently running
# ------------------------------------------------------------------------------
$pproProcess = Get-Process -Name "*Adobe Premiere*" -ErrorAction SilentlyContinue
if ($pproProcess) {
    Write-Warn "Adobe Premiere Pro is currently running (PID: $($pproProcess.Id))."
    Write-Warn "IMPORTANT: You MUST completely restart Premiere Pro to load newly installed extensions."
}

# ------------------------------------------------------------------------------
# Final Instructions
# ------------------------------------------------------------------------------
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "                SETUP COMPLETED SUCCESSFULLY!             " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps to complete inside Adobe Premiere Pro:" -ForegroundColor Yellow
Write-Host "  1. Restart Adobe Premiere Pro." -ForegroundColor White
Write-Host "  2. Open your project and active sequence." -ForegroundColor White
Write-Host "  3. Go to top menu: Window -> Extensions -> MCP for Adobe Premiere Pro." -ForegroundColor White
Write-Host "  4. Keep the extension panel open." -ForegroundColor White
Write-Host "  5. In Antigravity, use skill.md instructions to ping, inspect, or edit your timeline!" -ForegroundColor White
Write-Host ""
Write-Host "Enjoy automated editing with Antigravity and Premiere Pro MCP!" -ForegroundColor Cyan
Write-Host ""
