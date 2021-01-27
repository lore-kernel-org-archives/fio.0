Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 24/38] t/zbd: add run-tests-against-nullb script
Date: Wed, 27 Jan 2021 13:19:31 +0900
Message-Id: <20210127041945.36909-25-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This script combines the t/zbd/run-tests-against-zoned-nullb script
functionality with t/zbd/run-tests-against-regular-nullb and adds
more zoned device configurations to test. This considerably improves
ZBD test coverage.

The added script makes the two old scripts named above obsolete,
remove them. Modify t/run-fio-tests.py and Makefile to refer to the
new script instead of the old one. Since the full test now runs
significantly longer than the two old ones combined due to many more
zoned configurations, only execute a few individual sections as a
part of testing n "make fulltest" and run-fio-tests.py. One extra test
section with 10% conventional zones is executed from the Makefile.
The Python tests only exercise all-conventional and all-sequential
configurations, exactly as before.

The script returns a non-zero return code if at least one of the
executed sections had a failed test.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 Makefile                              |   5 +-
 t/run-fio-tests.py                    |   8 +-
 t/zbd/run-tests-against-nullb         | 338 ++++++++++++++++++++++++++
 t/zbd/run-tests-against-regular-nullb |  27 --
 t/zbd/run-tests-against-zoned-nullb   |  53 ----
 5 files changed, 345 insertions(+), 86 deletions(-)
 create mode 100755 t/zbd/run-tests-against-nullb
 delete mode 100755 t/zbd/run-tests-against-regular-nullb
 delete mode 100755 t/zbd/run-tests-against-zoned-nullb

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
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
new file mode 100755
index 00000000..b4a48121
--- /dev/null
+++ b/t/zbd/run-tests-against-nullb
@@ -0,0 +1,338 @@
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
+	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
+	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
+	echo -e "\t   or an individual section/test."
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
+
+while (($#)); do
+	case "$1" in
+		-s) sections+=("$2"); shift; shift;;
+		-o) set_max_open="${2}"; shift; shift;;
+		-L) list_only=1; shift;;
+		-r) cleanup_nullb; exit 0;;
+		-l) libzbc=1; shift;;
+		-n) num_of_runs="${2}"; shift; shift;;
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
+		(($test_rc)) && rc=1
+	done
+
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
-- 
2.28.0


