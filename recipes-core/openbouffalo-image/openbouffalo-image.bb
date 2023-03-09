SUMMARY = "A small image just capable of allowing a device to boot."

inherit core-image
DEPENDS:append = " zip-native"


BFLB_PACKAGES_MINIMAL = "resize-rootfs \
                        coreutils \
                        net-tools \
                        util-linux \
                        mc \
                        joe \
                        ca-certificates \
                        ntp \
                        u-boot \
                        opensbi \ 
                        bl808-firmware \
                        "

IMAGE_INSTALL = "packagegroup-core-boot \
                packagegroup-core-full-cmdline \
                ${CORE_IMAGE_EXTRA_INSTALL} \
                ${BFLB_PACKAGES_MINIMAL} \
                "

IMAGE_LINGUAS = " "

IMAGE_VERSION_SUFFIX = "-${DISTRO_VERSION}"

LICENSE = "MIT"

IMAGE_ROOTFS_SIZE ?= "8192"

LICENSE_CREATE_PACKAGE = "0"
IMAGE_FEATURES:remove = "lic-pkgs"
IMAGE_FEATURES:append = " allow-root-login ssh-server-dropbear package-management"
COPY_LIC_MANIFEST="0"
COPY_LIC_DIRS="0"

IMAGE_FSTYPES = "wic.bz2"

do_create_download() {
    install -m 0755 -d ${DEPLOY_DIR_IMAGE}/downloads/
    cd ${WORKDIR}
    rm -f ${IMAGE_NAME}.zip
    mkdir -p OpenBouffalo-${DISTRO_VERSION}
    ls ${DEPLOY_DIR_IMAGE}/bl808-firmware.bin ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}*${IMAGE_FSTYPES}
    cp -r ${DEPLOY_DIR_IMAGE}/bl808-firmware.bin ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}*${IMAGE_FSTYPES} OpenBouffalo-${DISTRO_VERSION}
    zip -r ${IMAGE_NAME}.zip OpenBouffalo-${DISTRO_VERSION}/*
    install -m 0755 ${IMAGE_NAME}.zip ${DEPLOY_DIR_IMAGE}/downloads/
}

addtask do_create_download after do_image_complete before do_populate_lic_deploy 
