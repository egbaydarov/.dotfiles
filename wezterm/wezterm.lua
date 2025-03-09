local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux
config.font_size = 22
config.font = wezterm.font('ZedMono Nerd Font Mono', { weight = 500 })
config.color_scheme = 'Solarized Light (Gogh)'
config.cell_width = 1.07
config.enable_tab_bar = false
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

config.keys = {
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'w',
    mods = 'CMD|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = '%',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      command = { args = { 'top' } },
      size = { Percent = 50 },
    },
  },
  {
    key = '"',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical {
      args = { 'top' },
    },
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'F1',
    action = act.SwitchToWorkspace {
      name = 'f1',
    },
  },
  {
    key = 'F2',
    action = act.SwitchToWorkspace {
      name = 'f2',
    },
  },
  {
    key = 'F3',
    action = act.SwitchToWorkspace {
      name = 'f3',
    },
  },
  {
    key = 'F4',
    action = act.SwitchToWorkspace {
      name = 'f4',
    },
  },
}

wezterm.on('gui-startup',
  function(cmd)
    -- allow `wezterm start -- something` to affect what we spawn
    -- in our initial window
    local args = {}
    if cmd then
      args = cmd.args
    end

    -- Set a workspace for coding on a current project
    -- Top pane is for the editor, bottom pane is for the build tool
    local home_dir = wezterm.home_dir
    local proj_dir = args.dir or home_dir
    local tab, build_pane, window = mux.spawn_window {
      workspace = 'f1',
      cwd = proj_dir,
      args = args,
    }
    local editor_pane = build_pane:split {
      direction = 'Top',
      size = 0.9,
      cwd = proj_dir,
      args = { "nvim", "." }
    }
    local editor_pane_aux = editor_pane:split {
      direction = 'Left',
      size = 0.5,
      cwd = proj_dir,
      args = { "nvim", "." }
    }

    if args.boot_arg then
        build_pane:send_text(args.boot_arg .. "\n")
    end

    local tab, pane, window = mux.spawn_window {
      workspace = 'f2',
      cwd = home_dir .. '/.config',
      args = { "nvim", "." }
    }

    local tab, pane, window = mux.spawn_window {
      workspace = 'f3',
      cwd = home_dir .. '/.config',
    }
    pane:send_text("docker --help" .. "\n")

    local tab, pane, window = mux.spawn_window {
      workspace = 'f4',
      cwd = home_dir .. '/.config',
    }
    pane:send_text("docker container ls" .. "\n")

    -- We want to startup in the coding workspace
    mux.set_active_workspace 'coding'
  end
)


return config
