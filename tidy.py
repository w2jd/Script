#!/usr/bin/python3

# Title       : tidy directory
# Description : tidy directory by specific format
# How to Use  : python tidy.py [Path]
# Maker       : LT
# Date        : 2019.09.09.
# OS          : Windows 10 x64



### import
import sys
import re
import shutil
import os
import datetime

### set variable
pattern_square_bracket = re.compile('^\[.*\]')

### check argument
if len(sys.argv) != 2 or sys.argv[1] == '-h' or sys.argv[1] == 'help' or not(os.path.isdir(sys.argv[1])):
    print(" Program     : Tidy directory")
    print(" Description : Tidy directory by specific format")
    print("               ex> [manual] server1.pdf, [manual] server2.pdf → [manual]\\server1.pdf")
    print("                                                                 [manual]\\server2.pdf")
    print(" Usage       : python tidy.py [Directory]")
    print("               ex> python tidy.py C:\\Users\\liteman\\Desktop")
    sys.exit(1)
# Get target directory from input $1 (sys.argv[1])
homedir = sys.argv[1]

### move file from homedir to homedir/targetdir
def movefile(homedir, filename, targetdirectory):
    # make directory - check exist targetdir
    targetdir = os.path.join(homedir, targetdirectory)
    try:
        if not(os.path.isdir(targetdir)):
            os.makedirs(targetdir)
    except:
        print("[movefile] make directory")
        raise

    # move file
    try:
        original_file = os.path.join(homedir, filename)
        target_file = os.path.join(targetdir, filename)


        if not os.path.isfile(target_file): # file not exist
            shutil.move(original_file, targetdir)
        else:                               # file exist
            # if exist target_file then add access_time to file name
            get_access_time = os.path.getatime(original_file)
            access_time = datetime.datetime.fromtimestamp(get_access_time).strftime("%Y%m%d_%H%M%S")
            file_name = os.path.splitext(filename)[0]
            file_extension = os.path.splitext(filename)[1]
            targetdir_overwrite = os.path.join(targetdir, file_name + "_" + access_time + file_extension)

            shutil.move(original_file, targetdir_overwrite)
    except:
        print("[movefile] move file")
        raise

### Get File list exclude directory
file_list = [file for file in os.listdir(homedir) if os.path.isfile(os.path.join(homedir, file))]
specificfile = [regular for regular in file_list ]

### extract pattern_square_bracket from file name
for file in file_list:
    filename = pattern_square_bracket.match(file)

    # match pattern_square_bracket
    if filename != None:
        targetdir = filename.group()

        movefile(homedir, file, targetdir)

### print result
print("Complete!")
