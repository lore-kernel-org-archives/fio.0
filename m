Return-Path: <fio-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751443AbeEVRtK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 May 2018 13:49:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD2A94187E5E
        for <fio@vger.kernel.org>; Tue, 22 May 2018 17:49:09 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-123-198.rdu2.redhat.com [10.10.123.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91A0E2166BB3
        for <fio@vger.kernel.org>; Tue, 22 May 2018 17:49:09 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] make fio scripts python3-ready (part 2)
Date: Tue, 22 May 2018 12:49:09 -0500
Message-Id: <20180522174909.15967-1-billodo@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

NOTE: this patch (part 2) is in addition to commit 5eac3b00238b
(this patch was missed on that submit/commit (part 1)).

Many distributions are moving to python3 by default.  This is
another patch to make the python scripts in fio python3-ready.

Conversion was facilitated with automated tools.

The modified scripts pass rudimentary testing when run under
python2.7 as well as python3.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 tools/fio_jsonplus_clat2csv | 13 +++--
 tools/plot/fio2gnuplot      | 97 +++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index e63d6d8b..78a007e5 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -1,4 +1,5 @@
 #!/usr/bin/python2.7
+# Note: this script is python2 and python3 compatible.
 #
 # fio_jsonplus_clat2csv
 #
@@ -60,9 +61,13 @@
 # 10304ns is the 100th percentile for read latency
 #
 
+from __future__ import absolute_import
+from __future__ import print_function
 import os
 import json
 import argparse
+import six
+from six.moves import range
 
 
 def parse_args():
@@ -87,7 +92,7 @@ def percentile(idx, run_total):
 
 
 def more_lines(indices, bins):
-    for key, value in indices.iteritems():
+    for key, value in six.iteritems(indices):
         if value < len(bins[key]):
             return True
 
@@ -116,8 +121,8 @@ def main():
                                    "Are you sure you are using json+ output?")
 
             bins[ddir] = [[int(key), value] for key, value in
-                          jsondata['jobs'][jobnum][ddir][bins_loc]
-                          ['bins'].iteritems()]
+                          six.iteritems(jsondata['jobs'][jobnum][ddir][bins_loc]
+                          ['bins'])]
             bins[ddir] = sorted(bins[ddir], key=lambda bin: bin[0])
 
             run_total[ddir] = [0 for x in range(0, len(bins[ddir]))]
@@ -165,7 +170,7 @@ def main():
                         output.write(", , , ")
                 output.write("\n")
 
-            print "{0} generated".format(outfile)
+            print("{0} generated".format(outfile))
 
 
 if __name__ == '__main__':
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 5d31f13a..4d1815cf 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -1,4 +1,5 @@
 #!/usr/bin/python2.7
+# Note: this script is python2 and python3 compatible.
 #
 #  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
 #  Author: Erwan Velu  <erwan@enovance.com>
@@ -19,6 +20,8 @@
 #  along with this program; if not, write to the Free Software
 #  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 
+from __future__ import absolute_import
+from __future__ import print_function
 import os
 import fnmatch
 import sys
@@ -26,6 +29,8 @@ import getopt
 import re
 import math
 import shutil
+from six.moves import map
+from six.moves import range
 
 def find_file(path, pattern):
 	fio_data_file=[]
@@ -39,7 +44,7 @@ def find_file(path, pattern):
 	return fio_data_file
 
 def generate_gnuplot_script(fio_data_file,title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
-	if verbose: print "Generating rendering scripts"
+	if verbose: print("Generating rendering scripts")
 	filename=gnuplot_output_dir+'mygraph'
 	temporary_files.append(filename)
 	f=open(filename,'w')
@@ -124,7 +129,7 @@ def generate_gnuplot_math_script(title,gnuplot_output_filename,mode,average,gnup
 	f.close()
 
 def compute_aggregated_file(fio_data_file, gnuplot_output_filename, gnuplot_output_dir):
-	if verbose: print "Processing data file 2/2"
+	if verbose: print("Processing data file 2/2")
 	temp_files=[]
 	pos=0
 
@@ -152,7 +157,7 @@ def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_
 	end_time=max_time
 	if end_time == -1:
 		end_time="infinite"
-	if verbose: print "Processing data file 1/2 with %s<time<%s" % (min_time,end_time)
+	if verbose: print("Processing data file 1/2 with %s<time<%s" % (min_time,end_time))
 	files=[]
 	temp_outfile=[]
 	blk_size=0
@@ -198,8 +203,8 @@ def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_
 				try:
 					blk_size=int(block_size)
 				except:
-					print "Error while reading the following line :"
-					print line
+					print("Error while reading the following line :")
+					print(line)
 					sys.exit(1);
 
 			# We ignore the first 500msec as it doesn't seems to be part of the real benchmark
@@ -225,7 +230,7 @@ def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_
 	return blk_size
 
 def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir,mode,disk_perf,gpm_dir):
-	if verbose: print "Computing Maths"
+	if verbose: print("Computing Maths")
 	global_min=[]
 	global_max=[]
 	average_file=open(gnuplot_output_dir+gnuplot_output_filename+'.average', 'w')
@@ -243,14 +248,14 @@ def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir
 	max_file.write('DiskName %s\n'% mode)
 	average_file.write('DiskName %s\n'% mode)
 	stddev_file.write('DiskName %s\n'% mode )
-	for disk in xrange(len(fio_data_file)):
+	for disk in range(len(fio_data_file)):
 #		print disk_perf[disk]
 	    	min_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
 	    	max_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
 	    	average_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
 	    	stddev_file.write("# Disk%d was coming from %s\n" % (disk,fio_data_file[disk]))
 		avg  = average(disk_perf[disk])
-		variance = map(lambda x: (x - avg)**2, disk_perf[disk])
+		variance = [(x - avg)**2 for x in disk_perf[disk]]
 		standard_deviation = math.sqrt(average(variance))
 #		print "Disk%d [ min=%.2f max=%.2f avg=%.2f stddev=%.2f \n" % (disk,min(disk_perf[disk]),max(disk_perf[disk]),avg, standard_deviation)
 		average_file.write('%d %d\n' % (disk, avg))
@@ -264,7 +269,7 @@ def compute_math(fio_data_file, title,gnuplot_output_filename,gnuplot_output_dir
 
 	global_disk_perf = sum(disk_perf, [])
 	avg  = average(global_disk_perf)
-	variance = map(lambda x: (x - avg)**2, global_disk_perf)
+	variance = [(x - avg)**2 for x in global_disk_perf]
 	standard_deviation = math.sqrt(average(variance))
 
 	global_file.write('min=%.2f\n' % min(global_disk_perf))
@@ -331,52 +336,52 @@ def parse_global_files(fio_data_file, global_search):
 					max_file=file
 	# Let's print the avg output
 	if global_search == "avg":
-		print "Biggest aggregated value of %s was %2.f in file %s\n" % (global_search, max_result, max_file)
+		print("Biggest aggregated value of %s was %2.f in file %s\n" % (global_search, max_result, max_file))
 	else:
-		print "Global search %s is not yet implemented\n" % global_search
+		print("Global search %s is not yet implemented\n" % global_search)
 
 def render_gnuplot(fio_data_file, gnuplot_output_dir):
-	print "Running gnuplot Rendering"
+	print("Running gnuplot Rendering")
 	try:
 		# Let's render all the compared files if some
 		if len(fio_data_file) > 1:
-			if verbose: print " |-> Rendering comparing traces"
+			if verbose: print(" |-> Rendering comparing traces")
 			os.system("cd %s; for i in *.gnuplot; do gnuplot $i; done" % gnuplot_output_dir)
-		if verbose: print " |-> Rendering math traces"
+		if verbose: print(" |-> Rendering math traces")
 		os.system("cd %s; gnuplot mymath" % gnuplot_output_dir)
-		if verbose: print " |-> Rendering 2D & 3D traces"
+		if verbose: print(" |-> Rendering 2D & 3D traces")
 		os.system("cd %s; gnuplot mygraph" % gnuplot_output_dir)
 
 		name_of_directory="the current"
 		if gnuplot_output_dir != "./":
 			name_of_directory=gnuplot_output_dir
-		print "\nRendering traces are available in %s directory" % name_of_directory
+		print("\nRendering traces are available in %s directory" % name_of_directory)
 		global keep_temp_files
 		keep_temp_files=False
 	except:
-		print "Could not run gnuplot on mymath or mygraph !\n"
+		print("Could not run gnuplot on mymath or mygraph !\n")
 		sys.exit(1);
 
 def print_help():
-    print 'fio2gnuplot -ghbiodvk -t <title> -o <outputfile> -p <pattern> -G <type> -m <time> -M <time>'
-    print
-    print '-h --help                           : Print this help'
-    print '-p <pattern> or --pattern <pattern> : A glob pattern to select fio input files'
-    print '-b           or --bandwidth         : A predefined pattern for selecting *_bw.log files'
-    print '-i           or --iops              : A predefined pattern for selecting *_iops.log files'
-    print '-g           or --gnuplot           : Render gnuplot traces before exiting'
-    print '-o           or --outputfile <file> : The basename for gnuplot traces'
-    print '                                       - Basename is set with the pattern if defined'
-    print '-d           or --outputdir <dir>   : The directory where gnuplot shall render files'
-    print '-t           or --title <title>     : The title of the gnuplot traces'
-    print '                                       - Title is set with the block size detected in fio traces'
-    print '-G           or --Global <type>     : Search for <type> in .global files match by a pattern'
-    print '                                       - Available types are : min, max, avg, stddev'
-    print '                                       - The .global extension is added automatically to the pattern'
-    print '-m           or --min_time <time>   : Only consider data starting from <time> seconds (default is 0)'
-    print '-M           or --max_time <time>   : Only consider data ending before <time> seconds (default is -1 aka nolimit)'
-    print '-v           or --verbose           : Increasing verbosity'
-    print '-k           or --keep              : Keep all temporary files from gnuplot\'s output dir'
+    print('fio2gnuplot -ghbiodvk -t <title> -o <outputfile> -p <pattern> -G <type> -m <time> -M <time>')
+    print()
+    print('-h --help                           : Print this help')
+    print('-p <pattern> or --pattern <pattern> : A glob pattern to select fio input files')
+    print('-b           or --bandwidth         : A predefined pattern for selecting *_bw.log files')
+    print('-i           or --iops              : A predefined pattern for selecting *_iops.log files')
+    print('-g           or --gnuplot           : Render gnuplot traces before exiting')
+    print('-o           or --outputfile <file> : The basename for gnuplot traces')
+    print('                                       - Basename is set with the pattern if defined')
+    print('-d           or --outputdir <dir>   : The directory where gnuplot shall render files')
+    print('-t           or --title <title>     : The title of the gnuplot traces')
+    print('                                       - Title is set with the block size detected in fio traces')
+    print('-G           or --Global <type>     : Search for <type> in .global files match by a pattern')
+    print('                                       - Available types are : min, max, avg, stddev')
+    print('                                       - The .global extension is added automatically to the pattern')
+    print('-m           or --min_time <time>   : Only consider data starting from <time> seconds (default is 0)')
+    print('-M           or --max_time <time>   : Only consider data ending before <time> seconds (default is -1 aka nolimit)')
+    print('-v           or --verbose           : Increasing verbosity')
+    print('-k           or --keep              : Keep all temporary files from gnuplot\'s output dir')
 
 def main(argv):
     mode='unknown'
@@ -403,14 +408,14 @@ def main(argv):
     if not os.path.isfile(gpm_dir+'math.gpm'):
 	    gpm_dir="/usr/local/share/fio/"
     	    if not os.path.isfile(gpm_dir+'math.gpm'):
-		    print "Looks like fio didn't get installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n"
+		    print("Looks like fio didn't get installed properly as no gpm files found in '/usr/share/fio' or '/usr/local/share/fio'\n")
 		    sys.exit(3)
 
     try:
 	    opts, args = getopt.getopt(argv[1:],"ghkbivo:d:t:p:G:m:M:",['bandwidth', 'iops', 'pattern', 'outputfile', 'outputdir', 'title', 'min_time', 'max_time', 'gnuplot', 'Global', 'help', 'verbose','keep'])
     except getopt.GetoptError:
-	 print "Error: One of the options passed to the cmdline was not supported"
-	 print "Please fix your command line or read the help (-h option)"
+	 print("Error: One of the options passed to the cmdline was not supported")
+	 print("Please fix your command line or read the help (-h option)")
          sys.exit(2)
 
     for opt, arg in opts:
@@ -457,7 +462,7 @@ def main(argv):
 
     fio_data_file=find_file('.',pattern)
     if len(fio_data_file) == 0:
-	    print "No log file found with pattern %s!" % pattern
+	    print("No log file found with pattern %s!" % pattern)
 	    # Try numjob log file format if per_numjob_logs=1
             if (pattern == '*_bw.log'):
                 fio_data_file=find_file('.','*_bw.*.log')
@@ -466,13 +471,13 @@ def main(argv):
             if len(fio_data_file) == 0:
                 sys.exit(1)
             else:
-                print "Using log file per job format instead"
+                print("Using log file per job format instead")
     else:
-	    print "%d files Selected with pattern '%s'" % (len(fio_data_file), pattern)
+	    print("%d files Selected with pattern '%s'" % (len(fio_data_file), pattern))
 
     fio_data_file=sorted(fio_data_file, key=str.lower)
     for file in fio_data_file:
-	print ' |-> %s' % file
+	print(' |-> %s' % file)
 	if "_bw.log" in file :
 		mode="Bandwidth (KB/sec)"
 	if "_iops.log" in file :
@@ -483,7 +488,7 @@ def main(argv):
 	    if "IO" in mode:
 		    title='IO benchmark with %d fio results' % len(fio_data_file)
 
-    print
+    print()
     #We need to adjust the output filename regarding the pattern required by the user
     if (pattern_set_by_user == True):
 	    gnuplot_output_filename=pattern
@@ -514,9 +519,9 @@ def main(argv):
 	# Shall we clean the temporary files ?
 	if keep_temp_files==False and force_keep_temp_files==False:
 	    	# Cleaning temporary files
-		if verbose: print "Cleaning temporary files"
+		if verbose: print("Cleaning temporary files")
 		for f in enumerate(temporary_files):
-		    	if verbose: print " -> %s"%f[1]
+			if verbose: print(" -> %s"%f[1])
 			try:
 			    os.remove(f[1])
 			except:
-- 
2.17.0

