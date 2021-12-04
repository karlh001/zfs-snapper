# ZFS Snapper

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

* Checks if "count" file exists
* Reads last snapshot number
* Adds one to last number
* Creates snapshot
* Checks if snapshots need removing
* Deletes all snapshots with then "Auto" until last n defined remain

## Snapshots

Snapshots are named:

```
Auto_YYYYMMDD.X
```

Where X is incremental number

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
E.g. TEMPF=/tmp/
Remember to add / to the end.
You do not need to change this option

## Output file

This is the name of the temp file. You can leave this default unless your are experiencing problems with its file name.

## Errors Codes

### Could not find counter file. Please see README

Create an empty file named "count" in the same directory of the script, otherwise define its location in the script's options section

To create empty file, use touch command:

```
touch /foo/bar/count
```