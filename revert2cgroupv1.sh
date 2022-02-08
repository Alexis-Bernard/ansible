#! /bin/bash
sudo sed -i '/^GRUB_CMDLINE_LINUX=/ s/"$/ net.ifnames=0 systemd.unified_cgroup_hierarchy=0"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
