Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD30EECAAD5
	for <fio@archiver.kernel.org>; Fri,  2 Sep 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiIBMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 2 Sep 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIBMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Sep 2022 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716926376
        for <fio@vger.kernel.org>; Fri,  2 Sep 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QVm5WTplkKVOPuitEBEt9gItudz8hPNpMUUzhXogRk0=; b=l+gZAw2sW4QdN5YDMlQh1mE7vc
        jFaHPRPBDt52g5rKVrxzFZoP1IEuuXFqkpTXUe3dFKDPu9/ntzAIO9+pjJY9NXm5zHiiilDKgnD7I
        GfPb2IfoWqADpCiaeQukfOYyO8MuwZJxsWW4Uvop5L9oaHdBHNgtfVj0/fy+U5K0IPQsRE2WasS8m
        PvgpjgnUsSPTylCWBX6OuHslzc3c6uBtSoI+QvLZ6TCCJFP3IBnjuGw7ECyLG8hJmCaBOftRsgaJu
        YpOkoSaSQ6/zol3VgTp3PcW/K+8E2lKQlF8iU3Yfv6G9KkYQLqxGwIr0orZ1kF8gw890OChplYFjR
        uVyQa6xw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oU5LA-008etN-Vs
        for fio@vger.kernel.org; Fri, 02 Sep 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A64A31BC0110; Fri,  2 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220902120001.A64A31BC0110@kernel.dk>
Date:   Fri,  2 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2be18f6b266f3fcba89719b354672090f49d53d9:

  t/io_uring: take advantage of new io_uring setup flags (2022-08-31 18:44:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e57758c12bdb24885e32ba143a04fcc8f98565ca:

  Merge branch 'fiopr_compressfixes' of https://github.com/PCPartPicker/fio (2022-09-01 12:03:23 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: minor optimizations to IO init fast path
      Merge branch 'fiopr_compressfixes' of https://github.com/PCPartPicker/fio

aggieNick02 (1):
      Fix fio silently dropping log entries when using log_compression

 iolog.c              |   6 +--
 t/io_uring.c         |  10 +++--
 t/log_compression.py | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py   |   8 ++++
 4 files changed, 139 insertions(+), 6 deletions(-)
 create mode 100755 t/log_compression.py

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 37e799a1..41d3e473 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1574,14 +1574,14 @@ void iolog_compress_exit(struct thread_data *td)
  * Queue work item to compress the existing log entries. We reset the
  * current log to a small size, and reference the existing log in the
  * data that we queue for compression. Once compression has been done,
- * this old log is freed. If called with finish == true, will not return
- * until the log compression has completed, and will flush all previous
- * logs too
+ * this old log is freed. Will not return until the log compression
+ * has completed, and will flush all previous logs too
  */
 static int iolog_flush(struct io_log *log)
 {
 	struct iolog_flush_data *data;
 
+	workqueue_flush(&log->td->log_compress_wq);
 	data = malloc(sizeof(*data));
 	if (!data)
 		return 1;
diff --git a/t/io_uring.c b/t/io_uring.c
index 5b46015a..9d580b5a 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -658,11 +658,12 @@ static int prep_more_ios_uring(struct submitter *s, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
 	unsigned index, tail, next_tail, prepped = 0;
+	unsigned int head = atomic_load_acquire(ring->head);
 
 	next_tail = tail = *ring->tail;
 	do {
 		next_tail++;
-		if (next_tail == atomic_load_acquire(ring->head))
+		if (next_tail == head)
 			break;
 
 		index = tail & sq_ring_mask;
@@ -670,7 +671,6 @@ static int prep_more_ios_uring(struct submitter *s, int max_ios)
 			init_io_pt(s, index);
 		else
 			init_io(s, index);
-		ring->array[index] = index;
 		prepped++;
 		tail = next_tail;
 	} while (prepped < max_ios);
@@ -908,7 +908,7 @@ static int setup_ring(struct submitter *s)
 	struct io_sq_ring *sring = &s->sq_ring;
 	struct io_cq_ring *cring = &s->cq_ring;
 	struct io_uring_params p;
-	int ret, fd;
+	int ret, fd, i;
 	void *ptr;
 	size_t len;
 
@@ -1003,6 +1003,10 @@ static int setup_ring(struct submitter *s)
 	cring->ring_entries = ptr + p.cq_off.ring_entries;
 	cring->cqes = ptr + p.cq_off.cqes;
 	cq_ring_mask = *cring->ring_mask;
+
+	for (i = 0; i < p.sq_entries; i++)
+		sring->array[i] = i;
+
 	return 0;
 }
 
diff --git a/t/log_compression.py b/t/log_compression.py
new file mode 100755
index 00000000..94c92db7
--- /dev/null
+++ b/t/log_compression.py
@@ -0,0 +1,121 @@
+#!/usr/bin/env python3
+#
+# log_compression.py
+#
+# Test log_compression and log_store_compressed. Uses null ioengine.
+# Previous bugs have caused output in per I/O log files to be missing
+# and/or out of order
+#
+# Expected result: 8000 log entries, offset starting at 0 and increasing by bs
+# Buggy result: Log entries out of order (usually without log_store_compressed)
+# and/or missing log entries (usually with log_store_compressed)
+#
+# USAGE
+# python log_compression.py [-f fio-executable]
+#
+# EXAMPLES
+# python t/log_compression.py
+# python t/log_compression.py -f ./fio
+#
+# REQUIREMENTS
+# Python 3.5+
+#
+# ===TEST MATRIX===
+#
+# With log_compression=10K
+# With log_store_compressed=1 and log_compression=10K
+
+import os
+import sys
+import platform
+import argparse
+import subprocess
+
+
+def parse_args():
+    """Parse command-line arguments."""
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio',
+                        help='path to fio executable (e.g., ./fio)')
+    return parser.parse_args()
+
+
+def run_fio(fio,log_store_compressed):
+    fio_args = [
+        '--name=job',
+        '--ioengine=null',
+        '--filesize=1000M',
+        '--bs=128K',
+        '--rw=write',
+        '--iodepth=1',
+        '--write_bw_log=test',
+        '--per_job_logs=0',
+        '--log_offset=1',
+        '--log_compression=10K',
+        ]
+    if log_store_compressed:
+        fio_args.append('--log_store_compressed=1')
+
+    subprocess.check_output([fio] + fio_args)
+
+    if log_store_compressed:
+        fio_inflate_args = [
+            '--inflate-log=test_bw.log.fz'
+            ]
+        with open('test_bw.from_fz.log','wt') as f:
+            subprocess.check_call([fio]+fio_inflate_args,stdout=f)
+
+def check_log_file(log_store_compressed):
+    filename = 'test_bw.from_fz.log' if log_store_compressed else 'test_bw.log'
+    with open(filename,'rt') as f:
+        file_data = f.read()
+    log_lines = [x for x in file_data.split('\n') if len(x.strip())!=0]
+    log_ios = len(log_lines)
+
+    filesize = 1000*1024*1024
+    bs = 128*1024
+    ios = filesize//bs
+    if log_ios!=ios:
+        print('wrong number of ios ({}) in log; should be {}'.format(log_ios,ios))
+        return False
+
+    expected_offset = 0
+    for line_number,line in enumerate(log_lines):
+        log_offset = int(line.split(',')[4])
+        if log_offset != expected_offset:
+            print('wrong offset ({}) for io number {} in log; should be {}'.format(
+                log_offset, line_number, expected_offset))
+            return False
+        expected_offset += bs
+    return True
+
+def main():
+    """Entry point for this script."""
+    args = parse_args()
+    if args.fio:
+        fio_path = args.fio
+    else:
+        fio_path = os.path.join(os.path.dirname(__file__), '../fio')
+        if not os.path.exists(fio_path):
+            fio_path = 'fio'
+    print("fio path is", fio_path)
+
+    passed_count = 0
+    failed_count = 0
+    for log_store_compressed in [False, True]:
+        run_fio(fio_path, log_store_compressed)
+        passed = check_log_file(log_store_compressed)
+        print('Test with log_store_compressed={} {}'.format(log_store_compressed,
+            'PASSED' if passed else 'FAILED'))
+        if passed:
+            passed_count+=1
+        else:
+            failed_count+=1
+
+    print('{} tests passed, {} failed'.format(passed_count, failed_count))
+
+    sys.exit(failed_count)
+
+if __name__ == '__main__':
+    main()
+
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 47823761..e72fa2a0 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1124,6 +1124,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1012,
+        'test_class':       FioExeTest,
+        'exe':              't/log_compression.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
