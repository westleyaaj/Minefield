function love.conf(t)
    t.identity = "minefield"           -- The name of the save directory
    t.version = "11.5"                 -- The LÖVE version this game was made for

    t.window.title = "Minefield Beta" -- The window title
    t.window.width = 1200               -- The window width
    t.window.height = 800              -- The window height
    t.window.resizable = true          -- Let the user resize the window
    t.window.borderless = false        -- Remove the title bar and borders
    t.window.fullscreen = false        -- Enable fullscreen
    t.window.vsync = 1                 -- Vertical sync (1 to enable, 0 to disable)


end