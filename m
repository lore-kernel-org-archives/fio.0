Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:59079 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3G3MIj (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Jul 2013 08:08:39 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 4DF773808A
	for <fio@vger.kernel.org>; Tue, 30 Jul 2013 14:08:37 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 4C0BA46D251B
	for <fio@vger.kernel.org>; Tue, 30 Jul 2013 14:08:37 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jpgQ_eEUvxrc for <fio@vger.kernel.org>;
	Tue, 30 Jul 2013 14:08:36 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 7A891744C01
	for <fio@vger.kernel.org>; Tue, 30 Jul 2013 14:08:36 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id czKNlqO0e6WL for <fio@vger.kernel.org>;
	Tue, 30 Jul 2013 14:08:35 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 7963546D251B
	for <fio@vger.kernel.org>; Tue, 30 Jul 2013 14:08:35 +0200 (CEST)
Message-ID: <51F7ACC3.2000904@enovance.com>
Date: Tue, 30 Jul 2013 14:08:35 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull Request] Updating tools
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,

I've been pushing this branch featuring :
- installing fio2gnuplot (and .gpm files) & genfio during make install
- moving fio_generate_plot into tools/ for more coherency
- Adding a option to fio2gnuplot to render gnuplot is a separate dir

Thanks for watching ;o)

Erwan,

The following changes since commit bf974737b15bad8d740f10503e9eab6e0b420aa2:

   Update sample atomic write job file (2013-07-26 13:11:52 -0600)

are available in the git repository at:

   git@github.com:enovance/fio.git erwan/outputdir

for you to fetch changes up to 1cc6579e7dc114347467ed359f015943b83bb4e9:

   fio2gnuplot: Using default install dir for gpm files (2013-07-30 
14:07:14 +0200)

----------------------------------------------------------------
Erwan Velu (5):
       fio2gnuplot: Option to select gnuplot's output dir
       Makefile: Installing fio2gnuplot & sons
       Makefile: Installing genfio at install time
       Tree: Moving fio_generate_plots in tools/
       fio2gnuplot: Using default install dir for gpm files

  Makefile                                           |  8 ++++++--
  fio_generate_plots => tools/fio_generate_plots     |  0
  fio_generate_plots.1 => tools/fio_generate_plots.1 |  0
  tools/plot/fio2gnuplot.py                          | 82 
++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
  4 files changed, 56 insertions(+), 34 deletions(-)
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
index 03ef0dd..eeb15db 100755
--- a/tools/plot/fio2gnuplot.py
+++ b/tools/plot/fio2gnuplot.py
@@ -37,10 +37,11 @@ def find_file(path, pattern):

      return fio_data_file

-def 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,mode,disk_perf):
-    f=open("mygraph",'w')
+def 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
+    filename=gnuplot_output_dir+'mygraph'
+    f=open(filename,'w')
      if len(fio_data_file) > 1:
-            f.write("call \'graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\'\n" % (title,gnuplot_output_filename,gnuplot_output_filename,mode))
+            f.write("call \'%s/graph3D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\'\n" % 
(gpm_dir,title,gnuplot_output_filename,gnuplot_output_filename,mode))

          pos=0
          # Let's create a temporary file for each selected fio file
@@ -51,26 +52,28 @@ def 
generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,mode,dis
                  smooth_filename = "%s-2Dsmooth" % (png_file)
                  trend_filename = "%s-2Dtrend" % (png_file)
                  avg  = average(disk_perf[pos])
-                f.write("call \'graph2D.gpm\' \'%s' \'%s\' \'\' \'%s\' 
\'%s\' \'%s\' \'%s\' \'%f\'\n" % 
(title,tmp_filename,raw_filename,mode,smooth_filename,trend_filename,avg))
+                f.write("call \'%s/graph2D.gpm\' \'%s' \'%s\' \'\' 
\'%s\' \'%s\' \'%s\' \'%s\' \'%f\'\n" % 
(gpm_dir,title,tmp_filename,raw_filename,mode,smooth_filename,trend_filename,avg))
                  pos = pos +1

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
@@ -83,14 +86,14 @@ def compute_aggregated_file(fio_data_file, 
gnuplot_output_filename):

  def average(s): return sum(s) * 1.0 / len(s)

-def compute_temp_file(fio_data_file,disk_perf):
+def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir):
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
@@ -144,14 +147,14 @@ def compute_temp_file(fio_data_file,disk_perf):
                  file.close()
      return blk_size

-def compute_math(fio_data_file, 
title,gnuplot_output_filename,mode,disk_perf):
+def compute_math(fio_data_file, 
title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
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
@@ -195,14 +198,14 @@ def compute_math(fio_data_file, 
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
@@ -249,11 +252,11 @@ def parse_global_files(fio_data_file, global_search):
      else:
          print "Global search %s is not yet implemented\n" % global_search

-def render_gnuplot():
+def render_gnuplot(gnuplot_output_dir):
      print "Running gnuplot Rendering\n"
      try:
-        os.system("gnuplot mymath")
-        os.system("gnuplot mygraph")
+        os.system("cd %s; gnuplot mymath" % gnuplot_output_dir)
+        os.system("cd %s; gnuplot mygraph" % gnuplot_output_dir)
      except:
          print "Could not run gnuplot on mymath or mygraph !\n"
          sys.exit(1);
@@ -268,6 +271,7 @@ def print_help():
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
@@ -280,13 +284,21 @@ def main(argv):
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
@@ -302,6 +314,12 @@ def main(argv):
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
@@ -352,14 +370,14 @@ def main(argv):
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
+            render_gnuplot(gnuplot_output_dir)

      # Cleaning temporary files
      try:

