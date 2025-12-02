local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

-- temporary for NixOs
config.front_end = 'OpenGL'
config.enable_wayland = true
config.use_ime = false
config.max_fps = 144
config.font_size = 14
config.initial_cols = 120
config.initial_rows = 28
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
  { key = 'V', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
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
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = '1',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f1',
    },
  },
  {
    key = '2',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f2',
    },
  },
  {
    key = '3',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f3',
    },
  },
  {
    key = '4',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f4',
    },
  },
  {
    key = '5',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f5',
    },
  },
  {
    key = '6',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f6',
    },
  },
  {
    key = '7',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f7',
    },
  },
  {
    key = '8',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f8',
    },
  },
  {
    key = '9',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f9',
    },
  },
  {
    key = '0',
    mods = 'ALT',
    action = act.SwitchToWorkspace {
      name = 'f0',
    },
  },
  {
    key = 'm',
    mods = 'ALT',
    action = wezterm.action.TogglePaneZoomState,
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
    local proj_dir = home_dir .. './stuff'
    local tab, build_pane, window = mux.spawn_window {
      workspace = 'f1',
      cwd = proj_dir,
      args = args,
    }
    local editor_pane = build_pane:split {
      direction = 'Top',
      size = 0.9,
      cwd = proj_dir,
    }
--    local editor_pane_aux = editor_pane:split {
--      direction = 'Left',
--      size = 0.5,
--      cwd = proj_dir,
--      args = { "nvim", "." }
--    }


    if not args.dir then
      local tab, pane, window = mux.spawn_window {
        workspace = 'f2',
        cwd = home_dir .. '/.config',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f3',
        cwd = home_dir .. '/.config',
      }
      -- pane:send_text("some --help" .. "\n")
      local tab, pane, window = mux.spawn_window {
        workspace = 'f4',
        cwd = home_dir,
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f5',
        cwd = home_dir .. '/stuff',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f6',
        cwd = home_dir .. '/stuff',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f7',
        cwd = home_dir .. '/stuff',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f8',
        cwd = home_dir .. '/stuff',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f9',
        cwd = home_dir .. '/stuff',
      }

      local tab, pane, window = mux.spawn_window {
        workspace = 'f0',
        cwd = home_dir .. '/stuff',
      }
    end

    mux.set_active_workspace 'f1'
  end
)


return config
