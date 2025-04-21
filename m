Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7B264FA7
	for <fio@vger.kernel.org>; Mon, 21 Apr 2025 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745239122; cv=none; b=aZUxwwlbMCCqoNESSkzYuAU8/fqlVTnHeZjce2d81qx4CD6Ty3Lc6ApOKsQ6kKxXk+NNEkIAN5Ag0vRz6iTD8j9A8AsiMyQXWvQuVCPiQBO4sSfT0MzVHARXUzCuNqSoOrO000XttBRRlX+f2WLf6IxJcKgux+90G1d1PLpKsNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745239122; c=relaxed/simple;
	bh=DZzAJ0uJbslTICReTGkIj6C4KOkx2mFeoWK0N4wkSHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhWhbLYNAaIAFcJW9EE1eyEfDfF6vV8rw406Ugy1KCJnuQLilKh/0yC6wZ22CLYFItPm5uJ/ljVlPh8RVsLpF9TVfM2tz4IjQMIflC/sG8+F/teh0gB+fKdqjRj7Q/2SspHiYpavETM39PN/Lwn5zcZ9PsoO2IClyaoQRMjgUrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NcxVFbz7; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NcxVFbz7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745239119; x=1776775119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DZzAJ0uJbslTICReTGkIj6C4KOkx2mFeoWK0N4wkSHY=;
  b=NcxVFbz7TWfd1BrPl51xga5o+FUXL0F/Mm95TsjvNX5oqR3pEeRLHqrG
   tQOw5TJPK7822XXmnsh7SgiTFJWarNfitc8Bpvq1eY/Xsj+diMAq0eE3h
   ENrdjYS+FFPoBAn+Ba1DPcRKGJlr0xJjkBOiSfR7Tq5LQjSlszZkn0u75
   7ESWdZPHhf9R/I5B9pNXa20Wks+zozYPZ7fmKjLQpyFSWSXmSqOtUiC4y
   9VZI97jfEKsAImjoQDd3gQkdMpudNj7crHY+WRjrX0UH97So6zQFtE8h9
   Wdv4Q5aWYA1yzHMRfOiZEWiYRuE54IWCBGV8uiOigf5yGPdwT348yJ2Qg
   A==;
X-CSE-ConnectionGUID: 58MHIWWKROychZS8TNRLdQ==
X-CSE-MsgGUID: gSaWwFCCST6XGWo7MVKu8Q==
X-IronPort-AV: E=Sophos;i="6.15,228,1739808000"; 
   d="scan'208";a="76027523"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2025 20:38:35 +0800
IronPort-SDR: 68062e35_5gGNrYrnwfKWaZKWCdrQO7UsRoB1wS8NxBJhLGpajqGvc5s
 msllW/MKxBFXE6vpGaLxHHAUqyJTWL9gQdRF4Cw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2025 04:38:29 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Apr 2025 05:38:34 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/8] zbd: add the recover_zbd_write_error option
Date: Mon, 21 Apr 2025 21:38:25 +0900
Message-ID: <20250421123828.82712-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the continue_on_error options is specified, it is expected that the
workload continues to run when non-critical errors happen. However,
write workloads with zonemode=zbd option can not continue after errors,
if the failed writes cause partial data write on the target device. This
partial write creates write pointer gap between the device and fio, then
the next write requests by fio will fail due to unaligned write command
errors. This restriction results in undesirable test stops during long
runs for SMR drives which can recover defect sectors.

To allow the write workloads with zonemode=zbd to continue after write
failures with partial data writes, introduce the new option
recover_zbd_write_error. When this option is specified together with the
continue_on_error option, fio checks the write pointer positions of the
write target zones in the error handling step. Then fix the write
pointer by moving it to the position that the failed writes would have
moved. Bump up FIO_SERVER_VER to note that the new option is added.

For that purpose, add a new function zbd_recover_write_error(). Call it
from zbd_queue_io() for sync IO engines, and from io_completed() for
async IO engines. Modify zbd_queue_io() to pass the pointer to the
status so that zbd_recover_write_error() can modify the status to ignore
the errors. Add three fields to struct fio_zone_info. The two new fields
writes_in_flight and max_write_error_offset track status of in-flight
writes at the write error, so that the write pointer positions can be
fixed after the in-flight writes completed. The field fixing_zone_wp
stores that the write pointer fix is ongoing, then prohibit the new
writes get issued to the zone.

When the failed write is synchronous, the write pointer fix is done by
writing the left data for the failed write. This keeps the verify
patterns written to the device, then verify works together with the
continue_on_zbd_write_error option. When the failed write is
asynchronous, other in-flight writes fail together. In this case, fio
waits for all in-flight writes complete then fix the write pointer. Then
verify data of the failed writes are lost and verify does not work.
Check the continue_on_zbd_write_error option is not specified together
with the verify workload and asynchronous IO engine.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst        |  11 +++++
 fio.1            |   9 ++++
 io_u.c           |   5 ++
 io_u.h           |   3 +-
 ioengines.c      |   2 +-
 options.c        |  10 ++++
 server.h         |   2 +-
 thread_options.h |   2 +
 zbd.c            | 122 +++++++++++++++++++++++++++++++++++++++++++++--
 zbd.h            |  12 ++++-
 10 files changed, 168 insertions(+), 10 deletions(-)

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
index 61770575..8f0e4bc6 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1267,6 +1267,18 @@ int zbd_setup_files(struct thread_data *td)
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
@@ -1810,11 +1822,11 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
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
 
@@ -1823,6 +1835,14 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
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
 
@@ -1850,11 +1870,19 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
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
@@ -1881,6 +1909,15 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 
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
 
@@ -2071,8 +2108,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
@@ -2279,6 +2323,8 @@ accept:
 
 	io_u->zbd_queue_io = zbd_queue_io;
 	io_u->zbd_put_io = zbd_put_io;
+	if (io_u->ddir == DDIR_WRITE)
+		zb->writes_in_flight++;
 
 	/*
 	 * Since we return with the zone lock still held,
@@ -2350,3 +2396,71 @@ void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
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
-- 
2.49.0

