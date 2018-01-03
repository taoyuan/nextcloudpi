#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP

# This is the image customization script for NextCloudPi on Armbian
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# More at https://ownyourbits.com/2017/02/13/nextcloud-ready-raspberry-pi-image/
#


RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4

Main() {
	case $RELEASE in
		jessie)
			# your code here
			;;
		xenial)
			# your code here
			;;
		stretch)

            # need sudo access that does not expire during build
            chage -d -1 root

            # indicate that this will be an Armbian image build
            touch /.ncp-image
            export ARMBIANBUILD

            # install NCP
            curl -sSL https://raw.githubusercontent.com/nextcloud/nextcloudpi/master/install.sh | bash

            # restore postfix package half-configured status
            sed -i '/Package: postfix/{n;d}'                                 /var/lib/dpkg/status
            sed -i '/Package: postfix/a;Status: install ok half-configured|' /var/lib/dpkg/status

            # force change root password at first login (again)
            chage -d 0 root

            # cleanup
            apt-get autoremove -y
            apt-get clean
            rm /var/lib/apt/lists/* -r
            rm /.ncp-image

            # cleanup all NCP options
            source /usr/local/etc/library.sh
            cd /usr/local/etc/nextcloudpi-config.d/
            for script in *.sh; do
              cleanup_script $script
            done

			;;
	esac
} # Main

Main "$@"

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA
