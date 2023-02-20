SUMMARY = "A small image just capable of allowing a device to boot."

inherit core-image

BFLB_PACKAGES_MINIMAL = "resize-rootfs \
                        coreutils \
                        net-tools \
                        util-linux \
                        mc \
                        joe \
                        "

IMAGE_INSTALL = "packagegroup-core-boot \
                packagegroup-core-full-cmdline \
                ${CORE_IMAGE_EXTRA_INSTALL} \
                ${BFLB_PACKAGES_MINIMAL} \
                "

IMAGE_LINGUAS = " "

LICENSE = "MIT"


IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"

LICENSE_CREATE_PACKAGE = "0"
IMAGE_FEATURES:remove = "lic-pkgs"
IMAGE_FEATURES:append = " allow-root-login ssh-server-dropbear"
COPY_LIC_MANIFEST="0"
COPY_LIC_DIRS="0"

IMAGE_FSTYPES = "wic.bz2 tar.gz"
