import XMonad
import System.Exit (exitSuccess)

import XMonad.Util.EZConfig
import XMonad.Prompt.ConfirmPrompt

ulauncher = spawn "ulauncher"

main = xmonad $ def
         `additionalKeysP`
         [ ("M-S-q", kill)
         , ("M-S-l", confirmPrompt def "logout" $ io exitSuccess)
         , ("M-p", ulauncher)
         , ("M-<Space>", ulauncher)
         ]
