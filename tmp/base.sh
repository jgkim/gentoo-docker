#!/bin/sh

set -e

echo "Configuring the portage environment..."
mv /tmp/make.conf /etc/portage/make.conf
grep --quiet "MAKEOPTS=" /etc/portage/make.conf || sed --in-place "/CPU_FLAGS_X86=/a MAKEOPTS=\"-j$(expr $(nproc) + 1)\"" /etc/portage/make.conf

echo "Installing a portage snapshot..."
emerge-webrsync --quiet

echo "Purging news items..."
eselect news read --quiet
eselect news purge

echo "Updating the portage tree..."
emerge --sync --quiet

echo "Choosing the right profile..."
eselect profile set "default/linux/amd64/13.0/no-multilib"
mkdir --parents /etc/portage/package.use /etc/portage/profile
mv /tmp/packages /etc/portage/profile/packages
echo "dev-util/pkgconfig internal-glib" > /etc/portage/package.use/pkgconfig

echo "Selecting the timezone for the system..."
echo "UTC" > /etc/timezone
emerge --config --quiet sys-libs/timezone-data

echo "Configuring locales..."
mv /tmp/locale.gen /etc/locale.gen
locale-gen
eselect locale set "en_US.utf8"

echo "Reloading the environment..."
env-update && source /etc/profile

echo "Updating the world..."
find / -type f \( -perm -4000 -or -perm -2000 \) -links +1 ! -path "/proc/*" -exec chmod u-s,g-s {} \;
emerge --emptytree --update --deep --newuse --quiet @world

echo "Updating configuration files..."
etc-update --preen --quiet
find /etc/ -name "._cfg[0-9][0-9][0-9][0-9]*" -exec rm {} \;

echo "Purging unused locales..."
emerge --quiet localepurge
mv /tmp/locale.nopurge /etc/locale.nopurge
localepurge

echo "Cleaning the source files directory..."
emerge --quiet gentoolkit
eclean-dist --deep --quiet

echo "Packaging development tools..."
quickpkg --include-config y autoconf automake bison yacc binutils libtool gcc localepurge libltdl autoconf-wrapper binutils-config help2man automake-wrapper gcc-config mpc mpfr gmp

echo "Cleaning the system..."
emerge --unmerge --quiet autoconf automake bison yacc binutils libtool gcc localepurge
emerge --depclean --quiet
if [ -f /etc/resolv.conf ]
then
	echo "nameserver 8.8.8.8" > /etc/resolv.conf
	echo "nameserver 8.8.4.4" >> /etc/resolv.conf
fi
mkdir --parents /usr/local/bin
mv /tmp/portagepurge /usr/local/bin/portagepurge
chmod +x /usr/local/bin/portagepurge
portagepurge

echo "Setting the default options for emerge..."
grep --quiet "EMERGE_DEFAULT_OPTS=" /etc/portage/make.conf || sed -i '/FEATURES=/a EMERGE_DEFAULT_OPTS="--usepkg --buildpkg"' /etc/portage/make.conf

echo "Done with installing the Gentoo base system."
