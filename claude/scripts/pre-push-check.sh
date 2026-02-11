#!/bin/bash
# Pre-push validation script
# Usage: ./pre-push-check.sh
# Run tests, lint, and build to verify code is ready to push

claude -p "Run all tests, lint, and build. Report any failures with file:line references. If all pass, say READY TO PUSH." --allowedTools "Bash,Read,Grep" --output-format text
