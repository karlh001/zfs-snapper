# ZFS Snapper
Read me v.4

## About

Welcome. This is a simple snapshot rotation tool. I wanted a script to create n snapshots then delete exisiting snapshots.

## Install

### Copy Script

Copy script into your /usr/bin or run script directly from any location.

```
sh /usr/bin/zfs_snaps.sh
```

Before running script, please open and edit the options. The only option you _have_ to change is dataset location, otherwise it will not run.

If the script does not run, try changing permissions to:

```
chmod +x /usr/bin/zfs_snaps.sh
```


### Set-up automatic schedule

Best option is to run using crontab. Crontab will take care of running the script at your defined intervals.

Edit crontab:

```
nano /etc/crontab
```

Add a new line. For example, if you want this script to run daily (at 6pm) then add this line (I have chosen root - this will be best option unless other users have access to ZFS):

```
0 18 * * * root /usr/bin/zfs_snaps.sh >/dev/null 2>&1
```

Another commond schedule could be hourly. Instead use:

```
0 * * * * root /usr/bin/zfs_snaps.sh >/dev/null 2>&1
```

## How It Works

* Creates snapshot
* Checks if snapshots need removing; counts all snapshots starting with 'Auto'
* Deletes all snapshots with then "Auto" until last n defined remain

## Snapshots

Snapshots are named:

```
Auto_YYYYMMDD_HHMMSS
```

## Options

You can edit following options:

### DATASET

Choose which dataset you wish to back-up. You can choose entire pool or a single dataset.

E.g. /pool/documents

Do not end with /

If you choose the entire pool, the back-up script is recurisve, which means if you choose the entire pool all datasets will get their own snapshot.

### VER

Relates to how many snapshots you wish to keep. Once your Auto_ snapshots reach defined value, the script will delete all previous.

Default is 10.

### TEMP FILE

Where can temporary files be stored? This allows the script to output to files.

E.g. TEMPF=/tmp/name-of-file

You do not need to change this option if you do not wish.

### PREFIX

Here you can choose the label for the snapshots. This will be displayed at the beginning of the snapshot. Ideally, this cannot be changed because the script looks for the prefix when deleting old versions.

E.g. Auto_YYYYMMDD_HHMMSS

## Testing

Tested on ZFS 0.8.3-1 on Ubuntu 12.13
