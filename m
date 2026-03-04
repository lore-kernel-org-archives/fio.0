Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A32517A5
	for <fio@vger.kernel.org>; Wed,  4 Mar 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629211; cv=none; b=MdHm+IudlgVejxqAxz6PgfUQ1tvAzLhuZ6LL9C0cuWrfusKyqjnEiaoMDwLL26U0jZ8SRNh/MtNJpM9t1H9CT8B6pTcsTHjaAUFzF8IwcF+mepih1rJLJ6Y3c1Wn6E6s9Cpu1V+71YW7rHg3JQ4C26Aq5TOZ4MCe2v8GdOocKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629211; c=relaxed/simple;
	bh=wDL1fAIjTIf1eqNR6bEkPWI3OJUEbJILXhS1bueJTvU=;
	h=Subject:From:To:Date:Message-Id; b=PnafCsq2sv4gGudR3kjraYrPPYr+mL6vueuDCB4n8tFk0pKCowkJ/j0LeDy4ypFPo8+j9kv6sS79ARbwnZo6nYa7BtC9M0228fRbOoQylrCe8LaImbxjvKmapyPkfxkiuaIaonqqIU+r4EDxz0JOjsmHBPoPiY+TLLYXsdjCTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k+21+ZM0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k+21+ZM0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=m9HPdr2IqMGfCUskfQ9INAXNxljrZ0yHiBjtBXUQR+k=; b=k+21+ZM0M68xVT3V1gmCkrikqN
	NNiuAirRqrRIlkFVaHspiUbzcbZ9yW9aIxDPiPy6LmNzHzyIqWCjcwNHKPqRr8o5K39DtS+kJi55/
	oe6IPS31Tgs3wi1Zr8A6npCNVCRH/kto+FVCsblJxfKdxmZ6b3RuxdKoZD+VbOU+51c73SewE9pIk
	wGZ5xa1Li3jNkpIROdtIYhbhYU3/lwrD1S8kc63w1X+CtXl8c9tQsleMijAuE1OGA/L67zaSVdTC+
	RxR/1/fGLAPBwRqhl1JKS8Z8cnb84nmLC5Df4JtgdJT/ZBkO2kxRAKdoDyeAfYojMmw65pGYFB5nF
	yoC/Ye8A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlpc-0000000DIQt-1bvf
	for fio@vger.kernel.org;
	Wed, 04 Mar 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A60E81BC01A8; Wed,  4 Mar 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  4 Mar 2026 06:00:01 -0700
Message-Id: <20260304130001.A60E81BC01A8@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ccf9f41fdacae34fbf8bf839406c4cc7d5070d49:

  Merge branch 'prof-use-after-free-fix' of https://github.com/jsemric/fio (2026-03-02 10:26:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5d15185ae6f0c46822c0e360c5bd75042269a5eb:

  t/zbd: avoid test case 71 failure with write_zone_remainder option (2026-03-03 19:11:54 -0500)

----------------------------------------------------------------
Shin'ichiro Kawasaki (8):
      zbd: fix zone selection of random writes
      zbd: fix write zone accounting
      zbd: introduce write_zone_remainder option
      doc: explain the option write_zone_remainder
      t/zbd: add -m option to enable write_zone_remainder option
      t/zbd: avoid test case 14 failure with write_zone_remainder option
      t/zbd: avoid test case 33 failure with write_zone_remainder option
      t/zbd: avoid test case 71 failure with write_zone_remainder option

 HOWTO.rst                     | 26 +++++++++++++-
 cconv.c                       |  2 ++
 fio.1                         | 25 +++++++++++--
 init.c                        | 13 +++++++
 options.c                     | 10 ++++++
 server.h                      |  2 +-
 t/zbd/run-tests-against-nullb |  6 ++++
 t/zbd/test-zbd-support        | 45 +++++++++++++++++++++---
 thread_options.h              |  2 ++
 zbd.c                         | 81 ++++++++++++++++++++++++++++++++-----------
 10 files changed, 181 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 20903496..e712ee2e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1034,7 +1034,14 @@ Target file/device
 				all zones instead of being restricted to a
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
-				:option:`zonesize` must be identical.
+				:option:`zonesize` must be identical. If the
+				size of the unwritten space in a zone is not
+				a multiple of the specified block size at
+				workload start, write workloads create unwritten
+				remainder areas at the ends of zones and keep
+				the zones in open conditions. To free up the
+				open zone resources, fio issues zone finish
+				operations to the zones with the remainders.
 				Trim is handled using a zone reset operation.
 				Trim only considers non-empty sequential write
 				required and sequential write preferred zones.
@@ -1167,6 +1174,23 @@ Target file/device
 	asynchronous IO engine and :option:`verify` workload are specified,
 	errors out. Default: false.
 
+.. option:: write_zone_remainders=bool
+
+	If the size of the unwritten space in a zone is not a multiple of the
+	specified block size at workload start, write workloads create unwritten
+	remainder areas at the ends of zones. By default, fio issues zone finish
+	operations on such zones, transitioning them to the full condition and
+	freeing up open zone resources. However, zone finish operations
+	introduces waits for in-flight writes, reducing overall write
+	throughput. If this option is specified, fio writes data to the
+	remainder areas instead of performing zone finish operations. This
+	improves write throughput by avoiding waits for in-flight writes,
+	particularly in asynchronous write workloads. The drawback of this
+	option is that it requires fio to perform writes smaller than the
+	minimum block size. Consequently, the option :option:`norandommap` must
+	be set. If :option:`norandommap` is not set, it is automatically set.
+	Default: false.
+
 I/O type
 ~~~~~~~~
 
diff --git a/cconv.c b/cconv.c
index 4e9c4b32..1c1b7273 100644
--- a/cconv.c
+++ b/cconv.c
@@ -276,6 +276,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->max_open_zones = __le32_to_cpu(top->max_open_zones);
 	o->ignore_zone_limits = le32_to_cpu(top->ignore_zone_limits);
 	o->recover_zbd_write_error = le32_to_cpu(top->recover_zbd_write_error);
+	o->write_zone_remainder = le32_to_cpu(top->write_zone_remainder);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment_percent = le32_to_cpu(top->offset_increment_percent);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
@@ -658,6 +659,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->max_open_zones = __cpu_to_le32(o->max_open_zones);
 	top->ignore_zone_limits = cpu_to_le32(o->ignore_zone_limits);
 	top->recover_zbd_write_error = cpu_to_le32(o->recover_zbd_write_error);
+	top->write_zone_remainder = cpu_to_le32(o->write_zone_remainder);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/fio.1 b/fio.1
index 207fdb42..4c37848b 100644
--- a/fio.1
+++ b/fio.1
@@ -809,9 +809,14 @@ starts. The \fBzonecapacity\fR parameter is ignored.
 .B zbd
 Zoned block device mode. I/O happens sequentially in each zone, even if random
 I/O has been selected. Random I/O happens across all zones instead of being
-restricted to a single zone.
-Trim is handled using a zone reset operation. Trim only considers non-empty
-sequential write required and sequential write preferred zones.
+restricted to a single zone. The \fBzoneskip\fR parameter is ignored.
+\fBzonerange\fR and \fBzonesize\fR must be identical. If the size of the
+unwritten space in a zone is not a multiple of the specified block size at
+workload start, write workloads create unwritten remainder areas at the ends of
+zones and keep the zones in open conditions. To free up the open zone resources,
+fio issues zone finish operations to the zones with the remainders. Trim is
+handled using a zone reset operation. Trim only considers non-empty sequential
+write required and sequential write preferred zones.
 .RE
 .RE
 .TP
@@ -931,6 +936,20 @@ fail due to partial writes and unexpected write pointer positions. If
 asynchronous, the write pointer move fills blocks with zero then breaks verify
 data. If an asynchronous IO engine and \fBverify\fR workload are specified,
 errors out. Default: false.
+.TP
+.BI write_zone_remainders \fR=\fPbool
+If the size of the unwritten space in a zone is not a multiple of the specified
+block size at workload start, write workloads create unwritten remainder areas
+at the ends of zones. By default, fio issues zone finish operations on such
+zones, transitioning them to the full condition and freeing up open zone
+resources. However, zone finish operations introduces waits for in-flight
+writes, reducing overall write throughput. If this option is specified, fio
+writes data to the remainder areas instead of performing zone finish operations.
+This improves write throughput by avoiding waits for in-flight writes,
+particularly in asynchronous write workloads. The drawback of this option is
+that it requires fio to perform writes smaller than the minimum block size.
+Consequently, the option \fBnorandommap\fR must be set. If \fBnorandommap\fR is
+not set, it is automatically set. Default: false.
 
 .SS "I/O type"
 .TP
diff --git a/init.c b/init.c
index 07278619..623c14e6 100644
--- a/init.c
+++ b/init.c
@@ -666,6 +666,19 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (o->zone_mode == ZONE_MODE_ZBD && o->write_zone_remainder) {
+		if (fio_option_is_set(o, norandommap)) {
+			if (o->norandommap == 0) {
+				log_err("fio: write_zone_remainder=1 requires norandommap=1\n");
+				ret |= 1;
+			}
+			/* if == 1, OK */
+		} else {
+			dprint(FD_ZBD, "fio: override norandommap=1 for write_zone_remainder=1\n");
+			o->norandommap = 1;
+		}
+	}
+
 	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_size) {
 		log_err("fio: --zonesize must be specified when using --zonemode=strided.\n");
 		ret |= 1;
diff --git a/options.c b/options.c
index 6406dd0c..8d9e3054 100644
--- a/options.c
+++ b/options.c
@@ -3939,6 +3939,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name	= "write_zone_remainder",
+		.lname	= "Fill remainders of zones by write instead of zone finish operion",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, write_zone_remainder),
+		.def	= 0,
+		.help	= "When block size is unaligned, zones have small remainder write areas at ends. Fill them by write instead of zone finish operations for better performance.",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name   = "fdp",
 		.lname  = "Flexible data placement",
diff --git a/server.h b/server.h
index 589e8bea..6ac89013 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 119,
+	FIO_SERVER_VER			= 120,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index f1cba355..628e41a3 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -23,6 +23,7 @@ usage()
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
 	echo -e "\t   or an individual section/test."
+	echo -e "\t-m Pass -m option to test-zbd-support to enable write_zone_remainder."
 	echo -e "\t-q Quit t/zbd/test-zbd-support run after any failed test."
 	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
 	echo -e "\t   running this script."
@@ -426,6 +427,7 @@ dev_size=1024
 dev_blocksize=4096
 set_max_open=8
 set_extra_max_active=2
+write_zone_remainder=0
 zbd_test_opts=()
 num_of_runs=1
 test_case=0
@@ -438,6 +440,7 @@ while (($#)); do
 		-L) list_only=1; shift;;
 		-r) cleanup_nullb; exit 0;;
 		-n) num_of_runs="${2}"; shift; shift;;
+		-m) write_zone_remainder=1; shift;;
 		-t) test_case="${2}"; shift; shift;;
 		-q) quit_on_err=1; shift;;
 		-h) usage; break;;
@@ -491,6 +494,9 @@ while ((run_nr <= $num_of_runs)); do
 		if ((quit_on_err)); then
 			zbd_test_opts+=("-q")
 		fi
+		if ((write_zone_remainder)); then
+			zbd_test_opts+=("-m")
+		fi
 		section$section_number
 		configure_nullb
 		rc=$?
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 40f1de90..2c57de95 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -13,6 +13,7 @@ usage() {
 	echo -e "\t-l Test with libzbc ioengine"
 	echo -e "\t-r Reset all zones before test start"
 	echo -e "\t-w Reset all zones before executing each write test case"
+	echo -e "\t-m Write zone remainder instead of zone finish operation"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-s <test #> Start testing from the case with the specified number"
@@ -202,6 +203,30 @@ has_max_open_zones() {
 	return 1
 }
 
+has_zone_writes() {
+	local has_zonemode_zbd=0
+	local has_write=0
+	local word
+
+	while (($# > 1)); do
+		if [[ ${1} =~ "--zonemode=zbd" ]]; then
+			has_zonemode_zbd=1
+		fi
+		if [[ ${1} =~ "--rw=" ]]; then
+			word=${1}
+			word=${word/--rw=/}
+			if [[ $word =~ w ]]; then
+				has_write=1
+			fi
+		fi
+		shift
+	done
+	if ((has_zonemode_zbd && has_write)); then
+		return 0
+	fi
+	return 1
+}
+
 run_fio() {
     local fio opts
 
@@ -215,6 +240,9 @@ run_fio() {
     if [[ -n ${max_open_zones_opt} ]] && ! has_max_open_zones "${opts[@]}"; then
 	    opts+=("--max_open_zones=${max_open_zones_opt}")
     fi
+    if [[ -n ${write_zone_remainder} ]] && has_zone_writes "${opts[@]}"; then
+	    opts+=("--write_zone_remainder=1")
+    fi
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -637,7 +665,7 @@ test13() {
 
 # Random write to conventional zones.
 test14() {
-    local off size
+    local off size nr_overlaps
 
     if ! result=($(first_online_zone "$dev")); then
 	echo "Failed to determine first online zone"
@@ -650,10 +678,11 @@ test14() {
 
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
-		    --verify=md5 --offset=$off --size=$size\
+		    --verify=md5 --offset=$off --size=$size --debug=io \
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    nr_overlaps=$(grep "iolog: overlap" --count "${logfile}.${test_number}")
     check_written $((size)) || return $?
-    check_read $((size)) || return $?
+    check_read $((size - nr_overlaps * 16 * 1024)) || return $?
 }
 
 # Sequential read on a mix of empty and full zones.
@@ -973,10 +1002,13 @@ test33() {
     size=$((2 * zone_size))
     io_size=$((5 * capacity))
     bs=$((3 * capacity / 4))
+    if ((!write_zone_remainder)); then
+	    io_size=$((io_size / bs * bs))
+    fi
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((io_size / bs * bs)) || return $?
+    check_written $((io_size)) || return $?
 }
 
 # Test repeated async write job with verify using two unaligned block sizes.
@@ -1736,7 +1768,8 @@ test71() {
 			--max_open_zones=1 --debug=zbd \
 		       >> "${logfile}.${test_number}" 2>&1 || return $?
 
-	check_written $((zone_size * 8)) || return $?
+	check_written $((zone_size * 8)) ||
+		check_written $((zone_size * 8 + 4096)) || return $?
 }
 
 set_nullb_badblocks() {
@@ -1877,6 +1910,7 @@ reset_all_zones=
 reset_before_write=
 use_libzbc=
 zbd_debug=
+write_zone_remainder=
 max_open_zones_opt=
 quit_on_err=
 force_io_uring=
@@ -1892,6 +1926,7 @@ while [ "${1#-}" != "$1" ]; do
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -w) reset_before_write=1; shift;;
+    -m) write_zone_remainder=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -s) start_test=$2; shift; shift;;
diff --git a/thread_options.h b/thread_options.h
index ff1f40ec..1b7f67eb 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -400,6 +400,7 @@ struct thread_options {
 	unsigned int job_max_open_zones;
 	unsigned int ignore_zone_limits;
 	unsigned int recover_zbd_write_error;
+	unsigned int write_zone_remainder;
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
@@ -731,6 +732,7 @@ struct thread_options_pack {
 	int32_t max_open_zones;
 	uint32_t ignore_zone_limits;
 	uint32_t recover_zbd_write_error;
+	uint32_t write_zone_remainder;
 
 	uint32_t log_entries;
 	uint32_t log_prio;
diff --git a/zbd.c b/zbd.c
index 08c537d7..6c93af51 100644
--- a/zbd.c
+++ b/zbd.c
@@ -86,18 +86,21 @@ static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
 
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
- * @f: file pointer.
+ * @td: FIO thread data
  * @z: zone info pointer.
  * @required: minimum number of bytes that must remain in a zone.
  *
  * The caller must hold z->mutex.
  */
-static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
+static bool zbd_zone_full(const struct thread_data *td, struct fio_zone_info *z,
 			  uint64_t required)
 {
+	if (!z->has_wp)
+		return false;
+	if (td->o.write_zone_remainder)
+		return zbd_zone_remainder(z) == 0;
 	assert((required & 511) == 0);
-
-	return z->has_wp && required > zbd_zone_remainder(z);
+	return required > zbd_zone_remainder(z);
 }
 
 static void zone_lock(struct thread_data *td, const struct fio_file *f,
@@ -629,7 +632,7 @@ static bool zbd_write_zone_get(struct thread_data *td, const struct fio_file *f,
 	 * Skip full zones with data verification enabled because resetting a
 	 * zone causes data loss and hence causes verification to fail.
 	 */
-	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(td, z, min_bs))
 		return false;
 
 	return __zbd_write_zone_get(td, f, z);
@@ -1513,14 +1516,16 @@ static struct fio_zone_info *zbd_convert_to_write_zone(struct thread_data *td,
 	struct fio_zone_info *z;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
-	bool wait_zone_write;
+	bool wait_zone_write = false;
 	bool in_flight;
 	bool should_retry = true;
 	bool need_zone_finish;
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (zbd_zone_remainder(zb) > 0 && zbd_zone_remainder(zb) < min_bs) {
+	/* If the first selected zone has remainder, finish it */
+	if (!td->o.write_zone_remainder && zbd_zone_remainder(zb) > 0 &&
+	    zbd_zone_remainder(zb) < min_bs) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		zbd_write_zone_put(td, f, zb);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1619,13 +1624,18 @@ examine_zone:
 	}
 
 choose_other_zone:
-	/* Check if number of write target zones reaches one of limits. */
-	wait_zone_write =
-		zbdi->num_write_zones == f->max_zone - f->min_zone ||
-		(zbdi->max_write_zones &&
-		 zbdi->num_write_zones == zbdi->max_write_zones) ||
-		(td->o.job_max_open_zones &&
-		 td->num_write_zones == td->o.job_max_open_zones);
+	/*
+	 * When zones have small remainder at zone ends, zone finish operations
+	 * may take some time. In this case, check if number of write target
+	 * zones reaches one of limits to wait for the zone finish operations.
+	 */
+	if (!td->o.write_zone_remainder)
+		wait_zone_write =
+			zbdi->num_write_zones == f->max_zone - f->min_zone ||
+			(zbdi->max_write_zones &&
+			 zbdi->num_write_zones == zbdi->max_write_zones) ||
+			(td->o.job_max_open_zones &&
+			 td->num_write_zones == td->o.job_max_open_zones);
 
 	pthread_mutex_unlock(&zbdi->mutex);
 
@@ -1643,6 +1653,19 @@ choose_other_zone:
 	}
 
 retry:
+	/*
+	 * For random writes, retry from the zone chosen at the beginning using
+	 * the initial io_u random offset.
+	 */
+	if (td_random(td)) {
+		zone_unlock(z);
+		zone_lock(td, f, zb);
+		if (zbd_write_zone_get(td, f, zb))
+			return zb;
+		z = zb;
+		zone_idx = zbd_zone_idx(f, z);
+	}
+
 	/* Zone 'z' is full, so try to choose a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
@@ -1668,8 +1691,10 @@ retry:
 
 	/* Check whether the write fits in any of the write target zones. */
 	pthread_mutex_lock(&zbdi->mutex);
-	need_zone_finish = true;
+	need_zone_finish = !td->o.write_zone_remainder;
 	for (i = 0; i < zbdi->num_write_zones; i++) {
+		uint64_t remainder;
+
 		zone_idx = zbdi->write_zones[i];
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
@@ -1679,7 +1704,17 @@ retry:
 		z = zbd_get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
-		if (zbd_zone_remainder(z) >= min_bs) {
+		/*
+		 * Check remainder size of the zone to see if the next write
+		 * fits the zone. In that case, choose the zone for the write.
+		 * The zone might be already removed from zbdi->write_zones[] by
+		 * other jobs at this moment. Call zbd_write_zone_get() to
+		 * ensure that the zone for the write is in the array.
+		 */
+		remainder = zbd_zone_remainder(z);
+		if (((td->o.write_zone_remainder && remainder > 0) ||
+		     (!td->o.write_zone_remainder && remainder >= min_bs)) &&
+		    zbd_write_zone_get(td, f, z)) {
 			need_zone_finish = false;
 			goto out;
 		}
@@ -2208,7 +2243,8 @@ retry:
 			goto eof;
 		}
 
-		if (zbd_zone_remainder(zb) > 0 &&
+		if (!td->o.write_zone_remainder &&
+		    zbd_zone_remainder(zb) > 0 &&
 		    zbd_zone_remainder(zb) < min_bs)
 			goto retry;
 
@@ -2221,7 +2257,7 @@ retry:
 		}
 
 		/* Reset the zone pointer if necessary */
-		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
+		if (zb->reset_zone || zbd_zone_full(td, zb, min_bs)) {
 			if (td->o.verify != VERIFY_NONE) {
 				/*
 				 * Unset io-u->file to tell get_next_verify()
@@ -2256,7 +2292,7 @@ retry:
 		}
 
 		/* Make writes occur at the write pointer */
-		assert(!zbd_zone_full(f, zb, min_bs));
+		assert(!zbd_zone_full(td, zb, min_bs));
 		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
 			td_verror(td, EINVAL, "invalid WP value");
@@ -2272,10 +2308,13 @@ retry:
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
 			      zbd_zone_capacity_end(zb) - io_u->offset);
-		new_len = new_len / min_bs * min_bs;
+		if ((td->o.write_zone_remainder && new_len > min_bs) ||
+			!td->o.write_zone_remainder)
+			new_len = new_len / min_bs * min_bs;
+
 		if (new_len == io_u->buflen)
 			goto accept;
-		if (new_len >= min_bs) {
+		if (td->o.write_zone_remainder || new_len >= min_bs) {
 			io_u->buflen = new_len;
 			dprint(FD_IO, "Changed length from %u into %llu\n",
 			       orig_len, io_u->buflen);
