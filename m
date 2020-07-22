Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Jul 2020 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ACDC0619DC
        for <fio@vger.kernel.org>; Wed, 22 Jul 2020 05:00:09 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyDPq-0006yD-7X
        for fio@vger.kernel.org; Wed, 22 Jul 2020 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200722120002.288471BC01B2@kernel.dk>
Date: Wed, 22 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d13596b225baf61425a9ca92b0583fc3fa97765d:

  Fio 3.21 (2020-07-20 16:37:50 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5090d1d0f2a109c276384c93308566b7a3bfa5ad:

  zbd: fix %lu -> %llu dprint() formatting (2020-07-21 09:40:07 -0600)

----------------------------------------------------------------
Hans Holmberg (3):
      options: Add zonecapacity option for zonemode=zbd
      t/zbd: Support testing zone capacity smaller than zone size
      t/zbd: Add test case to check zonecapacity option

Jens Axboe (1):
      zbd: fix %lu -> %llu dprint() formatting

Shin'ichiro Kawasaki (3):
      zbd: Support zone capacity smaller than zone size
      t/zbd: Mandate blkzone capacity report for devices with zone capacity
      t/zbd: Support testing zone capacity smaller than zone size with null_blk

 HOWTO                               |  18 +++++-
 cconv.c                             |   2 +
 configure                           |  19 ++++++
 engines/libzbc.c                    |   5 ++
 fio.1                               |  13 +++-
 options.c                           |  11 ++++
 oslib/linux-blkzoned.c              |  11 ++++
 t/zbd/functions                     |  82 ++++++++++++++++++++++++
 t/zbd/run-tests-against-zoned-nullb |  30 ++++++++-
 t/zbd/test-zbd-support              | 123 ++++++++++++++++++++++++++----------
 thread_options.h                    |   2 +
 zbd.c                               |  87 ++++++++++++++++++++-----
 zbd.h                               |   2 +
 zbd_types.h                         |   1 +
 14 files changed, 348 insertions(+), 58 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 8cf8d650..35ead0cb 100644
--- a/HOWTO
+++ b/HOWTO
@@ -970,14 +970,15 @@ Target file/device
 	Accepted values are:
 
 		**none**
-				The :option:`zonerange`, :option:`zonesize` and
-				:option:`zoneskip` parameters are ignored.
+				The :option:`zonerange`, :option:`zonesize`,
+				:option `zonecapacity` and option:`zoneskip`
+				parameters are ignored.
 		**strided**
 				I/O happens in a single zone until
 				:option:`zonesize` bytes have been transferred.
 				After that number of bytes has been
 				transferred processing of the next zone
-				starts.
+				starts. :option `zonecapacity` is ignored.
 		**zbd**
 				Zoned block device mode. I/O happens
 				sequentially in each zone, even if random I/O
@@ -1004,6 +1005,17 @@ Target file/device
 	For :option:`zonemode` =zbd, this is the size of a single zone. The
 	:option:`zonerange` parameter is ignored in this mode.
 
+
+.. option:: zonecapacity=int
+
+	For :option:`zonemode` =zbd, this defines the capacity of a single zone,
+	which is the accessible area starting from the zone start address.
+	This parameter only applies when using :option:`zonemode` =zbd in
+	combination with regular block devices. If not specified it defaults to
+	the zone size. If the target device is a zoned block device, the zone
+	capacity is obtained from the device information and this option is
+	ignored.
+
 .. option:: zoneskip=int
 
 	For :option:`zonemode` =strided, the number of bytes to skip after
diff --git a/cconv.c b/cconv.c
index 449bcf7b..2469389b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -223,6 +223,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->ss_limit.u.f = fio_uint64_to_double(le64_to_cpu(top->ss_limit.u.i));
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
+	o->zone_capacity = le64_to_cpu(top->zone_capacity);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
 	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->lockmem = le64_to_cpu(top->lockmem);
@@ -563,6 +564,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->ss_limit.u.i = __cpu_to_le64(fio_double_to_uint64(o->ss_limit.u.f));
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
+	top->zone_capacity = __cpu_to_le64(o->zone_capacity);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
 	top->zone_mode = __cpu_to_le32(o->zone_mode);
 	top->lockmem = __cpu_to_le64(o->lockmem);
diff --git a/configure b/configure
index 6991393b..b079a2a5 100755
--- a/configure
+++ b/configure
@@ -2390,6 +2390,7 @@ if compile_prog "" "" "valgrind_dev"; then
 fi
 print_config "Valgrind headers" "$valgrind_dev"
 
+if test "$targetos" = "Linux" ; then
 ##########################################
 # <linux/blkzoned.h> probe
 if test "$linux_blkzoned" != "yes" ; then
@@ -2407,6 +2408,24 @@ if compile_prog "" "" "linux_blkzoned"; then
 fi
 print_config "Zoned block device support" "$linux_blkzoned"
 
+##########################################
+# Check BLK_ZONE_REP_CAPACITY
+cat > $TMPC << EOF
+#include <linux/blkzoned.h>
+int main(void)
+{
+  return BLK_ZONE_REP_CAPACITY;
+}
+EOF
+if compile_prog "" "" "blkzoned report capacity"; then
+  output_sym "CONFIG_HAVE_REP_CAPACITY"
+  rep_capacity="yes"
+else
+  rep_capacity="no"
+fi
+print_config "Zoned block device capacity" "$rep_capacity"
+fi
+
 ##########################################
 # libzbc probe
 if test "$libzbc" != "yes" ; then
diff --git a/engines/libzbc.c b/engines/libzbc.c
index fdde8ca6..4b900233 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -235,6 +235,11 @@ static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
 		zbdz->start = zones[i].zbz_start << 9;
 		zbdz->len = zones[i].zbz_length << 9;
 		zbdz->wp = zones[i].zbz_write_pointer << 9;
+		/*
+		 * ZBC/ZAC do not define zone capacity, so use the zone size as
+		 * the zone capacity.
+		 */
+		zbdz->capacity = zbdz->len;
 
 		switch (zones[i].zbz_type) {
 		case ZBC_ZT_CONVENTIONAL:
diff --git a/fio.1 b/fio.1
index f134e0bf..a3d348b2 100644
--- a/fio.1
+++ b/fio.1
@@ -738,12 +738,13 @@ Accepted values are:
 .RS
 .TP
 .B none
-The \fBzonerange\fR, \fBzonesize\fR and \fBzoneskip\fR parameters are ignored.
+The \fBzonerange\fR, \fBzonesize\fR \fBzonecapacity\fR and \fBzoneskip\fR
+parameters are ignored.
 .TP
 .B strided
 I/O happens in a single zone until \fBzonesize\fR bytes have been transferred.
 After that number of bytes has been transferred processing of the next zone
-starts.
+starts. The \fBzonecapacity\fR parameter is ignored.
 .TP
 .B zbd
 Zoned block device mode. I/O happens sequentially in each zone, even if random
@@ -771,6 +772,14 @@ zoned block device, the specified \fBzonesize\fR must be 0 or equal to the
 device zone size. For a regular block device or file, the specified
 \fBzonesize\fR must be at least 512B.
 .TP
+.BI zonecapacity \fR=\fPint
+For \fBzonemode\fR=zbd, this defines the capacity of a single zone, which is
+the accessible area starting from the zone start address. This parameter only
+applies when using \fBzonemode\fR=zbd in combination with regular block devices.
+If not specified it defaults to the zone size. If the target device is a zoned
+block device, the zone capacity is obtained from the device information and this
+option is ignored.
+.TP
 .BI zoneskip \fR=\fPint
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
 bytes of data have been transferred.
diff --git a/options.c b/options.c
index 85a0f490..251ad2c1 100644
--- a/options.c
+++ b/options.c
@@ -3327,6 +3327,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
+	{
+		.name	= "zonecapacity",
+		.lname	= "Zone capacity",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= offsetof(struct thread_options, zone_capacity),
+		.help	= "Capacity per zone",
+		.def	= "0",
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
 	{
 		.name	= "zonerange",
 		.lname	= "Zone range",
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 1cf06363..6fe78b9c 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -113,6 +113,16 @@ out:
 	return 0;
 }
 
+static uint64_t zone_capacity(struct blk_zone_report *hdr,
+			      struct blk_zone *blkz)
+{
+#ifdef CONFIG_HAVE_REP_CAPACITY
+	if (hdr->flags & BLK_ZONE_REP_CAPACITY)
+		return blkz->capacity << 9;
+#endif
+	return blkz->len << 9;
+}
+
 int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 			  uint64_t offset, struct zbd_zone *zones,
 			  unsigned int nr_zones)
@@ -149,6 +159,7 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 		z->start = blkz->start << 9;
 		z->wp = blkz->wp << 9;
 		z->len = blkz->len << 9;
+		z->capacity = zone_capacity(hdr, blkz);
 
 		switch (blkz->type) {
 		case BLK_ZONE_TYPE_CONVENTIONAL:
diff --git a/t/zbd/functions b/t/zbd/functions
index 1bd22ec4..81b6f3f7 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -19,6 +19,51 @@ if [ -n "${use_libzbc}" ] &&
     exit 1
 fi
 
+blkzone_reports_capacity() {
+	local dev="${1}"
+
+	[[ -n "${blkzone}" ]] &&
+		"${blkzone}" report -c 1 -o 0 "${dev}" | grep -q 'cap '
+}
+
+# Whether or not $1 (/dev/...) is a NVME ZNS device.
+is_nvme_zns() {
+	local s
+
+	s=/sys/block/$(basename "${1}")/device/subsystem
+
+	if [[ ! -h "${s}" || $(realpath "${s}") != /sys/class/nvme ]]; then
+		return 1
+	fi
+
+	[[ $(</sys/block/$(basename "${1}")/queue/zoned) == host-managed ]]
+}
+
+# Whether or not $1 (/dev/...) is a null_blk device with zone capacity smaller
+# than zone size.
+is_nullb_with_zone_cap() {
+	local f
+
+	f=/sys/kernel/config/nullb/$(basename "${1}")
+	[[ -r "${f}/zone_capacity" &&
+		   $(<"${f}/zone_capacity") -lt $(<"${f}/zone_size") ]]
+}
+
+# Check if blkzone is available and suitable for the test target device. If not
+# available, print error message and return 1. Otherwise return 0.
+check_blkzone() {
+	local dev="${1}"
+
+	# If the device supports zone capacity, mandate zone capacity report by
+	# blkzone.
+	if (is_nvme_zns "${dev}" || is_nullb_with_zone_cap "${dev}") &&
+				! blkzone_reports_capacity "${dev}"; then
+		echo "Error: blkzone does not report zone capacity"
+		echo "Error: install latest util-linux with blkzone"
+		return 1
+	fi
+}
+
 # Reports the starting sector and length of the first sequential zone of device
 # $1.
 first_sequential_zone() {
@@ -39,6 +84,43 @@ first_sequential_zone() {
     fi
 }
 
+# Reports the summed zone capacity of $1 number of zones starting from offset $2
+# on device $3.
+total_zone_capacity() {
+	local nr_zones=$1
+	local sector=$(($2 / 512))
+	local dev=$3
+	local capacity=0 num
+	local grep_str
+
+	if [ -z "$is_zbd" ]; then
+		# For regular block devices, handle zone size as zone capacity.
+		echo $((zone_size * nr_zones))
+		return
+	fi
+
+	if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+		if blkzone_reports_capacity "${dev}"; then
+			grep_str='cap \K[0-9a-zA-Z]*'
+		else
+			# If zone capacity is not reported, refer zone length.
+			grep_str='len \K[0-9a-zA-Z]*'
+		fi
+		while read num; do
+			capacity=$((capacity + num))
+		done < <(${blkzone} report -c "$nr_zones" -o "$sector" "$dev" |
+				grep -Po "${grep_str}")
+	else
+		# ZBC devices do not have zone capacity. Use zone size.
+		while read num; do
+			capacity=$((capacity + num))
+		done < <(${zbc_report_zones} -nz "$nr_zones" -start "$sector" \
+				"$dev" | grep -Po 'sector [0-9]*, \K[0-9]*')
+	fi
+
+	echo $((capacity * 512))
+}
+
 max_open_zones() {
     local dev=$1
 
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
index 53aee3e8..f9c9530c 100755
--- a/t/zbd/run-tests-against-zoned-nullb
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -6,6 +6,21 @@
 
 scriptdir="$(cd "$(dirname "$0")" && pwd)"
 
+zone_size=1
+zone_capacity=1
+if [[ ${1} == "-h" ]]; then
+    echo "Usage: ${0} [OPTIONS]"
+    echo "Options:"
+    echo -e "\t-h Show this message."
+    echo -e "\t-zone-cap Use null blk with zone capacity less than zone size."
+    echo -e "\tany option supported by test-zbd-support script."
+    exit 1
+elif [[ ${1} == "-zone-cap" ]]; then
+    zone_size=4
+    zone_capacity=3
+    shift
+fi
+
 for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
 modprobe -r null_blk
 modprobe null_blk nr_devices=0 || exit $?
@@ -17,9 +32,18 @@ modprobe -r null_blk
 modprobe null_blk nr_devices=0 &&
     cd /sys/kernel/config/nullb &&
     mkdir nullb0 &&
-    cd nullb0 &&
-    echo 1 > zoned &&
-    echo 1 > zone_size &&
+    cd nullb0 || exit $?
+
+if ((zone_capacity < zone_size)); then
+    if [[ ! -w zone_capacity ]]; then
+        echo "null blk does not support zone capacity"
+        exit 1
+    fi
+    echo "${zone_capacity}" > zone_capacity
+fi
+
+echo 1 > zoned &&
+    echo "${zone_size}" > zone_size &&
     echo 0 > completion_nsec &&
     echo 4096 > blocksize &&
     echo 1024 > size &&
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 80dc3f30..e53a20c5 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -204,55 +204,64 @@ test4() {
 
 # Sequential write to sequential zones.
 test5() {
-    local size
+    local size off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Sequential read from sequential zones.
 test6() {
-    local size
+    local size off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
     write_and_run_one_fio_job \
 	    $((first_sequential_zone_sector * 512)) "${size}" \
-	    --offset=$((first_sequential_zone_sector * 512)) \
+	    --offset="${off}" \
 	    --size="${size}" --zonemode=zbd --zonesize="${zone_size}" \
 	    "$(ioengine "psync")" --iodepth=1 --rw=read \
 	    --bs="$(max $((zone_size / 64)) "$logical_block_size")" \
 	    >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_read $size || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 1.
 test7() {
     local size=$((zone_size))
+    local off capacity
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5 --size="$size"		\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64.
 test8() {
-    local size
+    local size off capacity
 
     size=$((4 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, sg, queue depth 1.
@@ -293,39 +302,45 @@ test10() {
 
 # Random write to sequential zones, libaio, queue depth 64, random block size.
 test11() {
-    local size
+    local size off capacity
 
     size=$((4 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 4 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bsrange=4K-64K --do_verify=1 --verify=md5		\
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64, max 1 open zone.
 test12() {
-    local size
+    local size off capacity
 
     size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=1 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to sequential zones, libaio, queue depth 64, max 4 open zones.
 test13() {
-    local size
+    local size off capacity
 
     size=$((8 * zone_size))
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 8 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=4 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd						      \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $size || return $?
-    check_read $size || return $?
+    check_written $capacity || return $?
+    check_read $capacity || return $?
 }
 
 # Random write to conventional zones.
@@ -349,7 +364,7 @@ test14() {
 # Sequential read on a mix of empty and full zones.
 test15() {
     local i off size
-    local w_off w_size
+    local w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
@@ -358,6 +373,7 @@ test15() {
     done
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
+    w_capacity=$(total_zone_capacity 2 $w_off $dev)
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
     write_and_run_one_fio_job "${w_off}" "${w_size}" \
@@ -365,14 +381,14 @@ test15() {
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
-    check_written $((w_size)) || return $?
-    check_read $((size / 2))
+    check_written $((w_capacity)) || return $?
+    check_read $((w_capacity))
 }
 
 # Random read on a mix of empty and full zones.
 test16() {
     local off size
-    local i w_off w_size
+    local i w_off w_size w_capacity
 
     for ((i=0;i<4;i++)); do
 	[ -n "$is_zbd" ] &&
@@ -381,13 +397,14 @@ test16() {
     done
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
+    w_capacity=$(total_zone_capacity 2 $w_off $dev)
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
     write_and_run_one_fio_job "${w_off}" "${w_size}" \
 		    "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
-    check_written $w_size || return $?
+    check_written $w_capacity || return $?
     check_read $size || return $?
 }
 
@@ -451,13 +468,17 @@ test23() {
 
 test24() {
     local bs loops=9 size=$((zone_size))
+    local off capacity
+
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
 
     bs=$(min $((256*1024)) "$zone_size")
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs"		\
 		   --size=$size --loops=$loops				\
 		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((size * loops)) || return $?
+    check_written $((capacity * loops)) || return $?
     check_reset_count -eq 8 ||
 	check_reset_count -eq 9 ||
 	check_reset_count -eq 10 || return $?
@@ -483,15 +504,19 @@ test25() {
 
 write_to_first_seq_zone() {
     local loops=4 r
+    local off capacity
+
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
 
     r=$(((RANDOM << 16) | RANDOM))
     run_fio --name="$dev" --filename="$dev" "$(ioengine "psync")" --rw="$1" \
 	    --thread=1 --do_verify=1 --verify=md5 --direct=1 --bs=4K	\
-	    --offset=$((first_sequential_zone_sector * 512))		\
-	    "--size=$zone_size" --loops=$loops --randseed="$r"		\
+	    --offset=$off						\
+	    --size=$zone_size --loops=$loops --randseed="$r"		\
 	    --zonemode=zbd --zonesize="${zone_size}" --group_reporting=1	\
 	    --gtod_reduce=1 >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((loops * zone_size)) || return $?
+    check_written $((loops * capacity)) || return $?
 }
 
 # Overwrite the first sequential zone four times sequentially.
@@ -511,15 +536,16 @@ test28() {
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts=("--debug=zbd")
+    capacity=$(total_zone_capacity 1 $off $dev)
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
-	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=randwrite")
+	opts+=("--size=$zone_size" "--io_size=$capacity" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
 	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_written $((jobs * zone_size)) || return $?
+    check_written $((jobs * $capacity)) || return $?
     check_reset_count -eq $jobs ||
 	check_reset_count -eq $((jobs - 1)) ||
 	return $?
@@ -608,10 +634,13 @@ test32() {
 # zone size.
 test33() {
     local bs io_size size
+    local off capacity=0;
 
+    off=$((first_sequential_zone_sector * 512))
+    capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
-    io_size=$((5 * zone_size))
-    bs=$((3 * zone_size / 4))
+    io_size=$((5 * capacity))
+    bs=$((3 * capacity / 4))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
@@ -660,8 +689,9 @@ test36() {
 
 # Test 3/4 for the I/O boundary rounding code: $size > $zone_size.
 test37() {
-    local bs off size
+    local bs off size capacity
 
+    capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
     else
@@ -673,7 +703,7 @@ test37() {
 		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
 		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1
-    check_written $((zone_size)) || return $?
+    check_written $capacity || return $?
 }
 
 # Test 4/4 for the I/O boundary rounding code: $offset > $disk_size - $zone_size
@@ -809,6 +839,26 @@ test48() {
 	    >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Check if fio handles --zonecapacity on a normal block device correctly
+test49() {
+
+    if [ -n "$is_zbd" ]; then
+	echo "$dev is not a regular block device" \
+	     >>"${logfile}.${test_number}"
+	return 0
+    fi
+
+    size=$((2 * zone_size))
+    capacity=$((zone_size * 3 / 4))
+
+    run_one_fio_job "$(ioengine "psync")" --rw=write \
+		    --zonemode=zbd --zonesize="${zone_size}" \
+		    --zonecapacity=${capacity} \
+		    --verify=md5  --size=${size} >>"${logfile}.${test_number}" 2>&1 ||
+	return $?
+    check_read $((capacity * 2)) || return $?
+}
+
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
@@ -863,6 +913,9 @@ if [[ -b "$realdev" ]]; then
 	case "$(<"/sys/class/block/$basename/queue/zoned")" in
 	host-managed|host-aware)
 		is_zbd=true
+		if ! check_blkzone "${dev}"; then
+			exit 1
+		fi
 		if ! result=($(first_sequential_zone "$dev")); then
 			echo "Failed to determine first sequential zone"
 			exit 1
diff --git a/thread_options.h b/thread_options.h
index 968ea0ab..3fe48ecc 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -193,6 +193,7 @@ struct thread_options {
 	unsigned int loops;
 	unsigned long long zone_range;
 	unsigned long long zone_size;
+	unsigned long long zone_capacity;
 	unsigned long long zone_skip;
 	enum fio_zone_mode zone_mode;
 	unsigned long long lockmem;
@@ -487,6 +488,7 @@ struct thread_options_pack {
 	uint32_t loops;
 	uint64_t zone_range;
 	uint64_t zone_size;
+	uint64_t zone_capacity;
 	uint64_t zone_skip;
 	uint64_t lockmem;
 	uint32_t mem_type;
diff --git a/zbd.c b/zbd.c
index cf2cded9..3eac5df3 100644
--- a/zbd.c
+++ b/zbd.c
@@ -140,6 +140,24 @@ static inline bool zbd_zone_swr(struct fio_zone_info *z)
 	return z->type == ZBD_ZONE_TYPE_SWR;
 }
 
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
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -154,7 +172,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 	assert((required & 511) == 0);
 
 	return zbd_zone_swr(z) &&
-		z->wp + required > z->start + f->zbd_info->zone_size;
+		z->wp + required > zbd_zone_capacity_end(z);
 }
 
 static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
@@ -271,7 +289,7 @@ static bool zbd_verify_sizes(void)
 			z = &f->zbd_info->zone_info[zone_idx];
 			if ((f->file_offset != z->start) &&
 			    (td->o.td_ddir != TD_DDIR_READ)) {
-				new_offset = (z+1)->start;
+				new_offset = zbd_zone_end(z);
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
@@ -353,6 +371,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	uint32_t nr_zones;
 	struct fio_zone_info *p;
 	uint64_t zone_size = td->o.zone_size;
+	uint64_t zone_capacity = td->o.zone_capacity;
 	struct zoned_block_device_info *zbd_info = NULL;
 	int i;
 
@@ -368,6 +387,16 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
+	if (zone_capacity == 0)
+		zone_capacity = zone_size;
+
+	if (zone_capacity > zone_size) {
+		log_err("%s: job parameter zonecapacity %llu is larger than zone size %llu\n",
+			f->file_name, (unsigned long long) td->o.zone_capacity,
+			(unsigned long long) td->o.zone_size);
+		return 1;
+	}
+
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -384,6 +413,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		p->wp = p->start;
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
+		p->capacity = zone_capacity;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
@@ -456,10 +486,11 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			mutex_init_pshared_with_type(&p->mutex,
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
+			p->capacity = z->capacity;
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
 			case ZBD_ZONE_COND_FULL:
-				p->wp = p->start + zone_size;
+				p->wp = p->start + p->capacity;
 				break;
 			default:
 				assert(z->start <= z->wp);
@@ -707,7 +738,7 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, z));
 
-	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
+	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);
 }
 
 /* The caller must hold f->zbd_info->mutex */
@@ -1068,7 +1099,7 @@ found_candidate_zone:
 	/* Both z->mutex and f->zbd_info->mutex are held. */
 
 examine_zone:
-	if (z->wp + min_bs <= (z+1)->start) {
+	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
@@ -1112,7 +1143,7 @@ examine_zone:
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		zone_lock(td, f, z);
-		if (z->wp + min_bs <= (z+1)->start)
+		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
@@ -1143,9 +1174,9 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 		assert(z);
 	}
 
-	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
+	if (z->verify_block * min_bs >= z->capacity)
 		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long) f->zbd_info->zone_size);
+			min_bs, (unsigned long long)z->capacity);
 	io_u->offset = z->start + z->verify_block++ * min_bs;
 	return z;
 }
@@ -1231,7 +1262,7 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
 		zone_end = min((uint64_t)(io_u->offset + io_u->buflen),
-			       (z + 1)->start);
+			       zbd_zone_capacity_end(z));
 		pthread_mutex_lock(&zbd_info->mutex);
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
@@ -1327,6 +1358,28 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
 
+	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
+	z = &f->zbd_info->zone_info[zone_idx];
+
+	/*
+	 * When the zone capacity is smaller than the zone size and the I/O is
+	 * sequential write, skip to zone end if the latest position is at the
+	 * zone capacity limit.
+	 */
+	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&
+	    ddir == DDIR_WRITE &&
+	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
+		dprint(FD_ZBD,
+		       "%s: Jump from zone capacity limit to zone end:"
+		       " (%llu -> %llu) for zone %u (%llu)\n",
+		       f->file_name, (unsigned long long) f->last_pos[ddir],
+		       (unsigned long long) zbd_zone_end(z),
+		       zbd_zone_nr(f->zbd_info, z),
+		       (unsigned long long) z->capacity);
+		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
+		f->last_pos[ddir] = zbd_zone_end(z);
+	}
+
 	/*
 	 * zone_skip is valid only for sequential workloads.
 	 */
@@ -1340,11 +1393,8 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	 * - For reads with td->o.read_beyond_wp == false, the last position
 	 *   reached the zone write pointer.
 	 */
-	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
-	z = &f->zbd_info->zone_info[zone_idx];
-
 	if (td->zone_bytes >= td->o.zone_size ||
-	    f->last_pos[ddir] >= (z+1)->start ||
+	    f->last_pos[ddir] >= zbd_zone_end(z) ||
 	    (ddir == DDIR_READ &&
 	     (!td->o.read_beyond_wp) && f->last_pos[ddir] >= z->wp)) {
 		/*
@@ -1530,6 +1580,13 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
+
+			if (zb->capacity < min_bs) {
+				log_err("zone capacity %llu smaller than minimum block size %d\n",
+					(unsigned long long)zb->capacity,
+					min_bs);
+				goto eof;
+			}
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
@@ -1545,7 +1602,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * small.
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
-			      (zb + 1)->start - io_u->offset);
+			      zbd_zone_capacity_end(zb) - io_u->offset);
 		new_len = new_len / min_bs * min_bs;
 		if (new_len == io_u->buflen)
 			goto accept;
@@ -1556,7 +1613,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			((zb + 1)->start - io_u->offset),
+			(zbd_zone_capacity_end(zb) - io_u->offset),
 			min_bs);
 		goto eof;
 	case DDIR_TRIM:
diff --git a/zbd.h b/zbd.h
index e942a7f6..021174c1 100644
--- a/zbd.h
+++ b/zbd.h
@@ -23,6 +23,7 @@ enum io_u_action {
  * struct fio_zone_info - information about a single ZBD zone
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
+ * @capacity: maximum size usable from the start of a zone (bytes)
  * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
@@ -35,6 +36,7 @@ struct fio_zone_info {
 	pthread_mutex_t		mutex;
 	uint64_t		start;
 	uint64_t		wp;
+	uint64_t		capacity;
 	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
diff --git a/zbd_types.h b/zbd_types.h
index d63c0d0a..5ed41aa0 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -50,6 +50,7 @@ struct zbd_zone {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		len;
+	uint64_t		capacity;
 	enum zbd_zone_type	type;
 	enum zbd_zone_cond	cond;
 };

