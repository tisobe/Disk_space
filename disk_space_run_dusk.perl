#!/usr/bin/perl

#################################################################################
#										#
#	disk_space_run_dusk.perl: run dusk in each directory to get disk size	#
#				  information.					#
#										#
#	author: t. isobe (tisobe@cfa.harvard.edu)				#
#										#
#	last update: Oct. 29, 2008						#
#										#
#################################################################################


############################################################
#
#--- set directories
#
$bin_dir  = '/data/mta4/MTA/bin/';
$run_dir  = '/data/mta/Script/Disk_check/Exc/';
$web_dir  = '/data/mta/www/mta_disk_space/';
$data_out = "$web_dir/Data/";
$fig_out  = "$web_dir/Figs/";

open(OUT, ">./dir_list");
print OUT "$bin_dir\n";
print OUT "$run_dir\n";
print OUT "$web_dir\n";
print OUT "$data_out\n";
print OUT "$fig_out\n";
close(OUT);

############################################################

system("mkdir $run_dir/param");

#
#--- /data/mta/
#
system("cd /data/mta; dusk > $run_dir/dusk_check");

#
#--- /data/mta4/
#
system("cd /data/mta4; dusk > $run_dir/dusk_check2");

#
#--- /data/swolk/MAYS/
#
system("cd /data/swolk/MAYS; dusk > $run_dir/dusk_check3");

#
#--- /data/swolk/AARON/
#
system("cd /data/swolk/AARON; dusk > $run_dir/dusk_check4");
