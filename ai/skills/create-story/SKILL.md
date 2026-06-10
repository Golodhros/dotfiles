---
name: create-story
description: Use when you need to create Storybook stories for React components — dispatches the story-agent for autonomous story creation
disable-model-invocation: true

---

# Create Story

## Overview

Dispatches the `story-agent` to create comprehensive Storybook stories for React components. The agent creates Playground and AllVariants stories following your Storybook conventions.

## When to Use

- After building a new component that needs Storybook documentation
- When adding stories to existing components that lack them
- When updating stories to reflect component changes

## Workflow

### Step 1: Identify the Component

Figure out what component needs stories:

- **Component path** — the file path the user provided or referenced
- **Portal component** — whether it renders via a portal (modals, tooltips, dropdowns)
- **Data-fetching component** — whether it uses GraphQL queries or API calls

### Step 2: Dispatch story-agent

Dispatch the `story-agent` via the Task tool with a prompt that includes:

1. **The component path** — exact file to create stories for
2. **Component characteristics** — portal-based, data-fetching, or standard
3. **Any user context** — specific variants to showcase, props to highlight

The story-agent handles everything autonomously: analyzing the component, searching for existing usages, creating Playground and AllVariants stories.

### Step 3: Present Results

When the story-agent returns, summarize the results to the user:

1. Story file created and its location
2. Stories included (Playground, AllVariants, any special state stories)
3. Any notes about mocking or special setup needed
