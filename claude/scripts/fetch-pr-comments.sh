#!/bin/bash
# Fetch and summarize PR comments
# Usage: ./fetch-pr-comments.sh <PR_NUMBER>
# Fetches PR comments using gh CLI and saves summary to .claude/pr-feedback.md

if [ -z "$1" ]; then
  echo "Usage: $0 <PR_NUMBER>"
  exit 1
fi

claude -p "Fetch comments from PR #$1 using gh CLI, summarize each reviewer's feedback as actionable items, and save to .claude/pr-feedback.md" --allowedTools "Bash,Read,Write" --output-format text
