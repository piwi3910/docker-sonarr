#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="sonarr"

echo "sonarr settings"
echo "================"
echo
echo "  User:       ${USER}"
echo "  UID:        ${SONARR_UID:=666}"
echo "  GID:        ${SONARR_GID:=666}"
echo "  GID_LIST:   ${SONARR_GID_LIST:=}"
echo
echo "  Config:     ${CONFIG:=/datadir}"
echo "  Downloads:  ${DOWNLOADS:=/downloads} "
echo "  Media:      ${MEDIA:=/media}"

#
# Change UID / GID of sonarr user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${SONARR_UID} ]] || usermod  -o -u ${SONARR_UID} ${USER}
[[ $(id -g ${USER}) == ${SONARR_GID} ]] || groupmod -o -g ${SONARR_GID} ${USER}
echo "[DONE]"

#
# Create groups from SONARR_GID_LIST.
#
if [[ -n ${SONARR_GID_LIST} ]]; then
    for gid in $(echo ${SONARR_GID_LIST} | sed "s/,/ /g")
    do
        printf "Create group $gid and add user ${USER}..."
        groupadd -g $gid "grp_$gid"
        usermod -aG grp_$gid ${USER}
        echo "[DONE]"
    done
fi

#
# Set directory permissions.
#

printf "Set permissions... "
chown -R ${USER}: /sonarr
function check_permissions {
  [ "$(stat -c '%u %g' $1)" == "${SONARR_UID} ${SONARR_GID}" ] || chown ${USER}: $1
}
check_permissions ${CONFIG}
check_permissions ${DOWNLOADS}
check_permissions ${MEDIA}
echo "[DONE]"


#
# Finally, start sonarr.
#

echo "Starting Sonarr..."
exec su -pc "mono Sonarr.exe -data=${CONFIG}" ${USER}
