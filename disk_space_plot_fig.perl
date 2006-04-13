#/usr/bin/perl

#################################################################################################
#                                                                                               #
#       disk_space_plot_fig.perl: control all plotting scripts 	                                #
#                                                                                               #
#               author: t. isobe (tisobe@cfa.harvard.edu)                                       #
#                                                                                               #
#               last update: Apr. 13, 2006                                                      #
#                                                                                               #
#################################################################################################

#################################################################################
#
#--- set directories
#
open(FH, "./dir_list");
@atemp = ();
while(<FH>){
        chomp $_;
        push(@atemp, $_);
}
close(FH);

$bin_dir  = $atemp[0];
$run_dir  = $atemp[1];
$web_dir  = $atemp[2];
$data_out = $atemp[3];
$fig_out  = $atemp[4];

#################################################################################

system("perl $bin_dir/disk_space_check_size.perl");

system("perl $bin_dir/disk_space_read_dusk.perl");

system("perl $bin_dir/disk_space_read_dusk2.perl");

system("perl $bin_dir/disk_space_read_dusk3.perl");

system("perl $bin_dir/disk_space_read_dusk4.perl");

system("rm -r param ./dusk* zspace dir_list");

#
#--- find today's date
#
($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst)= localtime(time);

if($uyear < 1900) {
        $uyear = 1900 + $uyear;
}

$tyear  = $uyear;
$tmonth = $umon + 1;
if($tmonth < 10){
	$tmonth = '0'."$tmonth";
}
$tday   = $umday;
if($tday < 10){
	$tday   = '0'."$tday";

$update = "Last Update: $tmonth/$umday/$tyear";


open(FH, "$web_dir/disk_space.html");
@line = ();
while(<FH>){
	chomp $_;
	if($_ =~ /Last Update/){
		push(@line, $update);
	}else{
		push(@line, $_);
	}
}
close(FH);

open(OUT, ">$web_dir/disk_space.html");
foreach $ent (@line){
	print OUT "$ent\n";
}
close(OUT);
