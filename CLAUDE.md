# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A library of agent skills (Agent Skills format) packaged as an installable plugin for Claude Code, Codex, and Cursor. There is no application code, build step, or test suite — the deliverables are the `SKILL.md` documents themselves plus the packaging that distributes them.

## Architecture

`skills/` is the single source of truth. Everything else is packaging that points at it:

- `skills/<name>/SKILL.md` — one skill per directory; YAML frontmatter `name` must match the directory name, `description` must be trigger-style ("Use when...") describing *when* to invoke, never summarizing the skill's workflow. Heavy reference material (templates, syntax mappings) goes in `skills/<name>/references/`, linked by relative path from SKILL.md.
- `.claude-plugin/plugin.json` + `marketplace.json` — Claude Code plugin; skills are auto-discovered from `skills/` at plugin root. The marketplace enables `/plugin marketplace add HScarb/agent-configs`.
- `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json` — Codex/Cursor manifests; both declare `"skills": "./skills/"`.
- `bin/install.js` + `package.json` — `npx github:HScarb/agent-configs` entry point; a dependency-free Node script (ESM, Node ≥18) that copies `skills/*` into `~/.claude/skills`, `~/.codex/skills`, `~/.cursor/skills` (auto-detected by which config dir exists, or `--agent`), with `--project` targeting the cwd instead of home.

Layout mirrors github.com/obra/superpowers.

**Version sync:** the version number is duplicated in 5 files — `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, and `package.json`. Bump all of them together.

## Commands

```bash
node bin/install.js --list                 # enumerate skills (validates each dir has SKILL.md)
node bin/install.js --project --agent claude   # smoke-test install into a scratch cwd
node -e "JSON.parse(require('fs').readFileSync('<file>'))"   # validate a manifest after editing
```

To verify the whole package: run the install in a temp dir containing an empty `.claude/` and check every skill lands with its `references/` intact.

## Conventions

- Adding a skill: create `skills/<name>/SKILL.md` only — the installer and all three plugin manifests pick it up automatically; no manifest edit needed. Update the skill table in `README.md`.
- Skill bodies may be in Chinese (e.g. `source-analyst`) but keep the frontmatter `description` in English (with Chinese trigger phrases appended if useful) for reliable triggering.
- Commit messages follow conventional commits: `<type>: <description>` (feat, fix, refactor, docs, chore).
- Do not reintroduce per-agent config directories (`.claude/`, `.gemini/`, `.roo/`) — they were deliberately removed in favor of the unified `skills/` + plugin-manifest layout.
