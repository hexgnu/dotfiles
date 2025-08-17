# Dotfiles Enhancement TODO

## High Priority - Immediate Impact

### Core Productivity Tools
- [ ] **Install and configure Rofi** - Modern dmenu replacement
  - [ ] Window switcher with preview
  - [ ] SSH launcher configuration
  - [ ] Clipboard manager integration
  - [ ] Calculator and file browser modes
  - [ ] Custom script launchers

- [ ] **Setup Dunst** - Notification daemon
  - [ ] Configure notification styling
  - [ ] Git push/pull notifications
  - [ ] Build status alerts
  - [ ] Timer/pomodoro notifications
  - [ ] Notification history and actions

- [ ] **Configure st (simple terminal)**
  - [ ] Apply scrollback patch
  - [ ] Add clipboard support patch
  - [ ] Enable font ligatures
  - [ ] Add alpha/transparency patch
  - [ ] Externalpipe for URL handling

- [ ] **Install fzf and integrate everywhere**
  - [ ] Bash history search
  - [ ] File/directory search
  - [ ] Git operations integration
  - [ ] Vim/nvim integration

## Medium Priority - Workflow Enhancement

### Window Management
- [ ] **Enhance i3 configuration**
  - [ ] Named workspaces with icons
  - [ ] Workspace-specific layouts
  - [ ] Configure scratchpad for quick terminal
  - [ ] Auto-assign applications to workspaces
  - [ ] Better resize mode keybindings

- [ ] **Setup sxhkd** - Independent hotkey daemon
  - [ ] Application-specific shortcuts
  - [ ] Global media controls
  - [ ] Quick note capture
  - [ ] Screenshot bindings

### File and Navigation
- [ ] **Install ranger or lf** - Terminal file manager
  - [ ] Image preview support
  - [ ] Custom shortcuts
  - [ ] Bulk rename operations
  - [ ] Integration with fzf

- [ ] **Setup zoxide** - Smart directory jumping
  - [ ] Replace cd with z
  - [ ] Frecency-based navigation
  - [ ] fzf integration

- [ ] **Install fd-find** - Fast file finding
  - [ ] Alias to replace find
  - [ ] Integration with fzf

### Clipboard and Screenshots
- [ ] **Setup greenclip or clipmenu**
  - [ ] Persistent clipboard history
  - [ ] Rofi integration
  - [ ] Bind to `$mod+c`
  - [ ] Image support

- [ ] **Configure flameshot or maim**
  - [ ] Selection screenshots
  - [ ] Annotation tools
  - [ ] Auto-upload capability
  - [ ] OCR text extraction

## Low Priority - Nice to Have

### Developer Tools
- [ ] **Install lazygit** - Git TUI
  - [ ] Custom keybindings
  - [ ] Integration with nvim
  - [ ] Commit templates

- [ ] **Enhance tmux configuration**
  - [ ] Tmux resurrect for session persistence
  - [ ] Better copy-mode with vi bindings
  - [ ] Project-based session management
  - [ ] Tmux-sessionizer script

- [ ] **Git workflow improvements**
  - [ ] Git worktree shortcuts
  - [ ] Auto-fetch in background
  - [ ] Better commit message templates
  - [ ] Pre-commit hooks

### System Enhancement
- [ ] **Setup autorandr** - Display management
  - [ ] Automatic display profiles
  - [ ] Workspace layout per profile
  - [ ] DPI handling

- [ ] **Configure picom properly**
  - [ ] Blur effects
  - [ ] Shadow configuration
  - [ ] Transparency rules
  - [ ] Performance optimization

- [ ] **Install redshift/gammastep**
  - [ ] Blue light filtering
  - [ ] Location-based adjustment
  - [ ] Manual override bindings

### Quick Capture and Notes
- [ ] **Setup note-taking system**
  - [ ] Obsidian or logseq integration
  - [ ] Quick capture keybinding
  - [ ] Daily notes template
  - [ ] Code snippet storage

- [ ] **Time tracking**
  - [ ] Integrate with existing RescueTime
  - [ ] Pomodoro timer in i3bar
  - [ ] Project time tracking

## Existing TODOs
- [ ] Remove ANSI from pbcopy / pbpaste

## Implementation Order

1. **Week 1**: Rofi, fzf, st configuration
2. **Week 2**: Dunst, clipboard manager, screenshot tools
3. **Week 3**: File navigation (ranger, zoxide, fd)
4. **Week 4**: i3 enhancements, workspace management
5. **Later**: Developer tools, system enhancements

## Quick Win Commands

```bash
# Install core tools (Fedora)
sudo dnf install rofi dunst fzf ripgrep fd-find ranger zoxide flameshot

# Clone st and apply patches
git clone https://git.suckless.org/st
cd st
# Apply patches: scrollback, clipboard, alpha, ligatures

# Install from source
cargo install zoxide
cargo install ripgrep
cargo install fd-find

# Node tools
npm install -g tldr
```

## Configuration Templates to Create

- [ ] `~/.config/rofi/config.rasi`
- [ ] `~/.config/dunst/dunstrc`
- [ ] `~/.config/sxhkd/sxhkdrc`
- [ ] `~/.config/ranger/rc.conf`
- [ ] `~/.config/picom/picom.conf`
- [ ] `~/.config/flameshot/flameshot.ini`
- [ ] `~/.config/greenclip.toml`

## Productivity Metrics

Track improvement in:
- Time to switch between applications
- Time to find and open files
- Number of manual repetitive tasks
- Context switching overhead
- Time spent in terminal vs GUI
