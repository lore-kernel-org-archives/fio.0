Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Sep 2020 08:00:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4B6C061244
        for <fio@vger.kernel.org>; Wed,  2 Sep 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDRQp-00079n-Eo
        for fio@vger.kernel.org; Wed, 02 Sep 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200902120001.B6E5A1BC0110@kernel.dk>
Date: Wed,  2 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 20c7a244e75e4aa705a31a74e7067de4c890dff7:

  options: flow should parse as FIO_OPT_INT (2020-08-31 09:07:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3412afb7b365b97ba515df9c72dfc89bf75aca0a:

  t/zbd: Remove unnecessary option for zbc_reset_zone (2020-09-01 08:37:45 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (7):
      zbd: Decrement open zones count at write command completion
      oslib/linux-blkzoned: Allow reset zone before file set up
      zbd: Initialize open zones list referring zone status at fio start
      t/zbd: Improve usage message of test-zbd-support script
      t/zbd: Add -o option to t/zbd/test-zoned-support
      t/zbd: Reset all zones before test when max open zones is specified
      t/zbd: Remove unnecessary option for zbc_reset_zone

 io_u.c                 |   4 +-
 io_u.h                 |   5 +-
 ioengines.c            |   4 +-
 oslib/linux-blkzoned.c |  18 +++++--
 t/zbd/functions        |   2 +-
 t/zbd/test-zbd-support | 122 ++++++++++++++++++++++++++++++++++++++++-------
 zbd.c                  | 127 +++++++++++++++++++++++++++++++++++++++----------
 zbd.h                  |   9 ++--
 8 files changed, 236 insertions(+), 55 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 155d0a32..f30fc037 100644
--- a/io_u.c
+++ b/io_u.c
@@ -795,7 +795,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	const bool needs_lock = td_async_processing(td);
 
-	zbd_put_io_u(io_u);
+	zbd_put_io_u(td, io_u);
 
 	if (td->parent)
 		td = td->parent;
@@ -1369,7 +1369,7 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
-		zbd_put_io_u(io_u);
+		zbd_put_io_u(td, io_u);
 
 		put_file_log(td, f);
 		td_io_close_file(td, f);
diff --git a/io_u.h b/io_u.h
index 31100928..5a28689c 100644
--- a/io_u.h
+++ b/io_u.h
@@ -101,13 +101,14 @@ struct io_u {
 	 * @success == true means that the I/O operation has been queued or
 	 * completed successfully.
 	 */
-	void (*zbd_queue_io)(struct io_u *, int q, bool success);
+	void (*zbd_queue_io)(struct thread_data *td, struct io_u *, int q,
+			     bool success);
 
 	/*
 	 * ZBD mode zbd_put_io callback: called in after completion of an I/O
 	 * or commit of an async I/O to unlock the I/O target zone.
 	 */
-	void (*zbd_put_io)(const struct io_u *);
+	void (*zbd_put_io)(struct thread_data *td, const struct io_u *);
 
 	/*
 	 * Callback for io completion
diff --git a/ioengines.c b/ioengines.c
index 1c5970a4..476df58d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -352,7 +352,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
-	zbd_queue_io_u(io_u, ret);
+	zbd_queue_io_u(td, io_u, ret);
 
 	unlock_file(td, io_u->file);
 
@@ -394,7 +394,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
-		zbd_put_io_u(io_u);
+		zbd_put_io_u(td, io_u);
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 6fe78b9c..0a8a577a 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -222,9 +222,21 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 		.sector         = offset >> 9,
 		.nr_sectors     = length >> 9,
 	};
+	int fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
 
-	if (ioctl(f->fd, BLKRESETZONE, &zr) < 0)
-		return -errno;
+	if (ioctl(fd, BLKRESETZONE, &zr) < 0)
+		ret = -errno;
 
-	return 0;
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
 }
diff --git a/t/zbd/functions b/t/zbd/functions
index 81b6f3f7..1a64a215 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -185,7 +185,7 @@ reset_zone() {
 	fi
     else
 	if [ "$offset" -lt 0 ]; then
-	    ${zbc_reset_zone} -all "$dev" "${offset}" >/dev/null
+	    ${zbc_reset_zone} -all "$dev" >/dev/null
 	else
 	    ${zbc_reset_zone} -sector "$dev" "${offset}" >/dev/null
 	fi
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 139495d3..248423bb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -5,7 +5,16 @@
 # This file is released under the GPL.
 
 usage() {
-    echo "Usage: $(basename "$0") [-d] [-e] [-l] [-r] [-v] [-t <test>] [-z] <SMR drive device node>"
+	echo "Usage: $(basename "$0") [OPTIONS] <test target device file>"
+	echo "Options:"
+	echo -e "\t-d Run fio with valgrind using DRD tool"
+	echo -e "\t-e Run fio with valgrind using helgrind tool"
+	echo -e "\t-v Run fio with valgrind --read-var-info option"
+	echo -e "\t-l Test with libzbc ioengine"
+	echo -e "\t-r Reset all zones before test start"
+	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
+	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-z Run fio with debug=zbd option"
 }
 
 max() {
@@ -95,14 +104,41 @@ is_scsi_device() {
     return 1
 }
 
+job_var_opts_exclude() {
+	local o
+	local ex_key="${1}"
+
+	for o in "${job_var_opts[@]}"; do
+		if [[ ${o} =~ "${ex_key}" ]]; then
+			continue
+		fi
+		echo -n "${o}"
+	done
+}
+
+has_max_open_zones() {
+	while (($# > 1)); do
+		if [[ ${1} =~ "--max_open_zones" ]]; then
+			return 0
+		fi
+		shift
+	done
+	return 1
+}
+
 run_fio() {
     local fio opts
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
-	  "--significant_figures=10" "$@")
-    opts+=(${var_opts[@]})
+    opts=(${global_var_opts[@]})
+    opts+=("--max-jobs=16" "--aux-path=/tmp" "--allow_file_create=0" \
+			   "--significant_figures=10" "$@")
+    # When max_open_zones option is specified to this test script, add
+    # max_open_zones option to fio command unless the test case already add it.
+    if [[ -n ${max_open_zones_opt} ]] && ! has_max_open_zones "${opts[@]}"; then
+	    opts+=("--max_open_zones=${max_open_zones_opt}")
+    fi
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -120,13 +156,16 @@ write_and_run_one_fio_job() {
     local r
     local write_offset="${1}"
     local write_size="${2}"
+    local -a write_opts
 
     shift 2
     r=$(((RANDOM << 16) | RANDOM))
-    run_fio --filename="$dev" --randseed="$r"  --name="write_job" --rw=write \
-	    "$(ioengine "psync")" --bs="${logical_block_size}" \
-	    --zonemode=zbd --zonesize="${zone_size}" --thread=1 --direct=1 \
-	    --offset="${write_offset}" --size="${write_size}" \
+    write_opts=(--name="write_job" --rw=write "$(ioengine "psync")" \
+		      --bs="${logical_block_size}" --zonemode=zbd \
+		      --zonesize="${zone_size}" --thread=1 --direct=1 \
+		      --offset="${write_offset}" --size="${write_size}")
+    write_opts+=("${job_var_opts[@]}")
+    run_fio --filename="$dev" --randseed="$r" "${write_opts[@]}" \
 	    --name="$dev" --wait_for="write_job" "$@" --thread=1 --direct=1
 }
 
@@ -142,6 +181,15 @@ run_fio_on_seq() {
     run_one_fio_job "${opts[@]}" "$@"
 }
 
+# Prepare for write test by resetting zones. When max_open_zones option is
+# specified, reset all zones of the test target to ensure that zones out of the
+# test target range do not have open zones. This allows the write test to the
+# target range to be able to open zones up to max_open_zones.
+prep_write() {
+	[[ -n "${max_open_zones_opt}" && -n "${is_zbd}" ]] &&
+		reset_zone "${dev}" -1
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -213,6 +261,7 @@ test4() {
 test5() {
     local size off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
@@ -228,6 +277,7 @@ test5() {
 test6() {
     local size off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
     size=$((4 * zone_size))
@@ -246,6 +296,7 @@ test7() {
     local size=$((zone_size))
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
@@ -260,6 +311,7 @@ test7() {
 test8() {
     local size off capacity
 
+    prep_write
     size=$((4 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
@@ -280,6 +332,7 @@ test9() {
 	return 0
     fi
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq --ioengine=sg					\
 		   --iodepth=1 --rw=randwrite --bs=16K			\
@@ -298,6 +351,7 @@ test10() {
 	return 0
     fi
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq --ioengine=sg 					\
 		   --iodepth=64 --rw=randwrite --bs=16K			\
@@ -311,6 +365,7 @@ test10() {
 test11() {
     local size off capacity
 
+    prep_write
     size=$((4 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 4 $off $dev)
@@ -325,6 +380,7 @@ test11() {
 test12() {
     local size off capacity
 
+    prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -339,6 +395,7 @@ test12() {
 test13() {
     local size off capacity
 
+    prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 8 $off $dev)
@@ -354,6 +411,7 @@ test13() {
 test14() {
     local size
 
+    prep_write
     size=$((16 * 2**20)) # 20 MB
     if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
 	echo "$dev does not have enough sequential zones" \
@@ -378,6 +436,7 @@ test15() {
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
+    prep_write
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
     w_capacity=$(total_zone_capacity 2 $w_off $dev)
@@ -402,6 +461,7 @@ test16() {
 	    reset_zone "$dev" $((first_sequential_zone_sector +
 				 i*sectors_per_zone))
     done
+    prep_write
     w_off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     w_size=$((2 * zone_size))
     w_capacity=$(total_zone_capacity 2 $w_off $dev)
@@ -424,6 +484,7 @@ test17() {
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
+    prep_write
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
@@ -477,6 +538,7 @@ test24() {
     local bs loops=9 size=$((zone_size))
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
 
@@ -499,12 +561,13 @@ test25() {
         [ -n "$is_zbd" ] &&
 	    reset_zone "$dev" $((first_sequential_zone_sector + i*sectors_per_zone))
     done
+    prep_write
     for ((i=0;i<16;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--thread=1" "--direct=1")
 	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
 	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=write" "--bs=16K")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}" "--group_reporting=1")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
@@ -513,6 +576,7 @@ write_to_first_seq_zone() {
     local loops=4 r
     local off capacity
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
 
@@ -542,6 +606,7 @@ test28() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--debug=zbd")
     capacity=$(total_zone_capacity 1 $off $dev)
     for ((i=0;i<jobs;i++)); do
@@ -549,7 +614,7 @@ test28() {
 	opts+=("--size=$zone_size" "--io_size=$capacity" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * $capacity)) || return $?
@@ -565,7 +630,7 @@ test29() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
@@ -573,7 +638,8 @@ test29() {
 	opts+=("$(ioengine "psync")" "--rw=randwrite" "--direct=1")
 	opts+=("--max_open_zones=4" "--group_reporting=1")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${var_opts[@]})
+	# max_open_zones is already specified
+	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -583,6 +649,7 @@ test29() {
 test30() {
     local off
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw	\
 		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
@@ -596,6 +663,7 @@ test30() {
 test31() {
     local bs inc nz off opts size
 
+    prep_write
     # Start with writing 128 KB to 128 sequential zones.
     bs=128K
     nz=128
@@ -609,7 +677,7 @@ test31() {
 	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
 	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-	opts+=(${var_opts[@]})
+	opts+=(${job_var_opts[@]})
     done
     "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
     # Next, run the test.
@@ -619,6 +687,7 @@ test31() {
     opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
+    opts+=(${job_var_opts[@]})
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
@@ -627,6 +696,7 @@ test31() {
 test32() {
     local off opts=() size
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
@@ -643,6 +713,7 @@ test33() {
     local bs io_size size
     local off capacity=0;
 
+    prep_write
     off=$((first_sequential_zone_sector * 512))
     capacity=$(total_zone_capacity 1 $off $dev)
     size=$((2 * zone_size))
@@ -659,6 +730,7 @@ test33() {
 test34() {
     local size
 
+    prep_write
     size=$((2 * zone_size))
     run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
 		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
@@ -670,6 +742,7 @@ test34() {
 test35() {
     local bs off io_size size
 
+    prep_write
     off=$(((first_sequential_zone_sector + 1) * 512))
     size=$((zone_size - 2 * 512))
     bs=$((zone_size / 4))
@@ -684,6 +757,7 @@ test35() {
 test36() {
     local bs off io_size size
 
+    prep_write
     off=$(((first_sequential_zone_sector) * 512))
     size=$((zone_size - 512))
     bs=$((zone_size / 4))
@@ -698,6 +772,7 @@ test36() {
 test37() {
     local bs off size capacity
 
+    prep_write
     capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
@@ -717,6 +792,7 @@ test37() {
 test38() {
     local bs off size
 
+    prep_write
     size=$((logical_block_size))
     off=$((disk_size - logical_block_size))
     bs=$((logical_block_size))
@@ -787,6 +863,7 @@ test45() {
     local bs i
 
     [ -z "$is_zbd" ] && return 0
+    prep_write
     bs=$((logical_block_size))
     run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
 		    --offset=$((first_sequential_zone_sector * 512)) \
@@ -799,6 +876,7 @@ test45() {
 test46() {
     local size
 
+    prep_write
     size=$((4 * zone_size))
     run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=4K \
 		   --group_reporting=1 --numjobs=8 \
@@ -810,6 +888,7 @@ test46() {
 test47() {
     local bs
 
+    prep_write
     bs=$((logical_block_size))
     run_fio_on_seq "$(ioengine "psync")" --rw=write --bs=$bs --zoneskip=1 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
@@ -824,7 +903,7 @@ test48() {
 
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
-    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    prep_write
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
     opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
@@ -835,6 +914,8 @@ test48() {
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--io_size=$zone_size" "--iodepth=256" "--thread=1")
 	opts+=("--group_reporting=1")
+	# max_open_zones is already specified
+	opts+=($(job_var_opts_exclude "--max_open_zones"))
     done
 
     fio=$(dirname "$0")/../../fio
@@ -872,6 +953,7 @@ dynamic_analyzer=()
 reset_all_zones=
 use_libzbc=
 zbd_debug=
+max_open_zones_opt=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -883,6 +965,7 @@ while [ "${1#-}" != "$1" ]; do
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -t) tests+=("$2"); shift; shift;;
+    -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
     -z) zbd_debug=1; shift;;
@@ -898,9 +981,10 @@ fi
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
-var_opts=()
+global_var_opts=()
+job_var_opts=()
 if [ -n "$zbd_debug" ]; then
-    var_opts+=("--debug=zbd")
+    global_var_opts+=("--debug=zbd")
 fi
 dev=$1
 realdev=$(readlink -f "$dev")
@@ -986,6 +1070,12 @@ elif [[ -c "$realdev" ]]; then
 	fi
 fi
 
+if [[ -n ${max_open_zones_opt} ]]; then
+	# Override max_open_zones with the script option value
+	max_open_zones="${max_open_zones_opt}"
+	job_var_opts+=("--max_open_zones=${max_open_zones_opt}")
+fi
+
 echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
 echo " zone size: $((zone_size >> 20)) MB"
 
diff --git a/zbd.c b/zbd.c
index 584d3640..e8ecbb6f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -628,6 +628,11 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	return ret;
 }
 
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
+			  uint32_t zone_idx);
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z);
+
 int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -651,6 +656,8 @@ int zbd_setup_files(struct thread_data *td)
 
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
+		struct fio_zone_info *z;
+		int zi;
 
 		if (!zbd)
 			continue;
@@ -666,6 +673,23 @@ int zbd_setup_files(struct thread_data *td)
 			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES);
 			return 1;
 		}
+
+		for (zi = f->min_zone; zi < f->max_zone; zi++) {
+			z = &zbd->zone_info[zi];
+			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
+			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
+				continue;
+			if (zbd_open_zone(td, f, zi))
+				continue;
+			/*
+			 * If the number of open zones exceeds specified limits,
+			 * reset all extra open zones.
+			 */
+			if (zbd_reset_zone(td, f, z) < 0) {
+				log_err("Failed to reest zone %d\n", zi);
+				return 1;
+			}
+		}
 	}
 
 	return 0;
@@ -722,12 +746,21 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 
 /* The caller must hold f->zbd_info->mutex */
 static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   unsigned int open_zone_idx)
+			   unsigned int zone_idx)
 {
-	uint32_t zone_idx;
+	uint32_t open_zone_idx = 0;
 
-	assert(open_zone_idx < f->zbd_info->num_open_zones);
-	zone_idx = f->zbd_info->open_zones[open_zone_idx];
+	for (; open_zone_idx < f->zbd_info->num_open_zones; open_zone_idx++) {
+		if (f->zbd_info->open_zones[open_zone_idx] == zone_idx)
+			break;
+	}
+	if (open_zone_idx == f->zbd_info->num_open_zones) {
+		dprint(FD_ZBD, "%s: zone %d is not open\n",
+		       f->file_name, zone_idx);
+		return;
+	}
+
+	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
 	memmove(f->zbd_info->open_zones + open_zone_idx,
 		f->zbd_info->open_zones + open_zone_idx + 1,
 		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
@@ -766,13 +799,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			continue;
 		zone_lock(td, f, z);
 		if (all_zones) {
-			unsigned int i;
-
 			pthread_mutex_lock(&f->zbd_info->mutex);
-			for (i = 0; i < f->zbd_info->num_open_zones; i++) {
-				if (f->zbd_info->open_zones[i] == nz)
-					zbd_close_zone(td, f, i);
-			}
+			zbd_close_zone(td, f, nz);
 			pthread_mutex_unlock(&f->zbd_info->mutex);
 
 			reset_wp = z->wp != z->start;
@@ -933,11 +961,10 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
  * was not yet open and opening a new zone would cause the zone limit to be
  * exceeded.
  */
-static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	const struct fio_file *f = io_u->file;
 	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
 	bool res = true;
 
@@ -952,8 +979,15 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 		return false;
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	if (is_zone_open(td, f, zone_idx))
+	if (is_zone_open(td, f, zone_idx)) {
+		/*
+		 * If the zone is already open and going to be full by writes
+		 * in-flight, handle it as a full zone instead of an open zone.
+		 */
+		if (z->wp >= zbd_zone_capacity_end(z))
+			res = false;
 		goto out;
+	}
 	res = false;
 	/* Zero means no limit */
 	if (td->o.job_max_open_zones > 0 &&
@@ -995,6 +1029,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
 	int i;
+	bool wait_zone_close;
 
 	assert(is_valid_offset(f, io_u->offset));
 
@@ -1030,11 +1065,9 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
-			pthread_mutex_unlock(&f->zbd_info->mutex);
-			pthread_mutex_unlock(&z->mutex);
 			dprint(FD_ZBD, "%s(%s): no zones are open\n",
 			       __func__, f->file_name);
-			return NULL;
+			goto open_other_zone;
 		}
 
 		/*
@@ -1081,14 +1114,30 @@ examine_zone:
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
-	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
-	       zone_idx);
-	if (td->o.max_open_zones || td->o.job_max_open_zones)
-		zbd_close_zone(td, f, open_zone_idx);
+
+open_other_zone:
+	/* Check if number of open zones reaches one of limits. */
+	wait_zone_close =
+		f->zbd_info->num_open_zones == f->max_zone - f->min_zone ||
+		(td->o.max_open_zones &&
+		 f->zbd_info->num_open_zones == td->o.max_open_zones) ||
+		(td->o.job_max_open_zones &&
+		 td->num_open_zones == td->o.job_max_open_zones);
+
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
 	/* Only z->mutex is held. */
 
+	/*
+	 * When number of open zones reaches to one of limits, wait for
+	 * zone close before opening a new zone.
+	 */
+	if (wait_zone_close) {
+		dprint(FD_ZBD, "%s(%s): quiesce to allow open zones to close\n",
+		       __func__, f->file_name);
+		io_u_quiesce(td);
+	}
+
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
 		zone_idx++;
@@ -1103,7 +1152,7 @@ examine_zone:
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
-		if (zbd_open_zone(td, io_u, zone_idx))
+		if (zbd_open_zone(td, f, zone_idx))
 			goto out;
 	}
 
@@ -1146,7 +1195,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const struct fio_file *f = io_u->file;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
-	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
+	if (!zbd_open_zone(td, f, z - f->zbd_info->zone_info)) {
 		pthread_mutex_unlock(&z->mutex);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
@@ -1203,6 +1252,28 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	return NULL;
 }
 
+/**
+ * zbd_end_zone_io - update zone status at command completion
+ * @io_u: I/O unit
+ * @z: zone info pointer
+ *
+ * If the write command made the zone full, close it.
+ *
+ * The caller must hold z->mutex.
+ */
+static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
+			    struct fio_zone_info *z)
+{
+	const struct fio_file *f = io_u->file;
+
+	if (io_u->ddir == DDIR_WRITE &&
+	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		zbd_close_zone(td, f, z - f->zbd_info->zone_info);
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+	}
+}
+
 /**
  * zbd_queue_io - update the write pointer of a sequential zone
  * @io_u: I/O unit
@@ -1212,7 +1283,8 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
  * For write and trim operations, update the write pointer of the I/O unit
  * target zone.
  */
-static void zbd_queue_io(struct io_u *io_u, int q, bool success)
+static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
+			 bool success)
 {
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
@@ -1258,6 +1330,9 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 		break;
 	}
 
+	if (q == FIO_Q_COMPLETED && !io_u->error)
+		zbd_end_zone_io(td, io_u, z);
+
 unlock:
 	if (!success || q != FIO_Q_QUEUED) {
 		/* BUSY or COMPLETED: unlock the zone */
@@ -1270,7 +1345,7 @@ unlock:
  * zbd_put_io - Unlock an I/O unit target zone lock
  * @io_u: I/O unit
  */
-static void zbd_put_io(const struct io_u *io_u)
+static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 {
 	const struct fio_file *f = io_u->file;
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
@@ -1292,6 +1367,8 @@ static void zbd_put_io(const struct io_u *io_u)
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
 	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
 
+	zbd_end_zone_io(td, io_u, z);
+
 	ret = pthread_mutex_unlock(&z->mutex);
 	assert(ret == 0);
 	zbd_check_swd(f);
@@ -1527,7 +1604,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_WRITE:
 		if (io_u->buflen > f->zbd_info->zone_size)
 			goto eof;
-		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
+		if (!zbd_open_zone(td, f, zone_idx_b)) {
 			pthread_mutex_unlock(&zb->mutex);
 			zb = zbd_convert_to_open_zone(td, io_u);
 			if (!zb)
diff --git a/zbd.h b/zbd.h
index 021174c1..bff55f99 100644
--- a/zbd.h
+++ b/zbd.h
@@ -98,18 +98,19 @@ static inline void zbd_close_file(struct fio_file *f)
 		zbd_free_zone_info(f);
 }
 
-static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
+static inline void zbd_queue_io_u(struct thread_data *td, struct io_u *io_u,
+				  enum fio_q_status status)
 {
 	if (io_u->zbd_queue_io) {
-		io_u->zbd_queue_io(io_u, status, io_u->error == 0);
+		io_u->zbd_queue_io(td, io_u, status, io_u->error == 0);
 		io_u->zbd_queue_io = NULL;
 	}
 }
 
-static inline void zbd_put_io_u(struct io_u *io_u)
+static inline void zbd_put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	if (io_u->zbd_put_io) {
-		io_u->zbd_put_io(io_u);
+		io_u->zbd_put_io(td, io_u);
 		io_u->zbd_queue_io = NULL;
 		io_u->zbd_put_io = NULL;
 	}

