Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 25/38] t/zbd: add -t option to run-tests-against-nullb
Date: Wed, 27 Jan 2021 13:19:32 +0900
Message-Id: <20210127041945.36909-26-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
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
 t/zbd/run-tests-against-nullb | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index b4a48121..8771e92e 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -20,6 +20,7 @@ usage()
 	echo -e "\t   tests."
 	echo -e "\t-s <#section> Only run the section with the given number."
 	echo -e "\t-l Use libzbc ioengine to run the tests."
+	echo -e "\t-t <#test> Only run the test with the given number in every section."
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
 	echo -e "\t   or an individual section/test."
@@ -239,6 +240,7 @@ set_max_open=8
 zbd_test_opts=()
 libzbc=0
 num_of_runs=1
+test_case=0
 
 while (($#)); do
 	case "$1" in
@@ -248,6 +250,7 @@ while (($#)); do
 		-r) cleanup_nullb; exit 0;;
 		-l) libzbc=1; shift;;
 		-n) num_of_runs="${2}"; shift; shift;;
+		-t) test_case="${2}"; shift; shift;;
 		-h) usage; break;;
 		--) shift; break;;
 		 *) usage; exit 1;;
@@ -290,6 +293,9 @@ while ((run_nr <= $num_of_runs)); do
 			exit 1
 		fi
 		zbd_test_opts=()
+		if ((test_case)); then
+			zbd_test_opts+=("-t" "${test_case}")
+		fi
 		section$section_number
 		configure_nullb
 		rc=$?
-- 
2.28.0


