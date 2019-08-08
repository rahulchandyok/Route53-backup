#
# =============================================================================================
#
# dnsbkp.sh: Takes the backup of all Route53 domains
# This script requires read rights for specified account of AWS which you need to backup
#
# Author: Rahul Chandyok
# ==============================================================================================
#

LOGFILE=/var/log/dnsbackup.log
DATE=`/bin/date`
DNSLIST="/tmp/dnslist.txt"
DEST=/root/DNS
NAME="$1"

# Initialize logfile
echo "" >> ${LOGFILE}
echo "####################### ${DATE} #####################" >> ${LOGFILE}
echo "Taking backup of" >> ${LOGFILE}

# Check existence of dnslist
if [ -f ${DNSLIST} ]
then
        rm -rf ${DNSLIST}
fi

# Create a list of all available domains on Route53
/usr/bin/cli53 list | grep ${NAME} | sed 's/INFO//g'
if [ $? -eq 0 ]
then
        echo -e "Domain name ${NAME} Found, Taking its backup at ${DEST}"
        /usr/bin/cli53 rrlist ${NAME} >> ${DEST}/${NAME}.txt
else
        echo -e "No Such domain name ${NAME} hosted on Route53"
        exit 1
fi
