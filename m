Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1902763E1
	for <fio@vger.kernel.org>; Thu,  8 Feb 2024 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707397219; cv=none; b=IygU656ySgZEJB1EcIsDwLGoq+oSd3/ey9w4UM94QHpp4Nnp8hbUzJZBRoBJhxNVh/v9y75ZsSmGq0q3FWBFNJkxt2UzTlx432CHJiL2uBn8CMtJ9dVZbeIe0/61kAVLbIJyQXBOgj5w56ThnJLjAm6WClKXGKsbIwwh4/LsQOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707397219; c=relaxed/simple;
	bh=EKDREDAfJwqEZEGhLznLytEgsJV0cPyvTEPkDk7XYF4=;
	h=Subject:From:To:Message-Id:Date; b=eO5D1eR6nKSeA7+2LizgWBWlG6Dh9PFW+2k9xVzUgJisw526yK1PeERrWU0Li1gASXptFKurRpRaepFBeNulwops9Iud5UOYxAumiC8wWcgDLt4YzM3KCFUM8z+SC39Kp9xDe9uD+V4v6hZ519C2dHJbtbYvZQoLmq+JNJ5kRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FUOXQA5B; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FUOXQA5B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xCGAjyuDN88oa0hWLQt6SjSKXVjj2qbgmXmKuXFHNyw=; b=FUOXQA5BtnsxexX710EdFVQp9I
	bae06AV3GjwmVuOLdIXC0BAw5nO7fm2hQL75A9TtO2W4luxX9kgDimnddon1qNhVT7nqmpxNPTxmz
	owJd6jWG0MMH7M7gMeAlFtNgo0R9oP+gwx4bsoxd6JqzLQ0esZZggR22vQ3aC1iqjTkoN8AQ7L/DO
	uqaH9sfomFleO0Zzz6p6npFOHLZa3h1PrAc3TRv9XRqJI/W1xMQmH39pV+aI8pEEexWJGR4k4lUq/
	UL1mjp2l6jGuyHfXIQNqyhiH3i6UapNaL8hFgW4UzhqIt15m6PzPwM6kK3MIg7aN0XAz79TrsqiQ6
	ayjyPn5Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rY40Z-0000000DS2b-3yL7
	for fio@vger.kernel.org;
	Thu, 08 Feb 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 557A51BC0145; Thu,  8 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240208130001.557A51BC0145@kernel.dk>
Date: Thu,  8 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 625b155dcd3d56595ced60806e091126446c1e08:

  examples: cmdprio_bssplit: add CDL example (2024-01-27 11:18:57 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 12067650d11d4777dee0cd64a136923c2fd2d073:

  t/zbd: add -s option to test-zbd-support script (2024-02-07 08:43:13 -0500)

----------------------------------------------------------------
Dmitry Fomichev (5):
      zbd: avoid assertions during sequential read I/O
      oslib: log BLKREPORTZONE error code
      zbd: use a helper to calculate zone index
      t/zbd: check device for unrestricted read support
      t/zbd: add -s option to test-zbd-support script

 oslib/linux-blkzoned.c |  2 ++
 t/zbd/functions        | 22 ++++++++++++++++++++++
 t/zbd/test-zbd-support | 20 ++++++++++++++++++--
 zbd.c                  | 21 +++++++++++++++------
 4 files changed, 57 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 2c3ecf33..1cc8d288 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -242,6 +242,8 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 	hdr->sector = offset >> 9;
 	ret = ioctl(fd, BLKREPORTZONE, hdr);
 	if (ret) {
+		log_err("%s: BLKREPORTZONE ioctl failed, ret=%d, err=%d.\n",
+			f->file_name, ret, -errno);
 		ret = -errno;
 		goto out;
 	}
diff --git a/t/zbd/functions b/t/zbd/functions
index 028df404..7734371e 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -290,6 +290,28 @@ min_seq_write_size() {
 	fi
 }
 
+urswrz() {
+    local dev=$1
+
+    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
+	if ! ${sg_inq} -e --page=0xB6 --len=10 --hex "$dev" \
+		 > /dev/null 2>&1; then
+	    # Couldn't get URSWRZ bit. Assume the reads are unrestricted
+	    # because this configuration is more common.
+	    echo 1
+	else
+	    ${sg_inq} -e --page=0xB6 --len=10 --hex "$dev" | tail -1 |
+		{
+		    read -r offset b0 b1 b2 b3 b4 trailer && \
+			echo $(( $b4 & 0x01 )) || echo 0
+		}
+	fi
+    else
+	${zbc_info} "$dev" |
+	    sed -n 's/^[[:blank:]].*Read commands are \(un\)restricted*/\1/p' | grep -q ^ && echo 1 || echo 0
+    fi
+}
+
 is_zbc() {
 	local dev=$1
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 532860eb..c27d2ad6 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -15,6 +15,7 @@ usage() {
 	echo -e "\t-w Reset all zones before executing each write test case"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-s <test #> Start testing from the case with the specified number"
 	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
 	echo -e "\t-u Use io_uring ioengine in place of libaio"
@@ -412,8 +413,16 @@ test4() {
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
     opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_read $size || return $?
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+    fio_rc=$?
+    if [[ $unrestricted_reads != 0 ]]; then
+	if [[ $fio_rc != 0 ]]; then
+		return "$fio_rc"
+	fi
+	check_read $size || return $?
+    else
+        [ $fio_rc == 0 ] && return 1 || return 0
+    fi
 }
 
 # Sequential write to sequential zones.
@@ -1594,6 +1603,7 @@ zbd_debug=
 max_open_zones_opt=
 quit_on_err=
 force_io_uring=
+start_test=1
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -1607,6 +1617,7 @@ while [ "${1#-}" != "$1" ]; do
     -w) reset_before_write=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
+    -s) start_test=$2; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
     -q) quit_on_err=1; shift;;
@@ -1664,6 +1675,7 @@ if [[ -b "$realdev" ]]; then
 		first_sequential_zone_sector=${result[0]}
 		sectors_per_zone=${result[1]}
 		zone_size=$((sectors_per_zone * 512))
+		unrestricted_reads=$(urswrz "$dev")
 		if ! max_open_zones=$(max_open_zones "$dev"); then
 			echo "Failed to determine maximum number of open zones"
 			exit 1
@@ -1681,9 +1693,11 @@ if [[ -b "$realdev" ]]; then
 		sectors_per_zone=$((zone_size / 512))
 		max_open_zones=128
 		max_active_zones=0
+		unrestricted_reads=1
 		set_io_scheduler "$basename" none || exit $?
 		;;
 	esac
+
 elif [[ -c "$realdev" ]]; then
 	# For an SG node, we must have libzbc option specified
 	if [[ ! -n "$use_libzbc" ]]; then
@@ -1712,6 +1726,7 @@ elif [[ -c "$realdev" ]]; then
 	first_sequential_zone_sector=${result[0]}
 	sectors_per_zone=${result[1]}
 	zone_size=$((sectors_per_zone * 512))
+	unrestricted_reads=$(urswrz "$dev")
 	if ! max_open_zones=$(max_open_zones "$dev"); then
 		echo "Failed to determine maximum number of open zones"
 		exit 1
@@ -1761,6 +1776,7 @@ trap 'intr=1' SIGINT
 ret=0
 
 for test_number in "${tests[@]}"; do
+    [ "${test_number}" -lt "${start_test}" ] && continue
     rm -f "${logfile}.${test_number}"
     unset SKIP_REASON
     echo -n "Running test $(printf "%02d" $test_number) ... "
diff --git a/zbd.c b/zbd.c
index 61b5b688..37417660 100644
--- a/zbd.c
+++ b/zbd.c
@@ -104,8 +104,7 @@ static void zone_lock(struct thread_data *td, const struct fio_file *f,
 		      struct fio_zone_info *z)
 {
 #ifndef NDEBUG
-	struct zoned_block_device_info *zbd = f->zbd_info;
-	uint32_t const nz = z - zbd->zone_info;
+	unsigned int const nz = zbd_zone_idx(f, z);
 	/* A thread should never lock zones outside its working area. */
 	assert(f->min_zone <= nz && nz < f->max_zone);
 	assert(z->has_wp);
@@ -674,9 +673,20 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 		return false;
 	}
 
+	if (td->o.td_ddir == TD_DDIR_READ) {
+		z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
+		new_end = z->start;
+		if (f->file_offset + f->io_size > new_end) {
+			log_info("%s: rounded io_size from %"PRIu64" to %"PRIu64"\n",
+				 f->file_name, f->io_size,
+				 new_end - f->file_offset);
+			f->io_size = new_end - f->file_offset;
+		}
+		return true;
+	}
+
 	z = zbd_offset_to_zone(f, f->file_offset);
-	if ((f->file_offset != z->start) &&
-	    (td->o.td_ddir != TD_DDIR_READ)) {
+	if (f->file_offset != z->start) {
 		new_offset = zbd_zone_end(z);
 		if (new_offset >= f->file_offset + f->io_size) {
 			log_info("%s: io_size must be at least one zone\n",
@@ -692,8 +702,7 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 
 	z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
 	new_end = z->start;
-	if ((td->o.td_ddir != TD_DDIR_READ) &&
-	    (f->file_offset + f->io_size != new_end)) {
+	if (f->file_offset + f->io_size != new_end) {
 		if (new_end <= f->file_offset) {
 			log_info("%s: io_size must be at least one zone\n",
 				 f->file_name);
