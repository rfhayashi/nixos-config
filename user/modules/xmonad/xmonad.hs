import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Prompt.ConfirmPrompt
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Actions.Commands

launcher = spawn "rofi -show drun"

main = xmonad $ docks $ def
         {
           workspaces = myWorkspaces
         , manageHook = myManageHook
         , layoutHook = myLayout
         , startupHook = myStartupHook
         }
         `additionalKeysP`
         ([("<XF86AudioRaiseVolume>", spawn "amixer set Master 5000+")
          ,("<XF86AudioLowerVolume>", spawn "amixer set Master 5000-")
          ,("<XF86AudioMute>", spawn "amixer set Master toggle")
          ,("M-S-q", kill)
          ,("M-S-l", confirmPrompt def "logout" $ io exitSuccess)
          ,("M-S-r", confirmPrompt def "reboot" $ spawn "reboot")
          ,("M-S-p", confirmPrompt def "poweroff" $ spawn "poweroff")
          ,("M-p", launcher)
          ,("M-<Escape>", spawn "xlock -mode blank")
          ,("M-S-<Backspace>", spawn "switch-keyboard-layout")
          ,("M-S-s", spawn "cd ~/Downloads && scrot --select")
          ,("M-S-<Return>", spawn "firefox")
          ,("M-<Return>", spawn "alacritty")
          ,("M-S-k", myCommands >>= runCommand)]
          ++ switchWorkspaceKeys)

myCommands = defaultCommands

myManageHook = manageDocks

myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full)
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

myStartupHook = do
  spawnOnce "autorandr --change"
  spawnOnce "exec eww open --screen 0 bar"
  spawnOnce "exec nm-applet --indicator"
  spawnOnce "exec cbatticon"

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

switchWorkspaceKeys = [ (otherModMasks ++ "M-" ++ [key], action tag)
                      | (tag, key)  <- zip myWorkspaces "123456789"
                      , (otherModMasks, action) <- [ ("", windows . W.view)
                                                   , ("S-", windows . W.shift)]]
