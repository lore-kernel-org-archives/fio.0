Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:20126 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3HBOvd (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Aug 2013 10:51:33 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 4C7863829B
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 16:51:31 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 495467BB08A
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 16:51:31 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NuNrPKTLyl4U for <fio@vger.kernel.org>;
	Fri,  2 Aug 2013 16:51:30 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 741A817BC2B
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 16:51:30 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id k768Eo3vVl4Y for <fio@vger.kernel.org>;
	Fri,  2 Aug 2013 16:51:29 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id E57D95A8DC45
	for <fio@vger.kernel.org>; Fri,  2 Aug 2013 16:51:28 +0200 (CEST)
Message-ID: <51FBC770.5000008@enovance.com>
Date: Fri, 02 Aug 2013 16:51:28 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull Requests] fio2gnuplot and iolog fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Dear Jens,

Please find below my latest works for fio.
I do have some fio2gnuplot fixes and one is very important as some data 
were mixed leading to weird/stupid plotting artefacts like loops....

Aside this, I've been fixing the empty field when logging IOs.

The following changes since commit 428b4f6ba681dbb40c8e2213d0c6ae8f8049dcd5:

   fio2gnuplot: Adding filename as title for 2D graphs (2013-07-31 
12:32:40 +0200)

are available in the git repository at:

   git@github.com:enovance/fio.git erwan/fixes

for you to fetch changes up to aab5954b98a275ca1cf29d5339cdc319d9f4cfda:

   iolog: Logging blocksize in IOPS traces (2013-08-02 16:39:40 +0200)

----------------------------------------------------------------
Erwan Velu (8):
       fio2gnuplot: Fixing typo when inserting fake data
       fio2gnuplot: Print line if int() conversion fails
       fio2gnuplot: Adding time selection options
       fio2gnplot: Renaming file variable to myfile
       fio2gnuplot: Fixing plotting issues on shorten files
       fio2gnuplot: Plotting average value for compare graphs
       fio2gnuplot: Display average value in label
       iolog: Logging blocksize in IOPS traces

  io_u.c                    |  2 +-
  iolog.h                   |  3 ++-
  stat.c                    |  4 ++--
  tools/plot/fio2gnuplot.py | 79 
+++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
  tools/plot/graph2D.gpm    |  6 +++---
  tools/plot/math.gpm       |  2 +-
  6 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/io_u.c b/io_u.c
index 6537c90..a35aafd 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1412,7 +1412,7 @@ static void account_io_completion(struct 
thread_data *td, struct io_u *io_u,
      if (!td->o.disable_bw)
          add_bw_sample(td, idx, bytes, &icd->time);

-    add_iops_sample(td, idx, &icd->time);
+    add_iops_sample(td, idx, bytes, &icd->time);
  }

  static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
diff --git a/iolog.h b/iolog.h
index 7099097..8fedc19 100644
--- a/iolog.h
+++ b/iolog.h
@@ -118,7 +118,8 @@ extern void add_slat_sample(struct thread_data *, 
enum fio_ddir, unsigned long,
                  unsigned int);
  extern void add_bw_sample(struct thread_data *, enum fio_ddir, 
unsigned int,
                  struct timeval *);
-extern void add_iops_sample(struct thread_data *, enum fio_ddir, struct 
timeval *);
+extern void add_iops_sample(struct thread_data *, enum fio_ddir, 
unsigned int,
+                struct timeval *);
  extern void init_disk_util(struct thread_data *);
  extern void update_rusage_stat(struct thread_data *);
  extern void setup_log(struct io_log **, unsigned long, int);
diff --git a/stat.c b/stat.c
index 442caa0..10d9efe 100644
--- a/stat.c
+++ b/stat.c
@@ -1691,7 +1691,7 @@ void add_bw_sample(struct thread_data *td, enum 
fio_ddir ddir, unsigned int bs,
      fio_gettime(&td->bw_sample_time, NULL);
  }

-void add_iops_sample(struct thread_data *td, enum fio_ddir ddir,
+void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, 
unsigned int bs,
               struct timeval *t)
  {
      struct thread_stat *ts = &td->ts;
@@ -1718,7 +1718,7 @@ void add_iops_sample(struct thread_data *td, enum 
fio_ddir ddir,
          add_stat_sample(&ts->iops_stat[ddir], iops);

          if (td->iops_log)
-            add_log_sample(td, td->iops_log, iops, ddir, 0);
+            add_log_sample(td, td->iops_log, iops, ddir, bs);

          td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
      }
diff --git a/tools/plot/fio2gnuplot.py b/tools/plot/fio2gnuplot.py
index 800c334..64b41c1 100755
--- a/tools/plot/fio2gnuplot.py
+++ b/tools/plot/fio2gnuplot.py
@@ -56,8 +56,8 @@ set ytics axis out auto
  set key top left reverse
  set xlabel "Time (Seconds)"
  set ylabel '%s'
-set xrange [0:]
  set yrange [0:]
+set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
  '''% (title,mode))
          compare.close()
          #Copying the common file for all kind of graph (raw/smooth/trend)
@@ -76,6 +76,13 @@ set yrange [0:]
  compare_trend=open(gnuplot_output_dir+compare_trend_filename+".gnuplot",'a')
          compare_trend.write("set output '%s.png'\n" % 
compare_trend_filename)

+        # Let's plot the average value for all the traces
+        global_disk_perf = sum(disk_perf, [])
+        global_avg  = average(global_disk_perf)
+        compare_raw.write("plot %s w l ls 1 ti 'Global average value 
(%.2f)'" % (global_avg,global_avg));
+        compare_smooth.write("plot %s w l ls 1 ti 'Global average value 
(%.2f)'" % (global_avg,global_avg));
+        compare_trend.write("plot %s w l ls 1 ti 'Global average value 
(%.2f)'" % (global_avg,global_avg));
+
          pos=0
          # Let's create a temporary file for each selected fio file
          for file in fio_data_file:
@@ -84,14 +91,9 @@ set yrange [0:]
          # Plotting comparing graphs doesn't have a meaning unless if 
there is at least 2 traces
          if len(fio_data_file) > 1:
              # Adding the plot instruction for each kind of comparing 
graphs
-            if pos ==0 :
-                compare_raw.write("plot '%s' using 2:3 with linespoints 
title '%s'" % (tmp_filename,fio_data_file[pos]))
-                compare_smooth.write("plot '%s' using 2:3 smooth 
csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
-                compare_trend.write("plot '%s' using 2:3 smooth bezier 
title '%s'" % (tmp_filename,fio_data_file[pos]))
-            else:
-                compare_raw.write(",\\\n'%s' using 2:3 with linespoints 
title '%s'" % (tmp_filename,fio_data_file[pos]))
-                compare_smooth.write(",\\\n'%s' using 2:3 smooth 
csplines title '%s'" % (tmp_filename,fio_data_file[pos]))
-                compare_trend.write(",\\\n'%s' using 2:3 smooth bezier 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+            compare_raw.write(",\\\n'%s' using 2:3 with linespoints 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+            compare_smooth.write(",\\\n'%s' using 2:3 smooth csplines 
title '%s'" % (tmp_filename,fio_data_file[pos]))
+            compare_trend.write(",\\\n'%s' using 2:3 smooth bezier 
title '%s'" % (tmp_filename,fio_data_file[pos]))

          png_file=file.replace('.log','')
                  raw_filename = "%s-2Draw" % (png_file)
@@ -139,8 +141,11 @@ def compute_aggregated_file(fio_data_file, 
gnuplot_output_filename, gnuplot_outp

  def average(s): return sum(s) * 1.0 / len(s)

-def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir):
-    print "Processing data file 1/2"
+def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, 
min_time, max_time):
+    end_time=max_time
+    if end_time == -1:
+        end_time="infinite"
+    print "Processing data file 1/2 with %s<time<%s" % (min_time,end_time)
      files=[]
      temp_outfile=[]
      blk_size=0
@@ -158,11 +163,11 @@ def 
compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir):
          current_line=[]
          nb_empty_files=0
          nb_files=len(files)
-        for file in files:
-            s=file.readline().replace(',',' ').split()
+        for myfile in files:
+            s=myfile.readline().replace(',',' ').split()
              if not s:
                  nb_empty_files+=1
-                s="-1, 0, 0, 0'".replace(',',' ').split()
+                s="-1, 0, 0, 0".replace(',',' ').split()

              if (nb_empty_files == nb_files):
                  shall_break=True
@@ -174,25 +179,35 @@ def 
compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir):
              break

          last_time = -1
-        index=0
+        index=-1
          perfs=[]
-        for line in current_line:
-            time, perf, x, block_size = line
+        for line in enumerate(current_line):
+            # Index will be used to remember what file was featuring 
what value
+            index=index+1
+
+            time, perf, x, block_size = line[1]
              if (blk_size == 0):
-                blk_size=int(block_size)
+                try:
+                    blk_size=int(block_size)
+                except:
+                    print "Error while reading the following line :"
+                    print line
+                    sys.exit(1);

              # We ignore the first 500msec as it doesn't seems to be 
part of the real benchmark
              # Time < 500 usually reports BW=0 breaking the min computing
-            if (((int(time)) > 500) or (int(time)==-1)):
-                disk_perf[index].append(int(perf))
-                perfs.append("%s %s"% (time, perf))
-                index = index + 1
+            if (min_time == 0):
+                min_time==0.5
+
+            # Then we estimate if the data we got is part of the time 
range we want to plot
+            if ((float(time)>(float(min_time)*1000)) and ((int(time) < 
(int(max_time)*1000)) or max_time==-1)):
+                    disk_perf[index].append(int(perf))
+                    perfs.append("%d %s %s"% (index, time, perf))

          # If we reach this point, it means that all the traces are 
coherent
          for p in enumerate(perfs):
-            perf_time,perf = p[1].split()
-            if (perf_time != "-1"):
-                temp_outfile[p[0]].write("%s %.2f %s\n" % (p[0], 
float(float(perf_time)/1000), perf))
+            index, perf_time,perf = p[1].split()
+            temp_outfile[int(index)].write("%s %.2f %s\n" % (index, 
float(float(perf_time)/1000), perf))


      for file in files:
@@ -328,7 +343,7 @@ def render_gnuplot(fio_data_file, gnuplot_output_dir):
          sys.exit(1);

  def print_help():
-    print 'fio2gnuplot.py -ghbiod -t <title> -o <outputfile> -p 
<pattern> -G <type>'
+    print 'fio2gnuplot.py -ghbiod -t <title> -o <outputfile> -p 
<pattern> -G <type> -m <time> -M <time>'
      print
      print '-h --help                           : Print this help'
      print '-p <pattern> or --pattern <pattern> : A pattern in regexp 
to select fio input files'
@@ -343,6 +358,8 @@ def print_help():
      print '-G        or --Global <type>     : Search for <type> in 
.global files match by a pattern'
      print '                                       - Available types 
are : min, max, avg, stddev'
      print '                                       - The .global 
extension is added automatically to the pattern'
+    print '-m           or --min_time <time>   : Only consider data 
starting from <time> seconds (default is 0)'
+    print '-M           or --max_time <time>   : Only consider data 
ending before <time> seconds (default is -1 aka nolimit)'

  def main(argv):
      mode='unknown'
@@ -356,6 +373,8 @@ def main(argv):
      run_gnuplot=False
      parse_global=False
      global_search=''
+    min_time=0
+    max_time=-1

      if not os.path.isfile(gpm_dir+'math.gpm'):
          gpm_dir="/usr/local/share/fio/"
@@ -364,7 +383,7 @@ def main(argv):
              sys.exit(3)

      try:
-        opts, args = getopt.getopt(argv[1:],"ghbio:d:t:p:G:")
+        opts, args = getopt.getopt(argv[1:],"ghbio:d:t:p:G:m:M:")
      except getopt.GetoptError:
       print_help()
           sys.exit(2)
@@ -388,6 +407,10 @@ def main(argv):
          os.makedirs(gnuplot_output_dir)
        elif opt in ("-t", "--title"):
           title=arg
+      elif opt in ("-m", "--min_time"):
+     min_time=arg
+      elif opt in ("-M", "--max_time"):
+     max_time=arg
        elif opt in ("-g", "--gnuplot"):
       run_gnuplot=True
        elif opt in ("-G", "--Global"):
@@ -439,7 +462,7 @@ def main(argv):
      if parse_global==True:
      parse_global_files(fio_data_file, global_search)
      else:
-  blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir)
+ 
  blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
          title="%s @ Blocksize = %dK" % (title,blk_size/1024)
          compute_aggregated_file(fio_data_file, 
gnuplot_output_filename, gnuplot_output_dir)
  compute_math(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir)
diff --git a/tools/plot/graph2D.gpm b/tools/plot/graph2D.gpm
index efc7ac2..5cd6ff3 100644
--- a/tools/plot/graph2D.gpm
+++ b/tools/plot/graph2D.gpm
@@ -22,13 +22,13 @@ set yrange [0:]
  set style line 100 lt 7 lw 0.5
  set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"

-plot '$1' using 2:3 with linespoints title '$2', $7 w l ls 1 ti 'Global 
average value'
+plot '$1' using 2:3 with linespoints title '$2', $7 w l ls 1 ti 'Global 
average value ($7)'

  set output '$5.png'
-plot '$1' using 2:3 smooth csplines title '$2', $7 w l ls 1 ti 'Global 
average value'
+plot '$1' using 2:3 smooth csplines title '$2', $7 w l ls 1 ti 'Global 
average value ($7)'

  set output '$6.png'
-plot '$1' using 2:3 smooth bezier title '$2', $7 w l ls 1 ti 'Global 
average value'
+plot '$1' using 2:3 smooth bezier title '$2', $7 w l ls 1 ti 'Global 
average value ($7)'

  #pause -1
  #The End
diff --git a/tools/plot/math.gpm b/tools/plot/math.gpm
index 81e03da..a01f5a0 100644
--- a/tools/plot/math.gpm
+++ b/tools/plot/math.gpm
@@ -22,4 +22,4 @@ set xtics axis out
  set xtic rotate by 45 scale 0 font ",8" autojustify
  set xtics offset 0,-1 border -5,1,5
  set style line 1 lt 1 lw 3 pt 3 linecolor rgb "green"
-plot '$1' using 2:xtic(1) ti col, $5 w l ls 1 ti 'Global average value'
+plot '$1' using 2:xtic(1) ti col, $5 w l ls 1 ti 'Global average value 
($5)'

