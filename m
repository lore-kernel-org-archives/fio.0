Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 23/36] t/zbd: add -t option to run-tests-against-nullb
Date: Thu, 24 Dec 2020 11:12:06 +0900
Message-Id: <20201224021219.189727-24-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

For debugging, it can be useful to run a single ZBD test case in all
zoned configurations defined in run-tests-against-nullb. Add -t option
to run-tests-against-nullb so that the single ZBD test case specified
in run-tests-against-nullb command line is executed in all sections
of the script.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/run-tests-against-nullb | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index 0f0b319d..e1efb4a5 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -20,6 +20,7 @@ function usage()
 	echo -e "\t-l List the device layouts for every section without running"
 	echo -e "\t   tests."
 	echo -e "\t-s <#section> Only run the section with the given number."
+	echo -e "\t-t <#test> Only run the test with the given number in every section."
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
 	echo -e "\t   running this script."
@@ -235,6 +236,7 @@ dev_size=1024
 dev_blocksize=4096
 set_max_open=8
 zbd_test_opts=()
+test_case=0
 
 while [ "${1#-}" != "$1" ]; do
 	case "$1" in
@@ -243,6 +245,7 @@ while [ "${1#-}" != "$1" ]; do
 		-l) list_only=1; shift;;
 		-r) cleanup_nullb;
 		    exit 0;;
+		-t) test_case="${2}"; shift; shift;;
 		-h) usage; break;;
 		--) shift; break;;
 		 *) usage; exit 1;;
@@ -281,6 +284,10 @@ for section_number in "${sections[@]}"; do
 		echo "error creating nullb"
 		exit 1
 	fi
+	zbd_test_opts=()
+	if ((test_case)); then
+		zbd_test_opts+=("-t" "${test_case}")
+	fi
 	section$section_number
 	configure_nullb
 	rc=$?
-- 
2.28.0


