local wezterm = require 'wezterm'
local config = wezterm.config_builder()

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

return config
