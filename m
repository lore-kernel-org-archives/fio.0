Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47621A426
	for <fio@vger.kernel.org>; Wed,  7 May 2025 12:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746619240; cv=none; b=EGvirHzVca8VMyZA7z1BsGkXPgrR40xU6zo7wt+DzQhen9KOxJPvgV0lV6cywxn11qfoIHDJQ/S39/k780UL5yz5qSjguqUK8UlWcWd/ZPHJUw7VoKVDc/pkNbuK0alXhA4HTuQDOzXS6vJsfXmoDZpexzEz46vIwkxmy0HqPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746619240; c=relaxed/simple;
	bh=N9UdTBiQbF7FVqwMgq43GLU42O1Dx1pWogyB1yx2zQE=;
	h=Subject:From:To:Message-Id:Date; b=BUae7NC+qdE5ftGDm1VjQidRal+x8FfkAExNRL5b4kY30pQ5eAMSociB8in+vIAlEBgjrJccdIbbb4HzoPpNUeQ3YfapNhbZxotPukJCWpo92miuurj7fhnfyPbh6N//TjEVRob8JOuoegHI3Jtg2kQU18M/r5E8iySqKLaSw4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dLuNpVZf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dLuNpVZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZtWwGJm1V7Kc+PvL3KSvbkbDmsVYeA8kT9uy6MkPmsI=; b=dLuNpVZfJok+BJRXhTdKann8ku
	DlqEZnK3bd6iZ9JjGhxtG62v5kTxKS6JBzVfZWrKuEYeSliKFdZNOa4PyPXrRwk+jCPRqimt1TXF8
	riii+tsN/X9nFYp4mKEECiTiWu7lm6y4svsvHyZFKp6tnG8pJzzyA2plqX8xmQu0gEc9BmB4nCQqR
	eWXZkKJlppsfyKZlP1mNYiE1hz5H2XWbiMecNRC5LzpNZ0q46sYD5IKmya1/xPg2UYQ4xCNQlr2iH
	9mx+pe3cY6Dtvou1UWh/XBTY9g7U/eXF2A30mdPU2/3UuPo3gwzeEv7I4tS7Ovd3Y54/8aYa5CJIZ
	NFnPoVQA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCdRo-00000004B41-1fD1
	for fio@vger.kernel.org;
	Wed, 07 May 2025 12:00:26 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 629621BC0166; Wed,  7 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250507120001.629621BC0166@kernel.dk>
Date: Wed,  7 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 19d9ef1e091a78ad651703d19c07886cb5dfd302:

  Merge branch 'master' of https://github.com/blah325/fio (2025-04-15 19:02:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4dc6c8da6ed938f12a42f167839100ab551ae8d1:

  t/zbd: add run-tests-against-scsi_debug (2025-05-07 05:28:47 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (8):
      oslib: blkzoned: add blkzoned_move_zone_wp() helper function
      ioengine: add move_zone_wp() callback
      engines/libzbc: implement move_zone_wp callback
      zbd: introduce zbd_move_zone_wp()
      zbd: add the recover_zbd_write_error option
      t/zbd: set badblocks related parameters in run-tests-against-nullb
      t/zbd: add the test cases to confirm continue_on_error option
      t/zbd: add run-tests-against-scsi_debug

 HOWTO.rst                          |  11 +++
 cconv.c                            |   2 +
 engines/libzbc.c                   |  28 ++++++
 fio.1                              |   9 ++
 io_u.c                             |   5 +
 io_u.h                             |   3 +-
 ioengines.c                        |   2 +-
 ioengines.h                        |   4 +-
 options.c                          |  10 ++
 oslib/blkzoned.h                   |   3 +
 oslib/linux-blkzoned.c             |  29 ++++++
 server.h                           |   2 +-
 t/zbd/run-tests-against-nullb      |   3 +
 t/zbd/run-tests-against-scsi_debug |  33 +++++++
 t/zbd/test-zbd-support             | 185 +++++++++++++++++++++++++++++++++++++
 thread_options.h                   |   2 +
 zbd.c                              | 162 +++++++++++++++++++++++++++++++-
 zbd.h                              |  12 ++-
 18 files changed, 494 insertions(+), 11 deletions(-)
 create mode 100755 t/zbd/run-tests-against-scsi_debug

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index bde3496e..a7e2f693 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1126,6 +1126,17 @@ Target file/device
 	requests. This and the previous parameter can be used to simulate
 	garbage collection activity.
 
+.. option:: recover_zbd_write_error=bool
+
+	If this option is specified together with the option
+	:option:`continue_on_error`, check the write pointer positions after the
+	failed writes to sequential write required zones. Then move the write
+	pointers so that the next writes do not fail due to partial writes and
+	unexpected write pointer positions. If :option:`continue_on_error` is
+	not specified, errors out. When the writes are asynchronous, the write
+	pointer move fills blocks with zero then breaks verify data. If an
+	asynchronous IO engine and :option:`verify` workload are specified,
+	errors out. Default: false.
 
 I/O type
 ~~~~~~~~
diff --git a/cconv.c b/cconv.c
index df841703..cc1a52c7 100644
--- a/cconv.c
+++ b/cconv.c
@@ -265,6 +265,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->max_open_zones = __le32_to_cpu(top->max_open_zones);
 	o->ignore_zone_limits = le32_to_cpu(top->ignore_zone_limits);
+	o->recover_zbd_write_error = le32_to_cpu(top->recover_zbd_write_error);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment_percent = le32_to_cpu(top->offset_increment_percent);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
@@ -637,6 +638,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zone_mode = __cpu_to_le32(o->zone_mode);
 	top->max_open_zones = __cpu_to_le32(o->max_open_zones);
 	top->ignore_zone_limits = cpu_to_le32(o->ignore_zone_limits);
+	top->recover_zbd_write_error = cpu_to_le32(o->recover_zbd_write_error);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/engines/libzbc.c b/engines/libzbc.c
index 1bf1e8c8..0fa6bfd1 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -323,6 +323,33 @@ err:
 	return -ret;
 }
 
+static int libzbc_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			       struct zbd_zone *z, uint64_t length,
+			       const char *buf)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = z->wp >> 9;
+	size_t count = length >> 9;
+	struct zbc_errno err;
+	int ret;
+
+	assert(ld);
+	assert(ld->zdev);
+	assert(buf);
+
+	ret = zbc_pwrite(ld->zdev, buf, count, sector);
+	if (ret == count)
+		return 0;
+
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_write for write pointer move failed");
+	if (err.sk)
+		log_err("%s: wp move failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
 static int libzbc_finish_zone(struct thread_data *td, struct fio_file *f,
 			      uint64_t offset, uint64_t length)
 {
@@ -457,6 +484,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model	= libzbc_get_zoned_model,
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
+	.move_zone_wp		= libzbc_move_zone_wp,
 	.get_max_open_zones	= libzbc_get_max_open_zones,
 	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
diff --git a/fio.1 b/fio.1
index 0ea239b8..8476b681 100644
--- a/fio.1
+++ b/fio.1
@@ -890,6 +890,15 @@ A number between zero and one that indicates how often a zone reset should be
 issued if the zone reset threshold has been exceeded. A zone reset is
 submitted after each (1 / zone_reset_frequency) write requests. This and the
 previous parameter can be used to simulate garbage collection activity.
+.BI recover_zbd_write_error \fR=\fPbool
+If this option is specified together with the option \fBcontinue_on_error\fR,
+check the write pointer positions after the failed writes to sequential write
+required zones. Then move the write pointers so that the next writes do not
+fail due to partial writes and unexpected write pointer positions. If
+\fBcontinue_on_error\fR is not specified, errors out. When the writes are
+asynchronous, the write pointer move fills blocks with zero then breaks verify
+data. If an asynchronous IO engine and \fBverify\fR workload are specified,
+errors out. Default: false.
 
 .SS "I/O type"
 .TP
diff --git a/io_u.c b/io_u.c
index 17f5e853..70a11837 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2102,6 +2102,11 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	assert(io_u->flags & IO_U_F_FLIGHT);
 	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK | IO_U_F_PATTERN_DONE);
 
+	if (td->o.zone_mode == ZONE_MODE_ZBD && td->o.recover_zbd_write_error &&
+	    io_u->error && io_u->ddir == DDIR_WRITE &&
+	    !td_ioengine_flagged(td, FIO_SYNCIO))
+		zbd_recover_write_error(td, io_u);
+
 	/*
 	 * Mark IO ok to verify
 	 */
diff --git a/io_u.h b/io_u.h
index 22ae6ed4..178c1229 100644
--- a/io_u.h
+++ b/io_u.h
@@ -111,8 +111,7 @@ struct io_u {
 	 * @success == true means that the I/O operation has been queued or
 	 * completed successfully.
 	 */
-	void (*zbd_queue_io)(struct thread_data *td, struct io_u *, int q,
-			     bool success);
+	void (*zbd_queue_io)(struct thread_data *td, struct io_u *, int *q);
 
 	/*
 	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
diff --git a/ioengines.c b/ioengines.c
index dcd4164d..05d01a0f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -386,7 +386,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
-	zbd_queue_io_u(td, io_u, ret);
+	zbd_queue_io_u(td, io_u, &ret);
 
 	unlock_file(td, io_u->file);
 
diff --git a/ioengines.h b/ioengines.h
index 1531cd89..bd5d189c 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	36
+#define FIO_IOOPS_VERSION	37
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -60,6 +60,8 @@ struct ioengine_ops {
 			    uint64_t, struct zbd_zone *, unsigned int);
 	int (*reset_wp)(struct thread_data *, struct fio_file *,
 			uint64_t, uint64_t);
+	int (*move_zone_wp)(struct thread_data *, struct fio_file *,
+			    struct zbd_zone *, uint64_t, const char *);
 	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
 				  unsigned int *);
 	int (*get_max_active_zones)(struct thread_data *, struct fio_file *,
diff --git a/options.c b/options.c
index 416bc91c..71c97e9e 100644
--- a/options.c
+++ b/options.c
@@ -3794,6 +3794,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name	= "recover_zbd_write_error",
+		.lname	= "Recover write errors when zonemode=zbd is set",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, recover_zbd_write_error),
+		.def	= 0,
+		.help	= "Continue writes for sequential write required zones after recovering write errors with care for partial write pointer move",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name   = "fdp",
 		.lname  = "Flexible data placement",
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index e598bd4f..3a4c73c2 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -16,6 +16,9 @@ extern int blkzoned_report_zones(struct thread_data *td,
 				struct zbd_zone *zones, unsigned int nr_zones);
 extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
+extern int blkzoned_move_zone_wp(struct thread_data *td, struct fio_file *f,
+				 struct zbd_zone *z, uint64_t length,
+				 const char *buf);
 extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 				       unsigned int *max_open_zones);
 extern int blkzoned_get_max_active_zones(struct thread_data *td,
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 1cc8d288..78e25fca 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -370,3 +370,32 @@ int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
 
 	return ret;
 }
+
+int blkzoned_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			  struct zbd_zone *z, uint64_t length, const char *buf)
+{
+	int fd, ret = 0;
+
+	/* If the file is not yet open, open it for this function */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_WRONLY | O_DIRECT);
+		if (fd < 0)
+			return -errno;
+	}
+
+	/* If write data is not provided, fill zero to move the write pointer */
+	if (!buf) {
+		ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, z->wp, length);
+		goto out;
+	}
+
+	if (pwrite(fd, buf, length, z->wp) < 0)
+		ret = -errno;
+
+out:
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
+}
diff --git a/server.h b/server.h
index e5968112..0b93cd02 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 109,
+	FIO_SERVER_VER			= 110,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 97d29966..f1cba355 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -91,6 +91,9 @@ configure_nullb()
 		fi
 	fi
 
+	[[ -w badblocks_once ]] && echo 1 > badblocks_once
+	[[ -w badblocks_partial_io ]] && echo 1 > badblocks_partial_io
+
 	echo 1 > power || return $?
 	return 0
 }
diff --git a/t/zbd/run-tests-against-scsi_debug b/t/zbd/run-tests-against-scsi_debug
new file mode 100755
index 00000000..b50d7a24
--- /dev/null
+++ b/t/zbd/run-tests-against-scsi_debug
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2020 Western Digital Corporation or its affiliates.
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# A couple of test cases in t/zbd/test-zbd-support script depend on the error
+# injection feature of scsi_debug. Prepare a zoned scsi_debug device and run
+# only for the test cases.
+
+declare dev sg scriptdir
+
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+
+modprobe -qr scsi_debug
+modprobe scsi_debug add_host=1 zbc=host-managed zone_nr_conv=0
+
+dev=$(dmesg | tail -5 | grep "Attached SCSI disk" | grep -Po ".* \[\Ksd[a-z]*")
+
+if ! grep -qe scsi_debug /sys/block/"${dev}"/device/vpd_pg83; then
+	echo "Failed to create scsi_debug device"
+	exit 1
+fi
+
+sg=$(echo /sys/block/"${dev}"/device/scsi_generic/*)
+sg=${sg##*/}
+
+echo standard engine:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 /dev/"${dev}"
+echo libzbc engine with block device:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 -l /dev/"${dev}"
+echo libzbc engine with sg node:
+"${scriptdir}"/test-zbd-support -t 72 -t 73 -l /dev/"${sg}"
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0278ac17..40f1de90 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -60,6 +60,17 @@ get_dev_path_by_id() {
 	return 1
 }
 
+get_scsi_device_path() {
+	local dev="${1}"
+	local syspath
+
+	syspath=/sys/block/"${dev##*/}"/device
+	if [[ -r /sys/class/scsi_generic/"${dev##*/}"/device ]]; then
+		syspath=/sys/class/scsi_generic/"${dev##*/}"/device
+	fi
+	realpath "$syspath"
+}
+
 dm_destination_dev_set_io_scheduler() {
 	local dev=$1 sched=$2
 	local dest_dev_id dest_dev path
@@ -354,6 +365,49 @@ require_no_max_active_zones() {
 	return 0
 }
 
+require_badblock() {
+	local syspath sdebug_path
+
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -d "${syspath}" ]]; then
+		if [[ ! -w "${syspath}/badblocks" ]]; then
+			SKIP_REASON="$dev does not have badblocks attribute"
+			return 1
+		fi
+		if [[ ! -w "${syspath}/badblocks_once" ]]; then
+			SKIP_REASON="$dev does not have badblocks_once attribute"
+			return 1
+		fi
+		if ((! $(<"${syspath}/badblocks_once"))); then
+			SKIP_REASON="badblocks_once attribute is not set for $dev"
+			return 1
+		fi
+		return 0
+	fi
+
+	syspath=$(get_scsi_device_path "$dev")
+	if [[ -r ${syspath}/model &&
+		      $(<"${syspath}"/model) =~ scsi_debug ]]; then
+		sdebug_path=/sys/kernel/debug/scsi_debug/${syspath##*/}
+		if [[ ! -w "$sdebug_path"/error ]]; then
+			SKIP_REASON="$dev does not have write error injection"
+			return 1
+		fi
+		return 0
+	fi
+
+	SKIP_REASON="$dev does not support either badblocks or error injection"
+	return 1
+}
+
+require_nullb() {
+	if [[ ! -d /sys/kernel/config/nullb/"${dev##*/}" ]]; then
+		SKIP_REASON="$dev is not null_blk"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -1685,6 +1739,137 @@ test71() {
 	check_written $((zone_size * 8)) || return $?
 }
 
+set_nullb_badblocks() {
+	local syspath
+
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -w $syspath/badblocks ]]; then
+		echo "$1" > "$syspath"/badblocks
+	fi
+
+	return 0
+}
+
+# The helper function to set up badblocks or error command and echo back
+# number of expected failures. If the device is null_blk, set the errors
+# at the sectors based of 1st argument (offset) and 2nd argument (gap).
+# If the device is scsi_debug, set the first write commands to fail.
+set_badblocks() {
+	local off=$(($1 / 512))
+	local gap=$(($2 / 512))
+	local syspath block scsi_dev
+
+	# null_blk
+	syspath=/sys/kernel/config/nullb/"${dev##*/}"
+	if [[ -d ${syspath} ]]; then
+		block=$((off + 2))
+		set_nullb_badblocks "+${block}-${block}"
+		block=$((off + gap + 11))
+		set_nullb_badblocks "+${block}-${block}"
+		block=$((off + gap*2 + 8))
+		set_nullb_badblocks "+${block}-${block}"
+
+		echo 3
+		return
+	fi
+
+	# scsi_debug
+	scsi_dev=$(get_scsi_device_path "$dev")
+	syspath=/sys/kernel/debug/scsi_debug/"${scsi_dev##*/}"/
+	echo 2 -1 0x8a 0x00 0x00 0x02 0x03 0x11 0x02 > "$syspath"/error
+
+	echo 1
+}
+
+# Single job sequential sync write to sequential zones, with continue_on_error
+test72() {
+	local size off capacity bs expected_errors
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	expected_errors=$(set_badblocks "$off" "$zone_size")
+	size=$((4 * zone_size))
+	capacity=$((size - bs * expected_errors))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --offset="$off" \
+		       --size="$size" --bs="$bs" --do_verify=1 --verify=md5 \
+		       --continue_on_error=1 --recover_zbd_write_error=1 \
+		       --ignore_error=,EIO:61 --debug=zbd \
+		       >>"${logfile}.${test_number}" 2>&1 || return $?
+	check_written "$capacity" || return $?
+	grep -qe "Write pointer move succeeded" "${logfile}.${test_number}"
+}
+
+# Multi job sequential async write to sequential zones, with continue_on_error
+test73() {
+	local size off capacity bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" "$zone_size" > /dev/null
+	capacity=$(total_zone_capacity 4 "$off" "$dev")
+	size=$((zone_size * 4))
+	run_fio --name=w --filename="${dev}" --rw=write "$(ioengine "libaio")" \
+		--iodepth=32 --numjob=8 --group_reporting=1 --offset="$off" \
+		--size="$size" --bs="$bs" --zonemode=zbd --direct=1 \
+		--zonesize="$zone_size" --continue_on_error=1 \
+		--recover_zbd_write_error=1 --debug=zbd \
+		>>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Write pointer move succeeded" \
+	     "${logfile}.${test_number}"
+}
+
+# Single job sequential sync write to sequential zones, with continue_on_error,
+# with failures in the recovery writes.
+test74() {
+	local size off bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_nullb || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" "$((bs / 2))" > /dev/null
+	size=$((4 * zone_size))
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --offset="$off" \
+		       --size="$size" --bs="$bs" --continue_on_error=1 \
+		       --recover_zbd_write_error=1 --ignore_error=,EIO:61 \
+		       >>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Failed to recover write pointer" "${logfile}.${test_number}"
+}
+
+# Multi job sequential async write to sequential zones, with continue_on_error
+# with failures in the recovery writes.
+test75() {
+	local size off bs
+
+	require_zbd || return "$SKIP_TESTCASE"
+	require_nullb || return "$SKIP_TESTCASE"
+	require_badblock || return "$SKIP_TESTCASE"
+
+	prep_write
+	off=$((first_sequential_zone_sector * 512))
+	bs=$(min "$(max $((zone_size / 64)) "$min_seq_write_size")" "$zone_cap_bs")
+	set_badblocks "$off" $((bs / 2)) > /dev/null
+	size=$((zone_size * 4))
+	run_fio --name=w --filename="${dev}" --rw=write "$(ioengine "libaio")" \
+		--iodepth=32 --numjob=8 --group_reporting=1 --offset="$off" \
+		--size="$size" --bs="$bs" --zonemode=zbd --direct=1 \
+		--zonesize="$zone_size" --continue_on_error=1 \
+		--recover_zbd_write_error=1 --debug=zbd \
+		>>"${logfile}.${test_number}" 2>&1 || return $?
+	grep -qe "Failed to recover write pointer" "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/thread_options.h b/thread_options.h
index d25ba891..b0094651 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -390,6 +390,7 @@ struct thread_options {
 	int max_open_zones;
 	unsigned int job_max_open_zones;
 	unsigned int ignore_zone_limits;
+	unsigned int recover_zbd_write_error;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
@@ -710,6 +711,7 @@ struct thread_options_pack {
 	uint32_t zone_mode;
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
+	uint32_t recover_zbd_write_error;
 
 	uint32_t log_entries;
 	uint32_t log_prio;
diff --git a/zbd.c b/zbd.c
index 89519234..8f0e4bc6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -442,6 +442,46 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	return res;
 }
 
+/**
+ * zbd_move_zone_wp - move the write pointer of a zone by writing the data in
+ *               the specified buffer
+ * @td: FIO thread data.
+ * @f: FIO file for which to move write pointer
+ * @z: Target zone to move the write pointer
+ * @length: Length of the move
+ * @buf: Buffer which holds the data to write
+ *
+ * Move the write pointer at the specified offset by writing the data
+ * in the specified buffer.
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+static int zbd_move_zone_wp(struct thread_data *td, struct fio_file *f,
+			    struct zbd_zone *z, uint64_t length,
+			    const char *buf)
+{
+	int ret = 0;
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		if (td->io_ops && td->io_ops->move_zone_wp)
+			ret = td->io_ops->move_zone_wp(td, f, z, length, buf);
+		else
+			ret = blkzoned_move_zone_wp(td, f, z, length, buf);
+		break;
+	default:
+		break;
+	}
+
+	if (ret < 0) {
+		td_verror(td, errno, "move wp failed");
+		log_err("%s: moving wp for %"PRIu64" sectors at sector %"PRIu64" failed (%d).\n",
+			f->file_name, length >> 9, z->wp >> 9, errno);
+	}
+
+	return ret;
+}
+
 /**
  * zbd_get_max_open_zones - Get the maximum number of open zones
  * @td: FIO thread data
@@ -1227,6 +1267,18 @@ int zbd_setup_files(struct thread_data *td)
 	if (!zbd_verify_bs())
 		return 1;
 
+	if (td->o.recover_zbd_write_error && td_write(td)) {
+		if (!td->o.continue_on_error) {
+			log_err("recover_zbd_write_error works only when continue_on_error is set\n");
+			return 1;
+		}
+		if (td->o.verify != VERIFY_NONE &&
+		    !td_ioengine_flagged(td, FIO_SYNCIO)) {
+			log_err("recover_zbd_write_error for async IO engines does not support verify\n");
+			return 1;
+		}
+	}
+
 	if (td->o.experimental_verify) {
 		log_err("zonemode=zbd does not support experimental verify\n");
 		return 1;
@@ -1770,11 +1822,11 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
  * For write and trim operations, update the write pointer of the I/O unit
  * target zone.
  */
-static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
-			 bool success)
+static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int *q)
 {
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
+	bool success = io_u->error == 0;
 	struct fio_zone_info *z;
 	uint64_t zone_end;
 
@@ -1783,6 +1835,14 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 	z = zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
 
+	if (!success && td->o.recover_zbd_write_error &&
+	    io_u->ddir == DDIR_WRITE && td_ioengine_flagged(td, FIO_SYNCIO) &&
+	    *q == FIO_Q_COMPLETED) {
+		zbd_recover_write_error(td, io_u);
+		if (!io_u->error)
+			success = true;
+	}
+
 	if (!success)
 		goto unlock;
 
@@ -1810,11 +1870,19 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		break;
 	}
 
-	if (q == FIO_Q_COMPLETED && !io_u->error)
+	if (*q == FIO_Q_COMPLETED && !io_u->error)
 		zbd_end_zone_io(td, io_u, z);
 
 unlock:
-	if (!success || q != FIO_Q_QUEUED) {
+	if (!success || *q != FIO_Q_QUEUED) {
+		if (io_u->ddir == DDIR_WRITE) {
+			z->writes_in_flight--;
+			if (z->writes_in_flight == 0 && z->fixing_zone_wp) {
+				dprint(FD_ZBD, "%s: Fixed write pointer of the zone %u\n",
+				       f->file_name, zbd_zone_idx(f, z));
+				z->fixing_zone_wp = 0;
+			}
+		}
 		/* BUSY or COMPLETED: unlock the zone */
 		zone_unlock(z);
 		io_u->zbd_put_io = NULL;
@@ -1841,6 +1909,15 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 
 	zbd_end_zone_io(td, io_u, z);
 
+	if (io_u->ddir == DDIR_WRITE) {
+		z->writes_in_flight--;
+		if (z->writes_in_flight == 0 && z->fixing_zone_wp) {
+			z->fixing_zone_wp = 0;
+			dprint(FD_ZBD, "%s: Fixed write pointer of the zone %u\n",
+			       f->file_name, zbd_zone_idx(f, z));
+		}
+	}
+
 	zone_unlock(z);
 }
 
@@ -2031,8 +2108,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
+retry_lock:
 	zone_lock(td, f, zb);
 
+	if (!td_ioengine_flagged(td, FIO_SYNCIO) && zb->fixing_zone_wp) {
+		zone_unlock(zb);
+		io_u_quiesce(td);
+		goto retry_lock;
+	}
+
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td))
@@ -2239,6 +2323,8 @@ accept:
 
 	io_u->zbd_queue_io = zbd_queue_io;
 	io_u->zbd_put_io = zbd_put_io;
+	if (io_u->ddir == DDIR_WRITE)
+		zb->writes_in_flight++;
 
 	/*
 	 * Since we return with the zone lock still held,
@@ -2310,3 +2396,71 @@ void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
 		log_err("%s: Exceeded max_active_zones limit. Check conditions of zones out of I/O ranges.\n",
 			f->file_name);
 }
+
+void zbd_recover_write_error(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_zone_info *z;
+	struct zbd_zone zrep;
+	unsigned long long retry_offset;
+	unsigned long long retry_len;
+	char *retry_buf;
+	uint64_t write_end_offset;
+	int ret;
+
+	z = zbd_offset_to_zone(f, io_u->offset);
+	if (!z->has_wp)
+		return;
+	write_end_offset = io_u->offset + io_u->buflen - z->start;
+
+	assert(z->writes_in_flight);
+
+	if (!z->fixing_zone_wp) {
+		z->fixing_zone_wp = 1;
+		dprint(FD_ZBD, "%s: Start fixing %u write pointer\n",
+		       f->file_name, zbd_zone_idx(f, z));
+	}
+
+	if (z->max_write_error_offset < write_end_offset)
+		z->max_write_error_offset = write_end_offset;
+
+	if (z->writes_in_flight > 1)
+		return;
+
+	/*
+	 * This is the last write to the zone since the write error to recover.
+	 * Get the zone current write pointer and recover the write pointer
+	 * position so that next write can continue.
+	 */
+	ret = zbd_report_zones(td, f, z->start, &zrep, 1);
+	if (ret != 1) {
+		log_info("fio: Report zone for write recovery failed for %s\n",
+			 f->file_name);
+		return;
+	}
+
+	if (zrep.wp < z->start ||
+	    z->start + z->max_write_error_offset < zrep.wp ) {
+		log_info("fio: unexpected write pointer position on error for %s: wp=%"PRIu64"\n",
+			 f->file_name, zrep.wp);
+		return;
+	}
+
+	retry_offset = zrep.wp;
+	retry_len = z->start + z->max_write_error_offset - retry_offset;
+	retry_buf = NULL;
+	if (retry_offset >= io_u->offset)
+		retry_buf = (char *)io_u->buf + (retry_offset - io_u->offset);
+
+	ret = zbd_move_zone_wp(td, io_u->file, &zrep, retry_len, retry_buf);
+	if (ret) {
+		log_info("fio: Failed to recover write pointer for %s\n",
+			 f->file_name);
+		return;
+	}
+
+	z->wp = retry_offset + retry_len;
+
+	dprint(FD_ZBD, "%s: Write pointer move succeeded for error=%d\n",
+	       f->file_name, io_u->error);
+}
diff --git a/zbd.h b/zbd.h
index 5750a0b8..14204316 100644
--- a/zbd.h
+++ b/zbd.h
@@ -25,6 +25,9 @@ enum io_u_action {
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
  * @capacity: maximum size usable from the start of a zone (bytes)
+ * @writes_in_flight: number of writes in flight fo the zone
+ * @max_write_error_offset: maximum offset from zone start among the failed
+ *                          writes to the zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
@@ -32,17 +35,21 @@ enum io_u_action {
  * @write: whether or not this zone is the write target at this moment. Only
  *              relevant if zbd->max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
+ * @fixing_zone_wp: whether or not the write pointer of this zone is under fix
  */
 struct fio_zone_info {
 	pthread_mutex_t		mutex;
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		capacity;
+	uint32_t		writes_in_flight;
+	uint32_t		max_write_error_offset;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		has_wp:1;
 	unsigned int		write:1;
 	unsigned int		reset_zone:1;
+	unsigned int		fixing_zone_wp:1;
 };
 
 /**
@@ -106,6 +113,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
 int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
 void zbd_log_err(const struct thread_data *td, const struct io_u *io_u);
+void zbd_recover_write_error(struct thread_data *td, struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
@@ -114,10 +122,10 @@ static inline void zbd_close_file(struct fio_file *f)
 }
 
 static inline void zbd_queue_io_u(struct thread_data *td, struct io_u *io_u,
-				  enum fio_q_status status)
+				  enum fio_q_status *status)
 {
 	if (io_u->zbd_queue_io) {
-		io_u->zbd_queue_io(td, io_u, status, io_u->error == 0);
+		io_u->zbd_queue_io(td, io_u, (int *)status);
 		io_u->zbd_queue_io = NULL;
 	}
 }
