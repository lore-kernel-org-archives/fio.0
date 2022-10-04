Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6F0C433FE
	for <fio@archiver.kernel.org>; Tue,  4 Oct 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJDMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 4 Oct 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJDMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Oct 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4D32A8F
        for <fio@vger.kernel.org>; Tue,  4 Oct 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RGxpqNg8CCuHi6TATA5SN0yJ5mPrVklKG0++bWTFxp8=; b=tX1LH1lYiPD6jxyzTcnV/gf570
        wObOT0spQvMPu/vrQdnTfFYbcrJq7t0osTVJB2gORIvjXuhaTnoCvUpLTTHmQyOjBHM1OO0d1UAob
        EcgGHLT7HbzJbgqDL+8PCxFVgMsu7OK/6GThspsaoBAmLgE7LBdFL3Txf74lOch8m4n/cKFJKWH/D
        cVQ8ducllYf9zmu/N7khfUvmRrPlLjzjcIb7aEnERhrMwSD3acPt7GQOSy6LsYUdB4Nqyo6qnmn5D
        GzQQHKNSKYaHGJDRqERYfM/XssfM0OTCZ/S6fdWv/XiTCFM3xXS9VuVptZiaen8npFX/6P9tQstYG
        WML43FXA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ofgal-00H9hW-NW
        for fio@vger.kernel.org; Tue, 04 Oct 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8B6371BC0147; Tue,  4 Oct 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221004120001.8B6371BC0147@kernel.dk>
Date:   Tue,  4 Oct 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c16dc793a3c45780f67ce65244b6e91323dee014:

  Add randtrimwrite data direction (2022-09-28 10:06:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 793b868671d14f9a3e4fa76ac129545987084a8d:

  randtrimwrite: fix corner case with variable block sizes (2022-10-03 17:36:57 -0400)

----------------------------------------------------------------
Anuj Gupta (1):
      engines/io_uring: add fixedbufs support for io_uring_cmd

Vincent Fu (4):
      randtrimwrite: write at same offset as trim
      test: test job for randtrimwrite
      randtrimwrite: fix offsets for corner case
      randtrimwrite: fix corner case with variable block sizes

 engines/io_uring.c |  4 +++
 io_ddir.h          |  2 ++
 io_u.c             | 34 +++++++++++++++++++++++--
 t/jobs/t0023.fio   | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100644 t/jobs/t0023.fio

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index d0fc61dc..c679177f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -433,6 +433,10 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 		ld->prepped = 0;
 		sqe->flags |= IOSQE_ASYNC;
 	}
+	if (o->fixedbufs) {
+		sqe->uring_cmd_flags = IORING_URING_CMD_FIXED;
+		sqe->buf_index = io_u->index;
+	}
 
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
diff --git a/io_ddir.h b/io_ddir.h
index 7227e9ee..217eb628 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -52,6 +52,8 @@ enum td_ddir {
 #define file_randommap(td, f)	(!(td)->o.norandommap && fio_file_axmap((f)))
 #define td_trimwrite(td)	(((td)->o.td_ddir & TD_DDIR_TRIMWRITE) \
 					== TD_DDIR_TRIMWRITE)
+#define td_randtrimwrite(td)	(((td)->o.td_ddir & TD_DDIR_RANDTRIMWRITE) \
+					== TD_DDIR_RANDTRIMWRITE)
 
 static inline int ddir_sync(enum fio_ddir ddir)
 {
diff --git a/io_u.c b/io_u.c
index eec378dd..91f1a358 100644
--- a/io_u.c
+++ b/io_u.c
@@ -417,7 +417,13 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 
 	b = offset = -1ULL;
 
-	if (rw_seq) {
+	if (td_randtrimwrite(td) && ddir == DDIR_WRITE) {
+		/* don't mark randommap for these writes */
+		io_u_set(td, io_u, IO_U_F_BUSY_OK);
+		offset = f->last_start[DDIR_TRIM];
+		*is_random = true;
+		ret = 0;
+	} else if (rw_seq) {
 		if (td_random(td)) {
 			if (should_do_random(td, ddir)) {
 				ret = get_next_rand_block(td, f, ddir, &b);
@@ -507,6 +513,24 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u,
 		return 1;
 	}
 
+	/*
+	 * For randtrimwrite, we decide whether to issue a trim or a write
+	 * based on whether the offsets for the most recent trim and write
+	 * operations match. If they don't match that means we just issued a
+	 * new trim and the next operation should be a write. If they *do*
+	 * match that means we just completed a trim+write pair and the next
+	 * command should be a trim.
+	 *
+	 * This works fine for sequential workloads but for random workloads
+	 * it's possible to complete a trim+write pair and then have the next
+	 * randomly generated offset match the previous offset. If that happens
+	 * we need to alter the offset for the last write operation in order
+	 * to ensure that we issue a write operation the next time through.
+	 */
+	if (td_randtrimwrite(td) && ddir == DDIR_TRIM &&
+	    f->last_start[DDIR_TRIM] == io_u->offset)
+		f->last_start[DDIR_WRITE]--;
+
 	io_u->verify_offset = io_u->offset;
 	return 0;
 }
@@ -530,6 +554,12 @@ static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *i
 
 	assert(ddir_rw(ddir));
 
+	if (td_randtrimwrite(td) && ddir == DDIR_WRITE) {
+		struct fio_file *f = io_u->file;
+
+		return f->last_pos[DDIR_TRIM] - f->last_start[DDIR_TRIM];
+	}
+
 	if (td->o.bs_is_seq_rand)
 		ddir = is_random ? DDIR_WRITE : DDIR_READ;
 
@@ -768,7 +798,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 
 	if (td_trimwrite(td)) {
 		struct fio_file *f = io_u->file;
-		if (f->last_pos[DDIR_WRITE] == f->last_pos[DDIR_TRIM])
+		if (f->last_start[DDIR_WRITE] == f->last_start[DDIR_TRIM])
 			ddir = DDIR_TRIM;
 		else
 			ddir = DDIR_WRITE;
diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
new file mode 100644
index 00000000..0250ee1a
--- /dev/null
+++ b/t/jobs/t0023.fio
@@ -0,0 +1,75 @@
+# randtrimwrite data direction tests
+[global]
+filesize=1M
+ioengine=null
+rw=randtrimwrite
+log_offset=1
+per_job_logs=0
+randrepeat=0
+stonewall
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets touched
+# 			block sizes match
+# Buggy result: 	something else
+[basic]
+write_bw_log
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes 8k for both write and trim
+# Buggy result: 	something else
+[bs]
+write_bw_log
+bs=4k,4k,8k
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bsrange]
+write_bw_log
+bsrange=512-4k
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bssplit]
+write_bw_log
+bsrange=512/25:1k:25:2k:25:4k/25
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets touched
+# 			block sizes match
+# Buggy result: 	something else
+[basic_no_rm]
+write_bw_log
+norandommap=1
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes 8k for both write and trim
+# Buggy result: 	something else
+[bs_no_rm]
+write_bw_log
+bs=4k,4k,8k
+norandommap=1
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bsrange_no_rm]
+write_bw_log
+bsrange=512-4k
+norandommap=1
+
+# Expected result: 	trim issued to random offset followed by write to same offset
+# 			all offsets trimmed
+# 			block sizes match
+# Buggy result: 	something else
+[bssplit_no_rm]
+write_bw_log
+bsrange=512/25:1k:25:2k:25:4k/25
+norandommap=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index e72fa2a0..a2b036d9 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -649,6 +649,61 @@ class FioJobTest_t0022(FioJobTest):
             self.failure_reason += " no duplicate offsets found with norandommap=1".format(len(offsets))
 
 
+class FioJobTest_t0023(FioJobTest):
+    """Test consists of fio test job t0023"""
+
+    def check_seq(self, filename):
+        bw_log_filename = os.path.join(self.test_dir, filename)
+        file_data, success = self.get_file(bw_log_filename)
+        log_lines = file_data.split('\n')
+
+        prev_ddir = 1
+        for line in log_lines:
+            if len(line.strip()) == 0:
+                continue
+            vals = line.split(',')
+            ddir = int(vals[2])
+            bs = int(vals[3])
+            offset = int(vals[4])
+            if prev_ddir == 1:
+                if ddir != 2:
+                    self.passed = False
+                    self.failure_reason += " {0}: write not preceeded by trim: {1}".format(bw_log_filename, line)
+                    break
+            else:
+                if ddir != 1:
+                    self.passed = False
+                    self.failure_reason += " {0}: trim not preceeded by write: {1}".format(bw_log_filename, line)
+                    break
+                else:
+                    if prev_bs != bs:
+                        self.passed = False
+                        self.failure_reason += " {0}: block size does not match: {1}".format(bw_log_filename, line)
+                        break
+                    if prev_offset != offset:
+                        self.passed = False
+                        self.failure_reason += " {0}: offset does not match: {1}".format(bw_log_filename, line)
+                        break
+            prev_ddir = ddir
+            prev_bs = bs
+            prev_offset = offset
+
+
+    def check_result(self):
+        super(FioJobTest_t0023, self).check_result()
+
+        self.check_seq("basic_bw.log")
+        self.check_seq("bs_bw.log")
+        self.check_seq("bsrange_bw.log")
+        self.check_seq("bssplit_bw.log")
+        self.check_seq("basic_no_rm_bw.log")
+        self.check_seq("bs_no_rm_bw.log")
+        self.check_seq("bsrange_no_rm_bw.log")
+        self.check_seq("bssplit_no_rm_bw.log")
+
+        # TODO make sure all offsets were touched
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -1026,6 +1081,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          23,
+        'test_class':       FioJobTest_t0023,
+        'job':              't0023.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
