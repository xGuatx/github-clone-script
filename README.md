# GitHub Repository Clone & Re-upload Script

Simple Bash script to clone a public GitHub repository and push it to your own private repository while preserving git history.

## Purpose

This tool was created to avoid using GitHub forks when you want to:
- Have full control over a repository copy
- Keep your own independent version
- Preserve git history from the original project
- Push to a private repository without fork relationship

## Features

- Clone any public GitHub repository
- Automatically detect default branch (main/master/etc.)
- Preserve full git history
- Secure credential input (hidden password prompt)
- Support for GitHub Personal Access Tokens (2FA compatible)
- Interactive prompts (no hardcoded credentials)

## Prerequisites

- `git` installed and configured
- GitHub account with access to create private repositories
- (Optional) GitHub Personal Access Token if 2FA is enabled

## Usage

### Interactive Mode (Recommended)

```bash
chmod +x clone.sh
./clone.sh
```

The script will prompt for:
1. **Public repository URL** - The GitHub repo you want to clone
2. **Local folder name** - Name for the cloned directory (optional, auto-detected from repo name)
3. **Private repository URL** - Your private GitHub repo URL (must end with .git)
4. **GitHub username** - Your GitHub username
5. **GitHub token/password** - Your password or Personal Access Token (hidden input)

### Example Session

```bash
$ ./clone.sh
Public repository URL to clone: https://github.com/example/public-repo
Local folder name (or empty for auto):
Private repository URL (HTTPS with .git): https://github.com/yourusername/your-private-repo.git
GitHub username: yourusername
GitHub token (PAT if 2FA enabled): ******************

[+] Cloning https://github.com/example/public-repo...
[+] Pushing to private repository (main branch)...
[OK] Transfer completed successfully.
```

## Creating a Personal Access Token

If you have 2FA enabled on GitHub, you'll need a Personal Access Token (PAT):

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" -> "Generate new token (classic)"
3. Give it a descriptive name (e.g., "Clone Script")
4. Select scopes: `repo` (full control of private repositories)
5. Click "Generate token"
6. **Copy the token immediately** (you won't see it again)
7. Use this token instead of your password when prompted

## Security Notes

- **Never commit your .env file** if you create one
- Credentials are entered interactively (not stored in script)
- Token is masked during input (`read -s`)
- Repository clones are excluded from git (see .gitignore)
- Script is safe to share (no hardcoded credentials)

## How It Works

1. **Clone** the public repository to a local folder
2. **Detect** the default branch automatically
3. **Remove** the original `origin` remote
4. **Add** your private repository as new `origin`
5. **Push** all commits and history to your private repo

## Troubleshooting

**"Clone failed":**
- Verify the public repository URL is correct
- Check your internet connection
- Ensure the repository is publicly accessible

**"Branch 'X' does not exist locally":**
- The script will show available branches
- The repository might use a non-standard default branch
- Check the output and manually specify the branch if needed

**Authentication failed:**
- If using 2FA, make sure you're using a PAT (not password)
- Verify your token has `repo` scope
- Check that your username is correct

**Permission denied:**
- Ensure your private repository exists on GitHub
- Verify you have write access to the private repository
- Check that the private repo URL is correct (must end with .git)

## Why Not Fork?

GitHub forks have limitations:
- Forks maintain a relationship with the upstream repository
- You cannot make a forked repository truly independent
- Private forks of public repos have visibility restrictions
- This script gives you full control and independence

## Advanced Usage

For automation or CI/CD, you could modify the script to use environment variables instead of interactive prompts. See `.env.example` for the structure.

## License

This is a simple utility script for personal use. No warranty provided. Use at your own risk.

## Contributing

This is a personal tool, but suggestions for improvements are welcome via issues.
