Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB5EC433F5
	for <fio@archiver.kernel.org>; Wed, 15 Dec 2021 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhLONAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Dec 2021 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLONAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Dec 2021 08:00:08 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83569C061574
        for <fio@vger.kernel.org>; Wed, 15 Dec 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=T/5qxI7RJflMu7hnap/yjKJep/tcyzxYVmy3XIeoFdY=; b=V8L01ZCxQTqBqA0okcsm8f4Biw
        ObXqicLQMPQW15ozoq6gDWIhJskzowvvZcRrcTWwnpXVUIhiB8ZTqpwZh7fMpvhZWc+trpwi3yM/V
        TjfK5/+WatfrlXKRztgmJQwTRCiOhmV4f1LxdPELrVOy7piM8q5lZV0RVh4SsT4IuMzqOnOZK5u69
        t7gcNeMn2YQGqekO7KZUSeIvzXuxv5Y1hoMmcqZqC0mGGZWZH0dLLXX1ckkr6s2YKGFqqnkchImJy
        b0aSrkrqQOQlt2iSynvUVSAbxZD6xHRyz/bnyN+cyZFWugB35FDB2pQCRbqkXQoJPR9ZWB+qbJiAT
        133c7lpQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxTt7-001VSc-6w
        for fio@vger.kernel.org; Wed, 15 Dec 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2FD6A1BC0144; Wed, 15 Dec 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211215130002.2FD6A1BC0144@kernel.dk>
Date:   Wed, 15 Dec 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2ea393df3256e44398558c264f035f8db7656b08:

  Merge branch 'github-actions' of https://github.com/sitsofe/fio (2021-12-10 11:08:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9ffe433d729101a34d9709030d7d4dd2444347ef:

  t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs (2021-12-14 06:48:14 -0700)

----------------------------------------------------------------
Damien Le Moal (11):
      fio: Improve documentation of ignore_zone_limits option
      zbd: define local functions as static
      zbd: move and cleanup code
      zbd: remove is_zone_open() helper
      zbd: introduce zbd_zone_align_file_sizes() helper
      zbd: fix code style issues
      zbd: simplify zbd_close_zone()
      zbd: simplify zbd_open_zone()
      zbd: rename zbd_zone_idx() and zbd_zone_nr()
      zbd: rename get_zone()
      zbd: introduce zbd_offset_to_zone() helper

Niklas Cassel (2):
      ci: temporarily remove linux-i686-gcc build
      ci: use macos 11 in virtual environment

Shin'ichiro Kawasaki (1):
      t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs

 .github/workflows/ci.yml |   6 +-
 HOWTO                    |   6 +
 fio.1                    |   6 +-
 t/zbd/functions          |   6 +-
 zbd.c                    | 963 +++++++++++++++++++++++++----------------------
 5 files changed, 532 insertions(+), 455 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index a766cfa8..8167e3d1 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,7 +14,6 @@ jobs:
         - linux-gcc
         - linux-clang
         - macos
-        - linux-i686-gcc
         include:
         - build: linux-gcc
           os: ubuntu-20.04
@@ -23,10 +22,7 @@ jobs:
           os: ubuntu-20.04
           cc: clang
         - build: macos
-          os: macos-10.15
-        - build: linux-i686-gcc
-          os: ubuntu-20.04
-          arch: i686
+          os: macos-11
 
     env:
       CI_TARGET_ARCH: ${{ matrix.arch }}
diff --git a/HOWTO b/HOWTO
index 8c9e4135..2956e50d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1063,6 +1063,12 @@ Target file/device
 	Limit on the number of simultaneously opened zones per single
 	thread/process.
 
+.. option:: ignore_zone_limits=bool
+	If this option is used, fio will ignore the maximum number of open
+	zones limit of the zoned block device in use, thus allowing the
+	option :option:`max_open_zones` value to be larger than the device
+	reported limit. Default: false.
+
 .. option:: zone_reset_threshold=float
 
 	A number between zero and one that indicates the ratio of logical
diff --git a/fio.1 b/fio.1
index a3ebb67d..e0458c22 100644
--- a/fio.1
+++ b/fio.1
@@ -838,9 +838,9 @@ threads/processes.
 Limit on the number of simultaneously opened zones per single thread/process.
 .TP
 .BI ignore_zone_limits \fR=\fPbool
-If this isn't set, fio will query the max open zones limit from the zoned block
-device, and exit if the specified \fBmax_open_zones\fR value is larger than the
-limit reported by the device. Default: false.
+If this option is used, fio will ignore the maximum number of open zones limit
+of the zoned block device in use, thus allowing the option \fBmax_open_zones\fR
+value to be larger than the device reported limit. Default: false.
 .TP
 .BI zone_reset_threshold \fR=\fPfloat
 A number between zero and one that indicates the ratio of logical blocks with
diff --git a/t/zbd/functions b/t/zbd/functions
index e4e248b9..7cff18fd 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -72,9 +72,11 @@ zone_cap_bs() {
 	local sed_str='s/.*len \([0-9A-Za-z]*\), cap \([0-9A-Za-z]*\).*/\1 \2/p'
 	local cap bs="$zone_size"
 
-	# When blkzone is not available or blkzone does not report capacity,
+	# When blkzone command is neither available nor relevant to the
+	# test device, or when blkzone command does not report capacity,
 	# assume that zone capacity is same as zone size for all zones.
-	if [ -z "${blkzone}" ] || ! blkzone_reports_capacity "${dev}"; then
+	if [ -z "${blkzone}" ] || [ -z "$is_zbd" ] || [ -c "$dev" ] ||
+		   ! blkzone_reports_capacity "${dev}"; then
 		echo "$zone_size"
 		return
 	fi
diff --git a/zbd.c b/zbd.c
index c18998c4..b1fd6b4b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -22,13 +22,126 @@
 #include "pshared.h"
 #include "zbd.h"
 
+static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
+{
+	return (uint64_t)(offset - f->file_offset) < f->io_size;
+}
+
+static inline unsigned int zbd_zone_idx(const struct fio_file *f,
+					struct fio_zone_info *zone)
+{
+	return zone - f->zbd_info->zone_info;
+}
+
+/**
+ * zbd_offset_to_zone_idx - convert an offset into a zone number
+ * @f: file pointer.
+ * @offset: offset in bytes. If this offset is in the first zone_size bytes
+ *	    past the disk size then the index of the sentinel is returned.
+ */
+static unsigned int zbd_offset_to_zone_idx(const struct fio_file *f,
+					   uint64_t offset)
+{
+	uint32_t zone_idx;
+
+	if (f->zbd_info->zone_size_log2 > 0)
+		zone_idx = offset >> f->zbd_info->zone_size_log2;
+	else
+		zone_idx = offset / f->zbd_info->zone_size;
+
+	return min(zone_idx, f->zbd_info->nr_zones);
+}
+
+/**
+ * zbd_zone_end - Return zone end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)
+{
+	return (z+1)->start;
+}
+
+/**
+ * zbd_zone_capacity_end - Return zone capacity limit end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
+{
+	return z->start + z->capacity;
+}
+
+/**
+ * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
+ * @f: file pointer.
+ * @z: zone info pointer.
+ * @required: minimum number of bytes that must remain in a zone.
+ *
+ * The caller must hold z->mutex.
+ */
+static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
+			  uint64_t required)
+{
+	assert((required & 511) == 0);
+
+	return z->has_wp &&
+		z->wp + required > zbd_zone_capacity_end(z);
+}
+
+static void zone_lock(struct thread_data *td, const struct fio_file *f,
+		      struct fio_zone_info *z)
+{
+	struct zoned_block_device_info *zbd = f->zbd_info;
+	uint32_t nz = z - zbd->zone_info;
+
+	/* A thread should never lock zones outside its working area. */
+	assert(f->min_zone <= nz && nz < f->max_zone);
+
+	assert(z->has_wp);
+
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&z->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&z->mutex);
+	}
+}
+
+static inline void zone_unlock(struct fio_zone_info *z)
+{
+	int ret;
+
+	assert(z->has_wp);
+	ret = pthread_mutex_unlock(&z->mutex);
+	assert(!ret);
+}
+
+static inline struct fio_zone_info *zbd_get_zone(const struct fio_file *f,
+						 unsigned int zone_idx)
+{
+	return &f->zbd_info->zone_info[zone_idx];
+}
+
+static inline struct fio_zone_info *
+zbd_offset_to_zone(const struct fio_file *f,  uint64_t offset)
+{
+	return zbd_get_zone(f, zbd_offset_to_zone_idx(f, offset));
+}
+
 /**
  * zbd_get_zoned_model - Get a device zoned model
  * @td: FIO thread data
  * @f: FIO file for which to get model information
  */
-int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
-			enum zbd_zoned_model *model)
+static int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			       enum zbd_zoned_model *model)
 {
 	int ret;
 
@@ -71,9 +184,9 @@ int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
  * upon failure. If the zone report is empty, always assume an error (device
  * problem) and return -EIO.
  */
-int zbd_report_zones(struct thread_data *td, struct fio_file *f,
-		     uint64_t offset, struct zbd_zone *zones,
-		     unsigned int nr_zones)
+static int zbd_report_zones(struct thread_data *td, struct fio_file *f,
+			    uint64_t offset, struct zbd_zone *zones,
+			    unsigned int nr_zones)
 {
 	int ret;
 
@@ -105,8 +218,8 @@ int zbd_report_zones(struct thread_data *td, struct fio_file *f,
  * Reset the write pointer of all zones in the range @offset...@offset+@length.
  * Returns 0 upon success and a negative error code upon failure.
  */
-int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
-		 uint64_t offset, uint64_t length)
+static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
+			uint64_t offset, uint64_t length)
 {
 	int ret;
 
@@ -124,131 +237,233 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 }
 
 /**
- * zbd_get_max_open_zones - Get the maximum number of open zones
- * @td: FIO thread data
- * @f: FIO file for which to get max open zones
- * @max_open_zones: Upon success, result will be stored here.
- *
- * A @max_open_zones value set to zero means no limit.
+ * zbd_reset_zone - reset the write pointer of a single zone
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @z: Zone to reset.
  *
  * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
  */
-int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
-			   unsigned int *max_open_zones)
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z)
 {
-	int ret;
+	uint64_t offset = z->start;
+	uint64_t length = (z+1)->start - offset;
+	uint64_t data_in_zone = z->wp - z->start;
+	int ret = 0;
 
-	if (td->io_ops && td->io_ops->get_max_open_zones)
-		ret = td->io_ops->get_max_open_zones(td, f, max_open_zones);
-	else
-		ret = blkzoned_get_max_open_zones(td, f, max_open_zones);
-	if (ret < 0) {
-		td_verror(td, errno, "get max open zones failed");
-		log_err("%s: get max open zones failed (%d).\n",
-			f->file_name, errno);
+	if (!data_in_zone)
+		return 0;
+
+	assert(is_valid_offset(f, offset + length - 1));
+
+	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n",
+	       f->file_name, zbd_zone_idx(f, z));
+
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		ret = zbd_reset_wp(td, f, offset, length);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
 	}
 
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data -= data_in_zone;
+	f->zbd_info->wp_sectors_with_data -= data_in_zone;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	z->wp = z->start;
+	z->verify_block = 0;
+
+	td->ts.nr_zone_resets++;
+
 	return ret;
 }
 
 /**
- * zbd_zone_idx - convert an offset into a zone number
- * @f: file pointer.
- * @offset: offset in bytes. If this offset is in the first zone_size bytes
- *	    past the disk size then the index of the sentinel is returned.
+ * zbd_close_zone - Remove a zone from the open zones array.
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @zone_idx: Index of the zone to remove.
+ *
+ * The caller must hold f->zbd_info->mutex.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
+			   struct fio_zone_info *z)
 {
-	uint32_t zone_idx;
+	uint32_t ozi;
 
-	if (f->zbd_info->zone_size_log2 > 0)
-		zone_idx = offset >> f->zbd_info->zone_size_log2;
-	else
-		zone_idx = offset / f->zbd_info->zone_size;
+	if (!z->open)
+		return;
 
-	return min(zone_idx, f->zbd_info->nr_zones);
-}
+	for (ozi = 0; ozi < f->zbd_info->num_open_zones; ozi++) {
+		if (zbd_get_zone(f, f->zbd_info->open_zones[ozi]) == z)
+			break;
+	}
+	if (ozi == f->zbd_info->num_open_zones)
+		return;
 
-/**
- * zbd_zone_end - Return zone end location
- * @z: zone info pointer.
- */
-static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)
-{
-	return (z+1)->start;
+	dprint(FD_ZBD, "%s: closing zone %u\n",
+	       f->file_name, zbd_zone_idx(f, z));
+
+	memmove(f->zbd_info->open_zones + ozi,
+		f->zbd_info->open_zones + ozi + 1,
+		(ZBD_MAX_OPEN_ZONES - (ozi + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+
+	f->zbd_info->num_open_zones--;
+	td->num_open_zones--;
+	z->open = 0;
 }
 
 /**
- * zbd_zone_capacity_end - Return zone capacity limit end location
- * @z: zone info pointer.
+ * zbd_reset_zones - Reset a range of zones.
+ * @td: fio thread data.
+ * @f: fio file for which to reset zones
+ * @zb: first zone to reset.
+ * @ze: first zone not to reset.
+ *
+ * Returns 0 upon success and 1 upon failure.
  */
-static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
+static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
+			   struct fio_zone_info *const zb,
+			   struct fio_zone_info *const ze)
 {
-	return z->start + z->capacity;
+	struct fio_zone_info *z;
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
+	int res = 0;
+
+	assert(min_bs);
+
+	dprint(FD_ZBD, "%s: examining zones %u .. %u\n",
+	       f->file_name, zbd_zone_idx(f, zb), zbd_zone_idx(f, ze));
+
+	for (z = zb; z < ze; z++) {
+		if (!z->has_wp)
+			continue;
+
+		zone_lock(td, f, z);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, z);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+
+		if (z->wp != z->start) {
+			dprint(FD_ZBD, "%s: resetting zone %u\n",
+			       f->file_name, zbd_zone_idx(f, z));
+			if (zbd_reset_zone(td, f, z) < 0)
+				res = 1;
+		}
+
+		zone_unlock(z);
+	}
+
+	return res;
 }
 
 /**
- * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
- * @f: file pointer.
- * @z: zone info pointer.
- * @required: minimum number of bytes that must remain in a zone.
+ * zbd_get_max_open_zones - Get the maximum number of open zones
+ * @td: FIO thread data
+ * @f: FIO file for which to get max open zones
+ * @max_open_zones: Upon success, result will be stored here.
  *
- * The caller must hold z->mutex.
+ * A @max_open_zones value set to zero means no limit.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
  */
-static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
-			  uint64_t required)
+static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				  unsigned int *max_open_zones)
 {
-	assert((required & 511) == 0);
+	int ret;
 
-	return z->has_wp &&
-		z->wp + required > zbd_zone_capacity_end(z);
+	if (td->io_ops && td->io_ops->get_max_open_zones)
+		ret = td->io_ops->get_max_open_zones(td, f, max_open_zones);
+	else
+		ret = blkzoned_get_max_open_zones(td, f, max_open_zones);
+	if (ret < 0) {
+		td_verror(td, errno, "get max open zones failed");
+		log_err("%s: get max open zones failed (%d).\n",
+			f->file_name, errno);
+	}
+
+	return ret;
 }
 
-static void zone_lock(struct thread_data *td, const struct fio_file *f,
-		      struct fio_zone_info *z)
+/**
+ * zbd_open_zone - Add a zone to the array of open zones.
+ * @td: fio thread data.
+ * @f: fio file that has the open zones to add.
+ * @zone_idx: Index of the zone to add.
+ *
+ * Open a ZBD zone if it is not already open. Returns true if either the zone
+ * was already open or if the zone was successfully added to the array of open
+ * zones without exceeding the maximum number of open zones. Returns false if
+ * the zone was not already open and opening the zone would cause the zone limit
+ * to be exceeded.
+ */
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
+			  struct fio_zone_info *z)
 {
-	struct zoned_block_device_info *zbd = f->zbd_info;
-	uint32_t nz = z - zbd->zone_info;
+	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+	uint32_t zone_idx = zbd_zone_idx(f, z);
+	bool res = true;
 
-	/* A thread should never lock zones outside its working area. */
-	assert(f->min_zone <= nz && nz < f->max_zone);
+	if (z->cond == ZBD_ZONE_COND_OFFLINE)
+		return false;
 
-	assert(z->has_wp);
+	/*
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
+	 */
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
 
 	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
+	 * zbdi->max_open_zones == 0 means that there is no limit on the maximum
+	 * number of open zones. In this case, do no track open zones in
+	 * zbdi->open_zones array.
 	 */
-	if (pthread_mutex_trylock(&z->mutex) != 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&z->mutex);
+	if (!zbdi->max_open_zones)
+		return true;
+
+	pthread_mutex_lock(&zbdi->mutex);
+
+	if (z->open) {
+		/*
+		 * If the zone is going to be completely filled by writes
+		 * already in-flight, handle it as a full zone instead of an
+		 * open zone.
+		 */
+		if (z->wp >= zbd_zone_capacity_end(z))
+			res = false;
+		goto out;
 	}
-}
 
-static inline void zone_unlock(struct fio_zone_info *z)
-{
-	int ret;
+	res = false;
+	/* Zero means no limit */
+	if (td->o.job_max_open_zones > 0 &&
+	    td->num_open_zones >= td->o.job_max_open_zones)
+		goto out;
+	if (zbdi->num_open_zones >= zbdi->max_open_zones)
+		goto out;
 
-	assert(z->has_wp);
-	ret = pthread_mutex_unlock(&z->mutex);
-	assert(!ret);
-}
+	dprint(FD_ZBD, "%s: opening zone %u\n",
+	       f->file_name, zone_idx);
 
-static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
-{
-	return (uint64_t)(offset - f->file_offset) < f->io_size;
-}
+	zbdi->open_zones[zbdi->num_open_zones++] = zone_idx;
+	td->num_open_zones++;
+	z->open = 1;
+	res = true;
 
-static inline struct fio_zone_info *get_zone(const struct fio_file *f,
-					     unsigned int zone_nr)
-{
-	return &f->zbd_info->zone_info[zone_nr];
+out:
+	pthread_mutex_unlock(&zbdi->mutex);
+	return res;
 }
 
 /* Verify whether direct I/O is used for all host-managed zoned drives. */
@@ -277,15 +492,91 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	uint32_t zone_idx, zone_idx_b, zone_idx_e;
 
 	assert(f->zbd_info);
+
 	if (f->io_size == 0)
 		return false;
-	zone_idx_b = zbd_zone_idx(f, f->file_offset);
-	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
+
+	zone_idx_b = zbd_offset_to_zone_idx(f, f->file_offset);
+	zone_idx_e =
+		zbd_offset_to_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
-		if (get_zone(f, zone_idx)->has_wp)
+		if (zbd_get_zone(f, zone_idx)->has_wp)
 			return true;
 
-	return false;
+	return false;
+}
+
+/*
+ * Verify whether the file offset and size parameters are aligned with zone
+ * boundaries. If the file offset is not aligned, align it down to the start of
+ * the zone containing the start offset and align up the file io_size parameter.
+ */
+static bool zbd_zone_align_file_sizes(struct thread_data *td,
+				      struct fio_file *f)
+{
+	const struct fio_zone_info *z;
+	uint64_t new_offset, new_end;
+
+	if (!f->zbd_info)
+		return true;
+	if (f->file_offset >= f->real_file_size)
+		return true;
+	if (!zbd_is_seq_job(f))
+		return true;
+
+	if (!td->o.zone_size) {
+		td->o.zone_size = f->zbd_info->zone_size;
+		if (!td->o.zone_size) {
+			log_err("%s: invalid 0 zone size\n",
+				f->file_name);
+			return false;
+		}
+	} else if (td->o.zone_size != f->zbd_info->zone_size) {
+		log_err("%s: zonesize %llu does not match the device zone size %"PRIu64".\n",
+			f->file_name, td->o.zone_size,
+			f->zbd_info->zone_size);
+		return false;
+	}
+
+	if (td->o.zone_skip % td->o.zone_size) {
+		log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
+			f->file_name, td->o.zone_skip,
+			td->o.zone_size);
+		return false;
+	}
+
+	z = zbd_offset_to_zone(f, f->file_offset);
+	if ((f->file_offset != z->start) &&
+	    (td->o.td_ddir != TD_DDIR_READ)) {
+		new_offset = zbd_zone_end(z);
+		if (new_offset >= f->file_offset + f->io_size) {
+			log_info("%s: io_size must be at least one zone\n",
+				 f->file_name);
+			return false;
+		}
+		log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
+			 f->file_name, f->file_offset,
+			 new_offset);
+		f->io_size -= (new_offset - f->file_offset);
+		f->file_offset = new_offset;
+	}
+
+	z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
+	new_end = z->start;
+	if ((td->o.td_ddir != TD_DDIR_READ) &&
+	    (f->file_offset + f->io_size != new_end)) {
+		if (new_end <= f->file_offset) {
+			log_info("%s: io_size must be at least one zone\n",
+				 f->file_name);
+			return false;
+		}
+		log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
+			 f->file_name, f->io_size,
+			 new_end - f->file_offset);
+		f->io_size = new_end - f->file_offset;
+	}
+
+	return true;
 }
 
 /*
@@ -293,74 +584,14 @@ static bool zbd_is_seq_job(struct fio_file *f)
  */
 static bool zbd_verify_sizes(void)
 {
-	const struct fio_zone_info *z;
 	struct thread_data *td;
 	struct fio_file *f;
-	uint64_t new_offset, new_end;
-	uint32_t zone_idx;
 	int i, j;
 
 	for_each_td(td, i) {
 		for_each_file(td, f, j) {
-			if (!f->zbd_info)
-				continue;
-			if (f->file_offset >= f->real_file_size)
-				continue;
-			if (!zbd_is_seq_job(f))
-				continue;
-
-			if (!td->o.zone_size) {
-				td->o.zone_size = f->zbd_info->zone_size;
-				if (!td->o.zone_size) {
-					log_err("%s: invalid 0 zone size\n",
-						f->file_name);
-					return false;
-				}
-			} else if (td->o.zone_size != f->zbd_info->zone_size) {
-				log_err("%s: job parameter zonesize %llu does not match disk zone size %"PRIu64".\n",
-					f->file_name, td->o.zone_size,
-					f->zbd_info->zone_size);
-				return false;
-			}
-
-			if (td->o.zone_skip % td->o.zone_size) {
-				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
-					f->file_name, td->o.zone_skip,
-					td->o.zone_size);
+			if (!zbd_zone_align_file_sizes(td, f))
 				return false;
-			}
-
-			zone_idx = zbd_zone_idx(f, f->file_offset);
-			z = get_zone(f, zone_idx);
-			if ((f->file_offset != z->start) &&
-			    (td->o.td_ddir != TD_DDIR_READ)) {
-				new_offset = zbd_zone_end(z);
-				if (new_offset >= f->file_offset + f->io_size) {
-					log_info("%s: io_size must be at least one zone\n",
-						 f->file_name);
-					return false;
-				}
-				log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
-					 f->file_name, f->file_offset,
-					 new_offset);
-				f->io_size -= (new_offset - f->file_offset);
-				f->file_offset = new_offset;
-			}
-			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
-			z = get_zone(f, zone_idx);
-			new_end = z->start;
-			if ((td->o.td_ddir != TD_DDIR_READ) &&
-			    (f->file_offset + f->io_size != new_end)) {
-				if (new_end <= f->file_offset) {
-					log_info("%s: io_size must be at least one zone\n",
-						 f->file_name);
-					return false;
-				}
-				log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
-					 f->file_name, f->io_size,
-					 new_end - f->file_offset);
-				f->io_size = new_end - f->file_offset;
-			}
 		}
 	}
 
@@ -385,6 +616,7 @@ static bool zbd_verify_bs(void)
 
 			if (!f->zbd_info)
 				continue;
+
 			zone_size = f->zbd_info->zone_size;
 			if (td_trim(td) && td->o.bs[DDIR_TRIM] != zone_size) {
 				log_info("%s: trim block size %llu is not the zone size %"PRIu64"\n",
@@ -529,8 +761,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n", f->file_name,
-	       nr_zones, zone_size / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n",
+	       f->file_name, nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -546,6 +778,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
 			p->capacity = z->capacity;
+
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
 			case ZBD_ZONE_COND_FULL:
@@ -579,6 +812,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		offset = z->start + z->len;
 		if (j >= nr_zones)
 			break;
+
 		nrz = zbd_report_zones(td, f, offset, zones,
 				       min((uint32_t)(nr_zones - j),
 					   ZBD_REPORT_MAX_ZONES));
@@ -646,7 +880,8 @@ out:
 	/* Ensure that the limit is not larger than FIO's internal limit */
 	if (zbd->max_open_zones > ZBD_MAX_OPEN_ZONES) {
 		td_verror(td, EINVAL, "'max_open_zones' value is too large");
-		log_err("'max_open_zones' value is larger than %u\n", ZBD_MAX_OPEN_ZONES);
+		log_err("'max_open_zones' value is larger than %u\n",
+			ZBD_MAX_OPEN_ZONES);
 		return -EINVAL;
 	}
 
@@ -748,14 +983,10 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	ret = zbd_create_zone_info(td, file);
 	if (ret < 0)
 		td_verror(td, -ret, "zbd_create_zone_info() failed");
+
 	return ret;
 }
 
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
-			  uint32_t zone_idx);
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z);
-
 int zbd_init_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -765,6 +996,7 @@ int zbd_init_files(struct thread_data *td)
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
+
 	return 0;
 }
 
@@ -775,27 +1007,24 @@ void zbd_recalc_options_with_zone_granularity(struct thread_data *td)
 
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
-		// zonemode=strided doesn't get per-file zone size.
-		uint64_t zone_size = zbd ? zbd->zone_size : td->o.zone_size;
+		uint64_t zone_size;
 
+		/* zonemode=strided doesn't get per-file zone size. */
+		zone_size = zbd ? zbd->zone_size : td->o.zone_size;
 		if (zone_size == 0)
 			continue;
 
-		if (td->o.size_nz > 0) {
+		if (td->o.size_nz > 0)
 			td->o.size = td->o.size_nz * zone_size;
-		}
-		if (td->o.io_size_nz > 0) {
+		if (td->o.io_size_nz > 0)
 			td->o.io_size = td->o.io_size_nz * zone_size;
-		}
-		if (td->o.start_offset_nz > 0) {
+		if (td->o.start_offset_nz > 0)
 			td->o.start_offset = td->o.start_offset_nz * zone_size;
-		}
-		if (td->o.offset_increment_nz > 0) {
-			td->o.offset_increment = td->o.offset_increment_nz * zone_size;
-		}
-		if (td->o.zone_skip_nz > 0) {
+		if (td->o.offset_increment_nz > 0)
+			td->o.offset_increment =
+				td->o.offset_increment_nz * zone_size;
+		if (td->o.zone_skip_nz > 0)
 			td->o.zone_skip = td->o.zone_skip_nz * zone_size;
-		}
 	}
 }
 
@@ -822,8 +1051,9 @@ int zbd_setup_files(struct thread_data *td)
 
 		assert(zbd);
 
-		f->min_zone = zbd_zone_idx(f, f->file_offset);
-		f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
+		f->min_zone = zbd_offset_to_zone_idx(f, f->file_offset);
+		f->max_zone =
+			zbd_offset_to_zone_idx(f, f->file_offset + f->io_size);
 
 		/*
 		 * When all zones in the I/O range are conventional, io_size
@@ -863,7 +1093,7 @@ int zbd_setup_files(struct thread_data *td)
 			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
 			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
 				continue;
-			if (zbd_open_zone(td, f, zi))
+			if (zbd_open_zone(td, f, z))
 				continue;
 			/*
 			 * If the number of open zones exceeds specified limits,
@@ -879,123 +1109,6 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
 
-static inline unsigned int zbd_zone_nr(const struct fio_file *f,
-				       struct fio_zone_info *zone)
-{
-	return zone - f->zbd_info->zone_info;
-}
-
-/**
- * zbd_reset_zone - reset the write pointer of a single zone
- * @td: FIO thread data.
- * @f: FIO file associated with the disk for which to reset a write pointer.
- * @z: Zone to reset.
- *
- * Returns 0 upon success and a negative error code upon failure.
- *
- * The caller must hold z->mutex.
- */
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z)
-{
-	uint64_t offset = z->start;
-	uint64_t length = (z+1)->start - offset;
-	uint64_t data_in_zone = z->wp - z->start;
-	int ret = 0;
-
-	if (!data_in_zone)
-		return 0;
-
-	assert(is_valid_offset(f, offset + length - 1));
-
-	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f, z));
-	switch (f->zbd_info->model) {
-	case ZBD_HOST_AWARE:
-	case ZBD_HOST_MANAGED:
-		ret = zbd_reset_wp(td, f, offset, length);
-		if (ret < 0)
-			return ret;
-		break;
-	default:
-		break;
-	}
-
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= data_in_zone;
-	f->zbd_info->wp_sectors_with_data -= data_in_zone;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-	z->wp = z->start;
-	z->verify_block = 0;
-
-	td->ts.nr_zone_resets++;
-
-	return ret;
-}
-
-/* The caller must hold f->zbd_info->mutex */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   unsigned int zone_idx)
-{
-	uint32_t open_zone_idx = 0;
-
-	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
-		if (f->zbd_info->open_zones[open_zone_idx] == zone_idx)
-			break;
-	}
-	if (open_zone_idx == f->zbd_info->num_open_zones)
-		return;
-
-	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
-	memmove(f->zbd_info->open_zones + open_zone_idx,
-		f->zbd_info->open_zones + open_zone_idx + 1,
-		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
-	f->zbd_info->num_open_zones--;
-	td->num_open_zones--;
-	get_zone(f, zone_idx)->open = 0;
-}
-
-/*
- * Reset a range of zones. Returns 0 upon success and 1 upon failure.
- * @td: fio thread data.
- * @f: fio file for which to reset zones
- * @zb: first zone to reset.
- * @ze: first zone not to reset.
- */
-static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
-			   struct fio_zone_info *const zb,
-			   struct fio_zone_info *const ze)
-{
-	struct fio_zone_info *z;
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-	int res = 0;
-
-	assert(min_bs);
-
-	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
-		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
-	for (z = zb; z < ze; z++) {
-		uint32_t nz = zbd_zone_nr(f, z);
-
-		if (!z->has_wp)
-			continue;
-		zone_lock(td, f, z);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, nz);
-		pthread_mutex_unlock(&f->zbd_info->mutex);
-		if (z->wp != z->start) {
-			dprint(FD_ZBD, "%s: resetting zone %u\n",
-			       f->file_name, zbd_zone_nr(f, z));
-			if (zbd_reset_zone(td, f, z) < 0)
-				res = 1;
-		}
-		zone_unlock(z);
-	}
-
-	return res;
-}
-
 /*
  * Reset zbd_info.write_cnt, the counter that counts down towards the next
  * zone reset.
@@ -1046,8 +1159,8 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 	uint64_t swd = 0;
 	uint64_t wp_swd = 0;
 
-	zb = get_zone(f, f->min_zone);
-	ze = get_zone(f, f->max_zone);
+	zb = zbd_get_zone(f, f->min_zone);
+	ze = zbd_get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
 		if (z->has_wp) {
 			zone_lock(td, f, z);
@@ -1055,6 +1168,7 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 		}
 		swd += z->wp - z->start;
 	}
+
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
@@ -1067,6 +1181,7 @@ static uint64_t zbd_process_swd(struct thread_data *td,
 		break;
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
+
 	for (z = zb; z < ze; z++)
 		if (z->has_wp)
 			zone_unlock(z);
@@ -1097,11 +1212,13 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	if (!f->zbd_info || !td_write(td))
 		return;
 
-	zb = get_zone(f, f->min_zone);
-	ze = get_zone(f, f->max_zone);
+	zb = zbd_get_zone(f, f->min_zone);
+	ze = zbd_get_zone(f, f->max_zone);
 	swd = zbd_process_swd(td, f, SET_SWD);
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
-	       swd);
+
+	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n",
+	       __func__, f->file_name, swd);
+
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -1112,92 +1229,12 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zbd_reset_write_cnt(td, f);
 }
 
-/* The caller must hold f->zbd_info->mutex. */
-static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
-			 unsigned int zone_idx)
-{
-	struct zoned_block_device_info *zbdi = f->zbd_info;
-	int i;
-
-	/* This function should never be called when zbdi->max_open_zones == 0 */
-	assert(zbdi->max_open_zones);
-	assert(td->o.job_max_open_zones == 0 || td->num_open_zones <= td->o.job_max_open_zones);
-	assert(td->o.job_max_open_zones <= zbdi->max_open_zones);
-	assert(zbdi->num_open_zones <= zbdi->max_open_zones);
-
-	for (i = 0; i < zbdi->num_open_zones; i++)
-		if (zbdi->open_zones[i] == zone_idx)
-			return true;
-
-	return false;
-}
-
-/*
- * Open a ZBD zone if it was not yet open. Returns true if either the zone was
- * already open or if opening a new zone is allowed. Returns false if the zone
- * was not yet open and opening a new zone would cause the zone limit to be
- * exceeded.
- */
-static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
-			  uint32_t zone_idx)
-{
-	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
-	struct zoned_block_device_info *zbdi = f->zbd_info;
-	struct fio_zone_info *z = get_zone(f, zone_idx);
-	bool res = true;
-
-	if (z->cond == ZBD_ZONE_COND_OFFLINE)
-		return false;
-
-	/*
-	 * Skip full zones with data verification enabled because resetting a
-	 * zone causes data loss and hence causes verification to fail.
-	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
-		return false;
-
-	/*
-	 * zbdi->max_open_zones == 0 means that there is no limit on the maximum
-	 * number of open zones. In this case, do no track open zones in
-	 * zbdi->open_zones array.
-	 */
-	if (!zbdi->max_open_zones)
-		return true;
-
-	pthread_mutex_lock(&zbdi->mutex);
-	if (is_zone_open(td, f, zone_idx)) {
-		/*
-		 * If the zone is already open and going to be full by writes
-		 * in-flight, handle it as a full zone instead of an open zone.
-		 */
-		if (z->wp >= zbd_zone_capacity_end(z))
-			res = false;
-		goto out;
-	}
-	res = false;
-	/* Zero means no limit */
-	if (td->o.job_max_open_zones > 0 &&
-	    td->num_open_zones >= td->o.job_max_open_zones)
-		goto out;
-	if (zbdi->num_open_zones >= zbdi->max_open_zones)
-		goto out;
-	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
-	zbdi->open_zones[zbdi->num_open_zones++] = zone_idx;
-	td->num_open_zones++;
-	z->open = 1;
-	res = true;
-
-out:
-	pthread_mutex_unlock(&zbdi->mutex);
-	return res;
-}
-
 /* Return random zone index for one of the open zones. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
 {
-	return (io_u->offset - f->file_offset) * f->zbd_info->num_open_zones /
-		f->io_size;
+	return (io_u->offset - f->file_offset) *
+		f->zbd_info->num_open_zones / f->io_size;
 }
 
 static bool any_io_in_flight(void)
@@ -1244,13 +1281,15 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 */
 		zone_idx = zbdi->open_zones[pick_random_zone_idx(f, io_u)];
 	} else {
-		zone_idx = zbd_zone_idx(f, io_u->offset);
+		zone_idx = zbd_offset_to_zone_idx(f, io_u->offset);
 	}
 	if (zone_idx < f->min_zone)
 		zone_idx = f->min_zone;
 	else if (zone_idx >= f->max_zone)
 		zone_idx = f->max_zone - 1;
-	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
+
+	dprint(FD_ZBD,
+	       "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
 
 	/*
@@ -1262,13 +1301,16 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	for (;;) {
 		uint32_t tmp_idx;
 
-		z = get_zone(f, zone_idx);
+		z = zbd_get_zone(f, zone_idx);
 		if (z->has_wp)
 			zone_lock(td, f, z);
+
 		pthread_mutex_lock(&zbdi->mutex);
+
 		if (z->has_wp) {
 			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
-			    zbdi->max_open_zones == 0 && td->o.job_max_open_zones == 0)
+			    zbdi->max_open_zones == 0 &&
+			    td->o.job_max_open_zones == 0)
 				goto examine_zone;
 			if (zbdi->num_open_zones == 0) {
 				dprint(FD_ZBD, "%s(%s): no zones are open\n",
@@ -1278,14 +1320,15 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		}
 
 		/*
-		 * List of opened zones is per-device, shared across all threads.
-		 * Start with quasi-random candidate zone.
-		 * Ignore zones which don't belong to thread's offset/size area.
+		 * List of opened zones is per-device, shared across all
+		 * threads. Start with quasi-random candidate zone. Ignore
+		 * zones which don't belong to thread's offset/size area.
 		 */
 		open_zone_idx = pick_random_zone_idx(f, io_u);
 		assert(!open_zone_idx ||
 		       open_zone_idx < zbdi->num_open_zones);
 		tmp_idx = open_zone_idx;
+
 		for (i = 0; i < zbdi->num_open_zones; i++) {
 			uint32_t tmpz;
 
@@ -1302,9 +1345,12 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
+
 		pthread_mutex_unlock(&zbdi->mutex);
+
 		if (z->has_wp)
 			zone_unlock(z);
+
 		return NULL;
 
 found_candidate_zone:
@@ -1312,7 +1358,9 @@ found_candidate_zone:
 		if (new_zone_idx == zone_idx)
 			break;
 		zone_idx = new_zone_idx;
+
 		pthread_mutex_unlock(&zbdi->mutex);
+
 		if (z->has_wp)
 			zone_unlock(z);
 	}
@@ -1343,7 +1391,8 @@ open_other_zone:
 	 * zone close before opening a new zone.
 	 */
 	if (wait_zone_close) {
-		dprint(FD_ZBD, "%s(%s): quiesce to allow open zones to close\n",
+		dprint(FD_ZBD,
+		       "%s(%s): quiesce to allow open zones to close\n",
 		       __func__, f->file_name);
 		io_u_quiesce(td);
 	}
@@ -1358,7 +1407,7 @@ retry:
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx = f->min_zone;
-			z = get_zone(f, zone_idx);
+			z = zbd_get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
 		if (!z->has_wp)
@@ -1366,7 +1415,7 @@ retry:
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
-		if (zbd_open_zone(td, f, zone_idx))
+		if (zbd_open_zone(td, f, z))
 			goto out;
 	}
 
@@ -1381,7 +1430,7 @@ retry:
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
 
-		z = get_zone(f, zone_idx);
+		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
@@ -1396,7 +1445,8 @@ retry:
 	 */
 	in_flight = any_io_in_flight();
 	if (in_flight || should_retry) {
-		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
+		dprint(FD_ZBD,
+		       "%s(%s): wait zone close and retry open zones\n",
 		       __func__, f->file_name);
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
@@ -1407,17 +1457,22 @@ retry:
 	}
 
 	pthread_mutex_unlock(&zbdi->mutex);
+
 	zone_unlock(z);
-	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
-	       f->file_name);
+
+	dprint(FD_ZBD, "%s(%s): did not open another zone\n",
+	       __func__, f->file_name);
+
 	return NULL;
 
 out:
-	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
-	       zone_idx);
+	dprint(FD_ZBD, "%s(%s): returning zone %d\n",
+	       __func__, f->file_name, zone_idx);
+
 	io_u->offset = z->start;
 	assert(z->has_wp);
 	assert(z->cond != ZBD_ZONE_COND_OFFLINE);
+
 	return z;
 }
 
@@ -1429,25 +1484,27 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const struct fio_file *f = io_u->file;
 	const uint64_t min_bs = td->o.min_bs[DDIR_WRITE];
 
-	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
+	if (!zbd_open_zone(td, f, z)) {
 		zone_unlock(z);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
 	}
 
 	if (z->verify_block * min_bs >= z->capacity) {
-		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n", f->file_name, z->verify_block,
-			min_bs, z->capacity);
+		log_err("%s: %d * %"PRIu64" >= %"PRIu64"\n",
+			f->file_name, z->verify_block, min_bs, z->capacity);
 		/*
 		 * If the assertion below fails during a test run, adding
 		 * "--experimental_verify=1" to the command line may help.
 		 */
 		assert(false);
 	}
+
 	io_u->offset = z->start + z->verify_block * min_bs;
 	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
-		log_err("%s: %llu + %llu >= %"PRIu64"\n", f->file_name, io_u->offset,
-			io_u->buflen, zbd_zone_capacity_end(z));
+		log_err("%s: %llu + %llu >= %"PRIu64"\n",
+			f->file_name, io_u->offset, io_u->buflen,
+			zbd_zone_capacity_end(z));
 		assert(false);
 	}
 	z->verify_block += io_u->buflen / min_bs;
@@ -1468,7 +1525,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
 {
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
-	const struct fio_zone_info *const zf = get_zone(f, f->min_zone);
+	const struct fio_zone_info *const zf = zbd_get_zone(f, f->min_zone);
 
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1485,6 +1542,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
 		} else if (!td_random(td)) {
 			break;
 		}
+
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
 			if (z2->has_wp)
@@ -1495,8 +1553,11 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint64_t min_bytes,
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: no zone has %"PRIu64" bytes of readable data\n",
+
+	dprint(FD_ZBD,
+	       "%s: no zone has %"PRIu64" bytes of readable data\n",
 	       f->file_name, min_bytes);
+
 	return NULL;
 }
 
@@ -1517,7 +1578,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, zbd_zone_nr(f, z));
+		zbd_close_zone(td, f, z);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
@@ -1537,15 +1598,11 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	uint64_t zone_end;
 
 	assert(zbd_info);
 
-	zone_idx = zbd_zone_idx(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z = get_zone(f, zone_idx);
-
+	z = zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
 
 	if (!success)
@@ -1553,17 +1610,18 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 
 	dprint(FD_ZBD,
 	       "%s: queued I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
 
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
 		zone_end = min((uint64_t)(io_u->offset + io_u->buflen),
 			       zbd_zone_capacity_end(z));
-		pthread_mutex_lock(&zbd_info->mutex);
+
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
+		pthread_mutex_lock(&zbd_info->mutex);
 		if (z->wp <= zone_end) {
 			zbd_info->sectors_with_data += zone_end - z->wp;
 			zbd_info->wp_sectors_with_data += zone_end - z->wp;
@@ -1595,19 +1653,15 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 
 	assert(zbd_info);
 
-	zone_idx = zbd_zone_idx(f, io_u->offset);
-	assert(zone_idx < zbd_info->nr_zones);
-	z = get_zone(f, zone_idx);
-
+	z = zbd_offset_to_zone(f, io_u->offset);
 	assert(z->has_wp);
 
 	dprint(FD_ZBD,
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
-	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
+	       f->file_name, io_u->offset, io_u->buflen, zbd_zone_idx(f, z));
 
 	zbd_end_zone_io(td, io_u, z);
 
@@ -1649,28 +1703,26 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	enum fio_ddir ddir = io_u->ddir;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
 	assert(f->zbd_info);
 
-	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
-	z = get_zone(f, zone_idx);
+	z = zbd_offset_to_zone(f, f->last_pos[ddir]);
 
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
 	 * sequential write, skip to zone end if the latest position is at the
 	 * zone capacity limit.
 	 */
-	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&
-	    ddir == DDIR_WRITE &&
+	if (z->capacity < f->zbd_info->zone_size &&
+	    !td_random(td) && ddir == DDIR_WRITE &&
 	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
 		dprint(FD_ZBD,
 		       "%s: Jump from zone capacity limit to zone end:"
 		       " (%"PRIu64" -> %"PRIu64") for zone %u (%"PRIu64")\n",
 		       f->file_name, f->last_pos[ddir],
-		       zbd_zone_end(z), zone_idx, z->capacity);
+		       zbd_zone_end(z), zbd_zone_idx(f, z), z->capacity);
 		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] = zbd_zone_end(z);
 	}
@@ -1751,7 +1803,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbdi = f->zbd_info;
-	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
 	uint64_t min_bs = td->o.min_bs[io_u->ddir];
@@ -1762,14 +1813,15 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
-	zone_idx_b = zbd_zone_idx(f, io_u->offset);
-	zb = get_zone(f, zone_idx_b);
+
+	zb = zbd_offset_to_zone(f, io_u->offset);
 	orig_zb = zb;
 
 	if (!zb->has_wp) {
 		/* Accept non-write I/Os for conventional zones. */
 		if (io_u->ddir != DDIR_WRITE)
 			return io_u_accept;
+
 		/*
 		 * Make sure that writes to conventional zones
 		 * don't cross over to any sequential zones.
@@ -1783,12 +1835,16 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       "%s: off=%llu + min_bs=%"PRIu64" > next zone %"PRIu64"\n",
 			       f->file_name, io_u->offset,
 			       min_bs, (zb + 1)->start);
-			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
-			new_len = min(io_u->buflen, (zb + 1)->start - io_u->offset);
+			io_u->offset =
+				zb->start + (zb + 1)->start - io_u->offset;
+			new_len = min(io_u->buflen,
+				      (zb + 1)->start - io_u->offset);
 		} else {
 			new_len = (zb + 1)->start - io_u->offset;
 		}
+
 		io_u->buflen = new_len / min_bs * min_bs;
+
 		return io_u_accept;
 	}
 
@@ -1810,6 +1866,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb = zbd_replay_write_order(td, io_u, zb);
 			goto accept;
 		}
+
 		/*
 		 * Check that there is enough written data in the zone to do an
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
@@ -1820,7 +1877,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			zone_unlock(zb);
-			zl = get_zone(f, f->max_zone);
+			zl = zbd_get_zone(f, f->max_zone);
 			zb = zbd_find_zone(td, io_u, min_bs, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
@@ -1839,6 +1896,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			if (!td_random(td))
 				io_u->offset = zb->start;
 		}
+
 		/*
 		 * Make sure the I/O is within the zone valid data range while
 		 * maximizing the I/O size and preserving randomness.
@@ -1849,12 +1907,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			io_u->offset = zb->start +
 				((io_u->offset - orig_zb->start) %
 				 (range - io_u->buflen)) / min_bs * min_bs;
+
 		/*
 		 * When zbd_find_zone() returns a conventional zone,
 		 * we can simply accept the new i/o offset here.
 		 */
 		if (!zb->has_wp)
 			return io_u_accept;
+
 		/*
 		 * Make sure the I/O does not cross over the zone wp position.
 		 */
@@ -1866,9 +1926,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			dprint(FD_IO, "Changed length from %u into %llu\n",
 			       orig_len, io_u->buflen);
 		}
+
 		assert(zb->start <= io_u->offset);
 		assert(io_u->offset + io_u->buflen <= zb->wp);
+
 		goto accept;
+
 	case DDIR_WRITE:
 		if (io_u->buflen > zbdi->zone_size) {
 			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
@@ -1877,7 +1940,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       f->file_name, io_u->buflen, zbdi->zone_size);
 			goto eof;
 		}
-		if (!zbd_open_zone(td, f, zone_idx_b)) {
+
+		if (!zbd_open_zone(td, f, zb)) {
 			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
 			if (!zb) {
@@ -1886,14 +1950,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				goto eof;
 			}
 		}
+
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (zbdi->wp_sectors_with_data >=
-			    f->io_size * td->o.zrt.u.f &&
-			    zbd_dec_and_reset_write_cnt(td, f)) {
+			if (zbdi->wp_sectors_with_data >= f->io_size * td->o.zrt.u.f &&
+			    zbd_dec_and_reset_write_cnt(td, f))
 				zb->reset_zone = 1;
-			}
 		}
+
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
 			assert(td->o.verify == VERIFY_NONE);
@@ -1916,6 +1980,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				goto eof;
 			}
 		}
+
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
 		io_u->offset = zb->wp;
@@ -1925,6 +1990,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       f->file_name, io_u->offset);
 			goto eof;
 		}
+
 		/*
 		 * Make sure that the buflen is a multiple of the minimal
 		 * block size. Give up if shrinking would make the request too
@@ -1941,10 +2007,13 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       orig_len, io_u->buflen);
 			goto accept;
 		}
+
 		td_verror(td, EIO, "zone remainder too small");
 		log_err("zone remainder %lld smaller than min block size %"PRIu64"\n",
 			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
+
 		goto eof;
+
 	case DDIR_TRIM:
 		/* Check random trim targets a non-empty zone */
 		if (!td_random(td) || zb->wp > zb->start)
@@ -1952,7 +2021,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 		/* Find out a non-empty zone to trim */
 		zone_unlock(zb);
-		zl = get_zone(f, f->max_zone);
+		zl = zbd_get_zone(f, f->max_zone);
 		zb = zbd_find_zone(td, io_u, 1, zb, zl);
 		if (zb) {
 			io_u->offset = zb->start;
@@ -1960,7 +2029,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       f->file_name, io_u->offset);
 			goto accept;
 		}
+
 		goto eof;
+
 	case DDIR_SYNC:
 		/* fall-through */
 	case DDIR_DATASYNC:
@@ -1978,19 +2049,23 @@ accept:
 	assert(zb->cond != ZBD_ZONE_COND_OFFLINE);
 	assert(!io_u->zbd_queue_io);
 	assert(!io_u->zbd_put_io);
+
 	io_u->zbd_queue_io = zbd_queue_io;
 	io_u->zbd_put_io = zbd_put_io;
+
 	/*
 	 * Since we return with the zone lock still held,
 	 * add an annotation to let Coverity know that it
 	 * is intentional.
 	 */
 	/* coverity[missing_unlock] */
+
 	return io_u_accept;
 
 eof:
 	if (zb && zb->has_wp)
 		zone_unlock(zb);
+
 	return io_u_eof;
 }
 
@@ -2018,17 +2093,15 @@ int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
-	uint32_t zone_idx;
 	int ret;
 
-	zone_idx = zbd_zone_idx(f, io_u->offset);
-	z = get_zone(f, zone_idx);
-
+	z = zbd_offset_to_zone(f, io_u->offset);
 	if (!z->has_wp)
 		return 0;
 
 	if (io_u->offset != z->start) {
-		log_err("Trim offset not at zone start (%lld)\n", io_u->offset);
+		log_err("Trim offset not at zone start (%lld)\n",
+			io_u->offset);
 		return -EINVAL;
 	}
 
