#!ipxe

kernel vmlinuz-3.16.0-rc4 bootfile=http://boot.ipxe.org/demo/boot.php fastboot initrd=initrd.img
initrd initrd.img
boot