import XMonad

import XMonad.Util.EZConfig

ulauncher = spawn "ulauncher"

main = xmonad $ def
         `additionalKeysP`
         [ ("M-S-q", kill)
         , ("M-p", ulauncher)
         , ("M-<Space>", ulauncher)
         ]
