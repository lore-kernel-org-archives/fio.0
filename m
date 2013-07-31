Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:23643 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3GaKgU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Jul 2013 06:36:20 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 02222123B6
	for <fio@vger.kernel.org>; Wed, 31 Jul 2013 12:36:19 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id F1E2D767A56
	for <fio@vger.kernel.org>; Wed, 31 Jul 2013 12:36:18 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wii-BqAcP4UI for <fio@vger.kernel.org>;
	Wed, 31 Jul 2013 12:36:17 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id DD0A63C81429
	for <fio@vger.kernel.org>; Wed, 31 Jul 2013 12:36:17 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VTmqrFvGw8Um for <fio@vger.kernel.org>;
	Wed, 31 Jul 2013 12:36:16 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 4E6155B3D41B
	for <fio@vger.kernel.org>; Wed, 31 Jul 2013 12:36:15 +0200 (CEST)
Message-ID: <51F8E89E.4060208@enovance.com>
Date: Wed, 31 Jul 2013 12:36:14 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: [Pull Request] Updating tools
References: <51F7ACC3.2000904@enovance.com>
In-Reply-To: <51F7ACC3.2000904@enovance.com>
Content-Type: multipart/mixed;
 boundary="------------040008060802050703060809"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040008060802050703060809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Jens,

I've been updating my branch to add a new feature and some visual 
improvements.

The main feature is if more than one file is matching the pattern, a new 
set of graphing is generated allowing traces comparaisons on the same 
graph as does fio_generate_plots

I've been adding sample files in the three moods (raw/smooth/trend) as 
an attachement.

That's a good addition to the existing plotting I did with fio2gnuplot.
Cheers,
Erwan

The following changes since commit bf974737b15bad8d740f10503e9eab6e0b420aa2:

   Update sample atomic write job file (2013-07-26 13:11:52 -0600)

are available in the git repository at:

   git@github.com:enovance/fio.git erwan/outputdir

for you to fetch changes up to 428b4f6ba681dbb40c8e2213d0c6ae8f8049dcd5:

   fio2gnuplot: Adding filename as title for 2D graphs (2013-07-31 
12:32:40 +0200)

----------------------------------------------------------------
Erwan Velu (10):
       fio2gnuplot: Option to select gnuplot's output dir
       Makefile: Installing fio2gnuplot & sons
       Makefile: Installing genfio at install time
       Tree: Moving fio_generate_plots in tools/
       fio2gnuplot: Using default install dir for gpm files
       fio2gnuplot: Printing number of selected files
       fio2gnuplot: Adding comparing 2D graphs
       fio2gnuplot: Fixing help message
       fio2gnuplot: Adding information steps
       fio2gnuplot: Adding filename as title for 2D graphs

  Makefile                                           |   8 ++++--
  fio_generate_plots => tools/fio_generate_plots     |   0
  fio_generate_plots.1 => tools/fio_generate_plots.1 |   0
  tools/plot/fio2gnuplot.py                          | 159 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
  4 files changed, 129 insertions(+), 38 deletions(-)
  rename fio_generate_plots => tools/fio_generate_plots (100%)
  rename fio_generate_plots.1 => tools/fio_generate_plots.1 (100%)

diff --git a/Makefile b/Makefile
index 3de9735..8494b27 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ OPTFLAGS= -O3 -g -ffast-math
  CFLAGS    = -std=gnu99 -Wwrite-strings -Wall 
-Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
  LIBS    += -lm $(EXTLIBS)
  PROGS    = fio
-SCRIPTS = fio_generate_plots
+SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot.py tools/genfio

  ifdef CONFIG_GFIO
    PROGS += gfio
@@ -189,8 +189,10 @@ bindir = $(prefix)/bin

  ifeq ($(CONFIG_TARGET_OS), Darwin)
  mandir = /usr/share/man
+sharedir = /usr/share/fio
  else
  mandir = $(prefix)/man
+sharedir = $(prefix)/share/fio
  endif

  all: $(PROGS) $(SCRIPTS) FORCE
@@ -278,4 +280,6 @@ install: $(PROGS) $(SCRIPTS) FORCE
      $(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
      $(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
      $(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
-    $(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
+    $(INSTALL) -m 644 tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
+    $(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
+    $(INSTALL) -m 644 tools/plot/*gpm $(DESTDIR)$(sharedir)/
diff --git a/fio_generate_plots b/tools/fio_generate_plots
similarity index 100%
rename from fio_generate_plots
rename to tools/fio_generate_plots
diff --git a/fio_generate_plots.1 b/tools/fio_generate_plots.1
similarity index 100%
rename from fio_generate_plots.1
rename to tools/fio_generate_plots.1
diff --git a/tools/plot/fio2gnuplot.py b/tools/plot/fio2gnuplot.py
index 03ef0dd..800c334 100755
--- a/tools/plot/fio2gnuplot.py
+++ b/tools/plot/fio2gnuplot.py
@@ -25,6 +25,7 @@ import sys
  import getopt
  import re
  import math
+import shutil

  def find_file(path, pattern):
      fio_data_file=[]
@@ -37,40 +38,95 @@ def find_file(path, pattern):

      return fio_data_file

-def 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,mode,disk_perf):
-    f=open("mygraph",'w')
+def 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
+    print "Generating rendering scripts"
+    filename=gnuplot_output_dir+'mygraph'
+    f=open(filename,'w')
+
+    # Plotting 3D or comparing graphs doesn't have a meaning unless if 
there is at least 2 traces
      if len(fio_data_file) > 1:
-            f.write("call \'graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\'\n" % (title,gnuplot_output_filename,gnuplot_output_filename,mode))
+            f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\'\n" % 
(gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))
+
+        # Setting up the compare files that will be plot later
+        compare=open(gnuplot_output_dir + 'compare.gnuplot','w')
+        compare.write('''
+set title '%s'
+set terminal png size 1280,1024
+set ytics axis out auto
+set key top left reverse
+set xlabel "Time (Seconds)"
+set ylabel '%s'
+set xrange [0:]
+set yrange [0:]
+'''% (title,mode))
+        compare.close()
+        #Copying the common file for all kind of graph (raw/smooth/trend)
+        compare_raw_filename="compare-%s-2Draw" % (gnuplot_output_filename)
+        compare_smooth_filename="compare-%s-2Dsmooth" % 
(gnuplot_output_filename)
+        compare_trend_filename="compare-%s-2Dtrend" % 
(gnuplot_output_filename)
+ 
shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_raw_filename+".gnuplot")
+ 
shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_smooth_filename+".gnuplot")
+ 
shutil.copy(gnuplot_output_dir+'compare.gnuplot',gnuplot_output_dir+compare_trend_filename+".gnuplot")
+
+        #Setting up a different output filename for each kind of graph
+        compare_raw=open(gnuplot_output_dir+compare_raw_filename + 
".gnuplot",'a')
+        compare_raw.write("set output '%s.png'\n" % compare_raw_filename)
+ 
compare_smooth=open(gnuplot_output_dir+compare_smooth_filename+".gnuplot",'a')
+        compare_smooth.write("set output '%s.png'\n" % 
compare_smooth_filename)
+ 
compare_trend=open(gnuplot_output_dir+compare_trend_filename+".gnuplot",'a')
+        compare_trend.write("set output '%s.png'\n" % 
compare_trend_filename)

          pos=0
          # Let's create a temporary file for each selected fio file
          for file in fio_data_file:
                  tmp_filename = "gnuplot_temp_file.%d" % pos
-                png_file=file.replace('.log','')
+
+        # Plotting comparing graphs doesn't have a meaning unless if 
there is at least 2 traces
+        if len(fio_data_file) > 1:
+            # Adding the plot instruction for each kind of comparing graphs
+            if pos ==0 :
+                compare_raw.write("plot '%s' using 2:3 with linespoints 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+                compare_smooth.write("plot '%s' using 2:3 smooth 
csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
+                compare_trend.write("plot '%s' using 2:3 smooth bezier 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+            else:
+                compare_raw.write(",\\\n'%s' using 2:3 with linespoints 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+                compare_smooth.write(",\\\n'%s' using 2:3 smooth 
csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
+                compare_trend.write(",\\\n'%s' using 2:3 smooth bezier 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+
+        png_file=file.replace('.log','')
                  raw_filename = "%s-2Draw" % (png_file)
                  smooth_filename = "%s-2Dsmooth" % (png_file)
                  trend_filename = "%s-2Dtrend" % (png_file)
                  avg  = average(disk_perf[pos])
-                f.write("call \'graph2D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\' \'%s\' \'%s\' \'%f\'\n" % 
(title,tmp_filename,raw_filename,mode,smooth_filename,trend_filename,avg))
+                f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'%s\' 
\'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % 
(gpm_dir,title,tmp_filename,fio_data_file[pos],raw_filename,mode,smooth_filename,trend_filename,avg))
                  pos = pos +1

+    # Plotting comparing graphs doesn't have a meaning unless if there 
is at least 2 traces
+    if len(fio_data_file) > 1:
+        os.remove(gnuplot_output_dir+"compare.gnuplot")
+        compare_raw.close()
+        compare_smooth.close()
+        compare_trend.close()
      f.close()

-def 
generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average):
-    f=open("mymath",'a')
-        f.write("call \'math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' 
%s\n" % 
(title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
+def 
generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average,gnuplot_output_dir,gpm_dir):
+    filename=gnuplot_output_dir+'mymath';
+    f=open(filename,'a')
+        f.write("call \'%s/math.gpm\' \'%s' \'%s\' \'\' \'%s\' \'%s\' 
%s\n" % 
(gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode,average))
      f.close()

-def compute_aggregated_file(fio_data_file, gnuplot_output_filename):
+def compute_aggregated_file(fio_data_file, gnuplot_output_filename, 
gnuplot_output_dir):
+    print "Processing data file 2/2"
      temp_files=[]
      pos=0
+
      # Let's create a temporary file for each selected fio file
      for file in fio_data_file:
-        tmp_filename = "gnuplot_temp_file.%d" % pos
+        tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir, pos)
          temp_files.append(open(tmp_filename,'r'))
          pos = pos +1

-    f = open(gnuplot_output_filename, "w")
+    f = open(gnuplot_output_dir+gnuplot_output_filename, "w")
      index=0
      # Let's add some information
      for tempfile in temp_files:
@@ -83,14 +139,15 @@ def compute_aggregated_file(fio_data_file, 
gnuplot_output_filename):

  def average(s): return sum(s) * 1.0 / len(s)

-def compute_temp_file(fio_data_file,disk_perf):
+def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir):
+    print "Processing data file 1/2"
      files=[]
      temp_outfile=[]
      blk_size=0
      for file in fio_data_file:
          files.append(open(file))
          pos = len(files) - 1
-        tmp_filename = "gnuplot_temp_file.%d" % pos
+        tmp_filename = "%sgnuplot_temp_file.%d" % (gnuplot_output_dir,pos)
          gnuplot_file=open(tmp_filename,'w')
          temp_outfile.append(gnuplot_file)
          gnuplot_file.write("#Temporary file based on file %s\n" % file)
@@ -144,14 +201,15 @@ def compute_temp_file(fio_data_file,disk_perf):
                  file.close()
      return blk_size

-def compute_math(fio_data_file, 
title,gnuplot_output_filename,mode,disk_perf):
+def compute_math(fio_data_file, 
title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
+    print "Computing Maths"
      global_min=[]
      global_max=[]
-    average_file=open(gnuplot_output_filename+'.average', 'w')
-    min_file=open(gnuplot_output_filename+'.min', 'w')
-    max_file=open(gnuplot_output_filename+'.max', 'w')
-    stddev_file=open(gnuplot_output_filename+'.stddev', 'w')
-    global_file=open(gnuplot_output_filename+'.global','w')
+ 
average_file=open(gnuplot_output_dir+gnuplot_output_filename+'.average', 
'w')
+ min_file=open(gnuplot_output_dir+gnuplot_output_filename+'.min', 'w')
+ max_file=open(gnuplot_output_dir+gnuplot_output_filename+'.max', 'w')
+ stddev_file=open(gnuplot_output_dir+gnuplot_output_filename+'.stddev', 
'w')
+ global_file=open(gnuplot_output_dir+gnuplot_output_filename+'.global','w')

      min_file.write('DiskName %s\n' % mode)
      max_file.write('DiskName %s\n'% mode)
@@ -195,14 +253,14 @@ def compute_math(fio_data_file, 
title,gnuplot_output_filename,mode,disk_perf):
      stddev_file.close()
      global_file.close()
      try:
-        os.remove('mymath')
+        os.remove(gnuplot_output_dir+'mymath')
      except:
          True

-    generate_gnuplot_math_script("Average values of 
"+title,gnuplot_output_filename+'.average',mode,int(avg))
-    generate_gnuplot_math_script("Min values of 
"+title,gnuplot_output_filename+'.min',mode,average(global_min))
-    generate_gnuplot_math_script("Max values of 
"+title,gnuplot_output_filename+'.max',mode,average(global_max))
-    generate_gnuplot_math_script("Standard Deviation of 
"+title,gnuplot_output_filename+'.stddev',mode,int(standard_deviation))
+    generate_gnuplot_math_script("Average values of 
"+title,gnuplot_output_filename+'.average',mode,int(avg),gnuplot_output_dir,gpm_dir)
+    generate_gnuplot_math_script("Min values of 
"+title,gnuplot_output_filename+'.min',mode,average(global_min),gnuplot_output_dir,gpm_dir)
+    generate_gnuplot_math_script("Max values of 
"+title,gnuplot_output_filename+'.max',mode,average(global_max),gnuplot_output_dir,gpm_dir)
+    generate_gnuplot_math_script("Standard Deviation of 
"+title,gnuplot_output_filename+'.stddev',mode,int(standard_deviation),gnuplot_output_dir,gpm_dir)

  def parse_global_files(fio_data_file, global_search):
      max_result=0
@@ -249,17 +307,28 @@ def parse_global_files(fio_data_file, global_search):
      else:
          print "Global search %s is not yet implemented\n" % global_search

-def render_gnuplot():
-    print "Running gnuplot Rendering\n"
+def render_gnuplot(fio_data_file, gnuplot_output_dir):
+    print "Running gnuplot Rendering"
      try:
-        os.system("gnuplot mymath")
-        os.system("gnuplot mygraph")
+        # Let's render all the compared files if some
+        if len(fio_data_file) > 1:
+            print " |-> Rendering comparing traces"
+            os.system("cd %s; for i in *.gnuplot; do gnuplot $i; done" 
% gnuplot_output_dir)
+        print " |-> Rendering math traces"
+        os.system("cd %s; gnuplot mymath" % gnuplot_output_dir)
+        print " |-> Rendering 2D & 3D traces"
+        os.system("cd %s; gnuplot mygraph" % gnuplot_output_dir)
+
+        name_of_directory="the current"
+        if gnuplot_output_dir != "./":
+            name_of_directory=gnuplot_output_dir
+        print "\nRendering traces are available in %s directory" % 
name_of_directory
      except:
          print "Could not run gnuplot on mymath or mygraph !\n"
          sys.exit(1);

  def print_help():
-    print 'fio2gnuplot.py -ghbio -t <title> -o <outputfile> -p <pattern>'
+    print 'fio2gnuplot.py -ghbiod -t <title> -o <outputfile> -p 
<pattern> -G <type>'
      print
      print '-h --help                           : Print this help'
      print '-p <pattern> or --pattern <pattern> : A pattern in regexp 
to select fio input files'
@@ -268,6 +337,7 @@ def print_help():
      print '-g           or --gnuplot           : Render gnuplot traces 
before exiting'
      print '-o           or --outputfile <file> : The basename for 
gnuplot traces'
      print '                                       - Basename is set 
with the pattern if defined'
+    print '-d           or --outputdir <dir>   : The directory where 
gnuplot shall render files'
      print '-t           or --title <title>     : The title of the 
gnuplot traces'
      print '                                       - Title is set with 
the block size detected in fio traces'
      print '-G        or --Global <type>     : Search for <type> in 
.global files match by a pattern'
@@ -280,13 +350,21 @@ def main(argv):
      pattern_set_by_user=False
      title='No title'
      gnuplot_output_filename='result'
+    gnuplot_output_dir='./'
+    gpm_dir="/usr/share/fio/"
      disk_perf=[]
      run_gnuplot=False
      parse_global=False
      global_search=''

+    if not os.path.isfile(gpm_dir+'math.gpm'):
+        gpm_dir="/usr/local/share/fio/"
+            if not os.path.isfile(gpm_dir+'math.gpm'):
+            print "Looks like fio didn't got installed properly as no 
gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n"
+            sys.exit(3)
+
      try:
-        opts, args = getopt.getopt(argv[1:],"ghbio:t:p:G:")
+        opts, args = getopt.getopt(argv[1:],"ghbio:d:t:p:G:")
      except getopt.GetoptError:
       print_help()
           sys.exit(2)
@@ -302,6 +380,12 @@ def main(argv):
       pattern=pattern.replace('\\','')
        elif opt in ("-o", "--outputfile"):
           gnuplot_output_filename=arg
+      elif opt in ("-d", "--outputdir"):
+         gnuplot_output_dir=arg
+     if not gnuplot_output_dir.endswith('/'):
+        gnuplot_output_dir=gnuplot_output_dir+'/'
+     if not os.path.exists(gnuplot_output_dir):
+        os.makedirs(gnuplot_output_dir)
        elif opt in ("-t", "--title"):
           title=arg
        elif opt in ("-g", "--gnuplot"):
@@ -322,10 +406,12 @@ def main(argv):
      if len(fio_data_file) == 0:
          print "No log file found with pattern %s!" % pattern
          sys.exit(1)
+    else:
+        print "%d files Selected with pattern '%s'" % 
(len(fio_data_file), pattern)

      fio_data_file=sorted(fio_data_file, key=str.lower)
      for file in fio_data_file:
-    print 'Selected %s' % file
+    print ' |-> %s' % file
      if "_bw.log" in file :
          mode="Bandwidth (KB/sec)"
      if "_iops.log" in file :
@@ -336,6 +422,7 @@ def main(argv):
          if "IO" in mode:
              title='IO benchmark with %d fio results' % len(fio_data_file)

+    print
      #We need to adjust the output filename regarding the pattern 
required by the user
      if (pattern_set_by_user == True):
          gnuplot_output_filename=pattern
@@ -352,14 +439,14 @@ def main(argv):
      if parse_global==True:
      parse_global_files(fio_data_file, global_search)
      else:
-        blk_size=compute_temp_file(fio_data_file,disk_perf)
+ blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir)
          title="%s @ Blocksize = %dK" % (title,blk_size/1024)
-        compute_aggregated_file(fio_data_file, gnuplot_output_filename)
- compute_math(fio_data_file,title,gnuplot_output_filename,mode,disk_perf)
- 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,mode,disk_perf)
+        compute_aggregated_file(fio_data_file, gnuplot_output_filename, 
gnuplot_output_dir)
+ 
compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
+ 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)

          if (run_gnuplot==True):
-            render_gnuplot()
+            render_gnuplot(fio_data_file, gnuplot_output_dir)

      # Cleaning temporary files
      try:


--------------040008060802050703060809
Content-Type: image/png;
 name="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Dsmooth.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Dsmooth.png"

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
AB5y4qK++JEAAAAASUVORK5CYII=
--------------040008060802050703060809
Content-Type: image/png;
 name="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Draw.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Draw.png"

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
--------------040008060802050703060809
Content-Type: image/png;
 name="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Dtrend.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="compare-vm1-1-4m-vdb-read-para.results_-_bw-2Dtrend.png"

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
4K88Tlf74pRiWwBfrbs1Xgu5SAAPnQDutqDxn5YPf5AO+kG4XP1+fW/6OLf4JSvYaSr8t6gN
d4722Ysgj6fx7s19387RMF8/DObyE8DX0vrf+xtfl9y2PUNLvOzP15X+keiuZOYgod1e477w
l+f6tjVp5YsZAji6xN3mAn9L22Wjngu79o/XBy8oHbQlg+tqru6Q17gv/uW5umrfCVJU/3a3
4yHX+yzoUCu28hvjOfA17jK+PlcmgKuV8S23z+Ft25dxkqVPuh2/JftYOJ7jN6R2ArhaKd91
2w9Z2Wc7zjLXDOOhr9YA6t9t249IkT9eky+qn7ol+5g8RuDULamWAK5V1DfeRQ8TOdLICw9f
3KJN9j5GgLZKA6h/D9c9TORYe72gfgmNkdQypMsQwHXK++774Iw1h2wHG1XT80sRwHVK/A5c
82PjZ4wodQZQ/9qWn3jh2O2AixHAVYoNxIK0mfyRRwDXKLkQk3nz9BKZqgyg/g0aaZz4kUsA
Vyi+Ew4pg5YaA6h/4/Y97QwUTgCXkwuojAAupn9QmwoDaAIILCOAiwkg1EYAl9I/qE59ATQB
BBYSwKUEEKpTXQC9DRhYSgCXEkCojgAuJYBQndoCqH/AYgK4kABCfQRwIQGE+gjgQgII9RHA
hQQQ6iOACwkg1KeyAOofsJwALiOAUCEBXEYAoUICuIwAQoUEcBkBhAoJ4DICCBUSwEX0D2ok
gIsIINRIABcRQKiRAC4igFCjugLoNRBgBQFcQv+gSgK4hABClQRwCQGEKgngEgIIVRLAJQQQ
qiSASwggVEkAF9A/qJMALiCAUCcBXEAAoU5VBdBTgMAaAriAAEKdBHABAYQ6CeA8/YNKCeA8
AYRKCeA8AYRKCeA8AYRKCeA8AYRKCeAs/YNaCeAsAYRa1RRAe8DAKgI4SwChVgI4SwChVgI4
SwChVgI4R/+gWgI4RwChWgI4RwChWgI4RwChWgI4RwChWgI4RwChWhUFUP+AdQRwhgBCvQRw
hgBCvQRwhgBCvQRwhgBCvQRwhgBCvQRwmv5BxQRwmgBCxQRwmgBCxQRwmgBCxeoJoNdAgJUE
cJoAQsUEcJoAQsUEcJoAQsUEcJL+Qc0EcJIAQs0EcJIAQs0EcJIAQs0EcJIAQs0EcJIAQs2q
CaCjYIC1BHCSAELNBHCSAELNBHCSAELNBHCSAELNBHCK/kHVBHCKAELVBHCKAELVBHCKAELV
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
--------------040008060802050703060809--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


