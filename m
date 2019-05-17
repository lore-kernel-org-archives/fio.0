Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfEQMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 May 2019 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRbWt-0004bU-2V
        for fio@vger.kernel.org; Fri, 17 May 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190517120001.DDCA02C0096@kernel.dk>
Date: Fri, 17 May 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8066f6b6177acba17f61fecb9f04d04767fb1a96:

  t/io_uring: improve EOPNOTSUPP message (2019-05-09 09:56:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5495f0b72f8fbecb97192da430720aa56f8feb9:

  stat: remove terse v2 blank lines with description not set (2019-05-16 08:42:45 -0600)

----------------------------------------------------------------
Vincent Fu (5):
      client: do not print disk utilization for terse v2
      client: handle disk util for all output formats
      client: add a newline after terse disk util
      docs: improve terse output format documentation
      stat: remove terse v2 blank lines with description not set

 HOWTO    | 12 +++++++++++-
 client.c |  9 ++++++---
 fio.1    | 11 ++++++++++-
 stat.c   |  7 ++++---
 4 files changed, 31 insertions(+), 8 deletions(-)

---

Diff of recent changes:

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
 
         terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_cla
 t_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
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
diff --git a/client.c b/client.c
index 4cbffb62..43cfbd43 100644
--- a/client.c
+++ b/client.c
@@ -1219,12 +1219,15 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		json_array_add_disk_util(&du->dus, &du->agg, du_array);
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
-	} else if (output_format & FIO_OUTPUT_TERSE)
-		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
-	else if (output_format & FIO_OUTPUT_NORMAL) {
+	}
+	if (output_format & FIO_OUTPUT_NORMAL) {
 		__log_buf(&client->buf, "\nDisk stats (read/write):\n");
 		print_disk_util(&du->dus, &du->agg, 0, &client->buf);
 	}
+	if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3) {
+		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
+		__log_buf(&client->buf, "\n");
+	}
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
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
 		terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct1
 0;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
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
diff --git a/stat.c b/stat.c
index 2bc21dad..bf87917c 100644
--- a/stat.c
+++ b/stat.c
@@ -1244,12 +1244,13 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
 		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
-	if (ver == 2)
-		log_buf(out, "\n");
 
 	/* Additional output if description is set */
-	if (strlen(ts->description))
+	if (strlen(ts->description)) {
+		if (ver == 2)
+			log_buf(out, "\n");
 		log_buf(out, ";%s", ts->description);
+	}
 
 	log_buf(out, "\n");
 }

