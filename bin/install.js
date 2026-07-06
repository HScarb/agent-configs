#!/usr/bin/env node
/**
 * Install skills from this repo into agent skill directories.
 *
 * Usage:
 *   npx github:HScarb/agent-configs [options] [skill ...]
 *
 * Options:
 *   --agent <list>   Comma-separated targets: claude,codex,cursor (default: auto-detect)
 *   --project        Install into the current project (./.claude/skills etc.) instead of the home directory
 *   --list           List available skills and exit
 *   --help           Show this help
 */
import { cpSync, existsSync, readdirSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const SKILLS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..", "skills");

const AGENT_DIRS = {
  claude: ".claude",
  codex: ".codex",
  cursor: ".cursor",
};

function listSkills() {
  return readdirSync(SKILLS_DIR, { withFileTypes: true })
    .filter((entry) => entry.isDirectory() && existsSync(join(SKILLS_DIR, entry.name, "SKILL.md")))
    .map((entry) => entry.name);
}

function parseArgs(argv) {
  const options = { agents: [], project: false, list: false, help: false, skills: [] };
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--agent") {
      const value = argv[i + 1];
      if (!value) fail("--agent requires a value, e.g. --agent claude,codex");
      options.agents.push(...value.split(",").map((name) => name.trim()).filter(Boolean));
      i += 1;
    } else if (arg === "--project") {
      options.project = true;
    } else if (arg === "--list") {
      options.list = true;
    } else if (arg === "--help" || arg === "-h") {
      options.help = true;
    } else if (arg.startsWith("-")) {
      fail(`Unknown option: ${arg}`);
    } else {
      options.skills.push(arg);
    }
  }
  return options;
}

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function detectAgents(baseDir) {
  const detected = Object.keys(AGENT_DIRS).filter((agent) =>
    existsSync(join(baseDir, AGENT_DIRS[agent]))
  );
  return detected.length > 0 ? detected : ["claude"];
}

function main() {
  const options = parseArgs(process.argv.slice(2));
  const available = listSkills();

  if (options.help) {
    console.log(`Install skills from HScarb/agent-configs.

Usage: npx github:HScarb/agent-configs [options] [skill ...]

Options:
  --agent <list>   Comma-separated targets: ${Object.keys(AGENT_DIRS).join(",")} (default: auto-detect)
  --project        Install into the current project instead of the home directory
  --list           List available skills and exit
  --help           Show this help

Skills: ${available.join(", ")}`);
    return;
  }

  if (options.list) {
    for (const skill of available) console.log(skill);
    return;
  }

  const unknownAgents = options.agents.filter((agent) => !(agent in AGENT_DIRS));
  if (unknownAgents.length > 0) {
    fail(`Unknown agent(s): ${unknownAgents.join(", ")}. Valid values: ${Object.keys(AGENT_DIRS).join(", ")}`);
  }

  const unknownSkills = options.skills.filter((skill) => !available.includes(skill));
  if (unknownSkills.length > 0) {
    fail(`Unknown skill(s): ${unknownSkills.join(", ")}. Available: ${available.join(", ")}`);
  }

  const baseDir = options.project ? process.cwd() : homedir();
  const agents = options.agents.length > 0 ? options.agents : detectAgents(baseDir);
  const skills = options.skills.length > 0 ? options.skills : available;

  for (const agent of agents) {
    const targetRoot = join(baseDir, AGENT_DIRS[agent], "skills");
    for (const skill of skills) {
      const target = join(targetRoot, skill);
      try {
        cpSync(join(SKILLS_DIR, skill), target, { recursive: true, force: true });
        console.log(`installed ${skill} -> ${target}`);
      } catch (error) {
        fail(`failed to install ${skill} into ${target}: ${error.message}`);
      }
    }
  }

  console.log(`\nDone. Installed ${skills.length} skill(s) for: ${agents.join(", ")}.`);
}

main();
