#!/usr/bin/env bash
set -euo pipefail

SESSION="main"

HOME_DIR="${HOME}"
PROJ_DIR="${HOME_DIR}/stuff"
CFG_DIR="${HOME_DIR}/.config"
STUFF_DIR="${HOME_DIR}/stuff"

# Create the session if missing
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  # window :0 = f1 (project)
  tmux new-session -d -s "$SESSION" -n f1 -c "$PROJ_DIR"

  # f1 layout: top editor, bottom build
  tmux split-window -v -t "$SESSION":0 -c "$PROJ_DIR"
  tmux select-pane -t "$SESSION":0.0
  tmux resize-pane -t "$SESSION":0.1 -y 3 2>/dev/null || true

  # Create other windows (workspaces)
  tmux new-window -t "$SESSION" -n f2 -c "$CFG_DIR"
  tmux new-window -t "$SESSION" -n f3 -c "$CFG_DIR"
  tmux new-window -t "$SESSION" -n f4 -c "$HOME_DIR"
  tmux new-window -t "$SESSION" -n f5 -c "$STUFF_DIR"
  tmux new-window -t "$SESSION" -n f6 -c "$STUFF_DIR"
  tmux new-window -t "$SESSION" -n f7 -c "$STUFF_DIR"
  tmux new-window -t "$SESSION" -n f8 -c "$STUFF_DIR"
  tmux new-window -t "$SESSION" -n f9 -c "$STUFF_DIR"
  tmux new-window -t "$SESSION" -n f0 -c "$STUFF_DIR"
fi

# Ensure f1 has 2 panes even if it already existed
# (safe if you manually killed a pane)
panes="$(tmux list-panes -t "$SESSION":0 2>/dev/null | wc -l | tr -d ' ')"
if [[ "${panes}" == "1" ]]; then
  tmux split-window -v -t "$SESSION":0 -c "$PROJ_DIR"
  tmux select-pane -t "$SESSION":0.0
  tmux resize-pane -t "$SESSION":0.1 -y 3 2>/dev/null || true
fi

# Go to f1
tmux select-window -t "$SESSION":0

# If already inside tmux: switch client; otherwise attach
if [[ -n "${TMUX-}" ]]; then
  tmux switch-client -t "$SESSION"
else
  exec tmux attach -t "$SESSION"
fi

