Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492F1C43219
	for <fio@archiver.kernel.org>; Mon, 17 Oct 2022 12:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJQMAj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Oct 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJQMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Oct 2022 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052CA27917
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cqyV55XnDUL01RnCHOopyKTJvX2RghGbPrtRxPBJ8FI=; b=EP+PEBUCqniZYxo9XqsdgLVeZn
        dGd/Ni3tkD2tpSjlhOA6yjYD5xJSNDY1HRLtxX/ijFff1izMO1778BKaENXDzgGK88qmW1KYJQ8Bz
        w4elOpq5N2lOiQik0zcAarKOJO1bmckKxpg1O5fsp9okzYZnnyhbET7awljclBS7xNoSpdAccaM3/
        4O2s5zZsrPy9VLrSwsS++pwh1SqDJUZSc8AER5VBrNnBnaO9dgHYJPnx/gLw0XuZmENjGtqYkDxhM
        OrXAz24KP2DJb0PMQ3kW9wc8u+ds2setCcaVDTSrE7BSd3WfB43dmQCRVnBLiBJdbvXJuYdoByfdm
        PTjkLJ8w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okOmu-009p3q-Ku
        for fio@vger.kernel.org; Mon, 17 Oct 2022 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 22E521BC0183; Mon, 17 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221017120002.22E521BC0183@kernel.dk>
Date:   Mon, 17 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 8a63e7a32fcb6b7b131c4678ba95b81a9f2f8bca:

  Merge branch 'readme-update' of https://github.com/nikoandpiko/fio (2022-10-15 09:05:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0360d61fbfcc1f07bcdc16672f5040f8cf49681f:

  t/zbd: add a CLI option to force io_uring (2022-10-16 17:05:03 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      fio: warn about "ioengine=psync" and "iodepth >= 1"

Dmitry Fomichev (2):
      t/zbd: fix max_open_zones determination in tests
      t/zbd: add a CLI option to force io_uring

 backend.c              |  5 +++++
 t/zbd/functions        |  4 +++-
 t/zbd/test-zbd-support | 10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index ec535bcc..d8f4f2a5 100644
--- a/backend.c
+++ b/backend.c
@@ -1791,6 +1791,11 @@ static void *thread_main(void *data)
 	if (td_io_init(td))
 		goto err;
 
+	if (td_ioengine_flagged(td, FIO_SYNCIO) && td->o.iodepth > 1) {
+		log_info("note: both iodepth >= 1 and synchronous I/O engine "
+			 "are selected, queue depth will be capped at 1\n");
+	}
+
 	if (init_io_u(td))
 		goto err;
 
diff --git a/t/zbd/functions b/t/zbd/functions
index 7cff18fd..812320f5 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -230,9 +230,11 @@ max_open_zones() {
 		    echo ${max_nr_open_zones}
 		}
 	fi
-    else
+    elif [ -n "${use_libzbc}" ]; then
 	${zbc_report_zones} "$dev" |
 	    sed -n 's/^[[:blank:]]*Maximum number of open sequential write required zones:[[:blank:]]*//p'
+    else
+	echo 0
     fi
 }
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index d4aaa813..cdc03f28 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -17,6 +17,7 @@ usage() {
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
+	echo -e "\t-u Use io_uring ioengine in place of libaio"
 }
 
 max() {
@@ -38,6 +39,8 @@ min() {
 ioengine() {
 	if [ -n "$use_libzbc" ]; then
 		echo -n "--ioengine=libzbc"
+	elif [ "$1" = "libaio" -a -n "$force_io_uring" ]; then
+		echo -n "--ioengine=io_uring"
 	else
 		echo -n "--ioengine=$1"
 	fi
@@ -1275,6 +1278,7 @@ use_libzbc=
 zbd_debug=
 max_open_zones_opt=
 quit_on_err=
+force_io_uring=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -1292,6 +1296,7 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -q) quit_on_err=1; shift;;
     -z) zbd_debug=1; shift;;
+    -u) force_io_uring=1; shift;;
     --) shift; break;;
      *) usage; exit 1;;
   esac
@@ -1302,6 +1307,11 @@ if [ $# != 1 ]; then
     exit 1
 fi
 
+if [ -n "$use_libzbc" -a -n "$force_io_uring" ]; then
+    echo "Please specify only one of -l and -u options"
+    exit 1
+fi
+
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
