This is a project to help me setup my development environment on macOS and Linux.

## Repository Structure

```
InitDev/
├── main.sh                    # Entry point - orchestrates all modules
├── lib/                       # Modular components
│   ├── logging.sh            # Centralized logging (file + console with colors)
│   ├── system.sh             # OS and shell detection, Homebrew setup
│   ├── install.sh            # Package and tool installation (dependencies, Node, Bun)
│   ├── config.sh             # Configuration (git, aliases, directories, zoxide)
│   └── menu.sh               # Interactive menu system
├── README.md                 # User documentation
└── CLAUDE.md                 # This file
```

