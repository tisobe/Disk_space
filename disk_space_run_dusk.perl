#!/usr/bin/perl

#################################################################################
#										#
#	disk_space_run_dusk.perl: run dusk in each directory to get disk size	#
#				  information.					#
#										#
#	author: t. isobe (tisobe@cfa.harvard.edu)				#
#										#
#	last update: Mar. 16, 2011						#
#										#
#################################################################################


############################################################
#
#--- set directories
#
open(FH, "/data/mta/Script/Disk_check/house_keeping/dir_list");
@atemp = ();
whle(<FH>){
        chomp $_;
        push(@atemp, $_);
}
close(FH);

$bin_dir    = $atemp[0];
$run_dir    = $atemp[1];
$web_dir    = $atemp[2];
$data_out   = $atemp[3];
$fig_out    = $atemp[4];

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

#
#--- /data/swolk/	#---- this takes too long; dropped
#
#system("cd /data/swolk/; dusk > $run_dir/dusk_check5");
