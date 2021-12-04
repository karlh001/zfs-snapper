#!/bin/bash
# By Karl Hunter 2021
# Version 0.1.5 dated 20211204
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
# Default DATASET=pool/test
DATASET=pool/test3

# VERSION HISTORY
# Choose here how many versions you wish to keep
# Default VER=10
VER=5

# Temp file
# Where can temporary files be stored
# Add trailing /
# Default TEMPF=/tmp/
TEMPF=/tmp/

# Output file
# This is the name of the temp file
# Default OPF=ZFS-snap
# Default OPR=ZFS-snap-res
OPF=ZFS-snap
OPR=ZFS-res

# *** DO NOT EDIT AFTER THIS LINE ***

# Get today date and time for snapshot name
# As YearMonthDayHourMinute
CDATE=`date +"%Y%m%d%H%M"`

# Check if hour snapshot is required
# Clean up oldest snapshot:

# Get counter
# Checks if regular file exists
COUNTER=count
if [ -f "$COUNTER" ]; then

# Reads the file to get last back-up number
LASTNUMBER=$(head -n 1 $COUNTER)

else
# Could not find counter file
# Fatal error quits
echo "Error: could not find counter file. Please see README"
exit
fi

# Add 1 to the last number
num1=$LASTNUMBER
num2=1
NCOUNT="$((num1+num2))"

# Save new number to counter file
echo $NCOUNT >| $COUNTER

# Check if new number was added
if grep -q $NCOUNT  "$COUNTER";
then

# Creates the snapshot with timestamp
# Adds auto to snapshot name to prevent deletion of manual snapshots
zfs snapshot -r ${DATASET}@Auto_${CDATE}.$NCOUNT

# Deletes snapshots
# Add 1 to user to tatal bug fix
One=$VER
Two=1
SNAPKEEP="$((One+Two))"

# Check if return less than user-define
# Fixes zfs error if no snapshots to delete

# Execute delete
# Output snapshots to filter
zfs list -t snapshot -o name ${DATASET} > ${TEMPF}${OPF}

# Output number result
grep ${DATASET}@Auto ${TEMPF}${OPF} | wc -l > ${TEMPF}${OPR}

# If the snapshot count is less than the user-defined version then skip deletion
CHECKRES=$(${TEMPF}${OPR})
echo $CHECKERS
if $CHECKRES > $VER
then
# Cycles through and deletes snapshots
zfs list -t snapshot -o name | grep ^${DATASET}@Auto | tac | tail -n +${SNAPKEEP} | xargs -n 1 zfs destroy -r
fi

#Success
echo "Complete with no errors"
else
echo "Error: Counter file failed to update. See README"
exit
fi

# End
