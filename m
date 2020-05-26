Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgEZMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 May 2020 08:00:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71761C03E96D
        for <fio@vger.kernel.org>; Tue, 26 May 2020 05:00:14 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdYFe-0001RJ-Kl
        for fio@vger.kernel.org; Tue, 26 May 2020 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200526120001.4C0D61BC01A9@kernel.dk>
Date: Tue, 26 May 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5df5882b267b1cc7d08f7e9038e6c1046d492936:

  Merge branch 'parse-and-fill-pattern' of https://github.com/bvanassche/fio (2020-05-24 12:03:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c96b385b6e0c78478697713e6da9174fba2432d3:

  t/zbd: make the test script easier to terminate (2020-05-25 18:21:45 -0600)

----------------------------------------------------------------
Dmitry Fomichev (4):
      libzbc: cleanup init code
      libzbc: fix whitespace errors
      t/zbd: beautify test script output
      t/zbd: make the test script easier to terminate

 engines/libzbc.c       | 33 +++++++++++++++++----------------
 t/zbd/test-zbd-support | 20 ++++++++++++++++++--
 2 files changed, 35 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 8c682de6..9e568334 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -47,7 +47,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			   struct libzbc_data **p_ld)
 {
 	struct libzbc_data *ld = td->io_ops_data;
-        int ret, flags = OS_O_DIRECT;
+	int ret, flags = OS_O_DIRECT;
 
 	if (ld) {
 		/* Already open */
@@ -61,7 +61,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -EINVAL;
 	}
 
-        if (td_write(td)) {
+	if (td_write(td)) {
 		if (!read_only)
 			flags |= O_RDWR;
 	} else if (td_read(td)) {
@@ -71,17 +71,15 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			flags |= O_RDONLY;
 	} else if (td_trim(td)) {
 		td_verror(td, EINVAL, "libzbc does not support trim");
-                log_err("%s: libzbc does not support trim\n",
-                        f->file_name);
-                return -EINVAL;
+		log_err("%s: libzbc does not support trim\n", f->file_name);
+		return -EINVAL;
 	}
 
-        if (td->o.oatomic) {
+	if (td->o.oatomic) {
 		td_verror(td, EINVAL, "libzbc does not support O_ATOMIC");
-                log_err("%s: libzbc does not support O_ATOMIC\n",
-                        f->file_name);
-                return -EINVAL;
-        }
+		log_err("%s: libzbc does not support O_ATOMIC\n", f->file_name);
+		return -EINVAL;
+	}
 
 	ld = calloc(1, sizeof(*ld));
 	if (!ld)
@@ -92,15 +90,12 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=%d\n",
 			f->file_name, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = libzbc_get_dev_info(ld, f);
-	if (ret) {
-		zbc_close(ld->zdev);
-		free(ld);
-		return ret;
-	}
+	if (ret)
+		goto err_close;
 
 	td->io_ops_data = ld;
 out:
@@ -108,6 +103,12 @@ out:
 		*p_ld = ld;
 
 	return 0;
+
+err_close:
+	zbc_close(ld->zdev);
+err:
+	free(ld);
+	return ret;
 }
 
 static int libzbc_close_dev(struct thread_data *td)
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index de05f438..4001be3b 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -929,20 +929,36 @@ logfile=$0.log
 
 passed=0
 failed=0
+if [ -t 1 ]; then
+    red="\e[1;31m"
+    green="\e[1;32m"
+    end="\e[m"
+else
+    red=""
+    green=""
+    end=""
+fi
 rc=0
+
+intr=0
+trap 'intr=1' SIGINT
+
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
-    echo -n "Running test $test_number ... "
+    echo -n "Running test $(printf "%02d" $test_number) ... "
     if eval "test$test_number"; then
 	status="PASS"
+	cc_status="${green}${status}${end}"
 	((passed++))
     else
 	status="FAIL"
+	cc_status="${red}${status}${end}"
 	((failed++))
 	rc=1
     fi
-    echo "$status"
+    echo -e "$cc_status"
     echo "$status" >> "${logfile}.${test_number}"
+    [ $intr -ne 0 ] && exit 1
 done
 
 echo "$passed tests passed"

