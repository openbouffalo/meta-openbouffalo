require openbouffalo-image.bb

DESCRIPTION = "A small image just capable of allowing a device to boot and \
is suitable for development work."

#IMAGE_FEATURES += "dev-pkgs"


EXTRA_IMAGE_FEATURES += "dbg-pkgs dev-pkgs tools-sdk tools-debug tools-testapps debug-tweaks"