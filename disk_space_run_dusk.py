#!/usr/bin/env /data/fido/censka/bin/python

#################################################################################
#                                                                               #
#       disk_space_run_dusk.py:   run dusk in each directory to get disk size   #
#                                 information.                                  #
#                                                                               #
#       author: t. isobe (tisobe@cfa.harvard.edu)                               #
#                                                                               #
#       last update: Apr 22, 2013                                               #
#                                                                               #
#################################################################################

import os
import sys
import re
import string

#
#--- reading directory list
#
path = '/data/mta/Script/Disk_check/house_keeping/dir_list_py'
f    = open(path, 'r')
data = [line.strip() for line in f.readlines()]
f.close()

for ent in data:
    atemp = re.split(':', ent)
    var  = atemp[1].strip()
    line = atemp[0].strip()
    exec "%s = %s" %(var, line)

#
#--- append a path to a private folder to python directory
#
sys.path.append(bin_dir)
sys.path.append(mta_dir)
#
#--- converTimeFormat contains MTA time conversion routines
#
import convertTimeFormat    as tcnv
import mta_common_functions as mcf

#-----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------

def disk_space_run_dusk():

#
#--- /data/mta/
#
    cmd = 'cd /data/mta; /usr/local/bin/dusk > ' + run_dir + '/dusk_mta'
    os.system(cmd)
#
#--- /data/mta4/
#
    cmd = 'cd /data/mta4; /usr/local/bin/dusk > ' + run_dir + '/dusk_mta4'
    os.system(cmd)
#
#--- /data/swolk/MAYS/      --- retired
#
#    cmd = 'cd /data/swolk/MAYS/; dusk > ' + run_dir + '/dusk_check3'
#    os.system(cmd)
#
#--- /data/swolk/AARON/    --- retired
#
#    cmd = 'cd /data/swolk/AARON/; dusk > ' + run_dir + '/dusk_check4'
#    os.system(cmd)




#--------------------------------------------------------------------

if __name__ == '__main__':

    disk_space_run_dusk()
