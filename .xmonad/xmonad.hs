-- Import stuff

import XMonad.Util.SpawnOnce
import XMonad.Actions.SpawnOn
import XMonad.Actions.NoBorders
-- 1 import XMonad.Util.Run
import XMonad hiding ((|||))
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack)
import XMonad.Layout.Fullscreen

-- import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, PP(..))
import XMonad.Hooks.ManageDocks -- (docks, manageDocks ToggleStructs)


-- import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig--(additionalKeys, additionalKeysP, additionalMouseBindings)
-- import System.IO
import System.Exit

import XMonad.Actions.GroupNavigation
import XMonad.Layout.Tabbed
import XMonad.Hooks.InsertPosition
-- import XMonad.Layout.SimpleDecoration (shrinkText)
-- import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.ManageHelpers

-- Order screens by physical location
-- import XMonad.Actions.PhysicalScreens
-- import Data.Default
-- For getSortByXineramaPhysicalRule
import XMonad.Layout.LayoutCombinators
-- import XMonad hiding ( (|||) )

-- smartBorders and noBorders
import XMonad.Layout.NoBorders

-- spacing between tiles
import XMonad.Layout.Spacing
-- 1 import XMonad.Layout.Groups.Examples

-- UNCOMMENT when reenabeling the bar
-- !!BAR!!
-- import XMonad.Hooks.DynamicBars

--- Layouts (Most are not in use)
import XMonad.Layout.ResizableTile
--import XMonad.Layout.TwoPane
--import XMonad.Layout.BinarySpacePartition
--import XMonad.Layout.Dwindle
--import XMonad.Layout.ComboP
--import XMonad.Layout.SubLayouts
--import XMonad.Layout.WindowNavigation
--import XMonad.Layout.WindowNavigation
--import XMonad.Layout.BoringWindows
import XMonad.Layout.LayoutModifier
import XMonad.Hooks.WorkspaceHistory
import XMonad.Layout.TrackFloating
--import XMonad.Layout.Simplest
-- 1 import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Renamed
import Data.IORef

--Refocus last
import XMonad.Hooks.RefocusLast 
import Data.Monoid

-- Needed to fix matlab
import XMonad.Hooks.SetWMName

--import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.EwmhDesktops

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: [Char]
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
-- myFocusFollowsMouse :: Bool
-- myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
-- myClickJustFocuses :: Bool
-- myClickJustFocuses = False


-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 2


-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--

-- myModMask :: KeyMask
-- myModMask = mod4Mask
altMask :: KeyMask
altMask = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
  -- !!BAR!!
-- UNCOMMENT to get clickable workspaces
-- xmobarEscape :: String -> String
-- xmobarEscape = concatMap doubleLts
--   where
--         doubleLts '<' = "<<"
--         doubleLts x   = [x]
--myWorkspaces :: [String]
--myWorkspaces = clickable . map xmobarEscape
               -- $ [" \59333 ", " \62057 ", " \58875 ", " \61441 ", " \62229 ", " 6 "," 7 "," \61613 "," \61944 "]
  -- where
        --clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      --(i,ws) <- zip [1..9] l,
                      --let n = i ]

--myWorkspaces    = [" 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "]
myWorkspaces :: [[Char]]
myWorkspaces = [" \59333 ", " \62057 ", " \58875 ", " \61441 ", " \62229 ", " 6 "," 7 "," \61613 "," \61944 "]



-- Window count
  -- !!BAR!!
-- windowCount :: X (Maybe String)
-- windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Border colors for unfocused and focused windows, respectively.
--
--myNormalBorderColor  = "#dddddd"
myNormalBorderColor :: [Char]
myNormalBorderColor  = "#005577"
myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#ff0000"

      --  , normalBorderColor  = "#2f3d44"
      --  , focusedBorderColor = "#1ABC9C"
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys :: IORef Bool
  -> XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys fullscreenRef conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    
    ------[ Launch Meister ]-----
    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((altMask,            xK_space    ), spawn "dmenu_run")

    -- launch DOOM EMACS
    , ((modm,               xK_d        ), spawn "emacs")

    -- launch Firefox
    , ((modm .|. altMask,   xK_f        ), spawn "firefox")

    -- lauch browser
    , ((modm,               xK_b        ), spawn "firefox")
    
    -- launch qutebrowser
    , ((modm,               xK_q        ), spawn "qutebrowser")

    -- launch spotify / Discord
    , ((modm .|. altMask,   xK_s     ), spawnOn (myWorkspaces !! 3)  "spotify")
    , ((modm .|. altMask,   xK_d     ), spawnOn (myWorkspaces !! 3 ) "discord")
    
    -- emoji dmenu prompt
    -- , ((modm .|. altMask,   xK_e    ), spawn "~/programering/scripts/dmenu/emoji.sh")

    --, ((altMask,            xK_i    ),  spawn "~/programering/scripts/square.sh")
    -- , ((altMask,            xK_o    ),  spawn "~/programering/scripts/curly.sh")

    -- Launch dolphin
   -- , ((modm,               xK_d    ), spawn "dolphin")

    -- Launch range 
    , ((modm,               xK_r    ), spawn "st ranger")

    --Launch Pulsemixer
    , ((modm .|. altMask,   xK_p    ), spawn "alacritty --class pulsemixer -e pulsemixer")

    -- Launch boom
    , ((modm .|. altMask,   xK_b    ), spawn "btmenu")
    
    -- Launch zat
    , ((modm,               xK_z    ), spawn "$HOME/repos/scripts/zat/zat.sh")

    -- close focused window
    , ((altMask,            xK_q     ), kill)

    , ((modm .|. altMask,   xK_o    ), spawn "layout_selector")
    

    -----[ Movement ]-----
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_l     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_h     ), windows W.focusUp  )

--  , ((modm,               xK_h    ), windows W.focusLeft)

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. altMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. altMask, xK_l     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. altMask, xK_h     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. shiftMask,   xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm .|. shiftMask,   xK_l     ), sendMessage Expand)

    -- Shrink and expand ratio between the secondary panes, for the ResizableTall layout
    , ((modm .|. altMask,               xK_j), sendMessage MirrorShrink)
    , ((modm .|. altMask,               xK_k), sendMessage MirrorExpand)

    -- Gaps
    , ((modm,                          xK_plus), incWindowSpacing 3)
    , ((modm,                          xK_minus), decWindowSpacing 3)
    , ((modm,                          xK_g), toggleWindowSpacingEnabled)
    , ((modm .|. altMask,              xK_x), withFocused toggleBorder)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toogle structs
    , ((modm,               xK_s     ), sendMessage ToggleStruts)


    -----[ Layout Stuff ]-----
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((altMask,            xK_Tab   ), sendMessage $ JumpToLayout "Tabbed Simplest")

    , ((modm,               xK_f), io (modifyIORef fullscreenRef not))
    -- add tabs stuff
--  , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
--  , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
--  , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
--  , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
--  , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
--  , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

--  , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
--  , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')

    ----- [ Quit/restart ]-----
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r    ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_p ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++ 

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
   -- [((m .|. modm, k), windows $ f i)
     --   | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      --  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
          [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]

        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        -- Uncomment follwing line to disable worspace "Swapping"
        --, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
-- myMouseBindings :: XConfig l
--   -> M.Map (KeyMask, Button) (Window -> X ())
-- myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

--     -- mod-button1, Set the window to floating mode and move by dragging
--     [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
--                                        >> windows W.shiftMaster))

--     -- mod-button2, Raise the window to the top of the stack
--     , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

--     -- mod-button3, Set the window to floating mode and resize by dragging
--     , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
--                                        >> windows W.shiftMaster))

--     -- you may also bind events to the mouse scroll wheel (button4 and button5)
--     ]

------------------------------------------------------------------------
-- Layouts:

-- Tab layout config
myTabConfig :: Theme
myTabConfig = def {  activeColor = "#46d9ff"
                    --activeColor = "#556064"
                  , inactiveColor = "#2F3D44"
                  , urgentColor = "#FDF6E3"
                 -- , activeBorderColor = "#454948"
                  , activeBorderColor = "#000000"
                  , inactiveBorderColor = "#454948"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#000000"
                  , inactiveTextColor = "#1ABC9C"
                  , urgentTextColor = "#1ABC9C"
                  , fontName = "xft:Noto Sans CJK:size=10:antialias=true"
                  }

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 0 0 0) True (Border i i i i) True

-- mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing' i = spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True

sjark = renamed [Replace "Tabs"] $
         --trackFloating (tabbed shrinkText myTabConfig)
         X.L.FocusTracking.focusTracking (tabbed shrinkText myTabConfig)

myLayout =  avoidStruts $ smartBorders $ 
      renamed [Replace "Tiled"] tiled
     ||| sjark
     -- ||| Mirror tiled
  -- ||| noBorders Full
 -- ||| twopane
--  ||| Mirror twopane
 -- ||| emptyBSP
 -- ||| Spiral L XMonad.Layout.Dwindle.CW (3/2) (11/10) -- L means the non-main windows are put to the left.

  where
     -- The last parameter is fraction to multiply the slave window heights
     -- with. Useless here.
     tiled = mySpacing 3 $ ResizableTall nmaster delta ratio []
     -- In this layout the second pane will only show the focused window.
 --    twopane = spacing 3 $ TwoPane delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
------------------------------------------------------------------------
-- Window rules:

-- Toglablow EwmhDesktops fullscreen event hook
-- toggleableFullscreen :: IORef Bool -> Event -> XConfig
-- toggleableFullscreen ref evt =
--     io (readIORef ref) >>= \isOn ->
--         if isOn
--             then XMonad.Hooks.EwmhDesktops.ewmhFullscreen evt
--             else return (All True)


-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
-- IDK
-- insertPosition Below Newer <+> manageSpawn <+>
myManageHook :: ManageHook
myManageHook = manageSpawn
    <+> fullscreenManageHook
    <+> composeOne
    [  isFullscreen                  -?> doFullFloat
    ,  isDialog                     -?> (insertPosition Above Newer <+> doFloat)
    ,  title =?   "Save As"         -?> (insertPosition Above Newer <+> doFloat)
    ,  title =?   "Save File"       -?> (insertPosition Above Newer <+> doFloat)
    ,  appName =? "spectacle"       -?> (insertPosition Above Newer <+> doFloat)
    ,  appName =? "pulsemixer"      -?> doRectFloat $ W.RationalRect 0.25 0.25 0.5 0.5 
    ,  appName =? "calcurse"        -?> doRectFloat $ W.RationalRect 0.125 0.125 0.75 0.75 
    --,  appName =? "pulsemixer"      -?> (insertPosition Above Newer <+> doCenterFloat)
    ,  className =? "Gimp"          -?> doFloat
    ,  className =? "mpv"           -?> doFloat
    ,  className =? "tk"           -?> doFloat
    , return True                   -?> insertPosition Below Newer
    ]
    

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

-- Prevent focusing other tabs when working with floating windows in tabbed layout.
myEventHook :: Event -> X All
myEventHook = refocusLastWhen myPred
    where
        myPred = refocusingIsActive <||> isFloat

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X ()
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-Shift-x.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
        -- spawnOnce "nitrogen --restore &"
        --spawnOnce "picom --experimental-backends --backend glx --xrender-sync-fence -b"
        --spawnOnce "/home/syslak/programering/scripts/setBrightness.sh 130"
        spawnOnce "xinput set-prop 11 310 1 &"
        spawnOnce "setxkbmap -option caps:super &"
        spawnOnce "xset r rate 280 40 &"
        spawnOnce "ckb-next -b &"
        spawnOnce "$HOME/repos/batstat/bin/batstat &"
        spawnOnce "bluetoothctl power on &"
        -- spawnOnce "$HOME/programering/scripts/killCKB.sh &"
        --spawnOnce "/home/syslak/repos/scripts/remap.sh &"
        --spawnOnce "$HOME/programering/scripts/killCKB.sh &"
        --spawnOnce "/home/syslak/programering/scripts/remap.sh &"
        -- spawnOnce "xrandr --output DP-0 --mode 2560x1440 --rate 144 &"
        spawnOnce "bluetoothctl power on &"
        -- spawnOnce "$HOME/programering/scripts/killCKB.sh &"
        -- spawnOnce "/home/syslak/repos/scripts/remap.sh &"
        --spawnOnce "xcape -e 'Super_L=Escape'"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. 
--
main :: IO()
main = do
    fullscreenRef <- newIORef True
    --xmproc0 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrcDesktop" 
    --xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrcDesktop" 
    xmonad $ docks $ ewmhFullscreen $ ewmh $ def
        { modMask = mod4Mask
        , keys = myKeys fullscreenRef 
        , startupHook = myStartupHook
        , manageHook =  myManageHook
        , layoutHook = refocusLastLayoutHook $ myLayout
        , handleEventHook = windowedFullscreenFixEventHook <+> myEventHook <+> handleEventHook def
        , workspaces = myWorkspaces
        --, logHook = dynamicLogWithPP myPP {
            --                              }
        , logHook = refocusLastLogHook <+> workspaceHistoryHook <+> myLogHook <+> dynamicLog --dynamicLogWithPP xmobarPP { 
            -- Change from dynamicLog to dynamicLogWithPP and uncomment inside {} to  bring back xmobar
--              ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x
            --, ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"  -- Current workspace in xmobar
            --, ppVisible = xmobarColor "#98be65" ""                 -- Visible but not current workspace
            --, ppHidden = xmobarColor "#82AAFF" "" . wrap "<fn=5>*</fn>" ""   -- Hidden workspaces in xmobar
            --, ppHiddenNoWindows = xmobarColor "#c792ea" ""         -- Hidden workspaces (no windows)
            --, ppTitle = xmobarColor "#b3afc2" "" . shorten 60       -- Title of active window in xmobar
            --, ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"           --  Separators in xmobar
            --, ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"   -- Urgent workspace
            --, ppExtras  = [windowCount]                           -- # of windows current workspace
            --, ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        --}

                        >> historyHook
                        >> setWMName "LG3D" -- This fixes matlab
        , terminal = myTerminal 
        -- This is the color of the borders of the windows themselves.
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , borderWidth        = myBorderWidth
        } 
        `additionalKeysP`
        [ ("<XF86AudioPlay>", spawn "$HOME/programering/scripts/playPause.sh")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86MonBrightnessDown>", spawn "$HOME/repos/scripts/brightnessDown.sh")
        , ("<XF86MonBrightnessUp>", spawn "$HOME/repos/scripts/brightnessUp.sh")
        , ("<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 10%+")
        , ("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 10%-")
        , ("<XF86AudioMute>", spawn "amixer -D pulse set Master 1+ toggle")

        ]

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'super'. Keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Enter  Lauch terminal",
    "alt-space            Launch dmenu",
    "alt-q      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-l        Move focus to the next window",
    "mod-h        Move focus to the previous window",
    "mod-m        Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Shift-Return   Swap the focused window and the master window",
    "mod-Shift-l  Swap the focused window with the next window",
    "mod-Shift-h  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-alt-h  Shrink the master area",
    "mod-alt-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-Shift-r        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

