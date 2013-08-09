Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3HIEAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Aug 2013 00:00:07 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1V7dry-0001g1-LJ
	for fio@vger.kernel.org; Fri, 09 Aug 2013 04:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130809040002.A3EFE20B0D@kernel.dk>
Date: Fri,  9 Aug 2013 04:00:02 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7a16102ef84e3db14b6802a06f7f99e2e55af85d:

  Fio 2.1.2 (2013-08-06 09:39:54 -0600)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Erwan Velu (10):
      fio2gnplot: Print specific message if cmdline parsing fails
      fio2gnuplot: Adding getoplong support for cmdline
      fio2gnuplot: Fixing typo in error message
      fio2gnuplot: Adding verbose option
      fio2gnuplot: Deleting temporary files by default
      fio2gnuplot: Managing temporary files in a better way
      fio2gnuplot: Fixing help message
      fio2gnuplot: Removing .py extension
      fio2gnuplot: Adding manpage
      genfio: Don't consider only /dev/ disk device

 Makefile                                   |    8 +-
 tools/genfio                               |   47 ++++++---
 tools/plot/{fio2gnuplot.py => fio2gnuplot} |   67 +++++++++---
 tools/plot/fio2gnuplot.1                   |  161 ++++++++++++++++++++++++++++
 tools/plot/fio2gnuplot.manpage             |  117 ++++++++++++++++++++
 5 files changed, 368 insertions(+), 32 deletions(-)
 rename tools/plot/{fio2gnuplot.py => fio2gnuplot} (87%)
 create mode 100644 tools/plot/fio2gnuplot.1
 create mode 100644 tools/plot/fio2gnuplot.manpage

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8494b27..eb0e892 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ OPTFLAGS= -O3 -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot.py tools/genfio
+SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio
 
 ifdef CONFIG_GFIO
   PROGS += gfio
@@ -275,11 +275,15 @@ distclean: clean FORCE
 cscope:
 	@cscope -b -R
 
-install: $(PROGS) $(SCRIPTS) FORCE
+tools/plot/fio2gnuplot.1:
+	@cat tools/plot/fio2gnuplot.manpage | txt2man -t fio2gnuplot >  tools/plot/fio2gnuplot.1
+
+install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 tools/plot/fio2gnuplot.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
 	$(INSTALL) -m 644 tools/plot/*gpm $(DESTDIR)$(sharedir)/
diff --git a/tools/genfio b/tools/genfio
index bbf8833..11cf9a4 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -25,6 +25,7 @@ SEQ=-1
 TEMPLATE=/tmp/template.fio
 OUTFILE=
 DISKS=
+PRINTABLE_DISKS=
 RUNTIME=300
 ETA=0
 MODES="write,randwrite,read,randread"
@@ -53,7 +54,6 @@ show_help() {
 					Default is $IODEPTH
 -d disk1[,disk2,disk3,..]	: Run the tests on the selected disks
 					Separated each disk with a comma
-					Disk name shall be "sdxx", /dev/ shall NOT be used here
 -r seconds			: Time in seconds per benchmark
 					0 means till the end of the device
 					Default is $RUNTIME seconds
@@ -70,7 +70,7 @@ show_help() {
 
 Example:
 
-$PROG -d sdb,sdc,sdd,sde -a -b 4k,128k,1m -r 100 -a -x dellr720-day2/
+$PROG -d /dev/sdb,/dev/sdc,/dev/sdd,/dev/sde -a -b 4k,128k,1m -r 100 -a -x dellr720-day2/
 
 	Will generate an fio file that will run
 		- a sequential bench on /dev/sdb /dev/sdc /dev/sdd /dev/sde for block size = 4k with write,randwrite,read,randread tests
@@ -104,6 +104,21 @@ if [ "$CACHED_IO" = "FALSE" ]; then
 fi
 }
 
+
+diskname_to_printable() {
+COUNT=0
+for disk in $(echo $@ | tr "," " "); do
+	R=$(basename $disk | sed 's|/|_|g')
+	COUNT=$(($COUNT + 1))
+	if [ $COUNT -eq 1 ]; then
+		P="$R"
+	else
+		P="$P,$R"
+	fi
+done
+echo $P
+}
+
 gen_template() {
 cat >$TEMPLATE << EOF
 [global]
@@ -115,14 +130,16 @@ EOF
 
 gen_seq_suite() {
 TYPE=$1
+disk=$2
+PRINTABLE_DISK=$(diskname_to_printable $disk)
 cat >> $OUTFILE << EOF
-[$TYPE-$disk-$BLK_SIZE-seq]
+[$TYPE-$PRINTABLE_DISK-$BLK_SIZE-seq]
 stonewall
 bs=$BLK_SIZE
-filename=/dev/$disk
+filename=$disk
 rw=$TYPE
-write_bw_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$disk-$TYPE-seq.results
-write_iops_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$disk-$TYPE-seq.results
+write_bw_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$PRINTABLE_DISK-$TYPE-seq.results
+write_iops_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$PRINTABLE_DISK-$TYPE-seq.results
 EOF
 ETA=$(($ETA + $RUNTIME))
 }
@@ -130,7 +147,7 @@ ETA=$(($ETA + $RUNTIME))
 gen_seq_fio() {
 for disk in $(echo $DISKS | tr "," " "); do
 	for mode in $(echo $MODES | tr "," " "); do
-		gen_seq_suite "$mode"
+		gen_seq_suite "$mode" "$disk"
 	done
 done
 }
@@ -141,8 +158,9 @@ TYPE=$1
 NEED_WALL=$2
 D=0
 for disk in $(echo $DISKS | tr "," " "); do
+    PRINTABLE_DISK=$(diskname_to_printable $disk)
     cat >> $OUTFILE << EOF
-[$TYPE-$disk-$BLK_SIZE-para]
+[$TYPE-$PRINTABLE_DISK-$BLK_SIZE-para]
 bs=$BLK_SIZE
 EOF
 
@@ -152,10 +170,10 @@ if [ "$D" = 0 ]; then
 fi
 
 cat >> $OUTFILE << EOF
-filename=/dev/$disk
+filename=$disk
 rw=$TYPE
-write_bw_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$disk-$TYPE-para.results
-write_iops_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$disk-$TYPE-para.results
+write_bw_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$PRINTABLE_DISK-$TYPE-para.results
+write_iops_log=${PREFIX_FILENAME}$SHORT_HOSTNAME-$BLK_SIZE-$PRINTABLE_DISK-$TYPE-para.results
 EOF
 done
 
@@ -228,6 +246,7 @@ while getopts "hacpsd:b:r:m:x:D:A:B:" opt; do
       ;;
     d)
  	DISKS=$OPTARG
+	PRINTABLE_DISKS=$(diskname_to_printable "$DISKS")
       ;;
     D)
 	IODEPTH=$OPTARG
@@ -254,14 +273,14 @@ fi
 SHORT_HOSTNAME=$(hostname -s)
 case $SEQ in
 	2)
-		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-all-$MODES-$DISKS.fio
+		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-all-$MODES-$PRINTABLE_DISKS.fio
 	;;
 
 	1)
-		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-sequential-$MODES-$DISKS.fio
+		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-sequential-$MODES-$PRINTABLE_DISKS.fio
 	;;
 	0)
-		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-parallel-$MODES-$DISKS.fio
+		OUTFILE=${PREFIX}$SHORT_HOSTNAME-$BLOCK_SIZE-parallel-$MODES-$PRINTABLE_DISKS.fio
 	;;
 esac
 
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
new file mode 100755
index 0000000..f1e6a98
--- /dev/null
+++ b/tools/plot/fio2gnuplot
@@ -0,0 +1,517 @@
+#!/usr/bin/python
+#
+#  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
+#  Author: Erwan Velu  <erwan@enovance.com>
+#
+#  The license below covers all files distributed with fio unless otherwise
+#  noted in the file itself.
+#
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License version 2 as
+#  published by the Free Software Foundation.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+import os
+import fnmatch
+import sys
+import getopt
+import re
+import math
+import shutil
+
+def find_file(path, pattern):
+	fio_data_file=[]
+	# For all the local files
+	for file in os.listdir(path):
+	    # If the file math the regexp
+	    if fnmatch.fnmatch(file, pattern):
+		# Let's consider this file
+		fio_data_file.append(file)
+
+	return fio_data_file
+
+def generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
+	if verbose: print "Generating rendering scripts"
+	filename=gnuplot_output_dir+'mygraph'
+	temporary_files.append(filename)
+	f=open(filename,'w')
+
+	# Plotting 3D or comparing graphs doesn't have a meaning unless if there is at least 2 traces
+	if len(fio_data_file) > 1:
+        	f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\'\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))
+
+		# Setting up the compare files that will be plot later
+		compare=open(gnuplot_output_dir + 'compare.gnuplot','w')
+		compare.write('''
+set title '%s'
+set terminal png size 1280,1024
+set ytics axis out auto
+set key top left reverse
+set xlabel "Time (Seconds)"
+set ylabel '%s'
+set yrange [0:]
+set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
+'''% (title,mode))
+		compare.close()
+		#Copying the common file for all kind of graph (raw/smooth/trend)
+		compare_raw_filename="compare-%s-2Draw" % (gnuplot_output_filename)
+		compare_smooth_filename="compare-%s-2Dsmooth" % (gnuplot_output_filename)
+		compare_trend_filename="compare-%s-2Dtrend" % (gnuplot_output_filename)
+
+		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_raw_filename+".gnuplot")
+		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_smooth_filename+".gnuplot")
+		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_trend_filename+".gnuplot")
+		temporary_files.append(gnuplot_output_dir+compare_raw_filename+".gnuplot")
+		temporary_files.append(gnuplot_output_dir+compare_smooth_filename+".gnuplot")
+		temporary_files.append(gnuplot_output_dir+compare_trend_filename+".gnuplot")
+
+		#Setting up a different output filename for each kind of graph
+		compare_raw=open(gnuplot_output_dir+compare_raw_filename + ".gnuplot",'a')
+		compare_raw.write("set output '%s.png'\n" % compare_raw_filename)
+		compare_smooth=open(gnuplot_output_dir+compare_smooth_filename+".gnuplot",'a')
+		compare_smooth.write("set output '%s.png'\n" % compare_smooth_filename)
+		compare_trend=open(gnuplot_output_dir+compare_trend_filename+".gnuplot",'a')
+		compare_trend.write("set output '%s.png'\n" % compare_trend_filename)
+
+		# Let's plot the average value for all the traces
+		global_disk_perf = sum(disk_perf, [])
+		global_avg  = average(global_disk_perf)
+		compare_raw.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
+		compare_smooth.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
+		compare_trend.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
+
+        pos=0
+        # Let's create a temporary file for each selected fio file
+        for file in fio_data_file:
+                tmp_filename = "gnuplot_temp_file.%d" % pos
+
+		# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
+		if len(fio_data_file) > 1:
+			# Adding the plot instruction for each kind of comparing graphs
+			compare_raw.write(",\\\n'%s' using 2:3 with linespoints title '%s'" % (tmp_filename,fio_data_file[pos]))
+			compare_smooth.write(",\\\n'%s' using 2:3 smooth csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
+			compare_trend.write(",\\\n'%s' using 2:3 smooth bezier title '%s'" % (tmp_filename,fio_data_file[pos]))
+
+		png_file=file.replace('.log','')
+                raw_filename = "%s-2Draw" % (png_file)
+                smooth_filename = "%s-2Dsmooth" % (png_file)
+                trend_filename = "%s-2Dtrend" % (png_file)
+                avg  = average(disk_perf[pos])
+                f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % (gpm_dir,title,tmp_filename,fio_data_file[pos],raw_filename,mode,smooth_filename,trend_filename,avg))
+                pos = pos +1
+
+	# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
+	if len(fio_data_file) > 1:
+		os.remove(gnuplot_output_dir+"compare.gnuplot")
+		compare_raw.close()
+		compare_smooth.close()
+		compare_trend.close()
+	f.close()
+
+def generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average,gnuplot_output_dir,gpm_dir):
+	filename=gnuplot_output_dir+'mymath';
+	temporary_files.append(filename)
+	f=open(filename,'a')
+        f.write("call \'%s/math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' %s\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
+	f.close()
+
+def compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir):
+	if verbose: print "Processing data file 2/2"
+	temp_files=[]
+	pos=0
+
+	# Let's create a temporary file for each selected fio file
+	for file in fio_data_file:
+		tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir, pos)
+		temp_files.append(open(tmp_filename,'r'))
+		pos = pos +1
+
+	f = open(gnuplot_output_dir+gnuplot_output_filename, "w")
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename)
+	index=0
+	# Let's add some information
+	for tempfile in temp_files:
+		    f.write("# Disk%d was coming from %s\n" % (index,fio_data_file[index]))
+		    f.write(tempfile.read())
+		    f.write("\n")
+		    tempfile.close()
+		    index = index + 1
+	f.close()
+
+def average(s): return sum(s) * 1.0 / len(s)
+
+def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_time):
+	end_time=max_time
+	if end_time == -1:
+		end_time="infinite"
+	if verbose: print "Processing data file 1/2 with %s<time<%s" % (min_time,end_time)
+	files=[]
+	temp_outfile=[]
+	blk_size=0
+	for file in fio_data_file:
+		files.append(open(file))
+		pos = len(files) - 1
+		tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir,pos)
+		temporary_files.append(tmp_filename)
+		gnuplot_file=open(tmp_filename,'w')
+		temp_outfile.append(gnuplot_file)
+		gnuplot_file.write("#Temporary file based on file %s\n" % file)
+		disk_perf.append([])
+
+	shall_break = False
+	while True:
+		current_line=[]
+		nb_empty_files=0
+		nb_files=len(files)
+		for myfile in files:
+			s=myfile.readline().replace(',',' ').split()
+			if not s:
+				nb_empty_files+=1
+				s="-1, 0, 0, 0".replace(',',' ').split()
+
+			if (nb_empty_files == nb_files):
+				shall_break=True
+				break;
+
+			current_line.append(s);
+
+		if shall_break == True:
+			break
+
+		last_time = -1
+		index=-1
+		perfs=[]
+		for line in enumerate(current_line):
+			# Index will be used to remember what file was featuring what value
+			index=index+1
+
+			time, perf, x, block_size = line[1]
+			if (blk_size == 0):
+				try:
+					blk_size=int(block_size)
+				except:
+					print "Error while reading the following line :"
+					print line
+					sys.exit(1);
+
+			# We ignore the first 500msec as it doesn't seems to be part of the real benchmark
+			# Time < 500 usually reports BW=0 breaking the min computing
+			if (min_time == 0):
+				min_time==0.5
+
+			# Then we estimate if the data we got is part of the time range we want to plot
+			if ((float(time)>(float(min_time)*1000)) and ((int(time) < (int(max_time)*1000)) or max_time==-1)):
+					disk_perf[index].append(int(perf))
+					perfs.append("%d %s %s"% (index, time, perf))
+
+		# If we reach this point, it means that all the traces are coherent
+		for p in enumerate(perfs):
+			index, perf_time,perf = p[1].split()
+			temp_outfile[int(index)].write("%s %.2f %s\n" % (index, float(float(perf_time)/1000), perf))
+
+
+	for file in files:
+		file.close()
+	for file in temp_outfile:
+                file.close()
+	return blk_size
+
+def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
+	if verbose: print "Computing Maths"
+	global_min=[]
+	global_max=[]
+	average_file=open(gnuplot_output_dir+gnuplot_output_filename+'.average', 'w')
+	min_file=open(gnuplot_output_dir+gnuplot_output_filename+'.min', 'w')
+	max_file=open(gnuplot_output_dir+gnuplot_output_filename+'.max', 'w')
+	stddev_file=open(gnuplot_output_dir+gnuplot_output_filename+'.stddev', 'w')
+	global_file=open(gnuplot_output_dir+gnuplot_output_filename+'.global','w')
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename+'.average')
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename+'.min')
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename+'.max')
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename+'.stddev')
+	temporary_files.append(gnuplot_output_dir+gnuplot_output_filename+'.global')
+
+	min_file.write('DiskName %s\n' % mode)
+	max_file.write('DiskName %s\n'% mode)
+	average_file.write('DiskName %s\n'% mode)
+	stddev_file.write('DiskName %s\n'% mode )
+	for disk in xrange(len(fio_data_file)):
+#		print disk_perf[disk]
+	    	min_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+	    	max_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+	    	average_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+	    	stddev_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
+		avg  = average(disk_perf[disk])
+		variance = map(lambda x: (x - avg)**2, disk_perf[disk])
+		standard_deviation = math.sqrt(average(variance))
+#		print "Disk%d [ min=%.2f max=%.2f avg=%.2f stddev=%.2f \n" % (disk,min(disk_perf[disk]),max(disk_perf[disk]),avg, standard_deviation)
+		average_file.write('%d %d\n' % (disk, avg))
+		stddev_file.write('%d %d\n' % (disk, standard_deviation))
+		local_min=min(disk_perf[disk])
+		local_max=max(disk_perf[disk])
+		min_file.write('%d %d\n' % (disk, local_min))
+		max_file.write('%d %d\n' % (disk, local_max))
+		global_min.append(int(local_min))
+		global_max.append(int(local_max))
+
+	global_disk_perf = sum(disk_perf, [])
+	avg  = average(global_disk_perf)
+	variance = map(lambda x: (x - avg)**2, global_disk_perf)
+	standard_deviation = math.sqrt(average(variance))
+
+	global_file.write('min=%.2f\n' % min(global_disk_perf))
+	global_file.write('max=%.2f\n' % max(global_disk_perf))
+	global_file.write('avg=%.2f\n' % avg)
+	global_file.write('stddev=%.2f\n' % standard_deviation)
+	global_file.write('values_count=%d\n' % len(global_disk_perf))
+	global_file.write('disks_count=%d\n' % len(fio_data_file))
+	#print "Global [ min=%.2f max=%.2f avg=%.2f stddev=%.2f \n" % (min(global_disk_perf),max(global_disk_perf),avg, standard_deviation)
+
+	average_file.close()
+	min_file.close()
+	max_file.close()
+	stddev_file.close()
+	global_file.close()
+	try:
+		os.remove(gnuplot_output_dir+'mymath')
+	except:
+		True
+
+	generate_gnuplot_math_script("Average values of "+title,gnuplot_output_filename+'.average',mode,int(avg),gnuplot_output_dir,gpm_dir)
+	generate_gnuplot_math_script("Min values of "+title,gnuplot_output_filename+'.min',mode,average(global_min),gnuplot_output_dir,gpm_dir)
+	generate_gnuplot_math_script("Max values of "+title,gnuplot_output_filename+'.max',mode,average(global_max),gnuplot_output_dir,gpm_dir)
+	generate_gnuplot_math_script("Standard Deviation of "+title,gnuplot_output_filename+'.stddev',mode,int(standard_deviation),gnuplot_output_dir,gpm_dir)
+
+def parse_global_files(fio_data_file, global_search):
+	max_result=0
+	max_file=''
+	for file in fio_data_file:
+		f=open(file)
+		disk_count=0
+		search_value=-1
+
+		# Let's read the complete file
+		while True:
+			try:
+				# We do split the name from the value
+				name,value=f.readline().split("=")
+			except:
+				f.close()
+				break
+			# If we ended the file
+			if not name:
+				# Let's process what we have
+				f.close()
+				break
+			else:
+				# disks_count is not global_search item
+				# As we need it for some computation, let's save it
+				if name=="disks_count":
+					disks_count=int(value)
+
+				# Let's catch the searched item
+				if global_search in name:
+					search_value=float(value)
+
+		# Let's process the avg value by estimated the global bandwidth per file
+		# We keep the biggest in memory for reporting
+		if global_search == "avg":
+			if (disks_count > 0) and (search_value != -1):
+				result=disks_count*search_value
+				if (result > max_result):
+					max_result=result
+					max_file=file
+	# Let's print the avg output
+	if global_search == "avg":
+		print "Biggest aggregated value of %s was %2.f in file %s\n" % (global_search, max_result, max_file)
+	else:
+		print "Global search %s is not yet implemented\n" % global_search
+
+def render_gnuplot(fio_data_file, gnuplot_output_dir):
+	print "Running gnuplot Rendering"
+	try:
+		# Let's render all the compared files if some
+		if len(fio_data_file) > 1:
+			if verbose: print " |-> Rendering comparing traces"
+			os.system("cd %s; for i in *.gnuplot; do gnuplot $i; done" % gnuplot_output_dir)
+		if verbose: print " |-> Rendering math traces"
+		os.system("cd %s; gnuplot mymath" % gnuplot_output_dir)
+		if verbose: print " |-> Rendering 2D & 3D traces"
+		os.system("cd %s; gnuplot mygraph" % gnuplot_output_dir)
+
+		name_of_directory="the current"
+		if gnuplot_output_dir != "./":
+			name_of_directory=gnuplot_output_dir
+		print "\nRendering traces are available in %s directory" % name_of_directory
+		global keep_temp_files
+		keep_temp_files=False
+	except:
+		print "Could not run gnuplot on mymath or mygraph !\n"
+		sys.exit(1);
+
+def print_help():
+    print 'fio2gnuplot -ghbiodvk -t <title> -o <outputfile> -p <pattern> -G <type> -m <time> -M <time>'
+    print
+    print '-h --help                           : Print this help'
+    print '-p <pattern> or --pattern <pattern> : A pattern in regexp to select fio input files'
+    print '-b           or --bandwidth         : A predefined pattern for selecting *_bw.log files'
+    print '-i           or --iops              : A predefined pattern for selecting *_iops.log files'
+    print '-g           or --gnuplot           : Render gnuplot traces before exiting'
+    print '-o           or --outputfile <file> : The basename for gnuplot traces'
+    print '                                       - Basename is set with the pattern if defined'
+    print '-d           or --outputdir <dir>   : The directory where gnuplot shall render files'
+    print '-t           or --title <title>     : The title of the gnuplot traces'
+    print '                                       - Title is set with the block size detected in fio traces'
+    print '-G           or --Global <type>     : Search for <type> in .global files match by a pattern'
+    print '                                       - Available types are : min, max, avg, stddev'
+    print '                                       - The .global extension is added automatically to the pattern'
+    print '-m           or --min_time <time>   : Only consider data starting from <time> seconds (default is 0)'
+    print '-M           or --max_time <time>   : Only consider data ending before <time> seconds (default is -1 aka nolimit)'
+    print '-v           or --verbose           : Increasing verbosity'
+    print '-k           or --keep              : Keep all temporary files from gnuplot\'s output dir'
+
+def main(argv):
+    mode='unknown'
+    pattern=''
+    pattern_set_by_user=False
+    title='No title'
+    gnuplot_output_filename='result'
+    gnuplot_output_dir='./'
+    gpm_dir="/usr/share/fio/"
+    disk_perf=[]
+    run_gnuplot=False
+    parse_global=False
+    global_search=''
+    min_time=0
+    max_time=-1
+    global verbose
+    verbose=False
+    global temporary_files
+    temporary_files=[]
+    global keep_temp_files
+    keep_temp_files=True
+    force_keep_temp_files=False
+
+    if not os.path.isfile(gpm_dir+'math.gpm'):
+	    gpm_dir="/usr/local/share/fio/"
+    	    if not os.path.isfile(gpm_dir+'math.gpm'):
+		    print "Looks like fio didn't got installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n"
+		    sys.exit(3)
+
+    try:
+	    opts, args = getopt.getopt(argv[1:],"ghkbivo:d:t:p:G:m:M:",['bandwidth', 'iops', 'pattern', 'outputfile', 'outputdir', 'title', 'min_time', 'max_time', 'gnuplot', 'Global', 'help', 'verbose','keep'])
+    except getopt.GetoptError:
+	 print "Error: One of the option passed to the cmdline was not supported"
+	 print "Please fix your command line or read the help (-h option)"
+         sys.exit(2)
+
+    for opt, arg in opts:
+      if opt in ("-b", "--bandwidth"):
+         pattern='*_bw.log'
+      elif opt in ("-i", "--iops"):
+         pattern='*_iops.log'
+      elif opt in ("-v", "--verbose"):
+	 verbose=True
+      elif opt in ("-k", "--keep"):
+	 #User really wants to keep the temporary files
+	 force_keep_temp_files=True
+      elif opt in ("-p", "--pattern"):
+         pattern_set_by_user=True
+	 pattern=arg
+	 pattern=pattern.replace('\\','')
+      elif opt in ("-o", "--outputfile"):
+         gnuplot_output_filename=arg
+      elif opt in ("-d", "--outputdir"):
+         gnuplot_output_dir=arg
+	 if not gnuplot_output_dir.endswith('/'):
+		gnuplot_output_dir=gnuplot_output_dir+'/'
+	 if not os.path.exists(gnuplot_output_dir):
+		os.makedirs(gnuplot_output_dir)
+      elif opt in ("-t", "--title"):
+         title=arg
+      elif opt in ("-m", "--min_time"):
+	 min_time=arg
+      elif opt in ("-M", "--max_time"):
+	 max_time=arg
+      elif opt in ("-g", "--gnuplot"):
+	 run_gnuplot=True
+      elif opt in ("-G", "--Global"):
+	 parse_global=True
+	 global_search=arg
+      elif opt in ("-h", "--help"):
+	  print_help()
+	  sys.exit(1)
+
+    # Adding .global extension to the file
+    if parse_global==True:
+	    if not gnuplot_output_filename.endswith('.global'):
+	    	pattern = pattern+'.global'
+
+    fio_data_file=find_file('.',pattern)
+    if len(fio_data_file) == 0:
+	    print "No log file found with pattern %s!" % pattern
+	    sys.exit(1)
+    else:
+	    print "%d files Selected with pattern '%s'" % (len(fio_data_file), pattern)
+
+    fio_data_file=sorted(fio_data_file, key=str.lower)
+    for file in fio_data_file:
+	print ' |-> %s' % file
+	if "_bw.log" in file :
+		mode="Bandwidth (KB/sec)"
+	if "_iops.log" in file :
+		mode="IO per Seconds (IO/sec)"
+    if (title == 'No title') and (mode != 'unknown'):
+	    if "Bandwidth" in mode:
+		    title='Bandwidth benchmark with %d fio results' % len(fio_data_file)
+	    if "IO" in mode:
+		    title='IO benchmark with %d fio results' % len(fio_data_file)
+
+    print
+    #We need to adjust the output filename regarding the pattern required by the user
+    if (pattern_set_by_user == True):
+	    gnuplot_output_filename=pattern
+	    # As we do have some regexp in the pattern, let's make this simpliest
+	    # We do remove the simpliest parts of the expression to get a clear file name
+	    gnuplot_output_filename=gnuplot_output_filename.replace('-*-','-')
+	    gnuplot_output_filename=gnuplot_output_filename.replace('*','-')
+	    gnuplot_output_filename=gnuplot_output_filename.replace('--','-')
+	    gnuplot_output_filename=gnuplot_output_filename.replace('.log','')
+	    # Insure that we don't have any starting or trailing dash to the filename
+	    gnuplot_output_filename = gnuplot_output_filename[:-1] if gnuplot_output_filename.endswith('-') else gnuplot_output_filename
+	    gnuplot_output_filename = gnuplot_output_filename[1:] if gnuplot_output_filename.startswith('-') else gnuplot_output_filename
+
+    if parse_global==True:
+	parse_global_files(fio_data_file, global_search)
+    else:
+    	blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
+    	title="%s @ Blocksize = %dK" % (title,blk_size/1024)
+    	compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir)
+    	compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
+    	generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
+
+    	if (run_gnuplot==True):
+    		render_gnuplot(fio_data_file, gnuplot_output_dir)
+
+	# Shall we clean the temporary files ?
+	if keep_temp_files==False and force_keep_temp_files==False:
+	    	# Cleaning temporary files
+		if verbose: print "Cleaning temporary files"
+		for f in enumerate(temporary_files):
+		    	if verbose: print " -> %s"%f[1]
+			try:
+			    os.remove(f[1])
+			except:
+			    True
+
+#Main
+if __name__ == "__main__":
+    sys.exit(main(sys.argv))
diff --git a/tools/plot/fio2gnuplot.1 b/tools/plot/fio2gnuplot.1
new file mode 100644
index 0000000..1a33167
--- /dev/null
+++ b/tools/plot/fio2gnuplot.1
@@ -0,0 +1,161 @@
+.\" Text automatically generated by txt2man
+.TH fio2gnuplot  "07 ao��t 2013" "" ""
+.SH NAME
+\fBfio2gnuplot \fP- Render fio's output files with gnuplot
+.SH SYNOPSIS
+.nf
+.fam C
+\fBfio2gnuplot\fP [\fB-ghbiodvk\fP] [\fB-t\fP \fItitle\fP] [\fB-o\fP \fIoutputfile\fP]
+               [\fB-d\fP \fIoutput_dir\fP] [\fB-p\fP \fIpattern\fP]
+               [\fB-G\fP \fItype\fP] [\fB-m\fP \fImin_time\fP] [\fB-M\fP \fImax_time\fP]
+
+.fam T
+.fi
+.fam T
+.fi
+.SH DESCRIPTION
+\fBfio2gnuplot\fP analyze a set of fio's log files to turn them into a set of graphical traces using gnuplot tool.
+Several flavor of plotting are produced
+.TP
+.B
+Individual 2D Graph
+Each file is plotted in a separate image file with several option
+.RS
+.IP \(bu 3
+raw : Plot the exact reported performance. This plotting could be difficult to read
+.IP \(bu 3
+smooth :a smoother version of the raw print
+Using csplines option of gnuplot, the rendering is
+filtered to get an easier to read graph.
+.IP \(bu 3
+trend : an even smoother version of the raw print to get trends
+Bezier's curves makes much more filtered plots
+The resulting graph helps at understanding trends.
+.RE
+.TP
+.B
+Grouped 2D graph
+All files are plotted in a single image to ease the comparaison. The same rendering options as per the individual 2D graph are used :
+.RS
+.IP \(bu 3
+raw
+.IP \(bu 3
+smooth
+.IP \(bu 3
+trend
+.RE
+.TP
+.B
+Grouped 3D graph
+All files are plotted into a single 3D graph.
+The 3D plotting generates a 'surface' to estimate how close were
+the performance.
+A flat surface means a good coherency between traces.
+A rugged surface means a lack of coherency between traces
+.TP
+.B
+Mathemical Plotting
+.RS
+.TP
+.B
+Average graph
+A bar graph to show the average performance of each file.
+A green line is added to show the global average performance.
+This green line helps at understanding how far from the average is
+every individual file.
+.TP
+.B
+Min graph
+A green line is added to show the global average of minimal performance.
+This green line helps at understanding how far from the average is
+every individual file.
+.TP
+.B
+Max graph
+A bar graph to show the maximum performance of each file.
+A green line is added to show the global average of maximal performance.
+This green line helps at understanding how far from the average is
+every individual file.
+.TP
+.B
+Standard Deviation
+A bar graph to show the standard deviation of each file.
+A green line is added to show the global average of standard deviation.
+This green line helps at understanding how far from the average is
+every individual file.
+.SH OPTIONS
+.TP
+.B
+\fB-h\fP or \fB--help\fP
+The option \fB-h\fP displays help
+.TP
+.B
+\fB-p\fP '\fIpattern\fP' or --\fIpattern\fP '\fIpattern\fP'
+A \fIpattern\fP in regexp to select fio input files.
+Don't forget the simple quotes to avoid shell's interactions
+.TP
+.B
+\fB-b\fP or \fB--bandwidth\fP
+A predefined \fIpattern\fP for selecting *_bw.log files
+.TP
+.B
+\fB-i\fP or \fB--iops\fP
+A predefined \fIpattern\fP for selecting *_iops.log files
+.TP
+.B
+\fB-g\fP or \fB--gnuplot\fP
+Render gnuplot traces before exiting
+.TP
+.B
+\fB-o\fP file or --\fIoutputfile\fP file
+The basename for gnuplot traces (set with the \fIpattern\fP if defined)
+.TP
+.B
+\fB-d\fP dir or \fB--outputdir\fP dir
+The directory where gnuplot shall render files.
+.TP
+.B
+\fB-t\fP \fItitle\fP or --\fItitle\fP \fItitle\fP
+The \fItitle\fP of the gnuplot traces.
+Title is set with the block size detected in fio trace
+.TP
+.B
+\fB-G\fP \fItype\fP or \fB--Global\fP \fItype\fP
+Search for '\fItype\fP' in .global files match by a \fIpattern\fP.
+Available types are : min, max, avg, stddev.
+The .global extension is added automatically to the \fIpattern\fP
+.TP
+.B
+\fB-m\fP time or --\fImin_time\fP time
+Only consider data starting from 'time' seconds. Default is 0
+.TP
+.B
+\fB-M\fP time or --\fImax_time\fP time
+Only consider data ending before 'time' seconds. Default is \fB-1\fP aka nolimit
+.TP
+.B
+\fB-v\fP or \fB--verbose\fP
+Increasing verbosity
+.TP
+.B
+\fB-k\fP or \fB--keep\fP
+Keep all temporary files from gnuplot's output dir
+.SH EXAMPLE
+.TP
+.B
+To plot all the traces named like 'host*_read_4k_iops.log'
+$ \fBfio2gnuplot\fP \fB-p\fP 'host*_read_4k_iops.log' \fB-g\fP
+.TP
+.B
+To plot all IO oriented log files from the current directory
+$ \fBfio2gnuplot\fP \fB-g\fP \fB-i\fP
+.TP
+.B
+To plot all Bandwidth oriented log files from the current directory
+$ \fBfio2gnuplot\fP \fB-g\fP \fB-b\fP
+.TP
+.B
+To plot all Bandwidth oriented log files in a directory name 'outdir'
+$ \fBfio2gnuplot\fP \fB-g\fP \fB-b\fP \fB-d\fP outdir
+.SH AUTHOR
+Erwan Velu <erwan@enovance.com>
diff --git a/tools/plot/fio2gnuplot.manpage b/tools/plot/fio2gnuplot.manpage
new file mode 100644
index 0000000..6a12cf8
--- /dev/null
+++ b/tools/plot/fio2gnuplot.manpage
@@ -0,0 +1,117 @@
+NAME
+fio2gnuplot - Render fio's output files with gnuplot
+SYNOPSIS
+fio2gnuplot [-ghbiodvk] [-t title] [-o outputfile]
+		 [-d output_dir] [-p pattern]
+		 [-G type] [-m min_time] [-M max_time]
+
+DESCRIPTION
+ fio2gnuplot analyze a set of fio's log files to turn them into a set of graphical traces using gnuplot tool.
+  Several flavor of plotting are produced
+
+ Individual 2D Graph 	
+	Each file is plotted in a separate image file with several option
+	- raw : Plot the exact reported performance. This plotting could be difficult to read
+	- smooth :a smoother version of the raw print
+                  Using csplines option of gnuplot, the rendering is
+                  filtered to get an easier to read graph.
+	- trend : an even smoother version of the raw print to get trends
+                    	Bezier's curves makes much more filtered plots
+                    	The resulting graph helps at understanding trends.
+
+ Grouped 2D graph   
+	All files are plotted in a single image to ease the comparaison. The same rendering options as per the individual 2D graph are used :
+         - raw
+         - smooth
+         - trend
+
+ Grouped 3D graph  
+     All files are plotted into a single 3D graph.
+     The 3D plotting generates a 'surface' to estimate how close were
+     the performance.
+     A flat surface means a good coherency between traces.
+     A rugged surface means a lack of coherency between traces
+
+ Mathemical Plotting  
+  Average graph  
+     A bar graph to show the average performance of each file.
+     A green line is added to show the global average performance.
+     This green line helps at understanding how far from the average is
+     every individual file.
+
+  Min graph  
+     A green line is added to show the global average of minimal performance.
+     This green line helps at understanding how far from the average is
+     every individual file.
+
+  Max graph  
+     A bar graph to show the maximum performance of each file.
+     A green line is added to show the global average of maximal performance.
+     This green line helps at understanding how far from the average is
+     every individual file.
+
+  Standard Deviation  
+     A bar graph to show the standard deviation of each file.
+     A green line is added to show the global average of standard deviation.
+     This green line helps at understanding how far from the average is
+     every individual file.
+
+OPTIONS
+ -h or --help  
+	The option -h displays help
+
+ -p 'pattern' or --pattern 'pattern'  
+	A pattern in regexp to select fio input files.
+	Don't forget the simple quotes to avoid shell's interactions
+
+ -b or --bandwidth  
+	A predefined pattern for selecting *_bw.log files
+
+ -i or --iops  
+	A predefined pattern for selecting *_iops.log files
+
+ -g or --gnuplot  
+	Render gnuplot traces before exiting
+
+ -o file or --outputfile file  
+	The basename for gnuplot traces (set with the pattern if defined)
+
+ -d dir or --outputdir dir  
+	The directory where gnuplot shall render files.
+
+ -t title or --title title  
+	The title of the gnuplot traces.
+	Title is set with the block size detected in fio trace
+
+ -G type or --Global type  
+	Search for 'type' in .global files match by a pattern.
+ 	Available types are : min, max, avg, stddev.
+	The .global extension is added automatically to the pattern
+
+ -m time or --min_time time  
+	Only consider data starting from 'time' seconds. Default is 0
+
+ -M time or --max_time time  
+	 Only consider data ending before 'time' seconds. Default is -1 aka nolimit
+
+ -v or --verbose  
+	Increasing verbosity
+
+ -k or --keep  
+	Keep all temporary files from gnuplot's output dir
+
+EXAMPLE
+To plot all the traces named like 'host*_read_4k_iops.log'  
+	$ fio2gnuplot -p 'host*_read_4k_iops.log' -g
+
+To plot all IO oriented log files from the current directory  
+	$ fio2gnuplot -g -i
+
+To plot all Bandwidth oriented log files from the current directory  
+	$ fio2gnuplot -g -b
+
+To plot all Bandwidth oriented log files in a directory name 'outdir'  
+	$ fio2gnuplot -g -b -d outdir
+
+AUTHOR
+  Erwan Velu <erwan@enovance.com>
diff --git a/tools/plot/fio2gnuplot.py b/tools/plot/fio2gnuplot.py
deleted file mode 100755
index 64b41c1..0000000
--- a/tools/plot/fio2gnuplot.py
+++ /dev/null
@@ -1,482 +0,0 @@
-#!/usr/bin/python
-#
-#  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
-#  Author: Erwan Velu  <erwan@enovance.com>
-#
-#  The license below covers all files distributed with fio unless otherwise
-#  noted in the file itself.
-#
-#  This program is free software; you can redistribute it and/or modify
-#  it under the terms of the GNU General Public License version 2 as
-#  published by the Free Software Foundation.
-#
-#  This program is distributed in the hope that it will be useful,
-#  but WITHOUT ANY WARRANTY; without even the implied warranty of
-#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-#  GNU General Public License for more details.
-#
-#  You should have received a copy of the GNU General Public License
-#  along with this program; if not, write to the Free Software
-#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
-import os
-import fnmatch
-import sys
-import getopt
-import re
-import math
-import shutil
-
-def find_file(path, pattern):
-	fio_data_file=[]
-	# For all the local files
-	for file in os.listdir(path):
-	    # If the file math the regexp
-	    if fnmatch.fnmatch(file, pattern):
-		# Let's consider this file
-		fio_data_file.append(file)
-
-	return fio_data_file
-
-def generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
-	print "Generating rendering scripts"
-	filename=gnuplot_output_dir+'mygraph'
-	f=open(filename,'w')
-
-	# Plotting 3D or comparing graphs doesn't have a meaning unless if there is at least 2 traces
-	if len(fio_data_file) > 1:
-        	f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\'\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))
-
-		# Setting up the compare files that will be plot later
-		compare=open(gnuplot_output_dir + 'compare.gnuplot','w')
-		compare.write('''
-set title '%s'
-set terminal png size 1280,1024
-set ytics axis out auto
-set key top left reverse
-set xlabel "Time (Seconds)"
-set ylabel '%s'
-set yrange [0:]
-set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
-'''% (title,mode))
-		compare.close()
-		#Copying the common file for all kind of graph (raw/smooth/trend)
-		compare_raw_filename="compare-%s-2Draw" % (gnuplot_output_filename)
-		compare_smooth_filename="compare-%s-2Dsmooth" % (gnuplot_output_filename)
-		compare_trend_filename="compare-%s-2Dtrend" % (gnuplot_output_filename)
-		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_raw_filename+".gnuplot")
-		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_smooth_filename+".gnuplot")
-		shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_trend_filename+".gnuplot")
-
-		#Setting up a different output filename for each kind of graph
-		compare_raw=open(gnuplot_output_dir+compare_raw_filename + ".gnuplot",'a')
-		compare_raw.write("set output '%s.png'\n" % compare_raw_filename)
-		compare_smooth=open(gnuplot_output_dir+compare_smooth_filename+".gnuplot",'a')
-		compare_smooth.write("set output '%s.png'\n" % compare_smooth_filename)
-		compare_trend=open(gnuplot_output_dir+compare_trend_filename+".gnuplot",'a')
-		compare_trend.write("set output '%s.png'\n" % compare_trend_filename)
-
-		# Let's plot the average value for all the traces
-		global_disk_perf = sum(disk_perf, [])
-		global_avg  = average(global_disk_perf)
-		compare_raw.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
-		compare_smooth.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
-		compare_trend.write("plot %s w l ls 1 ti 'Global average value (%.2f)'" % (global_avg,global_avg));
-
-        pos=0
-        # Let's create a temporary file for each selected fio file
-        for file in fio_data_file:
-                tmp_filename = "gnuplot_temp_file.%d" % pos
-
-		# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
-		if len(fio_data_file) > 1:
-			# Adding the plot instruction for each kind of comparing graphs
-			compare_raw.write(",\\\n'%s' using 2:3 with linespoints title '%s'" % (tmp_filename,fio_data_file[pos]))
-			compare_smooth.write(",\\\n'%s' using 2:3 smooth csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
-			compare_trend.write(",\\\n'%s' using 2:3 smooth bezier title '%s'" % (tmp_filename,fio_data_file[pos]))
-
-		png_file=file.replace('.log','')
-                raw_filename = "%s-2Draw" % (png_file)
-                smooth_filename = "%s-2Dsmooth" % (png_file)
-                trend_filename = "%s-2Dtrend" % (png_file)
-                avg  = average(disk_perf[pos])
-                f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % (gpm_dir,title,tmp_filename,fio_data_file[pos],raw_filename,mode,smooth_filename,trend_filename,avg))
-                pos = pos +1
-
-	# Plotting comparing graphs doesn't have a meaning unless if there is at least 2 traces
-	if len(fio_data_file) > 1:
-		os.remove(gnuplot_output_dir+"compare.gnuplot")
-		compare_raw.close()
-		compare_smooth.close()
-		compare_trend.close()
-	f.close()
-
-def generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average,gnuplot_output_dir,gpm_dir):
-	filename=gnuplot_output_dir+'mymath';
-	f=open(filename,'a')
-        f.write("call \'%s/math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' %s\n" % (gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
-	f.close()
-
-def compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir):
-	print "Processing data file 2/2"
-	temp_files=[]
-	pos=0
-
-	# Let's create a temporary file for each selected fio file
-	for file in fio_data_file:
-		tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir, pos)
-		temp_files.append(open(tmp_filename,'r'))
-		pos = pos +1
-
-	f = open(gnuplot_output_dir+gnuplot_output_filename, "w")
-	index=0
-	# Let's add some information
-	for tempfile in temp_files:
-		    f.write("# Disk%d was coming from %s\n" % (index,fio_data_file[index]))
-		    f.write(tempfile.read())
-		    f.write("\n")
-		    tempfile.close()
-		    index = index + 1
-	f.close()
-
-def average(s): return sum(s) * 1.0 / len(s)
-
-def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_time):
-	end_time=max_time
-	if end_time == -1:
-		end_time="infinite"
-	print "Processing data file 1/2 with %s<time<%s" % (min_time,end_time)
-	files=[]
-	temp_outfile=[]
-	blk_size=0
-	for file in fio_data_file:
-		files.append(open(file))
-		pos = len(files) - 1
-		tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir,pos)
-		gnuplot_file=open(tmp_filename,'w')
-		temp_outfile.append(gnuplot_file)
-		gnuplot_file.write("#Temporary file based on file %s\n" % file)
-		disk_perf.append([])
-
-	shall_break = False
-	while True:
-		current_line=[]
-		nb_empty_files=0
-		nb_files=len(files)
-		for myfile in files:
-			s=myfile.readline().replace(',',' ').split()
-			if not s:
-				nb_empty_files+=1
-				s="-1, 0, 0, 0".replace(',',' ').split()
-
-			if (nb_empty_files == nb_files):
-				shall_break=True
-				break;
-
-			current_line.append(s);
-
-		if shall_break == True:
-			break
-
-		last_time = -1
-		index=-1
-		perfs=[]
-		for line in enumerate(current_line):
-			# Index will be used to remember what file was featuring what value
-			index=index+1
-
-			time, perf, x, block_size = line[1]
-			if (blk_size == 0):
-				try:
-					blk_size=int(block_size)
-				except:
-					print "Error while reading the following line :"
-					print line
-					sys.exit(1);
-
-			# We ignore the first 500msec as it doesn't seems to be part of the real benchmark
-			# Time < 500 usually reports BW=0 breaking the min computing
-			if (min_time == 0):
-				min_time==0.5
-
-			# Then we estimate if the data we got is part of the time range we want to plot
-			if ((float(time)>(float(min_time)*1000)) and ((int(time) < (int(max_time)*1000)) or max_time==-1)):
-					disk_perf[index].append(int(perf))
-					perfs.append("%d %s %s"% (index, time, perf))
-
-		# If we reach this point, it means that all the traces are coherent
-		for p in enumerate(perfs):
-			index, perf_time,perf = p[1].split()
-			temp_outfile[int(index)].write("%s %.2f %s\n" % (index, float(float(perf_time)/1000), perf))
-
-
-	for file in files:
-		file.close()
-	for file in temp_outfile:
-                file.close()
-	return blk_size
-
-def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
-	print "Computing Maths"
-	global_min=[]
-	global_max=[]
-	average_file=open(gnuplot_output_dir+gnuplot_output_filename+'.average', 'w')
-	min_file=open(gnuplot_output_dir+gnuplot_output_filename+'.min', 'w')
-	max_file=open(gnuplot_output_dir+gnuplot_output_filename+'.max', 'w')
-	stddev_file=open(gnuplot_output_dir+gnuplot_output_filename+'.stddev', 'w')
-	global_file=open(gnuplot_output_dir+gnuplot_output_filename+'.global','w')
-
-	min_file.write('DiskName %s\n' % mode)
-	max_file.write('DiskName %s\n'% mode)
-	average_file.write('DiskName %s\n'% mode)
-	stddev_file.write('DiskName %s\n'% mode )
-	for disk in xrange(len(fio_data_file)):
-#		print disk_perf[disk]
-	    	min_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	max_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	average_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-	    	stddev_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
-		avg  = average(disk_perf[disk])
-		variance = map(lambda x: (x - avg)**2, disk_perf[disk])
-		standard_deviation = math.sqrt(average(variance))
-#		print "Disk%d [ min=%.2f max=%.2f avg=%.2f stddev=%.2f \n" % (disk,min(disk_perf[disk]),max(disk_perf[disk]),avg, standard_deviation)
-		average_file.write('%d %d\n' % (disk, avg))
-		stddev_file.write('%d %d\n' % (disk, standard_deviation))
-		local_min=min(disk_perf[disk])
-		local_max=max(disk_perf[disk])
-		min_file.write('%d %d\n' % (disk, local_min))
-		max_file.write('%d %d\n' % (disk, local_max))
-		global_min.append(int(local_min))
-		global_max.append(int(local_max))
-
-	global_disk_perf = sum(disk_perf, [])
-	avg  = average(global_disk_perf)
-	variance = map(lambda x: (x - avg)**2, global_disk_perf)
-	standard_deviation = math.sqrt(average(variance))
-
-	global_file.write('min=%.2f\n' % min(global_disk_perf))
-	global_file.write('max=%.2f\n' % max(global_disk_perf))
-	global_file.write('avg=%.2f\n' % avg)
-	global_file.write('stddev=%.2f\n' % standard_deviation)
-	global_file.write('values_count=%d\n' % len(global_disk_perf))
-	global_file.write('disks_count=%d\n' % len(fio_data_file))
-	#print "Global [ min=%.2f max=%.2f avg=%.2f stddev=%.2f \n" % (min(global_disk_perf),max(global_disk_perf),avg, standard_deviation)
-
-	average_file.close()
-	min_file.close()
-	max_file.close()
-	stddev_file.close()
-	global_file.close()
-	try:
-		os.remove(gnuplot_output_dir+'mymath')
-	except:
-		True
-
-	generate_gnuplot_math_script("Average values of "+title,gnuplot_output_filename+'.average',mode,int(avg),gnuplot_output_dir,gpm_dir)
-	generate_gnuplot_math_script("Min values of "+title,gnuplot_output_filename+'.min',mode,average(global_min),gnuplot_output_dir,gpm_dir)
-	generate_gnuplot_math_script("Max values of "+title,gnuplot_output_filename+'.max',mode,average(global_max),gnuplot_output_dir,gpm_dir)
-	generate_gnuplot_math_script("Standard Deviation of "+title,gnuplot_output_filename+'.stddev',mode,int(standard_deviation),gnuplot_output_dir,gpm_dir)
-
-def parse_global_files(fio_data_file, global_search):
-	max_result=0
-	max_file=''
-	for file in fio_data_file:
-		f=open(file)
-		disk_count=0
-		search_value=-1
-
-		# Let's read the complete file
-		while True:
-			try:
-				# We do split the name from the value
-				name,value=f.readline().split("=")
-			except:
-				f.close()
-				break
-			# If we ended the file
-			if not name:
-				# Let's process what we have
-				f.close()
-				break
-			else:
-				# disks_count is not global_search item
-				# As we need it for some computation, let's save it
-				if name=="disks_count":
-					disks_count=int(value)
-
-				# Let's catch the searched item
-				if global_search in name:
-					search_value=float(value)
-
-		# Let's process the avg value by estimated the global bandwidth per file
-		# We keep the biggest in memory for reporting
-		if global_search == "avg":
-			if (disks_count > 0) and (search_value != -1):
-				result=disks_count*search_value
-				if (result > max_result):
-					max_result=result
-					max_file=file
-	# Let's print the avg output
-	if global_search == "avg":
-		print "Biggest aggregated value of %s was %2.f in file %s\n" % (global_search, max_result, max_file)
-	else:
-		print "Global search %s is not yet implemented\n" % global_search
-
-def render_gnuplot(fio_data_file, gnuplot_output_dir):
-	print "Running gnuplot Rendering"
-	try:
-		# Let's render all the compared files if some
-		if len(fio_data_file) > 1:
-			print " |-> Rendering comparing traces"
-			os.system("cd %s; for i in *.gnuplot; do gnuplot $i; done" % gnuplot_output_dir)
-		print " |-> Rendering math traces"
-		os.system("cd %s; gnuplot mymath" % gnuplot_output_dir)
-		print " |-> Rendering 2D & 3D traces"
-		os.system("cd %s; gnuplot mygraph" % gnuplot_output_dir)
-
-		name_of_directory="the current"
-		if gnuplot_output_dir != "./":
-			name_of_directory=gnuplot_output_dir
-		print "\nRendering traces are available in %s directory" % name_of_directory
-	except:
-		print "Could not run gnuplot on mymath or mygraph !\n"
-		sys.exit(1);
-
-def print_help():
-    print 'fio2gnuplot.py -ghbiod -t <title> -o <outputfile> -p <pattern> -G <type> -m <time> -M <time>'
-    print
-    print '-h --help                           : Print this help'
-    print '-p <pattern> or --pattern <pattern> : A pattern in regexp to select fio input files'
-    print '-b           or --bandwidth         : A predefined pattern for selecting *_bw.log files'
-    print '-i           or --iops              : A predefined pattern for selecting *_iops.log files'
-    print '-g           or --gnuplot           : Render gnuplot traces before exiting'
-    print '-o           or --outputfile <file> : The basename for gnuplot traces'
-    print '                                       - Basename is set with the pattern if defined'
-    print '-d           or --outputdir <dir>   : The directory where gnuplot shall render files'
-    print '-t           or --title <title>     : The title of the gnuplot traces'
-    print '                                       - Title is set with the block size detected in fio traces'
-    print '-G		or --Global <type>     : Search for <type> in .global files match by a pattern'
-    print '                                       - Available types are : min, max, avg, stddev'
-    print '                                       - The .global extension is added automatically to the pattern'
-    print '-m           or --min_time <time>   : Only consider data starting from <time> seconds (default is 0)'
-    print '-M           or --max_time <time>   : Only consider data ending before <time> seconds (default is -1 aka nolimit)'
-
-def main(argv):
-    mode='unknown'
-    pattern=''
-    pattern_set_by_user=False
-    title='No title'
-    gnuplot_output_filename='result'
-    gnuplot_output_dir='./'
-    gpm_dir="/usr/share/fio/"
-    disk_perf=[]
-    run_gnuplot=False
-    parse_global=False
-    global_search=''
-    min_time=0
-    max_time=-1
-
-    if not os.path.isfile(gpm_dir+'math.gpm'):
-	    gpm_dir="/usr/local/share/fio/"
-    	    if not os.path.isfile(gpm_dir+'math.gpm'):
-		    print "Looks like fio didn't got installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n"
-		    sys.exit(3)
-
-    try:
-	    opts, args = getopt.getopt(argv[1:],"ghbio:d:t:p:G:m:M:")
-    except getopt.GetoptError:
-	 print_help()
-         sys.exit(2)
-
-    for opt, arg in opts:
-      if opt in ("-b", "--bandwidth"):
-         pattern='*_bw.log'
-      elif opt in ("-i", "--iops"):
-         pattern='*_iops.log'
-      elif opt in ("-p", "--pattern"):
-         pattern_set_by_user=True
-	 pattern=arg
-	 pattern=pattern.replace('\\','')
-      elif opt in ("-o", "--outputfile"):
-         gnuplot_output_filename=arg
-      elif opt in ("-d", "--outputdir"):
-         gnuplot_output_dir=arg
-	 if not gnuplot_output_dir.endswith('/'):
-		gnuplot_output_dir=gnuplot_output_dir+'/'
-	 if not os.path.exists(gnuplot_output_dir):
-		os.makedirs(gnuplot_output_dir)
-      elif opt in ("-t", "--title"):
-         title=arg
-      elif opt in ("-m", "--min_time"):
-	 min_time=arg
-      elif opt in ("-M", "--max_time"):
-	 max_time=arg
-      elif opt in ("-g", "--gnuplot"):
-	 run_gnuplot=True
-      elif opt in ("-G", "--Global"):
-	 parse_global=True
-	 global_search=arg
-      elif opt in ("-h", "--help"):
-	  print_help()
-	  sys.exit(1)
-
-    # Adding .global extension to the file
-    if parse_global==True:
-	    if not gnuplot_output_filename.endswith('.global'):
-	    	pattern = pattern+'.global'
-
-    fio_data_file=find_file('.',pattern)
-    if len(fio_data_file) == 0:
-	    print "No log file found with pattern %s!" % pattern
-	    sys.exit(1)
-    else:
-	    print "%d files Selected with pattern '%s'" % (len(fio_data_file), pattern)
-
-    fio_data_file=sorted(fio_data_file, key=str.lower)
-    for file in fio_data_file:
-	print ' |-> %s' % file
-	if "_bw.log" in file :
-		mode="Bandwidth (KB/sec)"
-	if "_iops.log" in file :
-		mode="IO per Seconds (IO/sec)"
-    if (title == 'No title') and (mode != 'unknown'):
-	    if "Bandwidth" in mode:
-		    title='Bandwidth benchmark with %d fio results' % len(fio_data_file)
-	    if "IO" in mode:
-		    title='IO benchmark with %d fio results' % len(fio_data_file)
-
-    print
-    #We need to adjust the output filename regarding the pattern required by the user
-    if (pattern_set_by_user == True):
-	    gnuplot_output_filename=pattern
-	    # As we do have some regexp in the pattern, let's make this simpliest
-	    # We do remove the simpliest parts of the expression to get a clear file name
-	    gnuplot_output_filename=gnuplot_output_filename.replace('-*-','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('*','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('--','-')
-	    gnuplot_output_filename=gnuplot_output_filename.replace('.log','')
-	    # Insure that we don't have any starting or trailing dash to the filename
-	    gnuplot_output_filename = gnuplot_output_filename[:-1] if gnuplot_output_filename.endswith('-') else gnuplot_output_filename
-	    gnuplot_output_filename = gnuplot_output_filename[1:] if gnuplot_output_filename.startswith('-') else gnuplot_output_filename
-
-    if parse_global==True:
-	parse_global_files(fio_data_file, global_search)
-    else:
-    	blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
-    	title="%s @ Blocksize = %dK" % (title,blk_size/1024)
-    	compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir)
-    	compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
-    	generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
-
-    	if (run_gnuplot==True):
-    		render_gnuplot(fio_data_file, gnuplot_output_dir)
-
-    # Cleaning temporary files
-    try:
-	os.remove('gnuplot_temp_file.*')
-    except:
-	True
-
-#Main
-if __name__ == "__main__":
-    sys.exit(main(sys.argv))
