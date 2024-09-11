import XMonad
import System.Exit (exitSuccess)

import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Prompt.ConfirmPrompt

import Graphics.X11.ExtraTypes.XF86

ulauncher = spawn "ulauncher"

main = xmonad $ def
         {
           workspaces = myWorkspaces
         }
         `additionalKeysP`
         ([("<XF86AudioRaiseVolume>", spawn "amixer set Master 5000+")
          ,("<XF86AudioLowerVolume>", spawn "amixer set Master 5000-")
          ,("<XF86AudioMute>", spawn "amixer set Master toggle")
          ,("M-S-q", kill)
          ,("M-S-l", confirmPrompt def "logout" $ io exitSuccess)
          ,("M-p", ulauncher)
          ,("M-<Escape>", spawn "xlock -mode blank")
          ,("M-S-<Backspace>", spawn "switch-keyboard-layout")
          ,("M-s", spawn "cd ~/Downloads && scrot --select")
          ,("M-S-<Return>", spawn "firefox")
          ,("M-<Return>", spawn "xterm")]
          ++ switchWorkspaceKeys)

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

switchWorkspaceKeys = [ (otherModMasks ++ "M-" ++ [key], action tag)
                      | (tag, key)  <- zip myWorkspaces "123456789"
                      , (otherModMasks, action) <- [ ("", windows . W.view)
                                                   , ("S-", windows . W.shift)]]
