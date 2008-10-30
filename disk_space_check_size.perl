#!/usr/bin/perl
use PGPLOT;

#################################################################################
#										#
#	check_disk_space.perl: check /data/mta* space and send out email	#
#			       if it is beyond a limit				#
#										#
#		author: t. isobe (tisobe@cfa.harvard.edu)			#
#		last update: Oct  29, 2008					#
#										#
#################################################################################

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

#
#---- and other settings
#
$set_ymin = 30;
$set_ymax = 100;

#################################################################################

$check = 0;
#
#---- /data/mta/
#
system("df -k  /data/mta/ > zspace");
open(FH, "./zspace");
while(<FH>){
	chomp $_;
	@atemp = split(/\s+/, $_);
	if($atemp[1] =~ /\d/){
		@btemp = split(/\%/, $atemp[4]);
		$percent = $btemp[0];
		$per0 = $percent;
		if($percent > 95){
			$check++;
			$line = '/data/mta/  is at '."$percent".'% capacity'."\n";
		}
	}
}
close(FH);
#
#---- /data/mta1/
#--- for /data/mta1/, /data/mta2/, /data/mta3, you need to use
#--- "ls /data/mta1/", to makes df /data/mta1/ to work. I have no idea why....
#
system("ls /data/mta1/ > zspace; df -k /data/mta1/ > zspace");
open(FH, "./zspace");
while(<FH>){
	chomp $_;
	@atemp = split(/\s+/, $_);
	if($atemp[1] =~ /\d/){
		@btemp = split(/\%/, $atemp[4]);
		$percent = $btemp[0];
		$per1 = $percent;
		if($percent > 95){
			$check++;
			$line = "$line". '/data/mta1/ is at '."$percent".'% capacity'."\n";
		}
	}
}
close(FH);
#
#--- /data/mta2/
#
system("ls /data/mta2/ > zspace; df -k /data/mta2/ > zspace");
open(FH, "./zspace");
while(<FH>){
	chomp $_;
	@atemp = split(/\s+/, $_);
	if($atemp[1] =~ /\d/){
		@btemp = split(/\%/, $atemp[4]);
		$percent = $btemp[0];
		$per2 = $percent;
		if($percent > 90){
			$check++;
			$line = "$line".'/data/mta2/ is at '."$percent".'% capacity'."\n";
		}
	}
}
close(FH);
#
#---- /data/mta3/    this disk is not with mta anymore, but we still monitor
#
#system("ls /data/mta3/ > zspace; df -k  /data/mta3/ > zspace");
#open(FH, "./zspace");
#while(<FH>){
#	chomp $_;
#	@atemp = split(/\s+/, $_);
#	if($atemp[1] =~ /\d/){
#		@btemp = split(/\%/, $atemp[4]);
#		$percent = $btemp[0];
#		$per3 = $percent;
#		if($percent > 90){
#			$check++;
#			$line = "$line".'/data/mta3/ is at '."$percent".'% capacity'."\n";
#		}
#	}
#}
#close(FH);
#
#--- /data/mta4/
#
system("df -k  /data/mta4/ > zspace");
open(FH, "./zspace");
while(<FH>){
	chomp $_;
	@atemp = split(/\s+/, $_);
	if($atemp[1] =~ /\d/){
		@btemp = split(/\%/, $atemp[4]);
		$percent = $btemp[0];
		$per4 = $percent;
		if($percent > 90){
			$check++;
			$line = "$line".'/data/mta4/ is at '."$percent".'% capacity'."\n";
		}
	}
}
close(FH);
#
#---- /data/swolk/
#
system("ls /data/swolk/ > zspace; df -k  /data/swolk/ > zspace");
open(FH, "./zspace");
while(<FH>){
	chomp $_;
	@atemp = split(/\s+/, $_);
	if($atemp[1] =~ /\d/){
		@btemp = split(/\%/, $atemp[4]);
		$percent = $btemp[0];
		$per5 = $percent;
		if($percent > 95){
			$check++;
			$line = "$line".'/data/swolk/ is at '."$percent".'% capacity'."\n";
		}
	}
}
close(FH);
#
#---- /data/swolk/AARON/
#
#system("ls /data/swolk/AARON/> zspace; df -k  /data/swolk/AARON/ > zspace");
#open(FH, "./zspace");
#while(<FH>){
#	chomp $_;
#	@atemp = split(/\s+/, $_);
#	if($atemp[1] =~ /\d/){
#		@btemp = split(/\%/, $atemp[4]);
#		$percent = $btemp[0];
#		$per6 = $percent;
#		if($percent > 95){
#			$check++;
#			$line = "$line".'/data/swolk/AARON/ is at '."$percent".'% capacity'."\n";
#		}
#	}
#}
#close(FH);

#
#---- sending out warning email, if any of the disk exceeded the limit
#
if($check > 0){
	$top = "$top"."-----------------------\n";
	$top = "$top".'  Disk Space Warning:'."\n";
	$top = "$top"."-----------------------\n\n";
	$line = "$top"."$line";
	open(OUT, '>./zline.tmp');
	print OUT  "$line";
	close(OUT);
system("cat ./zline.tmp |mailx -s \"Subject: Disk Space Warning\n\" -r  mta\@head.cfa.harvard.edu isobe\@head.cfa.harvard.edu brad\@head.cfa.harvard.edu swolk\@head.cfa.harvard.edu 6177214360\@vtext.com");
# fixed typo in brad address. BDS 1/28/05
# add nbizunok. BDS 3/25/05
# rm nbizunok. BDS 10/03/07
	system("rm ./zline.tmp");

}
#
#---- find today's date
#
($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst)= localtime(time);

if($uyear < 1900) {
        $uyear = 1900 + $uyear;
}

$tyear  = $uyear;
$tmonth = $umon + 1;
$tday   = $umday;

conv_date_dom();

$temp_time = $dom + $uhour/24 + $umin/1440;
$time = sprintf "%6.3f",$temp_time;
#
#--- read previous data
#
open(FH, "$data_out/disk_space_data");
@save_list = ();
while(<FH>){
	chomp $_;
	push(@save_list, $_);
}
close(FH);
#
#--- current data in one line
#
$line = "$time\t"."$per0\t"."$per1\t"."$per2\t"."$per3\t"."$per4\t"."$per5\t"."$per6";
#
#--- check whether this line is a duplicate of the past data
#
$check = 0;
OUTER:
foreach $ent (@save_list){
	if($ent eq $line){
		$check = 1;
		last OUTER;
	}
}
#
#--- if not, add the data into the database
#
if($check == 0){
	push(@save_list, $line);
	open(OUT, ">>$data_out/disk_space_data");
	print OUT "$line\n";
	close(OUT);
}
#
#--- separate the data into each element
#
@time   = ();
@space0 = ();
@space1 = ();
@space2 = ();
@space3 = ();
@space4 = ();
@space5 = ();
@space6 = ();

$cnt = 0;
foreach $ent (@save_list){
	@atemp = split(/\s+/, $ent);
	push(@time,   $atemp[0]);
	push(@space0, $atemp[1]);
	push(@space1, $atemp[2]);
	push(@space2, $atemp[3]);
	push(@space3, $atemp[4]);
	push(@space4, $atemp[5]);
#
#--- special cases here. MAYS and AARON added later. put zero to unchecked  past date
#
#---- space for /data/mays/ is now used for /data/swolk (10/29/08: DOM: 3382)
#
	if($atemp[6] =~ /\d/){
		push(@space5, $atemp[6]);
	}else{
		push(@space5, '0');
	}	
	if($atemp[7] =~ /\d/){
		push(@space6, $atemp[7]);
	}else{
		push(@space6, '0');
	}	
	$cnt++;
}
#
#--- setting plotting limits
@temp = sort{$a<=>$b} @time;
$min = $temp[0];
$max = $temp[$cnt -1];
$xdiff = $max - $min;
if($xdiff == 0){
	$xmin = $min -1;
	$xmax = $max +1;
}else{
	$xmin = $min -  0.1 * $xdiff;
	$xmax = $max +  0.1 * $xdiff;
}
$xdiff = $xmax - $xmin;
#
#--- ymin and ymax are predetermined
#

$ymin = $set_ymin;
$ymax = $set_ymax;

#
#---- a first panel
#
pgbegin(0, "/cps",1,1);
pgsubp(1,1);
pgsch(1);
pgslw(3);
#
#--- disk: mta
#
pgsvp(0.10, 1.0, 0.69, 0.99);
pgswin($xmin, $xmax, $ymin, $ymax);
pgbox(ABCST,0.0 , 0.0, ABCNSTV, 0.0, 0.0);
pgsci(2);
pgmove($time[0], $space0[0]);
for($k = 1; $k < $cnt; $k++){
	pgdraw($time[$k], $space0[$k]);
}
pgsci(1);
$xt = $xmin + 0.05 * $xdiff;
$yt = $ymax - 0.08 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.0, "/data/mta/");
#
#--- disk: mta1
#
pgsvp(0.10, 1.0, 0.38, 0.68);
pgswin($xmin, $xmax, $ymin, $ymax);
pgbox(ABCST,0.0 , 0.0, ABCNSTV, 0.0, 0.0);
pgsci(3);
pgmove($time[0], $space1[0]);
for($k = 1; $k < $cnt; $k++){
	pgdraw($time[$k], $space1[$k]);
}
pgsci(1);
$xt = $xmin + 0.05 * $xdiff;
$yt = $ymax - 0.08 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.0,  "/data/mta1/");
$xt = $xmin - 0.05 * $xdiff;
$yt = $ymax - 0.5 * ($ymax - $ymin);
pgptext($xt, $yt, 90.0, 0.5,  "Disk Space Used (%)");
#
#--- disk: mta2
#
pgsvp(0.1, 1.0, 0.07, 0.37);
pgswin($xmin, $xmax, $ymin, $ymax);
pgbox(ABCNST,0.0 , 0.0, ABCNSTV, 0.0, 0.0);
pgsci(4);
pgmove($time[0], $space2[0]);
for($k = 1; $k < $cnt; $k++){
	pgdraw($time[$k], $space2[$k]);
}
pgsci(1);
$xt = $xmin + 0.05 * $xdiff;
$yt = $ymax - 0.08 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.0,  "/data/mta2/");
$xt = $xmin + 0.5 * $xdiff;
$yt = $ymin - 0.2 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.5,  "Time (DOM)");

pgclos();

system("echo ''|gs -sDEVICE=ppmraw  -r256x256 -q -NOPAUSE -sOutputFile=-  pgplot.ps| $bin_dir/pnmflip -r270 | $bin_dir/ppmtogif > $fig_out/disk_space1.gif");


#
#--- a second panel
#


pgbegin(0, "/cps",1,1);
pgsubp(1,1);
pgsch(1);
pgslw(3);

#
#--- disk: mta4
#

pgsvp(0.1, 1.0, 0.69, 0.99);
pgswin($xmin, $xmax, $ymin, $ymax);
pgbox(ABCST,0.0 , 0.0, ABCNSTV, 0.0, 0.0);
pgsci(2);
pgmove($time[0], $space4[0]);
for($k = 1; $k < $cnt; $k++){
	pgdraw($time[$k], $space4[$k]);
}
pgsci(1);
$xt = $xmin + 0.05 * $xdiff;
$yt = $ymax - 0.08 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.0, "/data/mta4/");

#
#--- disk: /data/swolk
#

pgsvp(0.1, 1.0, 0.38, 0.68);
pgswin($xmin, $xmax, $ymin, $ymax);
pgbox(ABCNST,0.0 , 0.0, ABCNSTV, 0.0, 0.0);
pgsci(3);
$tstart = 0;
OUTER:
for($k = 1616; $k < $cnt; $k++){	#---- we started checking /data/swolk/ from dom 3390, entry # 1616
	if($space5[$k] > 0){
		pgmove($time[$k], $space5[$k]);
#
#--- special treatment, if there are not enough data points, use a marker
#
        if($dcnt < 50){
                pgpt(1, $time[$k], $space5[$k], 3);
        }
		$tstart = $k + 1;
		last OUTER;
	}
}
for($k = $tstart; $k < $cnt; $k++){
	pgdraw($time[$k], $space5[$k]);
        if($dcnt < 50){
                pgpt(1, $time[$k], $space5[$k], 3);
        }
}
pgsci(1);
$xt = $xmin + 0.05 * $xdiff;
$yt = $ymax - 0.08 * ($ymax - $ymin);
pgptext($xt, $yt, 0.0, 0.0, "/data/swolk/");
$xt = $xmin - 0.05 * $xdiff;
$yt = $ymax - 0.5 * ($ymax - $ymin);
pgptext($xt, $yt, 90.0, 0.5,  "Disk Space Used (%)");
pgptext($xt, $yt, 0.0, 0.5,  "Time (DOM)");

pgclos();

system("echo ''|gs -sDEVICE=ppmraw  -r256x256 -q -NOPAUSE -sOutputFile=-  pgplot.ps| $bin_dir/pnmflip -r270 | $bin_dir/ppmtogif > $fig_out/disk_space2.gif");

system("rm zspece pgplot.ps");


#####################################################################
### conv_date_dom: change the time format to dom                  ###
#####################################################################

sub conv_date_dom{

        $ydiff = $tyear - 1999;
        $acc_date = 365 * $ ydiff;
        if($tyear > 2000){
                $acc_date++;
        }
        if($tyear > 2004){
                $acc_date++;
        }
        if($tyear > 2008){
                $acc_date++;
        }
        if($tyear > 2012){
                $acc_date++;
        }

        if($tmonth == 1){
                $dom =   1;
        }elsif($tmonth == 2){
                $dom =  32;
        }elsif($tmonth == 3){
                $dom =  60;
        }elsif($tmonth == 4){
                $dom =  91;
        }elsif($tmonth == 5){
                $dom = 121;
        }elsif($tmonth == 6){
                $dom = 152;
        }elsif($tmonth == 7){
                $dom = 182;
        }elsif($tmonth == 8){
                $dom = 213;
        }elsif($tmonth == 9){
                $dom = 244;
        }elsif($tmonth == 10){
                $dom = 274;
        }elsif($tmonth == 11){
                $dom = 305;
        }elsif($tmonth == 12){
                $dom = 335;
        }
        if($tyear == 2000 || $tyear == 2004 || $tyear == 2008 || $tyear == 2012){
                if($tmonth > 2){
                        $dom++;
                }
        }

        $dom = $dom + $acc_date + $tday - 202;
}


