Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 30/36] t/zbd: add an option to bail on a failed test
Date: Thu, 24 Dec 2020 11:12:13 +0900
Message-Id: <20201224021219.189727-31-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
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
 t/zbd/run-tests-against-nullb | 6 ++++++
 t/zbd/test-zbd-support        | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index e1efb4a5..284bc658 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -22,6 +22,7 @@ function usage()
 	echo -e "\t-s <#section> Only run the section with the given number."
 	echo -e "\t-t <#test> Only run the test with the given number in every section."
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
+	echo -e "\t-q Quit t/zbd/test-zbd-support run after any failed test."
 	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
 	echo -e "\t   running this script."
 	exit 1
@@ -237,6 +238,7 @@ dev_blocksize=4096
 set_max_open=8
 zbd_test_opts=()
 test_case=0
+quit_on_err=0
 
 while [ "${1#-}" != "$1" ]; do
 	case "$1" in
@@ -246,6 +248,7 @@ while [ "${1#-}" != "$1" ]; do
 		-r) cleanup_nullb;
 		    exit 0;;
 		-t) test_case="${2}"; shift; shift;;
+		-q) quit_on_err=1; shift;;
 		-h) usage; break;;
 		--) shift; break;;
 		 *) usage; exit 1;;
@@ -288,6 +291,9 @@ for section_number in "${sections[@]}"; do
 	if ((test_case)); then
 		zbd_test_opts+=("-t" "${test_case}")
 	fi
+	if ((quit_on_err)); then
+		zbd_test_opts+=("-q")
+	fi
 	section$section_number
 	configure_nullb
 	rc=$?
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


