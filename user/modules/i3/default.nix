{ lib, osConfig, pkgs, ...}:
let
  inherit (lib) mkIf;
  cfg = osConfig.rfhayashi.i3;
  i3status-conf = ./i3status.conf;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify notify-osd wmctrl blueman ];

    # kept here if we decide to use rofi again
    home.file.".config/rofi/config.rasi".text = ''
      configuration {
        kb-row-up: "Up,Control+k";
        kb-row-down: "Down,Control+j";
        kb-remove-to-eol: "";
        kb-accept-entry: "Control+m,Return,KP_Enter";
      }
      @theme "arthur"
    '';

    home.file.".config/i3/config".text = ''
set $mod Mod1

font pango:Source Code Pro 8

# colors
client.focused              #688060 #688060 #DCDCCC #ffcfaf
client.focused_inactive     #3f3f3f #3F3F3F #7f9f7f #3f3f3f
client.unfocused            #3f3f3f #3F3F3F #DCDCCC #3f3f3f
client.urgent               #dca3a3 #dca3a3 #DCDCCC #3f3f3f

# TODO do we still need xss-lock given we are using suspend? (make sure computer is suspended after inactivity)
# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
exec --no-startup-id ${pkgs.xss-lock}/bin/xss-lock -- sh -c "i3lock -n -c 000000 && xset dpms force off"

bindsym $mod+Escape exec --no-startup-id ${pkgs.suspend}

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id ${pkgs.networkmanagerapplet}/bin/nm-applet

# Autorandr
exec --no-startup-id autorandr --change

# Battery Status
exec --no-startup-id ${pkgs.cbatticon}/bin/cbatticon

# Bluetooth
exec --no-startup-id ${pkgs.blueman}/bin/blueman-applet

# Volume
exec --no-startup-id ${pkgs.pasystray}/bin/pasystray

# Launcher
exec --no-startup-id systemctl --user start ulauncher

# Use pactl to adjust volume in PulseAudio.
bindsym XF86AudioRaiseVolume exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%
bindsym XF86AudioLowerVolume exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%
bindsym XF86AudioMute exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86AudioMicMute exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Brigthness
bindsym XF86MonBrightnessUp exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +10%
bindsym XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-

# use these keys for focus, movement, and resize directions when reaching for
# the arrows is not convenient
set $up k
set $down j
set $left h
set $right l

# use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# move tiling windows via drag & drop by left-clicking into the title bar,
# or left-clicking anywhere into the window while holding the floating modifier.
tiling_drag modifier titlebar

# start a terminal
bindsym $mod+Return exec ${pkgs.alacritty}/bin/alacritty

# start the browser
bindsym $mod+Shift+Return exec ${pkgs.firefox}/bin/firefox

# kill focused window
bindsym $mod+Shift+q kill

# window switch
bindsym $mod+Shift+p exec ${pkgs.rofi}/bin/rofi -show window

# i3-input
bindsym $mod+i exec i3-input

# switch keyboard layout
bindsym $mod+Shift+BackSpace exec --no-startup-id ${pkgs.switch-keyboard-layout}/bin/switch-keyboard-layout

# change focus
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+semicolon split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+Shift+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

# workspaces
set $ws_monitor "1: monitor"
set $ws_editor "3: editor"
set $ws_web "4: web"

workspace $ws_editor output primary
workspace $ws_monitor output nonprimary primary
workspace $ws_web output nonprimary primary

# switch to workspace
bindsym $mod+1 workspace number $ws_monitor
bindsym $mod+3 workspace number $ws_editor
bindsym $mod+4 workspace number $ws_web

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws_monitor
bindsym $mod+Shift+3 move container to workspace number $ws_editor
bindsym $mod+Shift+4 move container to workspace number $ws_web

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym $left       resize shrink width 10 px or 10 ppt
        bindsym $down       resize grow height 10 px or 10 ppt
        bindsym $up         resize shrink height 10 px or 10 ppt
        bindsym $right      resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
        status_command i3status --config ${i3status-conf}
        tray_output primary
        colors {
          background #3f3f3f
          statusline #dcdccc

          focused_workspace  #93b3a3 #3f3f3f #93b3a3
          active_workspace   #ffcfaf #3f3f3f #ffcfaf
          inactive_workspace #636363 #3f3f3f #dcdccc
          urgent_workspace   #dca3a3 #3f3f3f #dca3a3
        }
}

# window rules
for_window [class="^Alacritty$"] floating enable
assign [class="^Emacs$"] $ws_editor
assign [class="^firefox$"] $ws_web

# start programs
exec ${pkgs.emacs}/bin/emacs
exec ${pkgs.firefox}/bin/firefox

'';  
  };
}
