#!/bin/bash

# Prompt for the task
task=$(dmenu -fn 'Source Code Pro:pixelsize=30' -p "Add Todo:")

# Check if the input is not empty
if [ -n "$task" ]; then
    python ~/git/personal/dotfiles/bin/flush_todo_inbox.py -c "$task"  # This command adds the task to Todoist
fi
