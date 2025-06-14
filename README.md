# <center>🚀 Smith-Pad</center>

This repository is served as a place where all-in-one in codebase is here. 📚

## Quick Links 🔗

- [GitHub Repositories](https://github.com/smith-pad/) 📦
- [Codeberg Repositories](https://codeberg.org/smith-pad/) 📦

## Cursor Rules

This repository uses automated cursor rules to maintain code quality and consistency. The rules are defined in `.cursor/rules.json` and are automatically updated through GitHub Actions.

### Current Rules

1. **Code Style**
   - Enforces consistent code style
   - Checks for trailing whitespace
   - Ensures spaces instead of tabs

2. **Documentation**
   - Ensures proper documentation
   - Requires ticket numbers for TODO comments

3. **Security**
   - Checks for potential hardcoded credentials
   - Monitors for sensitive information

### Automation

The cursor rules are automatically:
- Checked on every push and pull request
- Updated weekly via GitHub Actions
- Committed back to the repository if changes are needed

To manually update the rules, you can run:
```bash
cursor rules update
```

To check the current rules:
```bash
cursor rules check
```