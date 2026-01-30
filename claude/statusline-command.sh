#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Get git branch
git_branch=$(cd "$current_dir" 2>/dev/null && git -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null)

# Get Kubernetes context and namespace
k8s_context=$(kubectl config current-context 2>/dev/null)
k8s_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
if [ -z "$k8s_namespace" ]; then
  k8s_namespace="default"
fi

# Get AWS profile
aws_profile="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-}}"
if [ -z "$aws_profile" ]; then
  # Try to get from AWS config
  aws_profile=$(aws configure get profile 2>/dev/null || echo "")
fi

# Format context usage
if [ -n "$context_used" ]; then
  context_display=$(printf "%.0f%%" "$context_used")
else
  context_display="N/A"
fi

# Build status line
status_line=""

# Git branch (cyan)
if [ -n "$git_branch" ]; then
  status_line="${status_line}$(printf '\033[36m')${git_branch}$(printf '\033[0m') "
fi

# Kubernetes context (magenta) and namespace (purple)
if [ -n "$k8s_context" ]; then
  status_line="${status_line}$(printf '\033[35m')☸ ${k8s_context}$(printf '\033[0m')"
  if [ -n "$k8s_namespace" ] && [ "$k8s_namespace" != "default" ]; then
    status_line="${status_line}$(printf '\033[35m'):${k8s_namespace}$(printf '\033[0m')"
  fi
  status_line="${status_line} "
fi

# AWS profile (yellow with emoji)
if [ -n "$aws_profile" ]; then
  status_line="${status_line}$(printf '\033[33m')🅰 ${aws_profile}$(printf '\033[0m') "
fi

# Model name (green)
status_line="${status_line}$(printf '\033[32m')${model_name}$(printf '\033[0m') "

# Context usage (yellow)
status_line="${status_line}$(printf '\033[33m')${context_display}$(printf '\033[0m') "

# Current directory (blue)
status_line="${status_line}$(printf '\033[34m')${current_dir}$(printf '\033[0m')"

echo "$status_line"
