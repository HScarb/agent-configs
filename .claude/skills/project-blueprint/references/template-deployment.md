# deployment.md Template

```markdown
# Deployment & Operations

## Environment Configuration

### Required Environment Variables

| Variable | Purpose | Default | Source |
|----------|---------|---------|--------|
| [VAR_NAME] | [Purpose] | [Default] | `[.env.example:line]` |

### Configuration Files

| File | Purpose | Source |
|------|---------|--------|
| [filename] | [Purpose] | `[path:line]` |

## Build Process

### Prerequisites

| Requirement | Version | Source |
|-------------|---------|--------|
| [Tool] | [Version] | `[file:line]` |

### Build Commands

```bash
# [Description]
[command]
```

**Source**: `[package.json|Makefile:line]`

## Deployment

### Container Build

```dockerfile
# Key Dockerfile instructions
[relevant dockerfile content]
```

**Source**: `[Dockerfile:line]`

### Deployment Target

| Target | Configuration | Source |
|--------|--------------|--------|
| [Platform] | [Details] | `[file:line]` |

## Health & Monitoring

### Health Checks

| Endpoint | Purpose | Source |
|----------|---------|--------|
| [path] | [Purpose] | `[file:line]` |

### Logging

| Log Type | Destination | Source |
|----------|-------------|--------|
| [Type] | [Where] | `[file:line]` |

## CI/CD Pipeline

[Describe pipeline based on CI config files]

**Source**: `[.github/workflows|.gitlab-ci.yml:line]`
```
