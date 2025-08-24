local wezterm = require("wezterm")

local config = {}

-- THEME
config.color_scheme = 'Catppuccin Frappe'
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 25
config.enable_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
config.window_background_opacity = 0.9

-- WINDOW DECORATION
config.window_decorations = "TITLE | RESIZE"

-- KEYBINDINGS
config.keys = {
  {
    key = "t",
    mods = "CTRL",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      if #tab:panes() > 1 then
        -- Kalau ada lebih dari 1 pane → tutup pane
        window:perform_action(wezterm.action.CloseCurrentPane { confirm = true }, pane)
      else
        -- Kalau hanya ada 1 pane → tutup tab
        window:perform_action(wezterm.action.CloseCurrentTab { confirm = true }, pane)
      end
    end),
  },
  { key="o", mods="CTRL|ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}} },
  { key="p", mods="CTRL|ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}} },

  { key = "a", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "d", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Right" },
  { key = "w", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "s", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Down" },
  { key = "f", mods = "CTRL", action = wezterm.action.Search({ CaseSensitiveString = "" }) },


  -- Rename tab (CTRL+SHIFT+R)
  {
    key = "r",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PromptInputLine {
      description = "Rename tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- TAB TITLE
wezterm.on("format-tab-title", function(tab)
  local title = tab.active_pane.title
  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  end
  return {
    { Text = " " .. title .. " " },
  }
end)

-- AUTO MAXIMIZE ON STARTUP
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
