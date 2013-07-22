Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:61284 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3GVRqv (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 13:46:51 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 0DDB4380BE
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 19:46:49 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 085D3126CC0F
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 19:46:49 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PKRdDdLKjSbm for <fio@vger.kernel.org>;
	Mon, 22 Jul 2013 19:46:43 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 54C313C81421
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 19:46:43 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PDgdLXLHK1D6 for <fio@vger.kernel.org>;
	Mon, 22 Jul 2013 19:46:37 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 7A5E7126CC0F
	for <fio@vger.kernel.org>; Mon, 22 Jul 2013 19:46:37 +0200 (CEST)
Message-ID: <51ED6FFC.2070309@enovance.com>
Date: Mon, 22 Jul 2013 19:46:36 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull Request] Fixing coherency in fio2gnuplot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
Sorry to make many pull request in a row but I just discover a serious 
problem when plotting multiple traces at the same time. It was in fact 
shortening the plots & rendering to the smallest trace file.

This bug is pretty boring and this patch series does fix it.
The branch is on top the current master, shall be easy to merge ;o)

Thanks,
Erwan

--------

The following changes since commit 21356fee2727b71ef72b39414955c5e7e98f97c1:

   net: Add UDP multicast example job file (2013-07-22 09:04:38 -0600)

are available in the git repository at:

   git@github.com:enovance/fio.git fix_coherency

for you to fetch changes up to d7e30e61f2c1d9c6101cc6896009750aae2e2bcf:

   fio2gnuplot: Don't plot fake data (2013-07-22 19:39:24 +0200)

----------------------------------------------------------------
Erwan Velu (3):
       fio2gnuplot: Keep original filename in temp. files
       fio2gnuplot: Don't truncate fio log files
       fio2gnuplot: Don't plot fake data

  tools/plot/fio2gnuplot.py | 20 ++++++++++++++++----
  1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/plot/fio2gnuplot.py b/tools/plot/fio2gnuplot.py
index ef32ee0..03ef0dd 100755
--- a/tools/plot/fio2gnuplot.py
+++ b/tools/plot/fio2gnuplot.py
@@ -91,17 +91,26 @@ def compute_temp_file(fio_data_file,disk_perf):
          files.append(open(file))
          pos = len(files) - 1
          tmp_filename = "gnuplot_temp_file.%d" % pos
-        temp_outfile.append(open(tmp_filename,'w'))
+        gnuplot_file=open(tmp_filename,'w')
+        temp_outfile.append(gnuplot_file)
+        gnuplot_file.write("#Temporary file based on file %s\n" % file)
          disk_perf.append([])

      shall_break = False
      while True:
          current_line=[]
+        nb_empty_files=0
+        nb_files=len(files)
          for file in files:
              s=file.readline().replace(',',' ').split()
              if not s:
+                nb_empty_files+=1
+                s="-1, 0, 0, 0'".replace(',',' ').split()
+
+            if (nb_empty_files == nb_files):
                  shall_break=True
                  break;
+
              current_line.append(s);

          if shall_break == True:
@@ -117,14 +126,17 @@ def compute_temp_file(fio_data_file,disk_perf):

              # We ignore the first 500msec as it doesn't seems to be 
part of the real benchmark
              # Time < 500 usually reports BW=0 breaking the min computing
-            if ((int(time)) > 500):
+            if (((int(time)) > 500) or (int(time)==-1)):
                  disk_perf[index].append(int(perf))
-                perfs.append(perf)
+                perfs.append("%s %s"% (time, perf))
                  index = index + 1

          # If we reach this point, it means that all the traces are 
coherent
          for p in enumerate(perfs):
-            temp_outfile[p[0]].write("%s %.2f %s\n" % (p[0], 
float(float(time)/1000), p[1]))
+            perf_time,perf = p[1].split()
+            if (perf_time != "-1"):
+                temp_outfile[p[0]].write("%s %.2f %s\n" % (p[0], 
float(float(perf_time)/1000), perf))
+

      for file in files:
          file.close()

