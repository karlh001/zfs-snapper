#!/bin/bash
# By Karl Hunter 2021
# Version 0.1.3 dated 20211203
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
# DATASET=pool/test
DATASET=pool/test

# VERSION HISTORY
# Choose here how many versions you wish to keep
# Default is 10
VER=10

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
zfs snapshot -r ${DATASET}@${CDATE}.$NCOUNT

# Get list of snapshots from dataset
# Only include name column for array
# Using -o name switch
IFS$
SNAPS=$(zfs list -r -t snapshot -o name ${DATASET})
echo $SNAPS | awk '{ print $2 }'
unset IFS


#Success
echo "Complete"
else
echo "Error: Counter file failed to update. See README"
exit
fi

# End
