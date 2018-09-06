Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbeIFQfY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Sep 2018 12:35:24 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fxsxM-0006qi-2W
        for fio@vger.kernel.org; Thu, 06 Sep 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180906120002.1612B2C00A8@kernel.dk>
Date: Thu,  6 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 53ee8c17adb00e3db4f2c9441777ba777390cb9f:

  engines/sg: improve error handling (2018-09-03 09:01:14 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f111f76c0e6687c0cc6fc562cb902e4a64e42b37:

  Merge branch 'master' of https://github.com/damien-lemoal/fio (2018-09-05 19:25:39 -0600)

----------------------------------------------------------------
Damien Le Moal (5):
      zbd: Fix test scripts
      zbd: Improve read randomness
      zbd: Remove inexistent functions declaration
      zbd: Fix zbd_zone_idx()
      zbd: Use bytes unit

Jens Axboe (4):
      Document oddity with --status-interval and --output-format=json
      Merge branch 'sz/log-names-need-help' of https://github.com/szaydel/fio
      init: move log name generation into helper
      Merge branch 'master' of https://github.com/damien-lemoal/fio

Rebecca Cran (1):
      Windows: update download URL and add missing examples

Sam Zaydel (1):
      Log files names start with _ when write_XX_log= keys in config file have empty value(s)

 HOWTO                                 |   5 +-
 fio.1                                 |   5 +-
 init.c                                |  20 ++++-
 os/windows/examples.wxs               |  90 ++++++++++++++++++--
 os/windows/install.wxs                |   2 +-
 t/zbd/run-tests-against-regular-nullb |   4 +-
 t/zbd/run-tests-against-zoned-nullb   |   4 +-
 zbd.c                                 | 149 +++++++++++++++++++---------------
 zbd.h                                 |  12 ---
 9 files changed, 196 insertions(+), 95 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 7bbd589..0c5b710 100644
--- a/HOWTO
+++ b/HOWTO
@@ -194,7 +194,10 @@ Command line options
 	Force a full status dump of cumulative (from job start) values at `time`
 	intervals. This option does *not* provide per-period measurements. So
 	values such as bandwidth are running averages. When the time unit is omitted,
-	`time` is interpreted in seconds.
+	`time` is interpreted in seconds. Note that using this option with
+	``--output-format=json`` will yield output that technically isn't valid
+	json, since the output will be collated sets of valid json. It will need
+	to be split into valid sets of json after the run.
 
 .. option:: --section=name
 
diff --git a/fio.1 b/fio.1
index b555b20..593f4db 100644
--- a/fio.1
+++ b/fio.1
@@ -93,7 +93,10 @@ the value is interpreted in seconds.
 Force a full status dump of cumulative (from job start) values at \fItime\fR
 intervals. This option does *not* provide per-period measurements. So
 values such as bandwidth are running averages. When the time unit is omitted,
-\fItime\fR is interpreted in seconds.
+\fItime\fR is interpreted in seconds. Note that using this option with
+`\-\-output-format=json' will yield output that technically isn't valid json,
+since the output will be collated sets of valid json. It will need to be split
+into valid sets of json after the run.
 .TP
 .BI \-\-section \fR=\fPname
 Only run specified section \fIname\fR in job file. Multiple sections can be specified.
diff --git a/init.c b/init.c
index b925b4c..09f58a3 100644
--- a/init.c
+++ b/init.c
@@ -1419,6 +1419,17 @@ static bool wait_for_ok(const char *jobname, struct thread_options *o)
 }
 
 /*
+ * Treat an empty log file name the same as a one not given
+ */
+static const char *make_log_name(const char *logname, const char *jobname)
+{
+	if (logname && strcmp(logname, ""))
+		return logname;
+
+	return jobname;
+}
+
+/*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
  * members of td.
@@ -1542,7 +1553,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
-		const char *pre = o->lat_log_file ? o->lat_log_file : o->name;
+		const char *pre = make_log_name(o->lat_log_file, o->name);
 		const char *suf;
 
 		if (p.log_gz_store)
@@ -1561,6 +1572,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		gen_log_name(logname, sizeof(logname), "clat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_log, &p, logname);
+
 	}
 
 	if (o->write_hist_log) {
@@ -1574,7 +1586,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
-		const char *pre = o->hist_log_file ? o->hist_log_file : o->name;
+		const char *pre = make_log_name(o->hist_log_file, o->name);
 		const char *suf;
 
 #ifndef CONFIG_ZLIB
@@ -1605,7 +1617,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
-		const char *pre = o->bw_log_file ? o->bw_log_file : o->name;
+		const char *pre = make_log_name(o->bw_log_file, o->name);
 		const char *suf;
 
 		if (fio_option_is_set(o, bw_avg_time))
@@ -1636,7 +1648,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
-		const char *pre = o->iops_log_file ? o->iops_log_file : o->name;
+		const char *pre = make_log_name(o->iops_log_file, o->name);
 		const char *suf;
 
 		if (fio_option_is_set(o, iops_avg_time))
diff --git a/os/windows/examples.wxs b/os/windows/examples.wxs
index cc2ff5c..e8580d9 100755
--- a/os/windows/examples.wxs
+++ b/os/windows/examples.wxs
@@ -3,16 +3,22 @@
     <Fragment>
         <DirectoryRef Id="examples">
                 <Component>
-                    <File Source="..\..\examples\1mbs_clients.fio" />
+                  <File Source="..\..\examples\1mbs_clients.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\aio-read.fio" />
+                  <File Source="..\..\examples\aio-read.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\backwards-read.fio" />
+                  <File Source="..\..\examples\backwards-read.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\basic-verify.fio" />
+                  <File Source="..\..\examples\basic-verify.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\butterfly.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\cpp_null.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\cpuio.fio" />
@@ -21,7 +27,7 @@
                   <File Source="..\..\examples\dev-dax.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\disk-zone-profile.fio" />
+                  <File Source="..\..\examples\disk-zone-profile.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\e4defrag.fio" />
@@ -36,13 +42,37 @@
                   <File Source="..\..\examples\falloc.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\filecreate-ioengine.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-read.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-RW.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-rand-write.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-read.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-RW.job" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\fio-seq-write.job" />
+                </Component>
+                <Component>
                   <File Source="..\..\examples\fixed-rate-submission.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\flow.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\fsx.fio" />
+                  <File Source="..\..\examples\fsx.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\ftruncate.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\fusion-aw-sync.fio" />
@@ -51,7 +81,25 @@
                   <File Source="..\..\examples\gfapi.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\iometer-file-access-server.fio" />
+                  <File Source="..\..\examples\gpudirect-rdmaio-client.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\gpudirect-rdmaio-server.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-s3.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-swift.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\http-webdav.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\ime.fio" />
+                </Component>
+                <Component>
+                  <File Source="..\..\examples\iometer-file-access-server.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\jesd219.fio" />
@@ -63,13 +111,16 @@
                   <File Source="..\..\examples\libhdfs.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\libpmem.fio" />
+                </Component>
+                <Component>
                   <File Source="..\..\examples\mtd.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\netio.fio" />
+                  <File Source="..\..\examples\netio.fio" />
                 </Component>
                 <Component>
-                    <File Source="..\..\examples\netio_multicast.fio" />
+                  <File Source="..\..\examples\netio_multicast.fio" />
                 </Component>
                 <Component>
                   <File Source="..\..\examples\null.fio" />
@@ -84,6 +135,9 @@
                   <File Source="..\..\examples\poisson-rate-submission.fio" />
                 </Component>
                 <Component>
+                  <File Source="..\..\examples\rados.fio" />
+                </Component>
+                <Component>
                   <File Source="..\..\examples\rand-zones.fio" />
                 </Component>
                 <Component>
@@ -124,6 +178,8 @@
             <ComponentRef Id="aio_read.fio" />
             <ComponentRef Id="backwards_read.fio" />
             <ComponentRef Id="basic_verify.fio" />
+            <ComponentRef Id="butterfly.fio"/>
+            <ComponentRef Id="cpp_null.fio"/>
             <ComponentRef Id="cpuio.fio" />
             <ComponentRef Id="dev_dax.fio" />
             <ComponentRef Id="disk_zone_profile.fio" />
@@ -131,15 +187,30 @@
             <ComponentRef Id="e4defrag2.fio" />
             <ComponentRef Id="enospc_pressure.fio" />
             <ComponentRef Id="falloc.fio" />
+            <ComponentRef Id="filecreate_ioengine.fio"/>
+            <ComponentRef Id="fio_rand_read.job"/>
+            <ComponentRef Id="fio_rand_RW.job"/>
+            <ComponentRef Id="fio_rand_write.job"/>
+            <ComponentRef Id="fio_seq_read.job"/>
+            <ComponentRef Id="fio_seq_RW.job"/>
+            <ComponentRef Id="fio_seq_write.job"/>
             <ComponentRef Id="fixed_rate_submission.fio" />
             <ComponentRef Id="flow.fio" />
             <ComponentRef Id="fsx.fio" />
+            <ComponentRef Id="ftruncate.fio"/>
             <ComponentRef Id="fusion_aw_sync.fio" />
             <ComponentRef Id="gfapi.fio" />
+            <ComponentRef Id="gpudirect_rdmaio_client.fio"/>
+            <ComponentRef Id="gpudirect_rdmaio_server.fio"/>
+            <ComponentRef Id="http_s3.fio"/>
+            <ComponentRef Id="http_swift.fio"/>
+            <ComponentRef Id="http_webdav.fio"/>
+            <ComponentRef Id="ime.fio"/>
             <ComponentRef Id="iometer_file_access_server.fio" />
             <ComponentRef Id="jesd219.fio" />
             <ComponentRef Id="latency_profile.fio" />
             <ComponentRef Id="libhdfs.fio" />
+            <ComponentRef Id="libpmem.fio"/>
             <ComponentRef Id="mtd.fio" />
             <ComponentRef Id="netio.fio" />
             <ComponentRef Id="netio_multicast.fio" />
@@ -147,6 +218,7 @@
             <ComponentRef Id="numa.fio" />
             <ComponentRef Id="pmemblk.fio" />
             <ComponentRef Id="poisson_rate_submission.fio" />
+            <ComponentRef Id="rados.fio"/>
             <ComponentRef Id="rand_zones.fio" />
             <ComponentRef Id="rbd.fio" />
             <ComponentRef Id="rdmaio_client.fio" />
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 73b2810..97d88e9 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -61,7 +61,7 @@
 	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/cgit/fio/" />
 	<Property Id='ARPCONTACT'>fio@vger.kernel.org</Property>
 	<Property Id='ARPHELPLINK'>http://www.spinics.net/lists/fio/</Property>
-	<Property Id='ARPURLUPDATEINFO'>http://bluestop.org/fio/</Property>
+	<Property Id='ARPURLUPDATEINFO'>https://bluestop.org/fio/</Property>
 
 	<WixVariable Id="WixUILicenseRtf" Value="eula.rtf" />
 
diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
index 133c7c4..0f6e4b6 100755
--- a/t/zbd/run-tests-against-regular-nullb
+++ b/t/zbd/run-tests-against-regular-nullb
@@ -4,6 +4,8 @@
 #
 # This file is released under the GPL.
 
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || return $?
@@ -22,4 +24,4 @@ modprobe null_blk nr_devices=0 &&
     echo 1 > memory_backed &&
     echo 1 > power
 
-"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
+"${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 7d9eb43..9336716 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -4,6 +4,8 @@
 #
 # This file is released under the GPL.
 
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || return $?
@@ -24,4 +26,4 @@ modprobe null_blk nr_devices=0 &&
     echo 1 > memory_backed &&
     echo 1 > power
 
-"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
+"${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/zbd.c b/zbd.c
index 5619769..0f3636a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -31,10 +31,10 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 {
 	uint32_t zone_idx;
 
-	if (f->zbd_info->zone_size_log2)
+	if (f->zbd_info->zone_size_log2 > 0)
 		zone_idx = offset >> f->zbd_info->zone_size_log2;
 	else
-		zone_idx = (offset >> 9) / f->zbd_info->zone_size;
+		zone_idx = offset / f->zbd_info->zone_size;
 
 	return min(zone_idx, f->zbd_info->nr_zones);
 }
@@ -53,7 +53,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 	assert((required & 511) == 0);
 
 	return z->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
-		z->wp + (required >> 9) > z->start + f->zbd_info->zone_size;
+		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
@@ -121,8 +121,8 @@ static bool zbd_verify_sizes(void)
 				continue;
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
-			if (f->file_offset != (z->start << 9)) {
-				new_offset = (z+1)->start << 9;
+			if (f->file_offset != z->start) {
+				new_offset = (z+1)->start;
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
@@ -136,7 +136,7 @@ static bool zbd_verify_sizes(void)
 			}
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
 			z = &f->zbd_info->zone_info[zone_idx];
-			new_end = z->start << 9;
+			new_end = z->start;
 			if (f->file_offset + f->io_size != new_end) {
 				if (new_end <= f->file_offset) {
 					log_info("%s: io_size must be at least one zone\n",
@@ -168,10 +168,10 @@ static bool zbd_verify_bs(void)
 			zone_size = f->zbd_info->zone_size;
 			for (k = 0; k < ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
-				    (zone_size << 9) % td->o.bs[k] != 0) {
+				    zone_size % td->o.bs[k] != 0) {
 					log_info("%s: block size %llu is not a divisor of the zone size %d\n",
 						 f->file_name, td->o.bs[k],
-						 zone_size << 9);
+						 zone_size);
 					return false;
 				}
 			}
@@ -273,9 +273,9 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	pthread_mutexattr_t attr;
 	int i;
 
-	zone_size = td->o.zone_size >> 9;
+	zone_size = td->o.zone_size;
 	assert(zone_size);
-	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
 	if (!zbd_info)
@@ -300,7 +300,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) + 9 : -1;
+		ilog2(zone_size) : -1;
 	f->zbd_info->nr_zones = nr_zones;
 	pthread_mutexattr_destroy(&attr);
 	return 0;
@@ -351,20 +351,20 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto close;
 	}
 	z = (void *)(hdr + 1);
-	zone_size = z->len;
-	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+	zone_size = z->len << 9;
+	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 
 	if (td->o.zone_size == 0) {
-		td->o.zone_size = zone_size << 9;
-	} else if (td->o.zone_size != zone_size << 9) {
+		td->o.zone_size = zone_size;
+	} else if (td->o.zone_size != zone_size) {
 		log_info("fio: %s job parameter zonesize %lld does not match disk zone size %ld.\n",
-			 f->file_name, td->o.zone_size, zone_size << 9);
+			 f->file_name, td->o.zone_size, zone_size);
 		ret = -EINVAL;
 		goto close;
 	}
 
 	dprint(FD_ZBD, "Device %s has %d zones of size %lu KB\n", f->file_name,
-	       nr_zones, zone_size / 2);
+	       nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -378,18 +378,18 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		z = (void *)(hdr + 1);
 		for (i = 0; i < hdr->nr_zones; i++, j++, z++, p++) {
 			pthread_mutex_init(&p->mutex, &attr);
-			p->start = z->start;
+			p->start = z->start << 9;
 			switch (z->cond) {
 			case BLK_ZONE_COND_NOT_WP:
-				p->wp = z->start;
+				p->wp = p->start;
 				break;
 			case BLK_ZONE_COND_FULL:
-				p->wp = z->start + zone_size;
+				p->wp = p->start + zone_size;
 				break;
 			default:
 				assert(z->start <= z->wp);
-				assert(z->wp <= z->start + zone_size);
-				p->wp = z->wp;
+				assert(z->wp <= z->start + (zone_size >> 9));
+				p->wp = z->wp << 9;
 				break;
 			}
 			p->type = z->type;
@@ -413,12 +413,12 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		}
 	}
 	/* a sentinel */
-	zbd_info->zone_info[nr_zones].start = start_sector;
+	zbd_info->zone_info[nr_zones].start = start_sector << 9;
 
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) + 9 : -1;
+		ilog2(zone_size) : -1;
 	f->zbd_info->nr_zones = nr_zones;
 	zbd_info = NULL;
 	ret = 0;
@@ -556,18 +556,18 @@ int zbd_init(struct thread_data *td)
  * Returns 0 upon success and a negative error code upon failure.
  */
 static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
-			   uint64_t sector, uint64_t nr_sectors)
+			   uint64_t offset, uint64_t length)
 {
 	struct blk_zone_range zr = {
-		.sector         = sector,
-		.nr_sectors     = nr_sectors,
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
 	};
 	uint32_t zone_idx_b, zone_idx_e;
 	struct fio_zone_info *zb, *ze, *z;
 	int ret = 0;
 
 	assert(f->fd != -1);
-	assert(is_valid_offset(f, ((sector + nr_sectors) << 9) - 1));
+	assert(is_valid_offset(f, offset + length - 1));
 	switch (f->zbd_info->model) {
 	case ZBD_DM_HOST_AWARE:
 	case ZBD_DM_HOST_MANAGED:
@@ -583,9 +583,9 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 		break;
 	}
 
-	zone_idx_b = zbd_zone_idx(f, sector << 9);
+	zone_idx_b = zbd_zone_idx(f, offset);
 	zb = &f->zbd_info->zone_info[zone_idx_b];
-	zone_idx_e = zbd_zone_idx(f, (sector + nr_sectors) << 9);
+	zone_idx_e = zbd_zone_idx(f, offset + length);
 	ze = &f->zbd_info->zone_info[zone_idx_e];
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
@@ -635,7 +635,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const ze, bool all_zones)
 {
 	struct fio_zone_info *z, *start_z = ze;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE] >> 9;
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 	bool reset_wp;
 	int res = 0;
 
@@ -921,7 +921,7 @@ struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	/* Both z->mutex and f->zbd_info->mutex are held. */
 
 examine_zone:
-	if ((z->wp << 9) + min_bs <= ((z+1)->start << 9)) {
+	if (z->wp + min_bs <= (z+1)->start) {
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
@@ -938,12 +938,12 @@ examine_zone:
 		zone_idx++;
 		pthread_mutex_unlock(&z->mutex);
 		z++;
-		if (!is_valid_offset(f, z->start << 9)) {
+		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
-		assert(is_valid_offset(f, z->start << 9));
+		assert(is_valid_offset(f, z->start));
 		pthread_mutex_lock(&z->mutex);
 		if (z->open)
 			continue;
@@ -963,7 +963,7 @@ examine_zone:
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		pthread_mutex_lock(&z->mutex);
-		if ((z->wp << 9) + min_bs <= ((z+1)->start << 9))
+		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
@@ -976,7 +976,7 @@ examine_zone:
 out:
 	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
 	       zone_idx);
-	io_u->offset = z->start << 9;
+	io_u->offset = z->start;
 	return z;
 }
 
@@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
 		log_err("%s: %d * %d >= %ld\n", f->file_name, z->verify_block,
 			min_bs, f->zbd_info->zone_size);
-	io_u->offset = (z->start << 9) + z->verify_block++ * min_bs;
+	io_u->offset = z->start + z->verify_block++ * min_bs;
 	return z;
 }
 
@@ -1026,7 +1026,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != BLK_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z1->mutex);
-			if (z1->start + (min_bs >> 9) <= z1->wp)
+			if (z1->start + min_bs <= z1->wp)
 				return z1;
 			pthread_mutex_unlock(&z1->mutex);
 		} else if (!td_random(td)) {
@@ -1035,7 +1035,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != BLK_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z2->mutex);
-			if (z2->start + (min_bs >> 9) <= z2->wp)
+			if (z2->start + min_bs <= z2->wp)
 				return z2;
 			pthread_mutex_unlock(&z2->mutex);
 		}
@@ -1066,7 +1066,7 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 		return;
 
 	zone_idx = zbd_zone_idx(io_u->file, io_u->offset);
-	end = (io_u->offset + io_u->buflen) >> 9;
+	end = io_u->offset + io_u->buflen;
 	z = &zbd_info->zone_info[zone_idx];
 	assert(zone_idx < zbd_info->nr_zones);
 	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
@@ -1119,7 +1119,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
 	const struct fio_file *f = io_u->file;
 	uint32_t zone_idx_b;
-	struct fio_zone_info *zb, *zl;
+	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
 	uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	uint64_t new_len;
@@ -1132,6 +1132,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);
 	zb = &f->zbd_info->zone_info[zone_idx_b];
+	orig_zb = zb;
 
 	/* Accept the I/O offset for conventional zones. */
 	if (zb->type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -1153,21 +1154,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		/*
-		 * Avoid reads past the write pointer because such reads do not
-		 * hit the medium.
+		 * Check that there is enough written data in the zone to do an
+		 * I/O of at least min_bs B. If there isn't, find a new zone for
+		 * the I/O.
 		 */
 		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
-			((zb->wp - zb->start) << 9) - io_u->buflen : 0;
-		if (td_random(td) && range >= 0) {
-			io_u->offset = (zb->start << 9) +
-				((io_u->offset - (zb->start << 9)) %
-				 (range + 1)) / min_bs * min_bs;
-			assert(zb->start << 9 <= io_u->offset);
-			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
-			goto accept;
-		}
-		if (zb->cond == BLK_ZONE_COND_OFFLINE ||
-		    (io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+			zb->wp - zb->start : 0;
+		if (range < min_bs ||
+		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			pthread_mutex_unlock(&zb->mutex);
 			zl = &f->zbd_info->zone_info[zbd_zone_idx(f,
 						f->file_offset + f->io_size)];
@@ -1179,17 +1173,42 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				       io_u->buflen);
 				goto eof;
 			}
-			io_u->offset = zb->start << 9;
+			/*
+			 * zbd_find_zone() returned a zone with a range of at
+			 * least min_bs.
+			 */
+			range = zb->wp - zb->start;
+			assert(range >= min_bs);
+
+			if (!td_random(td))
+				io_u->offset = zb->start;
 		}
-		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
-			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
-			       f->file_name, io_u->offset, io_u->buflen,
-			       zb->wp);
-			goto eof;
+		/*
+		 * Make sure the I/O is within the zone valid data range while
+		 * maximizing the I/O size and preserving randomness.
+		 */
+		if (range <= io_u->buflen)
+			io_u->offset = zb->start;
+		else if (td_random(td))
+			io_u->offset = zb->start +
+				((io_u->offset - orig_zb->start) %
+				 (range - io_u->buflen)) / min_bs * min_bs;
+		/*
+		 * Make sure the I/O does not cross over the zone wp position.
+		 */
+		new_len = min((unsigned long long)io_u->buflen,
+			      (unsigned long long)(zb->wp - io_u->offset));
+		new_len = new_len / min_bs * min_bs;
+		if (new_len < io_u->buflen) {
+			io_u->buflen = new_len;
+			dprint(FD_IO, "Changed length from %u into %llu\n",
+			       orig_len, io_u->buflen);
 		}
+		assert(zb->start <= io_u->offset);
+		assert(io_u->offset + io_u->buflen <= zb->wp);
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > (f->zbd_info->zone_size << 9))
+		if (io_u->buflen > f->zbd_info->zone_size)
 			goto eof;
 		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
 			pthread_mutex_unlock(&zb->mutex);
@@ -1201,7 +1220,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
 			check_swd(td, f);
-			if ((f->zbd_info->sectors_with_data << 9) >=
+			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone = 1;
@@ -1225,7 +1244,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
-		io_u->offset = zb->wp << 9;
+		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
 			dprint(FD_ZBD, "Dropped request with offset %llu\n",
 			       io_u->offset);
@@ -1237,7 +1256,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * small.
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
-			      ((zb + 1)->start << 9) - io_u->offset);
+			      (zb + 1)->start - io_u->offset);
 		new_len = new_len / min_bs * min_bs;
 		if (new_len == io_u->buflen)
 			goto accept;
@@ -1248,7 +1267,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			(((zb + 1)->start << 9) - io_u->offset),
+			((zb + 1)->start - io_u->offset),
 			min_bs);
 		goto eof;
 	case DDIR_TRIM:
diff --git a/zbd.h b/zbd.h
index 08751fd..d750b67 100644
--- a/zbd.h
+++ b/zbd.h
@@ -95,8 +95,6 @@ int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
-int zbd_do_trim(struct thread_data *td, const struct io_u *io_u);
-void zbd_update_wp(struct thread_data *td, const struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 #else
 static inline void zbd_free_zone_info(struct fio_file *f)
@@ -123,16 +121,6 @@ static inline enum io_u_action zbd_adjust_block(struct thread_data *td,
 	return io_u_accept;
 }
 
-static inline int zbd_do_trim(struct thread_data *td, const struct io_u *io_u)
-{
-	return 1;
-}
-
-static inline void zbd_update_wp(struct thread_data *td,
-				 const struct io_u *io_u)
-{
-}
-
 static inline char *zbd_write_status(const struct thread_stat *ts)
 {
 	return NULL;

