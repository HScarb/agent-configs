---
name: project-blueprint
description: Generate key documentation for any project by analyzing source code. Use when user asks to generate project documentation, create docs for codebase, or needs overview/architecture/tech-stack/API/deployment docs. Outputs to project's .claude/docs directory. All content must be source-based with no fabrication.
---

# Project Blueprint

Generate essential documentation for projects by systematically analyzing source code.

## Core Principles

1. **Source-Based Only**: Every statement must have source code evidence. Never fabricate or assume.
2. **Concise & Accurate**: Keep documentation precise and avoid verbose explanations.
3. **Ask When Uncertain**: If information cannot be determined from source code, ask the user.

## Output Location

All documents are generated in the project's `.claude/docs` directory.

## Workflow

### Step 1: Project Analysis

Before generating any document, thoroughly analyze the project:

```
1. Identify project root and structure
2. Find key configuration files (package.json, pom.xml, build.gradle, requirements.txt, Cargo.toml, go.mod, etc.)
3. Locate entry points and main modules
4. Map directory structure and module relationships
5. Identify API definitions (routes, controllers, endpoints)
6. Find deployment configurations (Dockerfile, k8s, CI/CD configs)
```

### Step 2: Document Generation

Generate documents in this order, as later documents may depend on earlier analysis:

1. `tech-stack.md` - Foundation for understanding the project
2. `overview.md` - High-level project understanding
3. `architecture.md` - System structure and relationships
4. `api-design.md` - Interface specifications
5. `deployment.md` - Deployment and operations

### Step 3: Verification

For each document section, include source file references using format:
```
Source: `path/to/file.ext:line_number`
```

## Document Specifications

**IMPORTANT: Each document has exclusive responsibility. Never duplicate content across documents.**

| Document | Exclusive Scope |
|----------|-----------------|
| tech-stack.md | What technologies are used (tools, versions, dependencies) |
| overview.md | Why the project exists (vision, goals, features, users) |
| architecture.md | How the system is structured (modules, data flow, patterns) |
| api-design.md | How to interact with the system (endpoints, models, protocols) |
| deployment.md | How to run the system (env, build, deploy, monitor) |

### 1. tech-stack.md (Technology Stack)

**Scope**: Technology choices and versions only. No build process (→ deployment.md).

| Section | Source Files to Check |
|---------|----------------------|
| Language & Runtime | file extensions, config files |
| Frameworks | package.json, pom.xml, build.gradle, requirements.txt, go.mod |
| Database | config files, ORM models, migration files |
| Build Tools | tool names and versions only |
| Testing | test frameworks and tools |
| Dependencies | lock files, dependency manifests |

**Required Questions if Unclear:**
- Version control strategy (if not evident from config)
- Dependency update policy

### 2. overview.md (Project Overview)

**Scope**: Project identity and purpose only. No directory structure (→ architecture.md).

| Section | Source Files to Check |
|---------|----------------------|
| Project Name | package.json, README, config files |
| Description | README, package.json description field |
| Core Features | main modules, exported functions, API endpoints |
| Target Users | README, comments, documentation |

**Required Questions if Unclear:**
- Project vision and goals (if not in README)
- Target user base
- Core value proposition

### 3. architecture.md (Architecture Design)

**Scope**: System structure and relationships. Includes directory structure.

| Section | Source Files to Check |
|---------|----------------------|
| Directory Structure | actual file tree |
| Module Dependencies | import statements, module definitions |
| Data Flow | controller → service → repository patterns |
| External Integrations | API clients, SDK usage |
| Design Patterns | code structure, class hierarchies |

**Include Diagrams:**
- Use Mermaid syntax for architecture diagrams
- Base diagrams strictly on code analysis

### 4. api-design.md (API Design)

**Scope**: Interface contracts only. No internal implementation (→ architecture.md).

| Section | Source Files to Check |
|---------|----------------------|
| Endpoints | route definitions, controllers |
| Request/Response | DTOs, schemas, type definitions |
| Authentication | middleware, auth configs |
| Error Handling | error handlers, exception classes |
| Data Models | entity classes, database schemas |

**Format:**
```markdown
### [HTTP Method] /path/to/endpoint

**Source:** `path/to/controller.ext:line`

**Request:**
- Headers: ...
- Body: ...

**Response:**
- Success: ...
- Error: ...
```

### 5. deployment.md (Deployment & Operations)

**Scope**: How to build, deploy, and operate. No tool versions (→ tech-stack.md).

| Section | Source Files to Check |
|---------|----------------------|
| Environment Config | .env.example, config files |
| Build Process | Dockerfile, build scripts, CI configs |
| Deployment Target | k8s manifests, cloud configs |
| Health Checks | health endpoints, monitoring configs |
| Logging | logger configs, log statements |

**Required Questions if Unclear:**
- Production deployment process
- Monitoring and alerting setup
- Secret management approach

## Question Protocol

When source code cannot provide answers, ask the user. Format questions as:

```markdown
To complete [document_name], I need clarification on:

1. **[Topic]**: [Specific question]
   - What I found: [evidence from code]
   - What's missing: [what cannot be determined]

2. **[Topic]**: [Specific question]
   ...
```

## Example Output Structure

```
.claude/
└── docs/
    ├── overview.md
    ├── architecture.md
    ├── tech-stack.md
    ├── api-design.md
    └── deployment.md
```

## Document Templates

Each document has a dedicated template in `references/`:

| Document | Template |
|----------|----------|
| tech-stack.md | `references/template-tech-stack.md` |
| overview.md | `references/template-overview.md` |
| architecture.md | `references/template-architecture.md` |
| api-design.md | `references/template-api-design.md` |
| deployment.md | `references/template-deployment.md` |

Read the corresponding template before generating each document.
