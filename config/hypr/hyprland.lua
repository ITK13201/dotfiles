-- Hyprland 設定 (Lua)
-- https://wiki.hypr.land/Configuring/Start/
-- API の型定義: $(dirname $(readlink -f $(which Hyprland)))/../share/hypr/stubs/hl.meta.lua
--
-- UWSM 経由で起動する前提（SDDM で "Hyprland (uwsm-managed)" を選択）
-- waybar / dunst / hyprpaper / fcitx5 は systemd user サービス・XDG autostart で起動するため、ここでは起動しない

------------------
---- MONITORS ----
------------------

-- 左から HDMI-A-2 (縦向き) / DP-2 (メイン) / DP-1
-- transform: 1 = 90° 回転, 3 = 270° 回転 (表示が上下逆なら 1 と 3 を入れ替える)
hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@75", position = "0x0",    scale = 1, transform = 1 })
hl.monitor({ output = "DP-2",     mode = "2560x1440@60", position = "1080x0", scale = 1 })
hl.monitor({ output = "DP-1",     mode = "1920x1080@75", position = "3640x0", scale = 1 })

-- 起動時はメインモニターにフォーカスする
hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.focus({ monitor = "DP-2" }))
end)
-- 未知のモニター (接続時) は自動配置
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---------------------
---- MY PROGRAMS ----
---------------------

-- uwsm app 経由で起動し、アプリを個別の systemd scope に置く
local terminal = "uwsm app -- kitty"
local menu        = [[uwsm app -- "$(wofi --show drun --define=drun-print_desktop_file=true | sed -E "s/(\.desktop) /\1:/")"]]
local fileManager = "uwsm app -- thunar"
local clipboard   = "cliphist list | wofi --dmenu | cliphist decode | wl-copy"
local lock        = "loginctl lock-session"

-- 環境変数 (カーソル・テーマ等) は Home Manager の home.sessionVariables で設定し、UWSM がセッションに読み込む

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border = "rgba(414868aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        -- 壁紙は hyprpaper に任せる
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },
})

-----------------
---- PLUGINS ----
-----------------

-- plugins.lua は Home Manager が生成する (home-manager/desktop/hyprland/default.nix)
local plugins = require("plugins")
hl.plugin.load(plugins.hyprbars)

-- プラグインはロード後の再読込で有効になるため、初回の読み込みでは hl.plugin.hyprbars が存在しない
if hl.plugin.hyprbars then
    hl.config({
        plugin = {
            hyprbars = {
                bar_height     = 24,
                bar_color      = "rgba(1a1b26ee)",
                bar_text_font  = "Sans",
                bar_text_size  = 10,
                bar_padding    = 8,
                bar_button_padding = 6,
                bar_part_of_window = true,
                bar_precedence_over_border = true,
                col = { text = "rgb(c0caf5)" },
                on_double_click = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
            },
        },
    })

    -- ボタンは右から順に並ぶ: 閉じる → 最大化 → 最小化 で「- □ x」になる
    -- Hyprland に最小化の概念は無いため、special:minimized に退避する (SUPER + N で表示)
    local buttons = {
        { color = "rgb(f7768e)", icon = "\u{F05AD}", action = "hl.dsp.window.close()" },
        { color = "rgb(9ece6a)", icon = "\u{F05AF}", action = [[hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })]] },
        { color = "rgb(e0af68)", icon = "\u{F05B0}", action = [[hl.dsp.window.move({ workspace = "special:minimized", follow = false })]] },
    }
    for _, b in ipairs(buttons) do
        hl.plugin.hyprbars.add_button({
            bg_color = b.color,
            fg_color = "rgb(1a1b26)",
            size     = 14,
            icon     = b.icon,
            action   = "hyprctl dispatch '" .. b.action .. "'",
        })
    end
end

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 },   { 0.32, 1 }    } })
hl.curve("linear",       { type = "bezier", points = { { 0, 0 },      { 1, 1 }       } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 },  { 0.75, 1 }    } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0 },   { 0.1, 1 }     } })

hl.animation({ leaf = "global",     enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        repeat_delay = 300,
        repeat_rate  = 40,
        follow_mouse = 1,
        sensitivity  = 0,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- 日本語入力 (fcitx5 + mozc) の切り替えは fcitx5 既定の Ctrl+Space
-- Hyprland 側では Ctrl+Space をバインドしないこと

local mainMod = "SUPER"

-- アプリ・セッション
hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("uwsm stop"))

-- クリップボード履歴
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(clipboard))

-- スクリーンショット (~/Pictures/Screenshots に保存 + クリップボードにコピー)
hl.bind("Print",                 hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SHIFT + Print",         hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + Print",   hl.dsp.exec_cmd("hyprshot -m window"))

-- ウィンドウ操作
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))

-- フォーカス移動 (vim キー + 矢印キー)
local directions = {
    { keys = { "H", "left" },  dir = "left" },
    { keys = { "J", "down" },  dir = "down" },
    { keys = { "K", "up" },    dir = "up" },
    { keys = { "L", "right" }, dir = "right" },
}
for _, d in ipairs(directions) do
    for _, key in ipairs(d.keys) do
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ direction = d.dir }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = d.dir }))
    end
end

-- ワークスペース: mainMod + [0-9] で切り替え、+ SHIFT でウィンドウを移動
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- スクラッチパッド
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- 最小化したウィンドウ (hyprbars の最小化ボタン) の表示切り替え
hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("minimized"))

-- マウス: ホイールでワークスペース移動、ドラッグで移動・リサイズ
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- 音量 (PipeWire)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- ワークスペースのモニター割り当て: 1-4 メイン / 5-7 左 / 8-10 右
for i = 1, 10 do
    local monitor = (i <= 4 and "DP-2") or (i <= 7 and "HDMI-A-2") or "DP-1"
    hl.workspace_rule({ workspace = tostring(i), monitor = monitor, default = (i == 1 or i == 5 or i == 8) })
end

hl.window_rule({
    -- 音量ミキサーはポップアップとして中央にフローティング表示
    name   = "float-pavucontrol",
    match  = { class = "^org\\.pulseaudio\\.pavucontrol$" },
    float  = true,
    size   = "900 600",
    center = true,
})

hl.window_rule({
    -- アプリからの最大化要求を無視する
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- XWayland のドラッグ不具合対策
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
