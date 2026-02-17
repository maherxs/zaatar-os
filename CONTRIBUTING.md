# Contributing to Zaatar OS

Thank you for your interest in contributing to Zaatar OS! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

- Be respectful and considerate of others
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Maintain a professional and friendly environment

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [Issues](https://github.com/YOUR_USERNAME/zaatar-os/issues) section
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - System information (if relevant)

### Submitting Changes

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/zaatar-os.git
   cd zaatar-os
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add comments where necessary
   - Test your changes thoroughly

4. **Commit your changes**
   ```bash
   git commit -m "Add: Description of your changes"
   ```
   Use clear, descriptive commit messages.

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Wait for review and feedback

## Coding Standards

### Scripts

- Use `#!/usr/bin/env bash` for bash scripts
- Include `set -oue pipefail` for error handling
- Add comments explaining complex logic
- Use descriptive variable names
- Follow existing code formatting

### YAML Files

- Use 2 spaces for indentation
- Add comments for clarity
- Keep sections organized
- Follow the existing structure

### Commit Messages

Follow this format:
```
Type: Brief description

Detailed explanation if needed
```

Types:
- `Add:` - New features
- `Fix:` - Bug fixes
- `Update:` - Updates to existing features
- `Remove:` - Removing features
- `Docs:` - Documentation changes
- `Refactor:` - Code refactoring

## Testing

Before submitting:

1. Test your changes in a clean environment
2. Verify that the build process works
3. Check that all scripts execute correctly
4. Ensure no errors are introduced

## Areas for Contribution

- **Documentation**: Improve README, add guides, fix typos
- **Scripts**: Optimize installation scripts, add error handling
- **Configuration**: Improve system settings, add new options
- **Localization**: Improve Arabic support, add translations
- **Applications**: Suggest and add useful applications
- **Themes**: Improve theming, add customization options

## Questions?

Feel free to open an issue for questions or discussions. We're here to help!

Thank you for contributing to Zaatar OS! 🎉
