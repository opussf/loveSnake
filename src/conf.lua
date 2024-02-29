function love.conf(t)
    t.version = "11.5"
    t.window.title = "Snake v@VERSION@"
    t.window.width = 1024
    t.window.height = 768
    t.window.borderless = false
    t.window.resizable = false
    t.modules.joystick = false
    t.modules.physics = false
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
end