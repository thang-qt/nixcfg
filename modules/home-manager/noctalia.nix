{ inputs, pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = false;
    settings = {
      bar = {
        barType = "floating";
        position = "top";
        backgroundOpacity = 0;
        useSeparateOpacity = true;
        floating = true;
        frameThickness = 8;
        frameRadius = 12;
        hideOnOverview = false;
        displayMode = "always_visible";
        autoHideDelay = 500;
        autoShowDelay = 150;
        widgets = {
          left = [
            {
              id = "Launcher";
              icon = "rocket";
              usePrimaryColor = false;
            }
            {
              id = "Workspace";
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              labelMode = "index";
              occupiedColor = "secondary";
              reverseScroll = false;
              showApplications = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth = 350;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = false;
            }
          ];
          center = [
            {
              id = "Clock";
              customFont = "Hack";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
            }
          ];
          right = [
            {
              id = "MediaMini";
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 350;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = false;
              showProgressRing = false;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
            {
              id = "Tray";
              blacklist = [ ];
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              pinned = [ ];
            }
            {
              id = "NotificationHistory";
              hideWhenZero = false;
              hideWhenZeroUnread = false;
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              id = "Battery";
              deviceNativePath = "__default__";
              displayMode = "onhover";
              hideIfIdle = false;
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
              warningThreshold = 30;
            }
            {
              id = "Volume";
              displayMode = "onhover";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              useDistroLogo = false;
            }
          ];
        };
        screenOverrides = [ ];
      };
      general = {
        radiusRatio = 0.2;
        telemetryEnabled = false;
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
        autoStartAuth = false;
        allowPasswordWithFprintd = false;
      };
      ui = {
        fontDefault = "Noto Sans";
        fontFixed = "Noto Sans Mono";
        tooltipsEnabled = false;
        panelBackgroundOpacity = 0.96;
      };
      location = {
        name = "Hanoi";
        use12hourFormat = true;
      };
      calendar = {
        cards = [
          { id = "calendar-header-card"; enabled = true; }
          { id = "calendar-month-card"; enabled = true; }
          { id = "weather-card"; enabled = true; }
        ];
      };
      wallpaper = {
        overviewEnabled = true;
        directory = "/home/thang/Pictures/Wallpapers";
        showHiddenFiles = false;
        viewMode = "single";
        automationEnabled = true;
        randomIntervalSec = 7200;
        transitionDuration = 500;
      };
      appLauncher = {
        enableClipboardHistory = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        terminalCommand = "alacritty -e";
        iconMode = "native";
        enableSettingsSearch = true;
        enableWindowsSearch = true;
      };
      controlCenter = {
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
        cards = [
          { id = "profile-card"; enabled = true; }
          { id = "shortcuts-card"; enabled = true; }
          { id = "audio-card"; enabled = true; }
          { id = "brightness-card"; enabled = true; }
          { id = "weather-card"; enabled = true; }
          { id = "media-sysmon-card"; enabled = true; }
        ];
      };
      systemMonitor = {
        swapWarningThreshold = 80;
        swapCriticalThreshold = 90;
        diskPollingInterval = 30000;
      };
      dock = {
        enabled = false;
        position = "bottom";
        pinnedStatic = true;
        inactiveIndicators = true;
      };
      sessionMenu = {
        powerOptions = [
          { action = "lock"; command = ""; countdownEnabled = true; enabled = true; }
          { action = "suspend"; command = ""; countdownEnabled = true; enabled = true; }
          { action = "hibernate"; command = ""; countdownEnabled = true; enabled = true; }
          { action = "reboot"; command = ""; countdownEnabled = true; enabled = true; }
          { action = "logout"; command = ""; countdownEnabled = true; enabled = true; }
          { action = "shutdown"; command = ""; countdownEnabled = true; enabled = true; }
        ];
      };
      notifications = {
        respectExpireTimeout = true;
        enableMediaToast = false;
      };
      audio = {
        volumeFeedback = false;
      };
      brightness = {
        enableDdcSupport = true;
      };
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Gruvbox";
        darkMode = false;
        schedulingMode = "manual";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
      };
      templates = {
        enableUserTheming = false;
      };
      nightLight = {
        enabled = true;
      };
      hooks = {
        startup = "";
        session = "";
      };
    };
  };
}
