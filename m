Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfBXNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 24 Feb 2019 08:00:10 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gxtO4-0005R7-JG
        for fio@vger.kernel.org; Sun, 24 Feb 2019 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190224130001.D66BB2C008C@kernel.dk>
Date: Sun, 24 Feb 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3a294b8704a4125f12e3c3dec36667e68d821be0:

  options: catch division by zero in setting CPU affinity (2019-02-21 10:55:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bc596cbcdbb58b81da53a29acf1370d8a7e94429:

  t/zbd: Add multi-job libaio test (2019-02-23 21:19:01 -0700)

----------------------------------------------------------------
Damien Le Moal (4):
      t/zbd: Fix test 2 and 3 result handling
      zbd: Fix zone locking for async I/O engines
      zbd: Avoid async I/O multi-job workload deadlock
      t/zbd: Add multi-job libaio test

Dmitry Fomichev (2):
      sg: Avoid READ CAPACITY failures
      sg: Clean up handling of big endian data fields

Shin'ichiro Kawasaki (3):
      zbd: Fix partition block device handling
      t/zbd: Fix handling of partition devices
      t/zbd: Default to using blkzone tool

 engines/sg.c           | 127 ++++++++++++++++++++++++++----------------------
 io_u.c                 |  10 +---
 io_u.h                 |  17 +++++--
 ioengines.c            |   6 +--
 os/os.h                |  24 +++++++++
 t/zbd/functions        |  25 +++++++---
 t/zbd/test-zbd-support |  34 ++++++++++---
 zbd.c                  | 129 +++++++++++++++++++++++++++++++++++++++++--------
 zbd.h                  |  22 +++++++++
 9 files changed, 289 insertions(+), 105 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index 3cc068f3..d681ac93 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -137,7 +137,7 @@ struct sgio_cmd {
 };
 
 struct sgio_trim {
-	char *unmap_param;
+	uint8_t *unmap_param;
 	unsigned int unmap_range_count;
 	struct io_u **trim_io_us;
 };
@@ -157,6 +157,42 @@ struct sgio_data {
 #endif
 };
 
+static inline uint16_t sgio_get_be16(uint8_t *buf)
+{
+	return be16_to_cpu(*((uint16_t *) buf));
+}
+
+static inline uint32_t sgio_get_be32(uint8_t *buf)
+{
+	return be32_to_cpu(*((uint32_t *) buf));
+}
+
+static inline uint64_t sgio_get_be64(uint8_t *buf)
+{
+	return be64_to_cpu(*((uint64_t *) buf));
+}
+
+static inline void sgio_set_be16(uint16_t val, uint8_t *buf)
+{
+	uint16_t t = cpu_to_be16(val);
+
+	memcpy(buf, &t, sizeof(uint16_t));
+}
+
+static inline void sgio_set_be32(uint32_t val, uint8_t *buf)
+{
+	uint32_t t = cpu_to_be32(val);
+
+	memcpy(buf, &t, sizeof(uint32_t));
+}
+
+static inline void sgio_set_be64(uint64_t val, uint8_t *buf)
+{
+	uint64_t t = cpu_to_be64(val);
+
+	memcpy(buf, &t, sizeof(uint64_t));
+}
+
 static inline bool sgio_unbuffered(struct thread_data *td)
 {
 	return (td->o.odirect || td->o.sync_io);
@@ -440,25 +476,11 @@ static void fio_sgio_rw_lba(struct sg_io_hdr *hdr, unsigned long long lba,
 			    unsigned long long nr_blocks)
 {
 	if (lba < MAX_10B_LBA) {
-		hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
-		hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
-		hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
-		hdr->cmdp[5] = (unsigned char) (lba & 0xff);
-		hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be32((uint32_t) lba, &hdr->cmdp[2]);
+		sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[7]);
 	} else {
-		hdr->cmdp[2] = (unsigned char) ((lba >> 56) & 0xff);
-		hdr->cmdp[3] = (unsigned char) ((lba >> 48) & 0xff);
-		hdr->cmdp[4] = (unsigned char) ((lba >> 40) & 0xff);
-		hdr->cmdp[5] = (unsigned char) ((lba >> 32) & 0xff);
-		hdr->cmdp[6] = (unsigned char) ((lba >> 24) & 0xff);
-		hdr->cmdp[7] = (unsigned char) ((lba >> 16) & 0xff);
-		hdr->cmdp[8] = (unsigned char) ((lba >>  8) & 0xff);
-		hdr->cmdp[9] = (unsigned char) (lba & 0xff);
-		hdr->cmdp[10] = (unsigned char) ((nr_blocks >> 32) & 0xff);
-		hdr->cmdp[11] = (unsigned char) ((nr_blocks >> 16) & 0xff);
-		hdr->cmdp[12] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		hdr->cmdp[13] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be64(lba, &hdr->cmdp[2]);
+		sgio_set_be32((uint32_t) nr_blocks, &hdr->cmdp[10]);
 	}
 
 	return;
@@ -552,18 +574,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 #endif
 
 		offset = 8 + 16 * st->unmap_range_count;
-		st->unmap_param[offset] = (unsigned char) ((lba >> 56) & 0xff);
-		st->unmap_param[offset+1] = (unsigned char) ((lba >> 48) & 0xff);
-		st->unmap_param[offset+2] = (unsigned char) ((lba >> 40) & 0xff);
-		st->unmap_param[offset+3] = (unsigned char) ((lba >> 32) & 0xff);
-		st->unmap_param[offset+4] = (unsigned char) ((lba >> 24) & 0xff);
-		st->unmap_param[offset+5] = (unsigned char) ((lba >> 16) & 0xff);
-		st->unmap_param[offset+6] = (unsigned char) ((lba >>  8) & 0xff);
-		st->unmap_param[offset+7] = (unsigned char) (lba & 0xff);
-		st->unmap_param[offset+8] = (unsigned char) ((nr_blocks >> 32) & 0xff);
-		st->unmap_param[offset+9] = (unsigned char) ((nr_blocks >> 16) & 0xff);
-		st->unmap_param[offset+10] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		st->unmap_param[offset+11] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be64(lba, &st->unmap_param[offset]);
+		sgio_set_be32((uint32_t) nr_blocks, &st->unmap_param[offset + 8]);
 
 		st->unmap_range_count++;
 
@@ -582,14 +594,12 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 
 static void fio_sgio_unmap_setup(struct sg_io_hdr *hdr, struct sgio_trim *st)
 {
-	hdr->dxfer_len = st->unmap_range_count * 16 + 8;
-	hdr->cmdp[7] = (unsigned char) (((st->unmap_range_count * 16 + 8) >> 8) & 0xff);
-	hdr->cmdp[8] = (unsigned char) ((st->unmap_range_count * 16 + 8) & 0xff);
+	uint16_t cnt = st->unmap_range_count * 16;
 
-	st->unmap_param[0] = (unsigned char) (((16 * st->unmap_range_count + 6) >> 8) & 0xff);
-	st->unmap_param[1] = (unsigned char)  ((16 * st->unmap_range_count + 6) & 0xff);
-	st->unmap_param[2] = (unsigned char) (((16 * st->unmap_range_count) >> 8) & 0xff);
-	st->unmap_param[3] = (unsigned char)  ((16 * st->unmap_range_count) & 0xff);
+	hdr->dxfer_len = cnt + 8;
+	sgio_set_be16(cnt + 8, &hdr->cmdp[7]);
+	sgio_set_be16(cnt + 6, st->unmap_param);
+	sgio_set_be16(cnt, &st->unmap_param[2]);
 
 	return;
 }
@@ -723,6 +733,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	 * io_u structures, which are not initialized until later.
 	 */
 	struct sg_io_hdr hdr;
+	unsigned long long hlba;
+	unsigned int blksz = 0;
 	unsigned char cmd[16];
 	unsigned char sb[64];
 	unsigned char buf[32];  // read capacity return
@@ -759,23 +771,23 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		return ret;
 	}
 
-	*bs	 = ((unsigned long) buf[4] << 24) | ((unsigned long) buf[5] << 16) |
-		   ((unsigned long) buf[6] << 8) | (unsigned long) buf[7];
-	*max_lba = ((unsigned long) buf[0] << 24) | ((unsigned long) buf[1] << 16) |
-		   ((unsigned long) buf[2] << 8) | (unsigned long) buf[3];
+	if (hdr.info & SG_INFO_CHECK) {
+		/* RCAP(10) might be unsupported by device. Force RCAP(16) */
+		hlba = MAX_10B_LBA;
+	} else {
+		blksz = sgio_get_be32(&buf[4]);
+		hlba = sgio_get_be32(buf);
+	}
 
 	/*
 	 * If max lba masked by MAX_10B_LBA equals MAX_10B_LBA,
 	 * then need to retry with 16 byte Read Capacity command.
 	 */
-	if (*max_lba == MAX_10B_LBA) {
+	if (hlba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
 		hdr.cmdp[0] = 0x9e; // service action
 		hdr.cmdp[1] = 0x10; // Read Capacity(16)
-		hdr.cmdp[10] = (unsigned char) ((sizeof(buf) >> 24) & 0xff);
-		hdr.cmdp[11] = (unsigned char) ((sizeof(buf) >> 16) & 0xff);
-		hdr.cmdp[12] = (unsigned char) ((sizeof(buf) >> 8) & 0xff);
-		hdr.cmdp[13] = (unsigned char) (sizeof(buf) & 0xff);
+		sgio_set_be32(sizeof(buf), &hdr.cmdp[10]);
 
 		hdr.dxfer_direction = SG_DXFER_FROM_DEV;
 		hdr.dxferp = buf;
@@ -791,19 +803,20 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		if (hdr.info & SG_INFO_CHECK)
 			td_verror(td, EIO, "fio_sgio_read_capacity");
 
-		*bs = (buf[8] << 24) | (buf[9] << 16) | (buf[10] << 8) | buf[11];
-		*max_lba = ((unsigned long long)buf[0] << 56) |
-				((unsigned long long)buf[1] << 48) |
-				((unsigned long long)buf[2] << 40) |
-				((unsigned long long)buf[3] << 32) |
-				((unsigned long long)buf[4] << 24) |
-				((unsigned long long)buf[5] << 16) |
-				((unsigned long long)buf[6] << 8) |
-				(unsigned long long)buf[7];
+		blksz = sgio_get_be32(&buf[8]);
+		hlba = sgio_get_be64(buf);
+	}
+
+	if (blksz) {
+		*bs = blksz;
+		*max_lba = hlba;
+		ret = 0;
+	} else {
+		ret = EIO;
 	}
 
 	close(fd);
-	return 0;
+	return ret;
 }
 
 static void fio_sgio_cleanup(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index bee99c37..910b7deb 100644
--- a/io_u.c
+++ b/io_u.c
@@ -775,10 +775,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 
-	if (io_u->post_submit) {
-		io_u->post_submit(io_u, io_u->error == 0);
-		io_u->post_submit = NULL;
-	}
+	zbd_put_io_u(io_u);
 
 	if (td->parent)
 		td = td->parent;
@@ -1340,10 +1337,7 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
-		if (io_u->post_submit) {
-			io_u->post_submit(io_u, false);
-			io_u->post_submit = NULL;
-		}
+		zbd_put_io_u(io_u);
 
 		put_file_log(td, f);
 		td_io_close_file(td, f);
diff --git a/io_u.h b/io_u.h
index 97270c94..e75993bd 100644
--- a/io_u.h
+++ b/io_u.h
@@ -92,11 +92,22 @@ struct io_u {
 		struct workqueue_work work;
 	};
 
+#ifdef CONFIG_LINUX_BLKZONED
 	/*
-	 * Post-submit callback. Used by the ZBD code. @success == true means
-	 * that the I/O operation has been queued or completed successfully.
+	 * ZBD mode zbd_queue_io callback: called after engine->queue operation
+	 * to advance a zone write pointer and eventually unlock the I/O zone.
+	 * @q indicates the I/O queue status (busy, queued or completed).
+	 * @success == true means that the I/O operation has been queued or
+	 * completed successfully.
 	 */
-	void (*post_submit)(const struct io_u *, bool success);
+	void (*zbd_queue_io)(struct io_u *, int q, bool success);
+
+	/*
+	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
+	 * or commit of an async I/O to unlock the I/O target zone.
+	 */
+	void (*zbd_put_io)(const struct io_u *);
+#endif
 
 	/*
 	 * Callback for io completion
diff --git a/ioengines.c b/ioengines.c
index 45e769e6..7e5a50cc 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -329,10 +329,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
-	if (ret != FIO_Q_BUSY && io_u->post_submit) {
-		io_u->post_submit(io_u, io_u->error == 0);
-		io_u->post_submit = NULL;
-	}
+	zbd_queue_io_u(io_u, ret);
 
 	unlock_file(td, io_u->file);
 
@@ -374,6 +371,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
+		zbd_put_io_u(io_u);
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
diff --git a/os/os.h b/os/os.h
index 0b182c4a..36b6bb2e 100644
--- a/os/os.h
+++ b/os/os.h
@@ -210,19 +210,27 @@ static inline uint64_t fio_swap64(uint64_t val)
 
 #ifndef FIO_HAVE_BYTEORDER_FUNCS
 #ifdef CONFIG_LITTLE_ENDIAN
+#define __be16_to_cpu(x)		fio_swap16(x)
+#define __be32_to_cpu(x)		fio_swap32(x)
 #define __be64_to_cpu(x)		fio_swap64(x)
 #define __le16_to_cpu(x)		(x)
 #define __le32_to_cpu(x)		(x)
 #define __le64_to_cpu(x)		(x)
+#define __cpu_to_be16(x)		fio_swap16(x)
+#define __cpu_to_be32(x)		fio_swap32(x)
 #define __cpu_to_be64(x)		fio_swap64(x)
 #define __cpu_to_le16(x)		(x)
 #define __cpu_to_le32(x)		(x)
 #define __cpu_to_le64(x)		(x)
 #else
+#define __be16_to_cpu(x)		(x)
+#define __be32_to_cpu(x)		(x)
 #define __be64_to_cpu(x)		(x)
 #define __le16_to_cpu(x)		fio_swap16(x)
 #define __le32_to_cpu(x)		fio_swap32(x)
 #define __le64_to_cpu(x)		fio_swap64(x)
+#define __cpu_to_be16(x)		(x)
+#define __cpu_to_be32(x)		(x)
 #define __cpu_to_be64(x)		(x)
 #define __cpu_to_le16(x)		fio_swap16(x)
 #define __cpu_to_le32(x)		fio_swap32(x)
@@ -231,6 +239,14 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
 #ifdef FIO_INTERNAL
+#define be16_to_cpu(val) ({			\
+	typecheck(uint16_t, val);		\
+	__be16_to_cpu(val);			\
+})
+#define be32_to_cpu(val) ({			\
+	typecheck(uint32_t, val);		\
+	__be32_to_cpu(val);			\
+})
 #define be64_to_cpu(val) ({			\
 	typecheck(uint64_t, val);		\
 	__be64_to_cpu(val);			\
@@ -249,6 +265,14 @@ static inline uint64_t fio_swap64(uint64_t val)
 })
 #endif
 
+#define cpu_to_be16(val) ({			\
+	typecheck(uint16_t, val);		\
+	__cpu_to_be16(val);			\
+})
+#define cpu_to_be32(val) ({			\
+	typecheck(uint32_t, val);		\
+	__cpu_to_be32(val);			\
+})
 #define cpu_to_be64(val) ({			\
 	typecheck(uint64_t, val);		\
 	__cpu_to_be64(val);			\
diff --git a/t/zbd/functions b/t/zbd/functions
index 173f0ca6..d49555a8 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -1,8 +1,7 @@
 #!/bin/bash
 
-# To do: switch to blkzone once blkzone reset works correctly.
-blkzone=
-#blkzone=$(type -p blkzone 2>/dev/null)
+blkzone=$(type -p blkzone 2>/dev/null)
+sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
 if [ -z "${blkzone}" ] &&
@@ -34,9 +33,23 @@ first_sequential_zone() {
 max_open_zones() {
     local dev=$1
 
-    if [ -n "${blkzone}" ]; then
-	# To do: query the maximum number of open zones using sg_raw
-	return 1
+    if [ -n "${sg_inq}" ]; then
+	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
+	    # Non scsi device such as null_blk can not return max open zones.
+	    # Use default value.
+	    echo 128
+	else
+	    ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" | tail -1 |
+		{
+		    read -r offset b0 b1 b2 b3 trailer || return $?
+		    # Convert from hex to decimal
+		    max_nr_open_zones=$((0x${b0}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b1}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b2}))
+		    max_nr_open_zones=$((max_nr_open_zones * 256 + 0x${b3}))
+		    echo ${max_nr_open_zones}
+		}
+	fi
     else
 	${zbc_report_zones} "$dev" |
 	    sed -n 's/^[[:blank:]]*Maximum number of open sequential write required zones:[[:blank:]]*//p'
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 2d727910..10c78e9a 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -141,9 +141,8 @@ test2() {
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
-    run_fio "${opts[@]}" 2>&1 |
-	tee -a "${logfile}.${test_number}" |
-	grep -q 'No I/O performed'
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    ! grep -q 'WRITE:' "${logfile}.${test_number}"
 }
 
 # Run fio against an empty zone. This causes fio to report "No I/O performed".
@@ -160,12 +159,12 @@ test3() {
 	opts+=("--zonesize=${zone_size}")
     fi
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    grep -q "No I/O performed" "${logfile}.${test_number}"
+    grep -q 'READ:' "${logfile}.${test_number}"
     rc=$?
     if [ -n "$is_zbd" ]; then
-	[ $rc = 0 ]
-    else
 	[ $rc != 0 ]
+    else
+	[ $rc = 0 ]
     fi
 }
 
@@ -731,6 +730,17 @@ test45() {
 	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
 }
 
+# Random write to sequential zones, libaio, 8 jobs, queue depth 64 per job
+test46() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
+		   --group_reporting=1 --numjobs=8 \
+		   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size * 8)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
@@ -761,7 +771,15 @@ source "$(dirname "$0")/functions" || exit $?
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-disk_size=$(($(<"/sys/block/$basename/size")*512))
+major=$((0x$(stat -L -c '%t' "$realdev")))
+minor=$((0x$(stat -L -c '%T' "$realdev")))
+disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
+# When the target is a partition device, get basename of its holder device to
+# access sysfs path of the holder device
+if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
+	realsysfs=$(readlink "/sys/dev/block/$major:$minor")
+	basename=$(basename "${realsysfs%/*}")
+fi
 logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
 case "$(<"/sys/class/block/$basename/queue/zoned")" in
     host-managed|host-aware)
@@ -794,7 +812,7 @@ case "$(<"/sys/class/block/$basename/queue/zoned")" in
 esac
 
 if [ "${#tests[@]}" = 0 ]; then
-    for ((i=1;i<=45;i++)); do
+    for ((i=1;i<=46;i++)); do
 	tests+=("$i")
     done
 fi
diff --git a/zbd.c b/zbd.c
index 8acda1f6..2da742b7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -228,12 +228,45 @@ static enum blk_zoned_model get_zbd_model(const char *file_name)
 	char *zoned_attr_path = NULL;
 	char *model_str = NULL;
 	struct stat statbuf;
+	char *sys_devno_path = NULL;
+	char *part_attr_path = NULL;
+	char *part_str = NULL;
+	char sys_path[PATH_MAX];
+	ssize_t sz;
+	char *delim = NULL;
 
 	if (stat(file_name, &statbuf) < 0)
 		goto out;
-	if (asprintf(&zoned_attr_path, "/sys/dev/block/%d:%d/queue/zoned",
+
+	if (asprintf(&sys_devno_path, "/sys/dev/block/%d:%d",
 		     major(statbuf.st_rdev), minor(statbuf.st_rdev)) < 0)
 		goto out;
+
+	sz = readlink(sys_devno_path, sys_path, sizeof(sys_path) - 1);
+	if (sz < 0)
+		goto out;
+	sys_path[sz] = '\0';
+
+	/*
+	 * If the device is a partition device, cut the device name in the
+	 * canonical sysfs path to obtain the sysfs path of the holder device.
+	 *   e.g.:  /sys/devices/.../sda/sda1 -> /sys/devices/.../sda
+	 */
+	if (asprintf(&part_attr_path, "/sys/dev/block/%s/partition",
+		     sys_path) < 0)
+		goto out;
+	part_str = read_file(part_attr_path);
+	if (part_str && *part_str == '1') {
+		delim = strrchr(sys_path, '/');
+		if (!delim)
+			goto out;
+		*delim = '\0';
+	}
+
+	if (asprintf(&zoned_attr_path,
+		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
+		goto out;
+
 	model_str = read_file(zoned_attr_path);
 	if (!model_str)
 		goto out;
@@ -246,6 +279,9 @@ static enum blk_zoned_model get_zbd_model(const char *file_name)
 out:
 	free(model_str);
 	free(zoned_attr_path);
+	free(part_str);
+	free(part_attr_path);
+	free(sys_devno_path);
 	return model;
 }
 
@@ -1075,37 +1111,44 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	return NULL;
 }
 
-
 /**
- * zbd_post_submit - update the write pointer and unlock the zone lock
+ * zbd_queue_io - update the write pointer of a sequential zone
  * @io_u: I/O unit
- * @success: Whether or not the I/O unit has been executed successfully
+ * @success: Whether or not the I/O unit has been queued successfully
+ * @q: queueing status (busy, completed or queued).
  *
- * For write and trim operations, update the write pointer of all affected
- * zones.
+ * For write and trim operations, update the write pointer of the I/O unit
+ * target zone.
  */
-static void zbd_post_submit(const struct io_u *io_u, bool success)
+static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 {
-	struct zoned_block_device_info *zbd_info;
+	const struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
-	uint64_t end, zone_end;
+	uint64_t zone_end;
 
-	zbd_info = io_u->file->zbd_info;
 	if (!zbd_info)
 		return;
 
-	zone_idx = zbd_zone_idx(io_u->file, io_u->offset);
-	end = io_u->offset + io_u->buflen;
-	z = &zbd_info->zone_info[zone_idx];
+	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
+	z = &zbd_info->zone_info[zone_idx];
+
 	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
 		return;
+
 	if (!success)
 		goto unlock;
+
+	dprint(FD_ZBD,
+	       "%s: queued I/O (%lld, %llu) for zone %u\n",
+	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
-		zone_end = min(end, (z + 1)->start);
+		zone_end = min((uint64_t)(io_u->offset + io_u->buflen),
+			       (z + 1)->start);
 		pthread_mutex_lock(&zbd_info->mutex);
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
@@ -1122,10 +1165,42 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 	default:
 		break;
 	}
+
 unlock:
-	pthread_mutex_unlock(&z->mutex);
+	if (!success || q != FIO_Q_QUEUED) {
+		/* BUSY or COMPLETED: unlock the zone */
+		pthread_mutex_unlock(&z->mutex);
+		io_u->zbd_put_io = NULL;
+	}
+}
 
-	zbd_check_swd(io_u->file);
+/**
+ * zbd_put_io - Unlock an I/O unit target zone lock
+ * @io_u: I/O unit
+ */
+static void zbd_put_io(const struct io_u *io_u)
+{
+	const struct fio_file *f = io_u->file;
+	struct zoned_block_device_info *zbd_info = f->zbd_info;
+	struct fio_zone_info *z;
+	uint32_t zone_idx;
+
+	if (!zbd_info)
+		return;
+
+	zone_idx = zbd_zone_idx(f, io_u->offset);
+	assert(zone_idx < zbd_info->nr_zones);
+	z = &zbd_info->zone_info[zone_idx];
+
+	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+		return;
+
+	dprint(FD_ZBD,
+	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
+	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+
+	assert(pthread_mutex_unlock(&z->mutex) == 0);
+	zbd_check_swd(f);
 }
 
 bool zbd_unaligned_write(int error_code)
@@ -1180,7 +1255,21 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	pthread_mutex_lock(&zb->mutex);
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&zb->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&zb->mutex);
+	}
+
 	switch (io_u->ddir) {
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING) {
@@ -1318,8 +1407,10 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 accept:
 	assert(zb);
 	assert(zb->cond != BLK_ZONE_COND_OFFLINE);
-	assert(!io_u->post_submit);
-	io_u->post_submit = zbd_post_submit;
+	assert(!io_u->zbd_queue_io);
+	assert(!io_u->zbd_put_io);
+	io_u->zbd_queue_io = zbd_queue_io;
+	io_u->zbd_put_io = zbd_put_io;
 	return io_u_accept;
 
 eof:
diff --git a/zbd.h b/zbd.h
index 33e6d8bd..521283b2 100644
--- a/zbd.h
+++ b/zbd.h
@@ -96,6 +96,24 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f);
 bool zbd_unaligned_write(int error_code);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
+
+static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
+{
+	if (io_u->zbd_queue_io) {
+		io_u->zbd_queue_io(io_u, status, io_u->error == 0);
+		io_u->zbd_queue_io = NULL;
+	}
+}
+
+static inline void zbd_put_io_u(struct io_u *io_u)
+{
+	if (io_u->zbd_put_io) {
+		io_u->zbd_put_io(io_u);
+		io_u->zbd_queue_io = NULL;
+		io_u->zbd_put_io = NULL;
+	}
+}
+
 #else
 static inline void zbd_free_zone_info(struct fio_file *f)
 {
@@ -125,6 +143,10 @@ static inline char *zbd_write_status(const struct thread_stat *ts)
 {
 	return NULL;
 }
+
+static inline void zbd_queue_io_u(struct io_u *io_u,
+				  enum fio_q_status status) {}
+static inline void zbd_put_io_u(struct io_u *io_u) {}
 #endif
 
 #endif /* FIO_ZBD_H */

