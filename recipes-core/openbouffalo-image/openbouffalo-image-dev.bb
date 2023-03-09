require openbouffalo-image.bb

DESCRIPTION = "A image suitable for development work on linux"

IMAGE_INSTALL:append = " oblfr bl-mcu-sdk bflb-mcu-tool"

EXTRA_IMAGE_FEATURES += "dev-pkgs tools-sdk tools-debug tools-testapps debug-tweaks"