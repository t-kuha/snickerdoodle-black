FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2022-11-03-13-46-00.cfg \
            file://user_2022-11-03-14-09-00.cfg \
            "

