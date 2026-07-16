-- See https://wiki.hyprland.org/Configuring/Environment-variables/
local home_dir = os.getenv("HOME")

-- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Applications
hl.env("XDG_DATA_DIRS",
    home_dir ..
    "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS")

-- Virtual environment
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", home_dir .. "/.local/state/quickshell/.venv")
-- #env = QT_STYLE_OVERRIDE,kvantum
-- #env = GBM_BACKEND,nvidia-drm
-- #env = __GLX_VENDOR_LIBRARY_NAME,nvidia
-- #env = VDPAU_DRIVER,va_gl
-- #env = LIBVA_DRIVER_NAME,nvidia
-- #env = VDPAU_DRIVER,nvidia
-- #env = NVD_BACKEND,direct
-- #env = MOZ_DISABLE_RDD_SANDBOX,1
-- #env = SDL_VIDEODRIVER,wayland
-- #env = AQ_DRM_DEVICES, /dev/dri/card1
-- #env = WLR_NO_HARDWARE_CURSORS,1
-- #env = CLUTTER_BACKEND,wayland
-- #env = GDK_BACKEND,wayland,x11,*
