#!/bin/bash
# By Karl Hunter 2021
# Version 0.1.8 dated 20211209
# https://github.com/karlh001
# Snapshot ZFS pool

#################################
# 	   WELCOME		#
#				#
# PLEASE REVIW readme.md	#
#				#
#################################

# DATASET
# Edit the name of the pool and dataset you wish
# to snapshot. This can be the entire pool, e.g.
# DATASET=pool
# Where pool is the name of your ZFS pool
# Or, a dataset within the pool, e.g.
# poolname/dataset
DATASET=pool/test

# VERSION HISTORY
# Choose here how many versions you wish to keep
# Default VER=10
VER=10

# TEMP FILE
# Where can temporary files be stored
# Add trailing /
# Default TEMPF=/tmp/
TEMPF=/tmp/zfssnap.tmp

# PREFIX
# Choose your own snapshot prefix
# This is the label for the beginning of the snapshot
# e.g. Auto_YYYYMMDD_HHMMSS
# Default PREFIX=Auto_
PREFIX=Auto_

# *** DO NOT EDIT AFTER THIS LINE ***

# Get today date and time for snapshot name
# As YearMonthDayHourMinute
CDATE=`date +"%Y%m%d_%H%M%S"`

# It's snappy time
# Creates the snapshot with timestamp
# Adds auto to snapshot name to prevent deletion of manual snapshots
zfs snapshot -r ${DATASET}@${PREFIX}${CDATE}

# Run snapshot rotation
# Check if return less than user-define
# Execute delete
# Output snapshots to filter; gets ZFS snapshot list
zfs list -t snapshot -o name ${DATASET} > ${TEMPF}

# Output number result into variable
RESULT=$(grep ${DATASET}@${PREFIX} ${TEMPF} | wc -l)

# If the snapshot count is less than the user-defined version then skip
# Add one to user-defined variable to fix one less bug
KEEP=$(($VER+1))
if [ $RESULT -gt $VER ]; then
# Cycles through and deletes snapshots
zfs list -t snapshot -o name | grep ^${DATASET}@${PREFIX} | tac | tail -n +${KEEP} | xargs -n 1 zfs destroy -r
echo "Snapshot rotation has deleted snapshots; to retain last" ${VER}
else
# Info to user to inform no snapshots to delete
echo "No snapshots removed due to being less than rotation. You wish to keep" $VER "and you have $RESULT"
fi

#Success
echo "Complete with no errors"

# End
