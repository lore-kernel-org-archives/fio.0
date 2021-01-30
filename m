Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhA3NAu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Jan 2021 08:00:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E097DC06174A
        for <fio@vger.kernel.org>; Sat, 30 Jan 2021 05:00:08 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l5pr9-00B78a-Qv
        for fio@vger.kernel.org; Sat, 30 Jan 2021 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210130130001.95E371BC0134@kernel.dk>
Date: Sat, 30 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 119bb82143bd6c4a577c135ece4ed6b702443f50:

  Merge branch 'fio-fix-detecting-libpmem' of https://github.com/ldorau/fio (2021-01-27 09:51:01 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ef3c1b02473a14bf7b8b52e28d0cdded9c5cc9a:

  zbd: relocate Coverity annotation (2021-01-29 22:06:49 -0700)

----------------------------------------------------------------
Aravind Ramesh (1):
      zbd: initialize sectors with data at start time

Dmitry Fomichev (26):
      zbd: return ENOMEM if zone buffer allocation fails
      zbd: use zbd_zone_nr() more actively in the code
      zbd: add get_zone() helper function
      zbd: introduce zone_unlock()
      zbd: engines/libzbc: don't fail on assert for offline zones
      zbd: remove dependency on zone type during i/o
      zbd: skip offline zones in zbd_convert_to_open_zone()
      zbd: avoid zone buffer overrun
      zbd: don't unlock zone mutex after verify replay
      zbd: use zone_lock() in zbd_process_swd()
      zbd: don't log "zone nnnn is not open" message
      zbd: handle conventional start zone in zbd_convert_to_open_zone()
      zbd: improve replay range validation
      engines/libzbc: enable block backend
      zbd: avoid failing assertion in zbd_convert_to_open_zone()
      zbd: set thread errors in zbd_adjust_block()
      t/zbd: check for error in test #2
      t/zbd: add run-tests-against-nullb script
      t/zbd: add an option to bail on a failed test
      t/zbd: prevent test #31 from looping
      t/zbd: add checks for offline zone condition
      t/zbd: add test #54 to exercise ZBD verification
      t/zbd: show elapsed time in test-zbd-support
      t/zbd: increase timeout in test #48
      t/zbd: avoid looping on invalid command line options
      zbd: relocate Coverity annotation

Jens Axboe (1):
      zbd: fix 32-bit compile warnings for logging

Shin'ichiro Kawasaki (12):
      zbd: do not lock conventional zones on I/O adjustment
      zbd: do not set zbd handlers for conventional zones
      zbd: count sectors with data for write pointer zones
      zbd: initialize min_zone and max_zone for all zone types
      zbd: disable crossing from conventional to sequential zones
      t/zbd: add -t option to run-tests-against-nullb
      t/zbd: skip tests when test prerequisites are not met
      t/zbd: skip tests that need too many sequential zones
      t/zbd: test that conventional zones are not locked during random i/o
      t/zbd: test that zone_reset_threshold calculation is correct
      t/zbd: test random I/O direction in all-conventional case
      t/zbd: fix wrong units in test case #37

 Makefile                              |   5 +-
 engines/libzbc.c                      |   5 +-
 oslib/linux-blkzoned.c                |   2 +-
 t/run-fio-tests.py                    |   8 +-
 t/zbd/functions                       |  56 +++++-
 t/zbd/run-tests-against-nullb         | 354 +++++++++++++++++++++++++++++++++
 t/zbd/run-tests-against-regular-nullb |  27 ---
 t/zbd/run-tests-against-zoned-nullb   |  53 -----
 t/zbd/test-zbd-support                | 299 ++++++++++++++++++++++++----
 zbd.c                                 | 357 +++++++++++++++++++++-------------
 zbd.h                                 |   5 +
 11 files changed, 911 insertions(+), 260 deletions(-)
 create mode 100755 t/zbd/run-tests-against-nullb
 delete mode 100755 t/zbd/run-tests-against-regular-nullb
 delete mode 100755 t/zbd/run-tests-against-zoned-nullb

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f74e59e1..612344d1 100644
--- a/Makefile
+++ b/Makefile
@@ -626,9 +626,10 @@ fulltest:
 	   make -j &&						 	\
 	   sudo make install)						\
 	fi &&					 			\
-	sudo t/zbd/run-tests-against-regular-nullb &&		 	\
+	sudo t/zbd/run-tests-against-nullb -s 1 &&		 	\
 	if [ -e /sys/module/null_blk/parameters/zoned ]; then		\
-		sudo t/zbd/run-tests-against-zoned-nullb;	 	\
+		sudo t/zbd/run-tests-against-nullb -s 2;	 	\
+		sudo t/zbd/run-tests-against-nullb -s 4;	 	\
 	fi
 
 install: $(PROGS) $(SCRIPTS) $(ENGS_OBJS) tools/plot/fio2gnuplot.1 FORCE
diff --git a/engines/libzbc.c b/engines/libzbc.c
index 4b900233..2aacf7bb 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -86,7 +86,8 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -ENOMEM;
 
 	ret = zbc_open(f->file_name,
-		       flags | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA, &ld->zdev);
+		       flags | ZBC_O_DRV_BLOCK | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
+		       &ld->zdev);
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=%d\n",
 			f->file_name, ret);
@@ -283,7 +284,7 @@ static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
 		default:
 			/* Treat all these conditions as offline (don't use!) */
 			zbdz->cond = ZBD_ZONE_COND_OFFLINE;
-			break;
+			zbdz->wp = zbdz->start;
 		}
 	}
 
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 0a8a577a..f37c67fc 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -203,7 +203,7 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 		default:
 			/* Treat all these conditions as offline (don't use!) */
 			z->cond = ZBD_ZONE_COND_OFFLINE;
-			break;
+			z->wp = z->start;
 		}
 	}
 
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e5c2f17c..a59cdfe0 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -879,8 +879,8 @@ TEST_LIST = [
     {
         'test_id':          1007,
         'test_class':       FioExeTest,
-        'exe':              't/zbd/run-tests-against-regular-nullb',
-        'parameters':       None,
+        'exe':              't/zbd/run-tests-against-nullb',
+        'parameters':       ['-s', '1'],
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.zbd,
                              Requirements.root],
@@ -888,8 +888,8 @@ TEST_LIST = [
     {
         'test_id':          1008,
         'test_class':       FioExeTest,
-        'exe':              't/zbd/run-tests-against-zoned-nullb',
-        'parameters':       None,
+        'exe':              't/zbd/run-tests-against-nullb',
+        'parameters':       ['-s', '2'],
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.zbd,
                              Requirements.root, Requirements.zoned_nullb],
diff --git a/t/zbd/functions b/t/zbd/functions
index 1a64a215..40ffe1de 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -71,7 +71,7 @@ first_sequential_zone() {
 
     if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	${blkzone} report "$dev" |
-	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]]\([2]\)(.*/\1 \2/p' |
 	    {
 		read -r starting_sector length &&
 		    # Convert from hex to decimal
@@ -79,7 +79,7 @@ first_sequential_zone() {
 	    }
     else
 	${zbc_report_zones} "$dev" |
-	    sed -n 's/^Zone [0-9]*: type 0x2 .*, sector \([0-9]*\), \([0-9]*\) sectors,.*$/\1 \2/p' |
+	    sed -n 's/^Zone [0-9]*: type 0x2 .*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*, sector \([0-9]*\), \([0-9]*\) sectors.*$/\1 \2/p' |
 	    head -n1
     fi
 }
@@ -121,6 +121,58 @@ total_zone_capacity() {
 	echo $((capacity * 512))
 }
 
+# Reports the starting sector and length of the first zone of device $1
+# that is not in offline (or similar) condition.
+first_online_zone() {
+    local dev=$1
+
+    if [ -z "$is_zbd" ]; then
+	echo 0
+	return
+    fi
+
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+	${blkzone} report "$dev" |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]][12](.*/\1/p' |
+	    head -n1 |
+	    {
+		read -r starting_sector &&
+		    # Convert from hex to decimal
+		    echo $((starting_sector))
+	    }
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sector[[:blank:]]\([0-9]*\),.*$/\1/p' |
+	    head -n1
+    fi
+}
+
+# Reports the starting sector and length of the last zone of device $1
+# that is not in offline (or similar) condition.
+last_online_zone() {
+    local dev=$1
+
+    if [ -z "$is_zbd" ]; then
+	echo 0
+	return
+    fi
+
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
+	${blkzone} report "$dev" |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*zcond:\(14\|[[:blank:]][0-4]\)(.*type:[[:blank:]][12](.*/\1/p' |
+	    tail -1 |
+	    {
+		read -r starting_sector &&
+		    # Convert from hex to decimal
+		    echo $((starting_sector))
+	    }
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^Zone[[:blank:]][0-9]*:[[:blank:]]type[[:blank:]]0x[12][[:blank:]].*,[[:blank:]]cond[[:blank:]]0x[0-4e][[:blank:]].*,[[:blank:]]sector[[:blank:]]\([0-9]*\),.*$/\1/p' |
+	    tail -1
+    fi
+}
+
 max_open_zones() {
     local dev=$1
 
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
new file mode 100755
index 00000000..db901179
--- /dev/null
+++ b/t/zbd/run-tests-against-nullb
@@ -0,0 +1,354 @@
+#!/bin/bash
+#
+# Copyright (C) 2020 Western Digital Corporation or its affiliates.
+#
+# This file is released under the GPL.
+#
+# Run t/zbd/test-zbd-support script against a variety of conventional,
+# zoned and mixed zone configurations.
+#
+
+usage()
+{
+	echo "This script runs the tests from t/zbd/test-zbd-support script"
+        echo "against a nullb device in a variety of conventional and zoned"
+	echo "configurations."
+	echo "Usage: ${0} [OPTIONS]"
+	echo "Options:"
+	echo -e "\t-h Show this message."
+	echo -e "\t-L List the device layouts for every section without running"
+	echo -e "\t   tests."
+	echo -e "\t-s <#section> Only run the section with the given number."
+	echo -e "\t-l Use libzbc ioengine to run the tests."
+	echo -e "\t-t <#test> Only run the test with the given number in every section."
+	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
+	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
+	echo -e "\t   or an individual section/test."
+	echo -e "\t-q Quit t/zbd/test-zbd-support run after any failed test."
+	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
+	echo -e "\t   running this script."
+	exit 1
+}
+
+cleanup_nullb()
+{
+	for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
+	modprobe -r null_blk
+	modprobe null_blk nr_devices=0 || exit $?
+	for d in /sys/kernel/config/nullb/*; do
+		[ -d "$d" ] && rmdir "$d"
+	done
+	modprobe -r null_blk
+	[ -e /sys/module/null_blk ] && exit $?
+}
+
+create_nullb()
+{
+	modprobe null_blk nr_devices=0 &&
+	cd /sys/kernel/config/nullb &&
+	mkdir nullb0 &&
+	cd nullb0 || return $?
+}
+
+configure_nullb()
+{
+	echo 0 > completion_nsec &&
+		echo ${dev_blocksize} > blocksize &&
+		echo ${dev_size} > size &&
+		echo 1 > memory_backed || return $?
+
+	if ((conv_pcnt < 100)); then
+		echo 1 > zoned &&
+			echo "${zone_size}" > zone_size || return $?
+
+		if ((zone_capacity < zone_size)); then
+			if ((!zcap_supported)); then
+				echo "null_blk does not support zone capacity"
+				return 2
+			fi
+			echo "${zone_capacity}" > zone_capacity
+		fi
+		if ((conv_pcnt)); then
+			if ((!conv_supported)); then
+				echo "null_blk does not support conventional zones"
+				return 2
+			fi
+			nr_conv=$((dev_size/zone_size*conv_pcnt/100))
+			echo "${nr_conv}" > zone_nr_conv
+		fi
+	fi
+
+	echo 1 > power || return $?
+	return 0
+}
+
+show_nullb_config()
+{
+	if ((conv_pcnt < 100)); then
+		echo "    $(printf "Zoned Device, %d%% Conventional Zones (%d)" \
+			  ${conv_pcnt} ${nr_conv})"
+		echo "    $(printf "Zone Size: %d MB" ${zone_size})"
+		echo "    $(printf "Zone Capacity: %d MB" ${zone_capacity})"
+		if ((max_open)); then
+			echo "    $(printf "Max Open: %d Zones" ${max_open})"
+		else
+			echo "    Max Open: Unlimited Zones"
+		fi
+	else
+		echo "    Non-zoned Device"
+	fi
+}
+
+#
+# Test sections.
+#
+# Fully conventional device.
+section1()
+{
+	conv_pcnt=100
+	max_open=0
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, unlimited MaxOpen.
+section2()
+{
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=0
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, unlimited MaxOpen.
+section3()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=0
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, unlimited MaxOpen.
+section4()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=0
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, unlimited MaxOpen.
+section5()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=0
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, unlimited MaxOpen.
+section6()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=0
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, unlimited MaxOpen.
+section7()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=0
+}
+
+# Zoned device with no conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+section8()
+{
+	dev_size=1024
+	conv_pcnt=0
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+# Zoned device with no conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+section9()
+{
+	conv_pcnt=0
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+# Zoned device with mostly sequential zones, ZCAP == ZSIZE, limited MaxOpen.
+section10()
+{
+	conv_pcnt=10
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+# Zoned device with mostly sequential zones, ZCAP < ZSIZE, limited MaxOpen.
+section11()
+{
+	conv_pcnt=10
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+# Zoned device with mostly conventional zones, ZCAP == ZSIZE, limited MaxOpen.
+section12()
+{
+	conv_pcnt=66
+	zone_size=1
+	zone_capacity=1
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+# Zoned device with mostly conventional zones, ZCAP < ZSIZE, limited MaxOpen.
+section13()
+{
+	dev_size=2048
+	conv_pcnt=66
+	zone_size=4
+	zone_capacity=3
+	max_open=${set_max_open}
+	zbd_test_opts+=("-o ${max_open}")
+}
+
+#
+# Entry point.
+#
+SECONDS=0
+scriptdir="$(cd "$(dirname "$0")" && pwd)"
+sections=()
+zcap_supported=1
+conv_supported=1
+list_only=0
+dev_size=1024
+dev_blocksize=4096
+set_max_open=8
+zbd_test_opts=()
+libzbc=0
+num_of_runs=1
+test_case=0
+quit_on_err=0
+
+while (($#)); do
+	case "$1" in
+		-s) sections+=("$2"); shift; shift;;
+		-o) set_max_open="${2}"; shift; shift;;
+		-L) list_only=1; shift;;
+		-r) cleanup_nullb; exit 0;;
+		-l) libzbc=1; shift;;
+		-n) num_of_runs="${2}"; shift; shift;;
+		-t) test_case="${2}"; shift; shift;;
+		-q) quit_on_err=1; shift;;
+		-h) usage; break;;
+		--) shift; break;;
+		 *) usage; exit 1;;
+	esac
+done
+
+if [ "${#sections[@]}" = 0 ]; then
+	readarray -t sections < <(declare -F | grep "section[0-9]*" |  tr -c -d "[:digit:]\n" | sort -n)
+fi
+
+cleanup_nullb
+
+#
+# Test creating null_blk device and check if newer features are supported
+#
+if ! eval "create_nullb"; then
+	echo "can't create nullb"
+	exit 1
+fi
+if ! cat /sys/kernel/config/nullb/features | grep -q zone_capacity; then
+	zcap_supported=0
+fi
+if ! cat /sys/kernel/config/nullb/features | grep -q zone_nr_conv; then
+	conv_supported=0
+fi
+
+rc=0
+test_rc=0
+intr=0
+run_nr=1
+trap 'kill ${zbd_test_pid}; intr=1' SIGINT
+
+while ((run_nr <= $num_of_runs)); do
+	echo -e "\nRun #$run_nr:"
+	for section_number in "${sections[@]}"; do
+		cleanup_nullb
+		echo "---------- Section $(printf "%02d" $section_number) ----------"
+		if ! eval "create_nullb"; then
+			echo "error creating nullb"
+			exit 1
+		fi
+		zbd_test_opts=()
+		if ((test_case)); then
+			zbd_test_opts+=("-t" "${test_case}")
+		fi
+		if ((quit_on_err)); then
+			zbd_test_opts+=("-q")
+		fi
+		section$section_number
+		configure_nullb
+		rc=$?
+		((rc == 2)) && continue
+		if ((rc)); then
+			echo "can't set up nullb for section $(printf "%02d" $section_number)"
+			exit 1
+		fi
+		show_nullb_config
+		if ((libzbc)); then
+			if ((zone_capacity < zone_size)); then
+				echo "libzbc doesn't support zone capacity, skipping section $(printf "%02d" $section_number)"
+				continue
+			fi
+			if ((conv_pcnt == 100)); then
+				echo "libzbc only supports zoned devices, skipping section $(printf "%02d" $section_number)"
+				continue
+			fi
+			zbd_test_opts+=("-l")
+		fi
+		cd "${scriptdir}"
+		((intr)) && exit 1
+		((list_only)) && continue
+
+		./test-zbd-support ${zbd_test_opts[@]} /dev/nullb0 &
+		zbd_test_pid=$!
+		if kill -0 "${zbd_test_pid}"; then
+			wait "${zbd_test_pid}"
+			test_rc=$?
+		else
+			echo "can't run ZBD tests"
+			exit 1
+		fi
+		((intr)) && exit 1
+		if (($test_rc)); then
+			rc=1
+			((quit_on_err)) && break
+		fi
+	done
+
+	((rc && quit_on_err)) && break
+	run_nr=$((run_nr + 1))
+done
+
+if ((!list_only)); then
+	echo "--------------------------------"
+	echo "Total run time: $(TZ=UTC0 printf "%(%H:%M:%S)T\n" $(( SECONDS )) )"
+fi
+
+exit $rc
diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
deleted file mode 100755
index 5b7b4009..00000000
--- a/t/zbd/run-tests-against-regular-nullb
+++ /dev/null
@@ -1,27 +0,0 @@
-#!/bin/bash
-#
-# Copyright (C) 2018 Western Digital Corporation or its affiliates.
-#
-# This file is released under the GPL.
-
-scriptdir="$(cd "$(dirname "$0")" && pwd)"
-
-for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
-modprobe -r null_blk
-modprobe null_blk nr_devices=0 || exit $?
-for d in /sys/kernel/config/nullb/*; do
-    [ -d "$d" ] && rmdir "$d"
-done
-modprobe -r null_blk
-[ -e /sys/module/null_blk ] && exit $?
-modprobe null_blk nr_devices=0 &&
-    cd /sys/kernel/config/nullb &&
-    mkdir nullb0 &&
-    cd nullb0 &&
-    echo 0 > completion_nsec &&
-    echo 4096 > blocksize &&
-    echo 1024 > size &&
-    echo 1 > memory_backed &&
-    echo 1 > power || exit $?
-
-"${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
deleted file mode 100755
index f9c9530c..00000000
--- a/t/zbd/run-tests-against-zoned-nullb
+++ /dev/null
@@ -1,53 +0,0 @@
-#!/bin/bash
-#
-# Copyright (C) 2018 Western Digital Corporation or its affiliates.
-#
-# This file is released under the GPL.
-
-scriptdir="$(cd "$(dirname "$0")" && pwd)"
-
-zone_size=1
-zone_capacity=1
-if [[ ${1} == "-h" ]]; then
-    echo "Usage: ${0} [OPTIONS]"
-    echo "Options:"
-    echo -e "\t-h Show this message."
-    echo -e "\t-zone-cap Use null blk with zone capacity less than zone size."
-    echo -e "\tany option supported by test-zbd-support script."
-    exit 1
-elif [[ ${1} == "-zone-cap" ]]; then
-    zone_size=4
-    zone_capacity=3
-    shift
-fi
-
-for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
-modprobe -r null_blk
-modprobe null_blk nr_devices=0 || exit $?
-for d in /sys/kernel/config/nullb/*; do
-    [ -d "$d" ] && rmdir "$d"
-done
-modprobe -r null_blk
-[ -e /sys/module/null_blk ] && exit $?
-modprobe null_blk nr_devices=0 &&
-    cd /sys/kernel/config/nullb &&
-    mkdir nullb0 &&
-    cd nullb0 || exit $?
-
-if ((zone_capacity < zone_size)); then
-    if [[ ! -w zone_capacity ]]; then
-        echo "null blk does not support zone capacity"
-        exit 1
-    fi
-    echo "${zone_capacity}" > zone_capacity
-fi
-
-echo 1 > zoned &&
-    echo "${zone_size}" > zone_size &&
-    echo 0 > completion_nsec &&
-    echo 4096 > blocksize &&
-    echo 1024 > size &&
-    echo 1 > memory_backed &&
-    echo 1 > power || exit $?
-
-"${scriptdir}"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index acde3b3a..1658dc25 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -14,6 +14,7 @@ usage() {
 	echo -e "\t-r Reset all zones before test start"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
 }
 
@@ -190,6 +191,64 @@ prep_write() {
 		reset_zone "${dev}" -1
 }
 
+SKIP_TESTCASE=255
+
+require_scsi_dev() {
+	if ! is_scsi_device "$dev"; then
+		SKIP_REASON="$dev is not a SCSI device"
+		return 1
+	fi
+	return 0
+}
+
+require_conv_zone_bytes() {
+	local req_bytes=${1}
+
+	if ((req_bytes > first_sequential_zone_sector * 512)); then
+		SKIP_REASON="$dev does not have enough conventional zones"
+		return 1
+	fi
+	return 0
+}
+
+require_zbd() {
+	if [[ -z ${is_zbd} ]]; then
+		SKIP_REASON="$dev is not a zoned block device"
+		return 1
+	fi
+	return 0
+}
+
+require_regular_block_dev() {
+	if [[ -n ${is_zbd} ]]; then
+		SKIP_REASON="$dev is not a regular block device"
+		return 1
+	fi
+	return 0
+}
+
+require_seq_zones() {
+	local req_seq_zones=${1}
+	local seq_bytes=$((disk_size - first_sequential_zone_sector * 512))
+
+	if ((req_seq_zones > seq_bytes / zone_size)); then
+		SKIP_REASON="$dev does not have $req_seq_zones sequential zones"
+		return 1
+	fi
+	return 0
+}
+
+require_conv_zones() {
+	local req_c_zones=${1}
+	local conv_bytes=$((first_sequential_zone_sector * 512))
+
+	if ((req_c_zones > conv_bytes / zone_size)); then
+		SKIP_REASON="$dev does not have $req_c_zones conventional zones"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
@@ -221,14 +280,15 @@ test2() {
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
-    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    ! grep -q 'WRITE:' "${logfile}.${test_number}"
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'buflen exceeds zone size' "${logfile}.${test_number}"
 }
 
 # Run fio against an empty zone. This causes fio to report "No I/O performed".
 test3() {
     local off opts=() rc
 
+    require_seq_zones 129 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 128 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
@@ -246,6 +306,7 @@ test3() {
 test4() {
     local off opts=()
 
+    require_seq_zones 130 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 129 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
@@ -327,10 +388,7 @@ test8() {
 test9() {
     local size
 
-    if ! is_scsi_device "$dev"; then
-	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_scsi_dev || return $SKIP_TESTCASE
 
     prep_write
     size=$((4 * zone_size))
@@ -346,10 +404,7 @@ test9() {
 test10() {
     local size
 
-    if ! is_scsi_device "$dev"; then
-	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_scsi_dev || return $SKIP_TESTCASE
 
     prep_write
     size=$((4 * zone_size))
@@ -409,18 +464,20 @@ test13() {
 
 # Random write to conventional zones.
 test14() {
-    local size
+    local off size
 
+    if ! result=($(first_online_zone "$dev")); then
+	echo "Failed to determine first online zone"
+	exit 1
+    fi
+    off=${result[0]}
     prep_write
     size=$((16 * 2**20)) # 20 MB
-    if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
-	echo "$dev does not have enough sequential zones" \
-	     >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_conv_zone_bytes "${size}" || return $SKIP_TESTCASE
+
     run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
-		    --verify=md5 --size=$size				   \
+		    --verify=md5 --offset=$off --size=$size\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size)) || return $?
     check_read $((size)) || return $?
@@ -477,17 +534,26 @@ test16() {
 
 # Random reads and writes in the last zone.
 test17() {
-    local io off read size written
+    local io off last read size written
 
     off=$(((disk_size / zone_size - 1) * zone_size))
     size=$((disk_size - off))
+    if ! last=($(last_online_zone "$dev")); then
+	echo "Failed to determine last online zone"
+	exit 1
+    fi
+    if [[ "$((last * 512))" -lt "$off" ]]; then
+	off=$((last * 512))
+	size=$zone_size
+    fi
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
     prep_write
     run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
-		    --offset=$off --loops=2 --norandommap=1\
+		    --offset=$off --loops=2 --norandommap=1 \
+		    --size="$size"\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     written=$(fio_written <"${logfile}.${test_number}")
     read=$(fio_read <"${logfile}.${test_number}")
@@ -604,6 +670,7 @@ test27() {
 test28() {
     local i jobs=16 off opts
 
+    require_seq_zones 65 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     prep_write
@@ -628,6 +695,7 @@ test28() {
 test29() {
     local i jobs=16 off opts=()
 
+    require_seq_zones 80 || return $SKIP_TESTCASE
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
     prep_write
@@ -664,12 +732,18 @@ test31() {
     local bs inc nz off opts size
 
     prep_write
-    # Start with writing 128 KB to 128 sequential zones.
+    # Start with writing 128 KB to max_open_zones sequential zones.
     bs=128K
-    nz=128
+    nz=$((max_open_zones))
+    if [[ $nz -eq 0 ]]; then
+	nz=128
+    fi
     # shellcheck disable=SC2017
     inc=$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * zone_size)
 	   * zone_size))
+    if [ "$inc" -eq 0 ]; then
+	require_seq_zones $nz || return $SKIP_TESTCASE
+    fi
     opts=()
     for ((off = first_sequential_zone_sector * 512; off < disk_size;
 	  off += inc)); do
@@ -696,6 +770,8 @@ test31() {
 test32() {
     local off opts=() size
 
+    require_zbd || return $SKIP_TESTCASE
+
     prep_write
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
@@ -773,7 +849,7 @@ test37() {
     local bs off size capacity
 
     prep_write
-    capacity=$(total_zone_capacity 1 $first_sequential_zone_sector $dev)
+    capacity=$(total_zone_capacity 1 $((first_sequential_zone_sector*512)) $dev)
     if [ "$first_sequential_zone_sector" = 0 ]; then
 	off=0
     else
@@ -805,16 +881,23 @@ test38() {
 
 # Read one block from a block device.
 read_one_block() {
+    local off
     local bs
 
+    if ! result=($(first_online_zone "$dev")); then
+	echo "Failed to determine first online zone"
+	exit 1
+    fi
+    off=${result[0]}
     bs=$((logical_block_size))
-    run_one_fio_job --rw=read "$(ioengine "psync")" --bs=$bs --size=$bs "$@" 2>&1 |
+    run_one_fio_job --rw=read "$(ioengine "psync")" --offset=$off --bs=$bs \
+		    --size=$bs "$@" 2>&1 |
 	tee -a "${logfile}.${test_number}"
 }
 
 # Check whether fio accepts --zonemode=none for zoned block devices.
 test39() {
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=none >/dev/null || return $?
     check_read $((logical_block_size)) || return $?
 }
@@ -824,7 +907,7 @@ test40() {
     local bs
 
     bs=$((logical_block_size))
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=strided |
 	grep -q 'fio: --zonesize must be specified when using --zonemode=strided' ||
 	return $?
@@ -834,21 +917,21 @@ test40() {
 
 # Check whether fio checks the zone size for zoned block devices.
 test41() {
-    [ -n "$is_zbd" ] || return 0
+    require_zbd || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=$((2 * zone_size)) |
 	grep -q 'job parameter zonesize.*does not match disk zone size'
 }
 
 # Check whether fio handles --zonesize=0 correctly for regular block devices.
 test42() {
-    [ -n "$is_zbd" ] && return 0
+    require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=0 |
 	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
 }
 
 # Check whether fio handles --zonesize=1 correctly for regular block devices.
 test43() {
-    [ -n "$is_zbd" ] && return 0
+    require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=1 |
 	grep -q 'zone size must be at least 512 bytes for --zonemode=zbd'
 }
@@ -862,7 +945,7 @@ test44() {
 test45() {
     local bs i
 
-    [ -z "$is_zbd" ] && return 0
+    require_zbd || return $SKIP_TESTCASE
     prep_write
     bs=$((logical_block_size))
     run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
@@ -901,6 +984,9 @@ test47() {
 test48() {
     local i jobs=16 off opts=()
 
+    require_zbd || return $SKIP_TESTCASE
+    require_seq_zones 80 || return $SKIP_TESTCASE
+
     off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
     size=$((16*zone_size))
     prep_write
@@ -922,7 +1008,7 @@ test48() {
 
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
-    timeout -v -s KILL 45s \
+    timeout -v -s KILL 180s \
 	    "${dynamic_analyzer[@]}" "$fio" "${opts[@]}" \
 	    >> "${logfile}.${test_number}" 2>&1 || return $?
 }
@@ -930,11 +1016,7 @@ test48() {
 # Check if fio handles --zonecapacity on a normal block device correctly
 test49() {
 
-    if [ -n "$is_zbd" ]; then
-	echo "$dev is not a regular block device" \
-	     >>"${logfile}.${test_number}"
-	return 0
-    fi
+    require_regular_block_dev || return $SKIP_TESTCASE
 
     size=$((2 * zone_size))
     capacity=$((zone_size * 3 / 4))
@@ -948,12 +1030,137 @@ test49() {
     check_read $((capacity * 2)) || return $?
 }
 
+# Verify that conv zones are not locked and only seq zones are locked during
+# random read on conv-seq mixed zones.
+test50() {
+	local off
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	reset_zone "${dev}" -1
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	run_fio --name=job --filename=${dev} --offset=${off} --bs=64K \
+		--size=$((16 * zone_size)) "$(ioengine "libaio")" --rw=randread\
+		--time_based --runtime=3 --zonemode=zbd --zonesize=${zone_size}\
+		--direct=1 --group_reporting=1 ${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Verify that conv zones are neither locked nor opened during random write on
+# conv-seq mixed zones. Zone lock and zone open shall happen only on seq zones.
+test51() {
+	local off jobs=16
+	local -a opts
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	prep_write
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	opts+=("--size=$((16 * zone_size))" "$(ioengine "libaio")")
+	opts+=("--zonemode=zbd" "--direct=1" "--zonesize=${zone_size}")
+	opts+=("--max_open_zones=2" "--offset=$off")
+	opts+=("--thread=1" "--group_reporting=1")
+	opts+=("--time_based" "--runtime=30" "--rw=randwrite")
+	for ((i=0;i<jobs;i++)); do
+		opts+=("--name=job${i}" "--filename=$dev")
+		opts+=("--bs=$(((i+1)*16))K")
+		opts+=($(job_var_opts_exclude "--max_open_zones"))
+	done
+	run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Verify that zone_reset_threshold only takes logical blocks from seq
+# zones into account, and logical blocks of conv zones are not counted.
+test52() {
+	local off io_size
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 8 || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	reset_zone "${dev}" -1
+
+	# Total I/O size is 1/8 = 0.125 of the I/O range of cont + seq zones.
+	# Set zone_reset_threshold as 0.1. The threshold size is less than
+	# 0.125, then, reset count zero is expected.
+	# On the other hand, half of the I/O range is covered by conv zones.
+	# If fio would count the conv zones for zone_reset_threshold, the ratio
+	# were more than 0.5 and would trigger zone resets.
+
+	off=$((first_sequential_zone_sector * 512 - 8 * zone_size))
+	io_size=$((zone_size * 16 / 8))
+	run_fio --name=job --filename=$dev --rw=randwrite --bs=$((zone_size/16))\
+		--size=$((zone_size * 16)) --softrandommap=1 \
+		--io_size=$((io_size)) "$(ioengine "psync")" --offset=$off \
+		--zonemode=zbd --direct=1 --zonesize=${zone_size} \
+		--zone_reset_threshold=.1 --zone_reset_frequency=1.0 \
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	check_written ${io_size} || return $?
+	check_reset_count -eq 0 || return $?
+}
+
+# Check both reads and writes are executed by random I/O to conventional zones.
+test53() {
+	local off capacity io read_b=0 written_b=0
+
+	require_zbd || return $SKIP_TESTCASE
+	require_conv_zones 4 || return $SKIP_TESTCASE
+
+	off=$((first_sequential_zone_sector * 512 - 4 * zone_size))
+	capacity=$(total_zone_capacity 4 $off $dev)
+	run_fio --name=job --filename=${dev} --rw=randrw --bs=64K \
+		--size=$((4 * zone_size)) "$(ioengine "psync")" --offset=${off}\
+		--zonemode=zbd --direct=1 --zonesize=${zone_size} \
+		${job_var_opts[@]} \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+
+	written_b=$(fio_written <"${logfile}.${test_number}")
+	read_b=$(fio_read <"${logfile}.${test_number}")
+	io=$((written_b + read_b))
+	echo "Number of bytes read: $read_b" >>"${logfile}.${test_number}"
+	echo "Number of bytes written: $written_b" >>"${logfile}.${test_number}"
+	echo "Total number of bytes read and written: $io <> $capacity" \
+	     >>"${logfile}.${test_number}"
+	if ((io==capacity && written_b != 0 && read_b != 0)); then
+		return 0
+	fi
+	return 1
+}
+
+# Test read/write mix with verify.
+test54() {
+	require_zbd || return $SKIP_TESTCASE
+	require_seq_zones 8 || return $SKIP_TESTCASE
+
+	run_fio --name=job --filename=${dev} "$(ioengine "libaio")" \
+		--time_based=1 --runtime=30s --continue_on_error=0 \
+		--offset=$((first_sequential_zone_sector * 512)) \
+		--size=$((8*zone_size)) --direct=1 --iodepth=1 \
+		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
+		--zonemode=zbd --zonesize=${zone_size} \
+		--verify=crc32c --do_verify=1 --verify_backlog=2 \
+		--experimental_verify=1 \
+		--alloc-size=65536 --random_generator=tausworthe64 \
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+SECONDS=0
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
 use_libzbc=
 zbd_debug=
 max_open_zones_opt=
+quit_on_err=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -968,8 +1175,10 @@ while [ "${1#-}" != "$1" ]; do
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
+    -q) quit_on_err=1; shift;;
     -z) zbd_debug=1; shift;;
     --) shift; break;;
+     *) usage; exit 1;;
   esac
 done
 
@@ -1087,10 +1296,12 @@ fi
 logfile=$0.log
 
 passed=0
+skipped=0
 failed=0
 if [ -t 1 ]; then
     red="\e[1;31m"
     green="\e[1;32m"
+    cyan="\e[1;36m"
     end="\e[m"
 else
     red=""
@@ -1101,14 +1312,23 @@ rc=0
 
 intr=0
 trap 'intr=1' SIGINT
+ret=0
 
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
+    unset SKIP_REASON
     echo -n "Running test $(printf "%02d" $test_number) ... "
-    if eval "test$test_number" && check_log $test_number; then
+    eval "test$test_number"
+    ret=$?
+    if ((!ret)) && check_log $test_number; then
 	status="PASS"
 	cc_status="${green}${status}${end}"
 	((passed++))
+    elif ((ret==SKIP_TESTCASE)); then
+	status="SKIP"
+	echo "${SKIP_REASON}" >> "${logfile}.${test_number}"
+	cc_status="${cyan}${status}${end}    ${SKIP_REASON}"
+	((skipped++))
     else
 	status="FAIL"
 	cc_status="${red}${status}${end}"
@@ -1118,10 +1338,15 @@ for test_number in "${tests[@]}"; do
     echo -e "$cc_status"
     echo "$status" >> "${logfile}.${test_number}"
     [ $intr -ne 0 ] && exit 1
+    [ -n "$quit_on_err" -a "$rc" -ne 0 ] && exit 1
 done
 
 echo "$passed tests passed"
+if [ $skipped -gt 0 ]; then
+    echo " $skipped tests skipped"
+fi
 if [ $failed -gt 0 ]; then
-    echo " and $failed tests failed"
+    echo " $failed tests failed"
 fi
+echo "Run time: $(TZ=UTC0 printf "%(%H:%M:%S)T\n" $(( SECONDS )) )"
 exit $rc
diff --git a/zbd.c b/zbd.c
index f2599bd4..6a26fe10 100644
--- a/zbd.c
+++ b/zbd.c
@@ -131,15 +131,6 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 	return min(zone_idx, f->zbd_info->nr_zones);
 }
 
-/**
- * zbd_zone_swr - Test whether a zone requires sequential writes
- * @z: zone info pointer.
- */
-static inline bool zbd_zone_swr(struct fio_zone_info *z)
-{
-	return z->type == ZBD_ZONE_TYPE_SWR;
-}
-
 /**
  * zbd_zone_end - Return zone end location
  * @z: zone info pointer.
@@ -171,11 +162,12 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return zbd_zone_swr(z) &&
+	return z->has_wp &&
 		z->wp + required > zbd_zone_capacity_end(z);
 }
 
-static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
+static void zone_lock(struct thread_data *td, const struct fio_file *f,
+		      struct fio_zone_info *z)
 {
 	struct zoned_block_device_info *zbd = f->zbd_info;
 	uint32_t nz = z - zbd->zone_info;
@@ -183,6 +175,8 @@ static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zon
 	/* A thread should never lock zones outside its working area. */
 	assert(f->min_zone <= nz && nz < f->max_zone);
 
+	assert(z->has_wp);
+
 	/*
 	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
 	 * is changed or when io_u completes and zbd_put_io() executed.
@@ -199,11 +193,26 @@ static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zon
 	}
 }
 
+static inline void zone_unlock(struct fio_zone_info *z)
+{
+	int ret;
+
+	assert(z->has_wp);
+	ret = pthread_mutex_unlock(&z->mutex);
+	assert(!ret);
+}
+
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
 {
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
 }
 
+static inline struct fio_zone_info *get_zone(const struct fio_file *f,
+					     unsigned int zone_nr)
+{
+	return &f->zbd_info->zone_info[zone_nr];
+}
+
 /* Verify whether direct I/O is used for all host-managed zoned drives. */
 static bool zbd_using_direct_io(void)
 {
@@ -235,7 +244,7 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	zone_idx_b = zbd_zone_idx(f, f->file_offset);
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
-		if (zbd_zone_swr(&f->zbd_info->zone_info[zone_idx]))
+		if (get_zone(f, zone_idx)->has_wp)
 			return true;
 
 	return false;
@@ -286,7 +295,7 @@ static bool zbd_verify_sizes(void)
 			}
 
 			zone_idx = zbd_zone_idx(f, f->file_offset);
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 			if ((f->file_offset != z->start) &&
 			    (td->o.td_ddir != TD_DDIR_READ)) {
 				new_offset = zbd_zone_end(z);
@@ -302,7 +311,7 @@ static bool zbd_verify_sizes(void)
 				f->file_offset = new_offset;
 			}
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 			new_end = z->start;
 			if ((td->o.td_ddir != TD_DDIR_READ) &&
 			    (f->file_offset + f->io_size != new_end)) {
@@ -316,10 +325,6 @@ static bool zbd_verify_sizes(void)
 					 (unsigned long long) new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
-
-			f->min_zone = zbd_zone_idx(f, f->file_offset);
-			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
-			assert(f->min_zone < f->max_zone);
 		}
 	}
 
@@ -415,6 +420,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
 		p->capacity = zone_capacity;
+		p->has_wp = 1;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
@@ -443,7 +449,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *p;
 	uint64_t zone_size, offset;
 	struct zoned_block_device_info *zbd_info = NULL;
-	int i, j, ret = 0;
+	int i, j, ret = -ENOMEM;
 
 	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
 	if (!zones)
@@ -475,7 +481,6 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
-	ret = -ENOMEM;
 	if (!zbd_info)
 		goto out;
 	mutex_init_pshared(&zbd_info->mutex);
@@ -499,8 +504,17 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 				p->wp = z->wp;
 				break;
 			}
+
+			switch (z->type) {
+			case ZBD_ZONE_TYPE_SWR:
+				p->has_wp = 1;
+				break;
+			default:
+				p->has_wp = 0;
+			}
 			p->type = z->type;
 			p->cond = z->cond;
+
 			if (j > 0 && p->start != p[-1].start + zone_size) {
 				log_info("%s: invalid zone data\n",
 					 f->file_name);
@@ -512,8 +526,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		offset = z->start + z->len;
 		if (j >= nr_zones)
 			break;
-		nrz = zbd_report_zones(td, f, offset,
-					    zones, ZBD_REPORT_MAX_ZONES);
+		nrz = zbd_report_zones(td, f, offset, zones,
+				       min((uint32_t)(nr_zones - j),
+					   ZBD_REPORT_MAX_ZONES));
 		if (nrz < 0) {
 			ret = nrz;
 			log_info("fio: report zones (offset %llu) failed for %s (%d).\n",
@@ -662,6 +677,18 @@ int zbd_setup_files(struct thread_data *td)
 		if (!zbd)
 			continue;
 
+		f->min_zone = zbd_zone_idx(f, f->file_offset);
+		f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
+
+		/*
+		 * When all zones in the I/O range are conventional, io_size
+		 * can be smaller than zone size, making min_zone the same
+		 * as max_zone. This is why the assert below needs to be made
+		 * conditional.
+		 */
+		if (zbd_is_seq_job(f))
+			assert(f->min_zone < f->max_zone);
+
 		zbd->max_open_zones = zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
 
 		if (td->o.max_open_zones > 0 &&
@@ -695,10 +722,10 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
 
-static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
-				struct fio_zone_info *zone)
+static inline unsigned int zbd_zone_nr(const struct fio_file *f,
+				       struct fio_zone_info *zone)
 {
-	return zone - zbd_info->zone_info;
+	return zone - f->zbd_info->zone_info;
 }
 
 /**
@@ -716,15 +743,16 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 {
 	uint64_t offset = z->start;
 	uint64_t length = (z+1)->start - offset;
+	uint64_t data_in_zone = z->wp - z->start;
 	int ret = 0;
 
-	if (z->wp == z->start)
+	if (!data_in_zone)
 		return 0;
 
 	assert(is_valid_offset(f, offset + length - 1));
 
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f->zbd_info, z));
+		zbd_zone_nr(f, z));
 	switch (f->zbd_info->model) {
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
@@ -737,7 +765,8 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= z->wp - z->start;
+	f->zbd_info->sectors_with_data -= data_in_zone;
+	f->zbd_info->wp_sectors_with_data -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	z->wp = z->start;
 	z->verify_block = 0;
@@ -757,11 +786,8 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		if (f->zbd_info->open_zones[open_zone_idx] == zone_idx)
 			break;
 	}
-	if (open_zone_idx == f->zbd_info->num_open_zones) {
-		dprint(FD_ZBD, "%s: zone %d is not open\n",
-		       f->file_name, zone_idx);
+	if (open_zone_idx == f->zbd_info->num_open_zones)
 		return;
-	}
 
 	dprint(FD_ZBD, "%s: closing zone %d\n", f->file_name, zone_idx);
 	memmove(f->zbd_info->open_zones + open_zone_idx,
@@ -770,7 +796,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
 	td->num_open_zones--;
-	f->zbd_info->zone_info[zone_idx].open = 0;
+	get_zone(f, zone_idx)->open = 0;
 }
 
 /*
@@ -794,11 +820,11 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	assert(min_bs);
 
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
-		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
+		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
 	for (z = zb; z < ze; z++) {
-		uint32_t nz = z - f->zbd_info->zone_info;
+		uint32_t nz = zbd_zone_nr(f, z);
 
-		if (!zbd_zone_swr(z))
+		if (!z->has_wp)
 			continue;
 		zone_lock(td, f, z);
 		if (all_zones) {
@@ -812,12 +838,11 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
-			       f->file_name,
-			       zbd_zone_nr(f->zbd_info, z));
+			       f->file_name, zbd_zone_nr(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
 				res = 1;
 		}
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 	}
 
 	return res;
@@ -866,29 +891,37 @@ enum swd_action {
 };
 
 /* Calculate the number of sectors with data (swd) and perform action 'a' */
-static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
+static uint64_t zbd_process_swd(struct thread_data *td,
+				const struct fio_file *f, enum swd_action a)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
+	uint64_t wp_swd = 0;
 
-	zb = &f->zbd_info->zone_info[f->min_zone];
-	ze = &f->zbd_info->zone_info[f->max_zone];
+	zb = get_zone(f, f->min_zone);
+	ze = get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
+		if (z->has_wp) {
+			zone_lock(td, f, z);
+			wp_swd += z->wp - z->start;
+		}
 		swd += z->wp - z->start;
 	}
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
 		assert(f->zbd_info->sectors_with_data == swd);
+		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
 		break;
 	case SET_SWD:
 		f->zbd_info->sectors_with_data = swd;
+		f->zbd_info->wp_sectors_with_data = wp_swd;
 		break;
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	for (z = zb; z < ze; z++)
-		pthread_mutex_unlock(&z->mutex);
+		if (z->has_wp)
+			zone_unlock(z);
 
 	return swd;
 }
@@ -899,37 +932,28 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
  */
 static const bool enable_check_swd = false;
 
-/* Check whether the value of zbd_info.sectors_with_data is correct. */
-static void zbd_check_swd(const struct fio_file *f)
-{
-	if (!enable_check_swd)
-		return;
-
-	zbd_process_swd(f, CHECK_SWD);
-}
-
-static void zbd_init_swd(struct fio_file *f)
+/* Check whether the values of zbd_info.*sectors_with_data are correct. */
+static void zbd_check_swd(struct thread_data *td, const struct fio_file *f)
 {
-	uint64_t swd;
-
 	if (!enable_check_swd)
 		return;
 
-	swd = zbd_process_swd(f, SET_SWD);
-	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
-	       swd);
+	zbd_process_swd(td, f, CHECK_SWD);
 }
 
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
+	uint64_t swd;
 
 	if (!f->zbd_info || !td_write(td))
 		return;
 
-	zb = &f->zbd_info->zone_info[f->min_zone];
-	ze = &f->zbd_info->zone_info[f->max_zone];
-	zbd_init_swd(f);
+	zb = get_zone(f, f->min_zone);
+	ze = get_zone(f, f->max_zone);
+	swd = zbd_process_swd(td, f, SET_SWD);
+	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
+	       swd);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
@@ -968,7 +992,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
+	struct fio_zone_info *z = get_zone(f, zone_idx);
 	bool res = true;
 
 	if (z->cond == ZBD_ZONE_COND_OFFLINE)
@@ -1019,7 +1043,8 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
- * necessary. This algorithm can only work correctly if all write pointers are
+ * necessary. The open zone is searched across sequential zones.
+ * This algorithm can only work correctly if all write pointers are
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
@@ -1061,16 +1086,19 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	for (;;) {
 		uint32_t tmp_idx;
 
-		z = &f->zbd_info->zone_info[zone_idx];
-
-		zone_lock(td, f, z);
+		z = get_zone(f, zone_idx);
+		if (z->has_wp)
+			zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
-			goto examine_zone;
-		if (f->zbd_info->num_open_zones == 0) {
-			dprint(FD_ZBD, "%s(%s): no zones are open\n",
-			       __func__, f->file_name);
-			goto open_other_zone;
+		if (z->has_wp) {
+			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
+			    td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
+				goto examine_zone;
+			if (f->zbd_info->num_open_zones == 0) {
+				dprint(FD_ZBD, "%s(%s): no zones are open\n",
+				       __func__, f->file_name);
+				goto open_other_zone;
+			}
 		}
 
 		/*
@@ -1079,7 +1107,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		 * Ignore zones which don't belong to thread's offset/size area.
 		 */
 		open_zone_idx = pick_random_zone_idx(f, io_u);
-		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		assert(!open_zone_idx ||
+		       open_zone_idx < f->zbd_info->num_open_zones);
 		tmp_idx = open_zone_idx;
 		for (i = 0; i < f->zbd_info->num_open_zones; i++) {
 			uint32_t tmpz;
@@ -1098,7 +1127,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		if (z->has_wp)
+			zone_unlock(z);
 		return NULL;
 
 found_candidate_zone:
@@ -1107,7 +1137,8 @@ found_candidate_zone:
 			break;
 		zone_idx = new_zone_idx;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		if (z->has_wp)
+			zone_unlock(z);
 	}
 
 	/* Both z->mutex and f->zbd_info->mutex are held. */
@@ -1144,14 +1175,17 @@ open_other_zone:
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
 		zone_idx++;
-		pthread_mutex_unlock(&z->mutex);
+		if (z->has_wp)
+			zone_unlock(z);
 		z++;
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx = f->min_zone;
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
+		if (!z->has_wp)
+			continue;
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
@@ -1168,9 +1202,9 @@ open_other_zone:
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 
-		z = &f->zbd_info->zone_info[zone_idx];
+		z = get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
@@ -1178,7 +1212,7 @@ open_other_zone:
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
-	pthread_mutex_unlock(&z->mutex);
+	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
 	       f->file_name);
 	return NULL;
@@ -1187,6 +1221,8 @@ out:
 	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
 	       zone_idx);
 	io_u->offset = z->start;
+	assert(z->has_wp);
+	assert(z->cond != ZBD_ZONE_COND_OFFLINE);
 	return z;
 }
 
@@ -1198,26 +1234,39 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const struct fio_file *f = io_u->file;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
-	if (!zbd_open_zone(td, f, z - f->zbd_info->zone_info)) {
-		pthread_mutex_unlock(&z->mutex);
+	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
+		zone_unlock(z);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
 	}
 
-	if (z->verify_block * min_bs >= z->capacity)
+	if (z->verify_block * min_bs >= z->capacity) {
 		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
 			min_bs, (unsigned long long)z->capacity);
-	io_u->offset = z->start + z->verify_block++ * min_bs;
+		/*
+		 * If the assertion below fails during a test run, adding
+		 * "--experimental_verify=1" to the command line may help.
+		 */
+		assert(false);
+	}
+	io_u->offset = z->start + z->verify_block * min_bs;
+	if (io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
+		log_err("%s: %llu + %llu >= %llu\n", f->file_name, io_u->offset,
+			io_u->buflen, (unsigned long long) zbd_zone_capacity_end(z));
+		assert(false);
+	}
+	z->verify_block += io_u->buflen / min_bs;
+
 	return z;
 }
 
 /*
- * Find another zone for which @io_u fits below the write pointer. Start
- * searching in zones @zb + 1 .. @zl and continue searching in zones
- * @zf .. @zb - 1.
+ * Find another zone for which @io_u fits in the readable data in the zone.
+ * Search in zones @zb + 1 .. @zl. For random workload, also search in zones
+ * @zb - 1 .. @zf.
  *
- * Either returns NULL or returns a zone pointer and holds the mutex for that
- * zone.
+ * Either returns NULL or returns a zone pointer. When the zone has write
+ * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
 zbd_find_zone(struct thread_data *td, struct io_u *io_u,
@@ -1226,8 +1275,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
-	const struct fio_zone_info *const zf =
-		&f->zbd_info->zone_info[f->min_zone];
+	const struct fio_zone_info *const zf = get_zone(f, f->min_zone);
 
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1235,19 +1283,23 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, f, z1);
+			if (z1->has_wp)
+				zone_lock(td, f, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
-			pthread_mutex_unlock(&z1->mutex);
+			if (z1->has_wp)
+				zone_unlock(z1);
 		} else if (!td_random(td)) {
 			break;
 		}
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, f, z2);
+			if (z2->has_wp)
+				zone_lock(td, f, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
-			pthread_mutex_unlock(&z2->mutex);
+			if (z2->has_wp)
+				zone_unlock(z2);
 		}
 	}
 	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
@@ -1272,7 +1324,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z - f->zbd_info->zone_info);
+		zbd_close_zone(td, f, zbd_zone_nr(f, z));
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
@@ -1300,10 +1352,9 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z = &zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
-	if (!zbd_zone_swr(z))
-		return;
+	assert(z->has_wp);
 
 	if (!success)
 		goto unlock;
@@ -1321,8 +1372,10 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
-		if (z->wp <= zone_end)
+		if (z->wp <= zone_end) {
 			zbd_info->sectors_with_data += zone_end - z->wp;
+			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+		}
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
@@ -1339,7 +1392,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 unlock:
 	if (!success || q != FIO_Q_QUEUED) {
 		/* BUSY or COMPLETED: unlock the zone */
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 		io_u->zbd_put_io = NULL;
 	}
 }
@@ -1354,17 +1407,15 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
-	int ret;
 
 	if (!zbd_info)
 		return;
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z = &zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
-	if (!zbd_zone_swr(z))
-		return;
+	assert(z->has_wp);
 
 	dprint(FD_ZBD,
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
@@ -1372,9 +1423,8 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 
 	zbd_end_zone_io(td, io_u, z);
 
-	ret = pthread_mutex_unlock(&z->mutex);
-	assert(ret == 0);
-	zbd_check_swd(f);
+	zone_unlock(z);
+	zbd_check_swd(td, f);
 }
 
 /*
@@ -1417,7 +1467,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	assert(td->o.zone_size);
 
 	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
-	z = &f->zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1431,8 +1481,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 		       "%s: Jump from zone capacity limit to zone end:"
 		       " (%llu -> %llu) for zone %u (%llu)\n",
 		       f->file_name, (unsigned long long) f->last_pos[ddir],
-		       (unsigned long long) zbd_zone_end(z),
-		       zbd_zone_nr(f->zbd_info, z),
+		       (unsigned long long) zbd_zone_end(z), zone_idx,
 		       (unsigned long long) z->capacity);
 		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] = zbd_zone_end(z);
@@ -1526,12 +1575,34 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);
-	zb = &f->zbd_info->zone_info[zone_idx_b];
+	zb = get_zone(f, zone_idx_b);
 	orig_zb = zb;
 
-	/* Accept the I/O offset for conventional zones. */
-	if (!zbd_zone_swr(zb))
+	if (!zb->has_wp) {
+		/* Accept non-write I/Os for conventional zones. */
+		if (io_u->ddir != DDIR_WRITE)
+			return io_u_accept;
+		/*
+		 * Make sure that writes to conventional zones
+		 * don't cross over to any sequential zones.
+		 */
+		if (!(zb + 1)->has_wp ||
+		    io_u->offset + io_u->buflen <= (zb + 1)->start)
+			return io_u_accept;
+
+		if (io_u->offset + min_bs > (zb + 1)->start) {
+			dprint(FD_IO,
+			       "%s: off=%llu + min_bs=%u > next zone %llu\n",
+			       f->file_name, io_u->offset,
+			       min_bs, (unsigned long long) (zb + 1)->start);
+			io_u->offset = zb->start + (zb + 1)->start - io_u->offset;
+			new_len = min(io_u->buflen, (zb + 1)->start - io_u->offset);
+		} else {
+			new_len = (zb + 1)->start - io_u->offset;
+		}
+		io_u->buflen = new_len / min_bs * min_bs;
 		return io_u_accept;
+	}
 
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
@@ -1541,7 +1612,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
-	zbd_check_swd(f);
+	zbd_check_swd(td, f);
 
 	zone_lock(td, f, zb);
 
@@ -1549,7 +1620,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td)) {
 			zb = zbd_replay_write_order(td, io_u, zb);
-			pthread_mutex_unlock(&zb->mutex);
 			goto accept;
 		}
 		/*
@@ -1561,8 +1631,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->wp - zb->start : 0;
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
-			pthread_mutex_unlock(&zb->mutex);
-			zl = &f->zbd_info->zone_info[f->max_zone];
+			zone_unlock(zb);
+			zl = get_zone(f, f->max_zone);
 			zb = zbd_find_zone(td, io_u, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
@@ -1591,6 +1661,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			io_u->offset = zb->start +
 				((io_u->offset - orig_zb->start) %
 				 (range - io_u->buflen)) / min_bs * min_bs;
+		/*
+		 * When zbd_find_zone() returns a conventional zone,
+		 * we can simply accept the new i/o offset here.
+		 */
+		if (!zb->has_wp)
+			return io_u_accept;
 		/*
 		 * Make sure the I/O does not cross over the zone wp position.
 		 */
@@ -1606,18 +1682,27 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		assert(io_u->offset + io_u->buflen <= zb->wp);
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > f->zbd_info->zone_size)
+		if (io_u->buflen > f->zbd_info->zone_size) {
+			td_verror(td, EINVAL, "I/O buflen exceeds zone size");
+			dprint(FD_IO,
+			       "%s: I/O buflen %llu exceeds zone size %llu\n",
+			       f->file_name, io_u->buflen,
+			       (unsigned long long) f->zbd_info->zone_size);
 			goto eof;
+		}
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
-			pthread_mutex_unlock(&zb->mutex);
+			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
-			if (!zb)
+			if (!zb) {
+				dprint(FD_IO, "%s: can't convert to open zone",
+				       f->file_name);
 				goto eof;
-			zone_idx_b = zb - f->zbd_info->zone_info;
+			}
+			zone_idx_b = zbd_zone_nr(f, zb);
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (f->zbd_info->sectors_with_data >=
+			if (f->zbd_info->wp_sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone = 1;
@@ -1639,6 +1724,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 				goto eof;
 
 			if (zb->capacity < min_bs) {
+				td_verror(td, EINVAL, "ZCAP is less min_bs");
 				log_err("zone capacity %llu smaller than minimum block size %d\n",
 					(unsigned long long)zb->capacity,
 					min_bs);
@@ -1649,8 +1735,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		assert(!zbd_zone_full(f, zb, min_bs));
 		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
-			dprint(FD_ZBD, "Dropped request with offset %llu\n",
-			       io_u->offset);
+			td_verror(td, EINVAL, "invalid WP value");
+			dprint(FD_ZBD, "%s: dropped request with offset %llu\n",
+			       f->file_name, io_u->offset);
 			goto eof;
 		}
 		/*
@@ -1669,9 +1756,9 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			       orig_len, io_u->buflen);
 			goto accept;
 		}
-		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			(zbd_zone_capacity_end(zb) - io_u->offset),
-			min_bs);
+		td_verror(td, EIO, "zone remainder too small");
+		log_err("zone remainder %lld smaller than min block size %d\n",
+			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
 		goto eof;
 	case DDIR_TRIM:
 		/* fall-through */
@@ -1687,17 +1774,23 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(false);
 
 accept:
-	assert(zb);
+	assert(zb->has_wp);
 	assert(zb->cond != ZBD_ZONE_COND_OFFLINE);
 	assert(!io_u->zbd_queue_io);
 	assert(!io_u->zbd_put_io);
 	io_u->zbd_queue_io = zbd_queue_io;
 	io_u->zbd_put_io = zbd_put_io;
+	/*
+	 * Since we return with the zone lock still held,
+	 * add an annotation to let Coverity know that it
+	 * is intentional.
+	 */
+	/* coverity[missing_unlock] */
 	return io_u_accept;
 
 eof:
-	if (zb)
-		pthread_mutex_unlock(&zb->mutex);
+	if (zb && zb->has_wp)
+		zone_unlock(zb);
 	return io_u_eof;
 }
 
diff --git a/zbd.h b/zbd.h
index bff55f99..cc3ab624 100644
--- a/zbd.h
+++ b/zbd.h
@@ -28,6 +28,7 @@ enum io_u_action {
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
+ * @has_wp: whether or not this zone can have a valid write pointer
  * @open: whether or not this zone is currently open. Only relevant if
  *		max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
@@ -40,6 +41,7 @@ struct fio_zone_info {
 	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
+	unsigned int		has_wp:1;
 	unsigned int		open:1;
 	unsigned int		reset_zone:1;
 };
@@ -53,6 +55,8 @@ struct fio_zone_info {
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
  * @sectors_with_data: total size of data in all zones in units of 512 bytes
+ * @wp_sectors_with_data: total size of data in zones with write pointers in
+ *                        units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -73,6 +77,7 @@ struct zoned_block_device_info {
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		sectors_with_data;
+	uint64_t		wp_sectors_with_data;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;

