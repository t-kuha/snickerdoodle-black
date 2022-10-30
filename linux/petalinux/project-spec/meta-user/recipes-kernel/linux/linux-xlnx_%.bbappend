FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2022-10-30-05-50-00.cfg \
            file://user_2022-10-30-07-04-00.cfg \
            "

