Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 32/38] t/zbd: add an option to bail on a failed test
Date: Thu,  7 Jan 2021 06:57:33 +0900
Message-Id: <20210106215739.264524-33-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Sometimes, it can be useful to inspect the state of the zones of the
test device, usually right after a test failure. Currently,
test-zbd-support script just keeps running and proper examination of
device zones can be difficult.

Add the -q option to test/zbd/support to quit immediately upon
encountering any test failure. Additionally, define the same option
in run-tests-against-nullb to propagate it to test/zbd/support.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/run-tests-against-nullb | 12 +++++++++++-
 t/zbd/test-zbd-support        |  4 ++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 655025ed..d6d5a814 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -24,6 +24,7 @@ function usage()
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
 	echo -e "\t   or an individual section/test."
+	echo -e "\t-q Quit t/zbd/test-zbd-support run after any failed test."
 	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
 	echo -e "\t   running this script."
 	exit 1
@@ -241,6 +242,7 @@ zbd_test_opts=()
 libzbc=0
 num_of_runs=1
 test_case=0
+quit_on_err=0
 
 while (($#)); do
 	case "$1" in
@@ -251,6 +253,7 @@ while (($#)); do
 		-l) libzbc=1; shift;;
 		-n) num_of_runs="${2}"; shift; shift;;
 		-t) test_case="${2}"; shift; shift;;
+		-q) quit_on_err=1; shift;;
 		-h) usage; break;;
 		--) shift; break;;
 		 *) usage; exit 1;;
@@ -296,6 +299,9 @@ while ((run_nr <= $num_of_runs)); do
 		if ((test_case)); then
 			zbd_test_opts+=("-t" "${test_case}")
 		fi
+		if ((quit_on_err)); then
+			zbd_test_opts+=("-q")
+		fi
 		section$section_number
 		configure_nullb
 		rc=$?
@@ -330,9 +336,13 @@ while ((run_nr <= $num_of_runs)); do
 			exit 1
 		fi
 		((intr)) && exit 1
-		(($test_rc)) && rc=1
+		if (($test_rc)); then
+			rc=1
+			((quit_on_err)) && break
+		fi
 	done
 
+	((rc && quit_on_err)) && break
 	run_nr=$((run_nr + 1))
 done
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4d8e905d..93456ec6 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -14,6 +14,7 @@ usage() {
 	echo -e "\t-r Reset all zones before test start"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
 }
 
@@ -1113,6 +1114,7 @@ reset_all_zones=
 use_libzbc=
 zbd_debug=
 max_open_zones_opt=
+quit_on_err=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -1127,6 +1129,7 @@ while [ "${1#-}" != "$1" ]; do
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
+    -q) quit_on_err=1; shift;;
     -z) zbd_debug=1; shift;;
     --) shift; break;;
   esac
@@ -1288,6 +1291,7 @@ for test_number in "${tests[@]}"; do
     echo -e "$cc_status"
     echo "$status" >> "${logfile}.${test_number}"
     [ $intr -ne 0 ] && exit 1
+    [ -n "$quit_on_err" -a "$rc" -ne 0 ] && exit 1
 done
 
 echo "$passed tests passed"
-- 
2.28.0


