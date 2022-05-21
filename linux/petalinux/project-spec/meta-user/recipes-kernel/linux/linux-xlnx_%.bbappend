FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2022-05-17-14-32-00.cfg \
            file://user_2022-05-18-13-13-00.cfg \
            file://user_2022-05-18-14-08-00.cfg \
            "

