# api-design.md Template

```markdown
# API Design

## Overview

| Aspect | Value | Source |
|--------|-------|--------|
| Base URL | [URL pattern] | `[file:line]` |
| Protocol | [HTTP/gRPC/etc] | `[file:line]` |
| Auth Method | [JWT/OAuth/etc] | `[file:line]` |

## Authentication

[How authentication works based on code]

**Source**: `[auth_file:line]`

## Endpoints

### [Resource Name]

#### [HTTP Method] /path/to/endpoint

**Source**: `[controller:line]`

**Description**: [What this endpoint does]

**Request**:
```json
{
  "field": "type - description"
}
```

**Response**:
```json
{
  "field": "type - description"
}
```

**Error Codes**:
| Code | Meaning | Source |
|------|---------|--------|
| [4xx/5xx] | [Description] | `[file:line]` |

## Data Models

### [Model Name]

**Source**: `[entity_file:line]`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| [field] | [type] | [yes/no] | [description] |

## Error Handling

| Error Type | HTTP Code | Response Format | Source |
|------------|-----------|-----------------|--------|
| [Type] | [Code] | [Format] | `[file:line]` |
```
