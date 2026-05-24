if not vim.g.omarchy then
  return {}
end

return {
  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      -- Paths and runtime handles
      local uv = vim.uv or vim.loop
      local debounce_ms = 250
      local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
      local theme_file = vim.g.omarchy_theme
      local theme_dir = vim.fs.dirname(theme_file)
      local current_dir = vim.fs.dirname(theme_dir)

      local dir_watcher
      local current_watcher
      local debounce_timer = uv.new_timer()

      -- Forward declarations used across callbacks
      local attach_theme_dir_watcher
      local schedule_reload
      local run_theme_reload

      -- Helpers
      local function apply_theme()
        package.loaded["plugins.theme"] = nil

        local ok, theme_spec = pcall(require, "plugins.theme")
        if not ok then
          return
        end

        local theme_plugin_name
        for _, spec in ipairs(theme_spec) do
          if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
            theme_plugin_name = spec.name or spec[1]
            break
          end
        end

        vim.cmd("highlight clear")
        if vim.fn.exists("syntax_on") == 1 then
          vim.cmd("syntax reset")
        end

        vim.o.background = "dark"

        if theme_plugin_name then
          local plugin = require("lazy.core.config").plugins[theme_plugin_name]
          if plugin and plugin.dir then
            local plugin_dir = plugin.dir .. "/lua"
            require("lazy.core.util").walkmods(plugin_dir, function(modname)
              package.loaded[modname] = nil
              package.preload[modname] = nil
            end)
          end
        end

        for _, spec in ipairs(theme_spec) do
          if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
            local colorscheme = spec.opts.colorscheme

            require("lazy.core.loader").colorscheme(colorscheme)

            vim.defer_fn(function()
              pcall(vim.cmd.colorscheme, colorscheme)
              vim.cmd("redraw!")

              if vim.fn.filereadable(transparency_file) == 1 then
                vim.defer_fn(function()
                  vim.cmd.source(transparency_file)
                  vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                  vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })
                  vim.cmd("redraw!")
                end, 5)
              end
            end, 5)

            break
          end
        end
      end

      local function stop_handle(handle)
        if not handle then
          return
        end
        pcall(handle.stop, handle)
        pcall(handle.close, handle)
      end

      -- Reload orchestration
      schedule_reload = function()
        if not debounce_timer then
          return
        end
        debounce_timer:stop()
        debounce_timer:start(
          debounce_ms,
          0,
          vim.schedule_wrap(function()
            apply_theme()
          end)
        )
      end

      -- Watchers
      attach_theme_dir_watcher = function()
        stop_handle(dir_watcher)
        dir_watcher = uv.new_fs_event()
        if not dir_watcher then
          return
        end

        pcall(dir_watcher.start, dir_watcher, theme_dir, {}, function(err, filename)
          if err then
            return
          end
          if filename and filename ~= "neovim.lua" then
            return
          end
          run_theme_reload()
        end)
      end

      run_theme_reload = function()
        attach_theme_dir_watcher()
        schedule_reload()
      end

      local function start_watchers()
        attach_theme_dir_watcher()

        current_watcher = uv.new_fs_event()
        if current_watcher then
          pcall(current_watcher.start, current_watcher, current_dir, {}, function(err, filename)
            if err then
              return
            end
            if filename and filename ~= "theme" and filename ~= "theme.name" then
              return
            end
            run_theme_reload()
          end)
        end
      end

      start_watchers()

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          stop_handle(dir_watcher)
          stop_handle(current_watcher)
          stop_handle(debounce_timer)
        end,
      })
    end,
  },
}
