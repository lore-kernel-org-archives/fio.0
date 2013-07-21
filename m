Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:13775 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3GUKCF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 21 Jul 2013 06:02:05 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id ED97E12713
	for <fio@vger.kernel.org>; Sun, 21 Jul 2013 12:02:02 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id E95B15B3D41D
	for <fio@vger.kernel.org>; Sun, 21 Jul 2013 12:02:02 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JU3CZ5k3mpJC for <fio@vger.kernel.org>;
	Sun, 21 Jul 2013 12:02:02 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 85981780EAE
	for <fio@vger.kernel.org>; Sun, 21 Jul 2013 12:02:02 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WKMRwHquaDYZ for <fio@vger.kernel.org>;
	Sun, 21 Jul 2013 12:02:01 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id CE290780EAD
	for <fio@vger.kernel.org>; Sun, 21 Jul 2013 12:02:01 +0200 (CEST)
Message-ID: <51EBB199.80505@enovance.com>
Date: Sun, 21 Jul 2013 12:02:01 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull-Request] : Updating genfio & fio2gnuplot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4a93dec2a85f4a979421638fde2877268c470ab1:

   net: close socket on error (2013-07-20 20:41:23 -0600)

are available in the git repository at:

   tools

for you to fetch changes up to be34415aad27dc416fcd9eff076fb97cc78ebd9f:

   fio2gnuplot: Fixing Yaxis rendering for 2D plots (2013-07-21 11:58:49 
+0200)

----------------------------------------------------------------
Erwan Velu (7):
       genfio: Splitting gen_template in 2 parts
       genfio: Adding exec_{pre|post}run support
       genfio: Don't use cat EOF for small prints
       genfio: Use dynamic default values in help
       tools: Adding gitignore
       genfio: Protecting parse_cmdline from spaces
       fio2gnuplot: Fixing Yaxis rendering for 2D plots

  tools/.gitignore       |  1 +
  tools/genfio           | 51 
+++++++++++++++++++++++++++++----------------------
  tools/plot/graph2D.gpm |  2 +-
  3 files changed, 31 insertions(+), 23 deletions(-)
  create mode 100644 tools/.gitignore

diff --git a/tools/.gitignore b/tools/.gitignore
new file mode 100644
index 0000000..b25c15b
--- /dev/null
+++ b/tools/.gitignore
@@ -0,0 +1 @@
+*~
diff --git a/tools/genfio b/tools/genfio
index 6d3220d..bbf8833 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -50,21 +50,23 @@ show_help() {
                      one test after anoter but all disks at the same time
                      Enabled by default
  -D iodepth            : Run with the specified iodepth
-                    Default is 32
+                    Default is $IODEPTH
  -d disk1[,disk2,disk3,..]    : Run the tests on the selected disks
                      Separated each disk with a comma
                      Disk name shall be "sdxx", /dev/ shall NOT be used 
here
  -r seconds            : Time in seconds per benchmark
                      0 means till the end of the device
-                    Default is 300 seconds
+                    Default is $RUNTIME seconds
  -b blocksize[,blocksize1, ...]  : The blocksizes to test under fio 
format (4k, 1m, ...)
                      Separated each blocksize with a comma
-                    Default is 4k
+                    Default is $BLOCK_SIZE
  -m mode1,[mode2,mode3, ...]     : Define the fio IO profile to use 
like read, write, randread, randwrite
-                    Default is "write,randwrite,read,randread"
+                    Default is "$MODES"
  -x prefix            : Add a prefix to the fio filename
                      Useful to let a context associated with the file
                      If the prefix features a / (slash), prefix will be 
considered as a directory
+-A cmd_to_run            : System command to run after each job 
(exec_postrun in fio)
+-B cmd_to_run            : System command to run before each job 
(exec_prerun in fio)

  Example:

@@ -89,28 +91,26 @@ Estimated Time = 6000 seconds : 1 hour 40 minutes
  EOF
  }

-gen_template() {
-cat >$TEMPLATE << EOF
-[global]
-ioengine=libaio
-iodepth=$IODEPTH
-invalidate=1
-ramp_time=5
-EOF
+finish_template() {
+echo "iodepth=$IODEPTH" >> $TEMPLATE

  if [ "$RUNTIME" != "0" ]; then
-cat >>$TEMPLATE << EOF
-runtime=$RUNTIME
-time_based
-EOF
+    echo "runtime=$RUNTIME" >> $TEMPLATE
+    echo "time_based" >> $TEMPLATE
  fi

  if [ "$CACHED_IO" = "FALSE" ]; then
-cat >>$TEMPLATE << EOF
-direct=1
-EOF
+    echo "direct=1" >> $TEMPLATE
  fi
+}

+gen_template() {
+cat >$TEMPLATE << EOF
+[global]
+ioengine=libaio
+invalidate=1
+ramp_time=5
+EOF
  }

  gen_seq_suite() {
@@ -185,7 +185,7 @@ esac
  }

  parse_cmdline() {
-while getopts "hacpsd:b:r:m:x:D:" opt; do
+while getopts "hacpsd:b:r:m:x:D:A:B:" opt; do
    case $opt in
      h)
      show_help
@@ -235,6 +235,12 @@ while getopts "hacpsd:b:r:m:x:D:" opt; do
      a)
      SEQ=2
        ;;
+    B)
+    echo "exec_prerun=$OPTARG" >> $TEMPLATE
+      ;;
+    A)
+    echo "exec_postrun=$OPTARG" >> $TEMPLATE
+      ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
@@ -303,9 +309,10 @@ done


  ########## MAIN
-parse_cmdline $@
-check_mode_order
  gen_template
+parse_cmdline "$@"
+finish_template
+check_mode_order

  echo "Generating $OUTFILE"
  cp -f $TEMPLATE $OUTFILE
diff --git a/tools/plot/graph2D.gpm b/tools/plot/graph2D.gpm
index 2d0d30a..efc7ac2 100644
--- a/tools/plot/graph2D.gpm
+++ b/tools/plot/graph2D.gpm
@@ -8,7 +8,7 @@ set output '$3.png'

  #Preparing Axes
  #set logscale x
-set ytics axis out
+set ytics axis out auto
  #set data style lines
  set key top left reverse
  set xlabel "Time (Seconds)"
warn: No branch of tools is at:
warn:   be34415: fio2gnuplot: Fixing Yaxis rendering for 2D plots
warn: Are you sure you pushed 'HEAD' there?

