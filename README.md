# Adobe Premiere Pro MCP Connector 🎬🤖

An automated open-source Model Context Protocol (MCP) bridge connecting AI coding agents (such as Google Antigravity / Gemini) directly to **Adobe Premiere Pro** on your local machine.

---

## 🚀 Quick Start (One-Click Setup)

Run the single automated setup file to install all dependencies, configure the MCP server, install the CEP extension into Premiere Pro, and verify system health:

### Windows (One-Click)
Double-click `setup.bat` or run:
```powershell
.\setup.ps1
```

### macOS / Linux
```bash
chmod +x setup.sh
./setup.sh
```

---

## 🛠️ What the Automated Setup Does

1. **System Path Check**: Verifies that Node.js ($\ge 18$) and `npm` are available.
2. **Global MCP Server Installation**: Automatically installs `premiere-pro-mcp` globally via npm.
3. **CEP Extension Registration**: Runs `premiere-pro-mcp --install-cep`, placing the extension into Adobe's CEP directory and enabling OS player debug mode for unsigned local plugins.
4. **Antigravity MCP Configuration**: Creates and configures `.agents/mcp_config.json` and updates global `~/.gemini/config/mcp_config.json`:
   ```json
   {
     "mcpServers": {
       "premiere-pro": {
         "command": "premiere-pro-mcp"
       }
     }
   }
   ```
5. **Component Health Check**: Executes `premiere-pro-mcp --doctor` to validate all subsystems.

---

## 🎬 How to Use Inside Premiere Pro

1. **Restart Premiere Pro**: After running the setup script, completely restart Adobe Premiere Pro so it registers the newly installed extension.
2. **Open Your Project**: Load any existing `.prproj` project or create a new one.
3. **Open the Extension Panel**:
   - In the top menu, go to: **`Window` > `Extensions` > `MCP for Adobe Premiere Pro`**
4. **Keep the Panel Open**: The panel maintains the local WebSocket/HTTP connection between Antigravity and Premiere Pro.
5. **Start Editing via AI**: You can now ask Antigravity to inspect, cut, title, transition, and arrange clips directly on your timeline!

---

## 📁 Repository Contents

| File | Description |
| :--- | :--- |
| **[`setup.bat`](file:///c:/Users/ramaw/premior%20pro%20connector/setup.bat)** | One-click Windows batch launcher for instant automated setup. |
| **[`setup.ps1`](file:///c:/Users/ramaw/premior%20pro%20connector/setup.ps1)** | Full-featured PowerShell automation script with formatted logs & checks. |
| **[`setup.sh`](file:///c:/Users/ramaw/premior%20pro%20connector/setup.sh)** | Cross-platform POSIX setup script for macOS and Linux. |
| **[`skill.md`](file:///c:/Users/ramaw/premior%20pro%20connector/skill.md)** | Elite post-production editing skill definitions, mode selection gate, and track discipline rules. |
| **[`prompt1.txt`](file:///c:/Users/ramaw/premior%20pro%20connector/prompt1.txt)** | Starter prompt for environment setup, tool verification, and doctor check. |
| **[`prompt2.txt`](file:///c:/Users/ramaw/premior%20pro%20connector/prompt2.txt)** | Starter prompt for pinging the bridge and inspecting active sequence metadata. |
| **[`.agents/mcp_config.json`](file:///c:/Users/ramaw/premior%20pro%20connector/.agents/mcp_config.json)** | Local Antigravity MCP server configuration mapping. |
| **[`countdown_timer_5s.mov`](file:///c:/Users/ramaw/premior%20pro%20connector/countdown_timer_5s.mov)** | 5-second transparent Apple ProRes 4444 HUD countdown overlay asset. |

---

## 🎨 Editing Modes (`skill.md`)

When executing editing tasks, Antigravity adheres to two operational modes:

### 1. ⚡ Straightforward Mode (Utilitarian & Exact)
- Follows instructions literally with zero creative deviation.
- Clean, standard typography with neutral white styling.
- Standard cut-point transitions (`Dip to Black`, `Cross Dissolve`).
- Fast, predictable, minimal adjustments.

### 2. 🎬 Creative Director Mode (Stylized & Tone-Matched)
- Analyzes video genre, pacing, and mood prior to editing.
- Curated fonts tailored to context (e.g. brutalist tech, documentary serif, kinetic sans).
- Dynamic layout placement, rule of thirds, accent colors, and beat-synced cuts.
- Provides a 2-line "Editor's Rationale" explaining creative decisions.

---

## 🛡️ Track Discipline & Editing Rules

- **Track Discipline**: Secondary overlays, text, graphics, and B-roll are always placed on dedicated upper tracks (`V2`, `V3+`) to safeguard primary footage on `V1`.
- **Audio Protection**: Transitions and edits never unintentionally clip or desync adjacent audio tracks on `A1`.
- **Title Safety**: Respects 80% broadcast title-safe margins for 16:9 horizontal video and social safe zones for 9:16 vertical video.

---

## 👨‍💻 Author
**Ram Awasthi**
