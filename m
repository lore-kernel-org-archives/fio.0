Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 4/5] docs: improve terse output format documentation
Date: Wed, 15 May 2019 16:05:02 -0400
Message-Id: <20190515200503.23000-5-vincentfu@gmail.com>
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
References: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Fix up some details and note client/server mode differences.
---
 HOWTO | 12 +++++++++++-
 fio.1 | 11 ++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 4fd4da14..142b83e5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3693,7 +3693,8 @@ is one long line of values, such as::
     2;card0;0;0;7139336;121836;60004;1;10109;27.932460;116.933948;220;126861;3495.446807;1085.368601;226;126864;3523.635629;1089.012448;24063;99944;50.275485%;59818.274627;5540.657370;7155060;122104;60004;1;8338;29.086342;117.839068;388;128077;5032.488518;1234.785715;391;128085;5061.839412;1236.909129;23436;100928;50.287926%;59964.832030;5644.844189;14.595833%;19.394167%;123706;0;7313;0.1%;0.1%;0.1%;0.1%;0.1%;0.1%;100.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.01%;0.02%;0.05%;0.16%;6.04%;40.40%;52.68%;0.64%;0.01%;0.00%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%
     A description of this job goes here.
 
-The job description (if provided) follows on a second line.
+The job description (if provided) follows on a second line for terse v2.
+It appears on the same line for other terse versions.
 
 To enable terse output, use the :option:`--minimal` or
 :option:`--output-format`\=terse command line options. The
@@ -3778,6 +3779,11 @@ minimal output v3, separated by semicolons::
 
         terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
+In client/server mode terse output differs from what appears when jobs are run
+locally. Disk utilization data is omitted from the standard terse output and
+for v3 and later appears on its own separate line at the end of each terse
+reporting cycle.
+
 
 JSON output
 ------------
@@ -4056,6 +4062,7 @@ is recorded. Each *data direction* seen within the window period will aggregate
 its values in a separate row. Further, when using windowed logging the *block
 size* and *offset* entries will always contain 0.
 
+
 Client/Server
 -------------
 
@@ -4143,3 +4150,6 @@ containing two hostnames ``h1`` and ``h2`` with IP addresses 192.168.10.120 and
 
 	/mnt/nfs/fio/192.168.10.120.fileio.tmp
 	/mnt/nfs/fio/192.168.10.121.fileio.tmp
+
+Terse output in client/server mode will differ slightly from what is produced
+when fio is run in stand-alone mode. See the terse output section for details.
diff --git a/fio.1 b/fio.1
index 2708b503..84b80eee 100644
--- a/fio.1
+++ b/fio.1
@@ -3330,7 +3330,8 @@ is one long line of values, such as:
 		A description of this job goes here.
 .fi
 .P
-The job description (if provided) follows on a second line.
+The job description (if provided) follows on a second line for terse v2.
+It appears on the same line for other terse versions.
 .P
 To enable terse output, use the \fB\-\-minimal\fR or
 `\-\-output\-format=terse' command line options. The
@@ -3465,6 +3466,11 @@ minimal output v3, separated by semicolons:
 .nf
 		terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 .fi
+.P
+In client/server mode terse output differs from what appears when jobs are run
+locally. Disk utilization data is omitted from the standard terse output and
+for v3 and later appears on its own separate line at the end of each terse
+reporting cycle.
 .SH JSON OUTPUT
 The \fBjson\fR output format is intended to be both human readable and convenient
 for automated parsing. For the most part its sections mirror those of the
@@ -3859,6 +3865,9 @@ containing two hostnames `h1' and `h2' with IP addresses 192.168.10.120 and
 /mnt/nfs/fio/192.168.10.121.fileio.tmp
 .PD
 .RE
+.P
+Terse output in client/server mode will differ slightly from what is produced
+when fio is run in stand-alone mode. See the terse output section for details.
 .SH AUTHORS
 .B fio
 was written by Jens Axboe <axboe@kernel.dk>.
-- 
2.17.1


