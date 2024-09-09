import XMonad
import System.Exit (exitSuccess)

import XMonad.Util.EZConfig
import XMonad.Prompt.ConfirmPrompt

import Graphics.X11.ExtraTypes.XF86

ulauncher = spawn "ulauncher"

main = xmonad $ def
         `additionalKeys`
         [ ((0, xF86XK_AudioLowerVolume   ), spawn "amixer set Master 5000-")
         , ((0, xF86XK_AudioRaiseVolume   ), spawn "amixer set Master 5000+")
         , ((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")
         ]
         `additionalKeysP`
         [ ("M-S-q", kill)
         , ("M-S-l", confirmPrompt def "logout" $ io exitSuccess)
         , ("M-p", ulauncher)
         , ("M-<Space>", ulauncher)
         , ("M-<Escape>", spawn "xlock -mode blank")
         , ("M-S-<Backspace>", spawn "switch-keyboard-layout")
         , ("M-s", spawn "cd ~/Downloads && scrot --select")
         ]
