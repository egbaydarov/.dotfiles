vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  {
    root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
    rocks = { enabled = false },
    spec = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        "nvchad/base46",
        lazy = false,
        build = function()
          require("base46").load_all_highlights()
        end,
      },
      {
        "nvchad/ui",
        lazy = false,
        config = function()
          require "nvchad"
        end,
      },
      {
        "nvzone/volt",
        lazy = false,
      },
      {
        "nvzone/menu",
        lazy = false,
      },
      {
        "nvzone/minty",
        lazy = false,
        cmd = { "Huefy", "Shades" }
      },
      {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        opts = function()
          dofile(vim.g.base46_cache .. "devicons")
          return { override = require "nvchad.icons.devicons" }
        end,
      },
      {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        event = "User FilePost",
        opts = {
          indent = { char = "│", highlight = "IblChar" },
          scope = { char = "│", highlight = "IblScopeChar" },
        },
        config = function(_, opts)
          dofile(vim.g.base46_cache .. "blankline")

          local hooks = require "ibl.hooks"
          hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
          require("ibl").setup(opts)

          dofile(vim.g.base46_cache .. "blankline")
        end,
      },
      { import = "byda.lazy" },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    local_spec = false, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    ---@type number? limit the maximum amount of concurrent tasks
    concurrency = jit.os:find("Windows") and (vim.uv.available_parallelism() * 2) or nil,
    git = {
      -- defaults for the `Lazy log` command
      -- log = { "--since=3 days ago" }, -- show commits from the last 3 days
      log = { "-8" }, -- show the last 8 commits
      timeout = 120, -- kill processes that take more than 2 minutes
      url_format = "https://github.com/%s.git",
      -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
      -- then set the below to false. This should work, but is NOT supported and will
      -- increase downloads a lot.
      filter = true,
      -- rate of network related git operations (clone, fetch, checkout)
      throttle = {
        enabled = false, -- not enabled by default
        -- max 2 ops every 5 seconds
        rate = 2,
        duration = 5 * 1000, -- in ms
      },
      -- Time in seconds to wait before running fetch again for a plugin.
      -- Repeated update/check operations will not run again until this
      -- cooldown period has passed.
      cooldown = 0,
    },
    pkg = {
      enabled = true,
      cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
      -- the first package source that is found for a plugin will be used.
      sources = {
        "lazy",
      },
    },
    dev = {
      -- Directory where you store your local plugin projects. If a function is used,
      -- the plugin directory (e.g. `~/projects/plugin-name`) must be returned.
      ---@type string | fun(plugin: LazyPlugin): string
      path = "~/pp",
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = {}, -- For example {"folke"}
      fallback = false, -- Fallback to git when local plugin doesn't exist
    },
    install = {
      missing = false,
    },
    ui = {
      -- a number <1 is a percentage., >1 is a fixed size
      size = { width = 0.8, height = 0.8 },
      wrap = true, -- wrap the lines in the ui
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = "none",
      -- The backdrop opacity. 0 is fully opaque, 100 is fully transparegt.
      backdrop = 60,
      title = nil, ---@type string only works when border is not "none"
      title_pos = "center", ---@type "center" | "left" | "right"
      -- Show pills on top of the Lazy window
      pills = true, ---@type boolean
      icons = {
        ft = "",
        lazy = "󰂠 ",
        loaded = "",
        not_loaded = "",
      },
      -- leave nil, to automatically select a browser depending on your OS.
      -- If you want to use a specific browser, you can define it here
      browser = "chrome", ---@type string?
      throttle = 1000 / 60, -- how frequently should the ui process render events
      custom_keys = {
        -- You can define custom key maps here. If present, the description will
        -- be shown in the help menu.
        -- To disable one of the defaults, set it to false.
    
        ["<localleader>l"] = {
          function(plugin)
            require("lazy.util").float_term({ "lazygit", "log" }, {
              cwd = plugin.dir,
            })
          end,
          desc = "Open lazygit log",
        },
    
        ["<localleader>i"] = {
          function(plugin)
            Util.notify(vim.inspect(plugin), {
              title = "Inspect " .. plugin.name,
              lang = "lua",
            })
          end,
          desc = "Inspect Plugin",
        },
    
        ["<localleader>t"] = {
          function(plugin)
            require("lazy.util").float_term(nil, {
              cwd = plugin.dir,
            })
          end,
          desc = "Open terminal in plugin dir",
        },
      },
    },
    -- Output options for headless mode
    headless = {
      -- show the output from process commands like git
      process = true,
      -- show log messages
      log = true,
      -- show task start/end
      task = true,
      -- use ansi colors
      colors = true,
    },
    diff = {
      -- diff command <d> can be one of:
      -- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
      --   so you can have a different command for diff <d>
      -- * git: will run git diff and open a buffer with filetype git
      -- * terminal_git: will open a pseudo terminal with git diff
      -- * diffview.nvim: will open Diffview to show the diff
      cmd = "git",
    },
    checker = {
      -- automatically check for plugin updates
      enabled = false,
      concurrency = nil, ---@type number? set to 1 to check for updates very slowly
      notify = true, -- get a notification when new updates are found
      frequency = 3600, -- check for updates every hour
      check_pinned = false, -- check for pinned packages that can't be updated
    },
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = true, -- get a notification when changes are found
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
      enabled = false,
      root = vim.fn.stdpath("state") .. "/lazy/readme",
      files = { "README.md", "lua/**/README.md" },
      -- only generate markdown helptags for plugins that don't have docs
      skip_if_doc_exists = true,
    },
    state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
    -- Enable profiling of lazy.nvim. This will add some overhead,
    -- so only enable this when you are debugging lazy.nvim
    profiling = {
      -- Enables extra stats on the debug tab related to the loader cache.
      -- Additionally gathers stats about all package.loaders
      loader = false,
      -- Track each new require in the Lazy profiling tab
      require = false,
    },
})

dofile(vim.g.base46_cache .. "statusline")
require("plenary.reload").reload_module "chadrc"
local theme = require("chadrc").base46.theme
require("nvchad.themes.utils").reload_theme(theme)


