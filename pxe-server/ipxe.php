#!ipxe



:macrium-winpe
# sanboot --no-describe ${boot-url}/macrium-5.0/macrium-5.0-rescue-winpe-3.1.iso || goto failed
sanboot --no-describe https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.4.0-amd64-netinst.iso || goto failed

goto start

# kernel vmlinuz-3.16.0-rc4 bootfile=http://boot.ipxe.org/demo/boot.php fastboot initrd=initrd.img
# initrd initrd.img
# boot