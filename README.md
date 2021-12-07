# ZFS Snapper
Read me v.2

## About

Welcome. This is a simple snapshot rotation tool. I wanted a script to create n snapshots then delete exisiting snapshots.

## Install

Copy script into your /usr/bin or run script directly from any location.

```
sh /foo/bar/script.sh
```

Before running script, please open and edit options. The only option to have to change is dataset location, otherwise it will not run.

If the script does not run, try changing permissions to:

```
chmod +x /foo/bar/script.sh
```

You can copy script into your /etc/cron.daily or /etc/cron.hourly to automate.
If using hourly, edit "crontab -e" with line

```
0 * * * * /foo/bar/script.sh >/dev/null 2>&1
```

Above command will run hourly.

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

## DATASET

Choose which dataset you wish to back-up. You can choose entire pool or a single dataset.
E.g. /pool/documents
Do not end with /

### VER

Relates to how many snapshots you wish to keep. Once your Auto_ snapshots reach defined value, the script will delete all previous.
Default is 10.

## Temp file

Where can temporary files be stored? This allows the script to output to files.
E.g. TEMPF=/tmp/name-of-file
You do not need to change this option if you do not wish.

## Output file

This is the name of the temp file. You can leave this default unless your are experiencing problems with its file name.

