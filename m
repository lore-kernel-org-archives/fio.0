Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfJPMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Oct 2019 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKhyF-0002Lt-La
        for fio@vger.kernel.org; Wed, 16 Oct 2019 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191016120001.9DC602C03CF@kernel.dk>
Date: Wed, 16 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5cd4efe903798f2185a347911a9440324558c89f:

  parse: improve detection of bad input string (2019-10-14 08:03:53 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2e97fa1b0d76edc6517fa4a8a4f6e0792b458e8c:

  Merge branch 'fix-fsync-on-close' of https://github.com/sitsofe/fio (2019-10-15 09:27:06 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-fsync-on-close' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      backend: fix final fsync behaviour

Vincent Fu (3):
      io_u: skip to the next zone when zoneskip is set to zero
      filesetup: use zonerange for map and LFSR with zonemode=strided
      testing: add test script for zonemode=strided

 backend.c    |  11 +-
 filesetup.c  |   3 +
 io_u.c       |   3 +-
 ioengines.c  |   6 +-
 t/strided.py | 350 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 366 insertions(+), 7 deletions(-)
 create mode 100755 t/strided.py

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 2f463293..fe868271 100644
--- a/backend.c
+++ b/backend.c
@@ -281,6 +281,7 @@ static bool fio_io_sync(struct thread_data *td, struct fio_file *f)
 
 	io_u->ddir = DDIR_SYNC;
 	io_u->file = f;
+	io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
 
 	if (td_io_prep(td, io_u)) {
 		put_io_u(td, io_u);
@@ -314,7 +315,7 @@ requeue:
 
 static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
 {
-	int ret;
+	int ret, ret2;
 
 	if (fio_file_open(f))
 		return fio_io_sync(td, f);
@@ -323,8 +324,10 @@ static int fio_file_fsync(struct thread_data *td, struct fio_file *f)
 		return 1;
 
 	ret = fio_io_sync(td, f);
-	td_io_close_file(td, f);
-	return ret;
+	ret2 = 0;
+	if (fio_file_open(f))
+		ret2 = td_io_close_file(td, f);
+	return (ret || ret2);
 }
 
 static inline void __update_ts_cache(struct thread_data *td)
@@ -1124,7 +1127,7 @@ reap:
 				td->error = 0;
 		}
 
-		if (should_fsync(td) && td->o.end_fsync) {
+		if (should_fsync(td) && (td->o.end_fsync || td->o.fsync_on_close)) {
 			td_set_runstate(td, TD_FSYNCING);
 
 			for_each_file(td, f, i) {
diff --git a/filesetup.c b/filesetup.c
index a439b6d6..1d3094c1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1338,6 +1338,9 @@ bool init_random_map(struct thread_data *td)
 	for_each_file(td, f, i) {
 		uint64_t fsize = min(f->real_file_size, f->io_size);
 
+		if (td->o.zone_mode == ZONE_MODE_STRIDED)
+			fsize = td->o.zone_range;
+
 		blocks = fsize / (unsigned long long) td->o.rw_min_bs;
 
 		if (check_rand_gen_limits(td, f, blocks))
diff --git a/io_u.c b/io_u.c
index 94899552..5cbbe85a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -850,7 +850,8 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * See if it's time to switch to a new zone
 	 */
-	if (td->zone_bytes >= td->o.zone_size && td->o.zone_skip) {
+	if (td->zone_bytes >= td->o.zone_size &&
+			fio_option_is_set(&td->o, zone_skip)) {
 		td->zone_bytes = 0;
 		f->file_offset += td->o.zone_range + td->o.zone_skip;
 
diff --git a/ioengines.c b/ioengines.c
index 40fa75c3..9e3fcc9f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -376,14 +376,16 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
-		if (ddir_rw(io_u->ddir) || ddir_sync(io_u->ddir)) {
+		if (ddir_rw(io_u->ddir) ||
+		    (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING)) {
 			io_u_mark_depth(td, 1);
 			td->ts.total_io_u[io_u->ddir]++;
 		}
 	} else if (ret == FIO_Q_QUEUED) {
 		td->io_u_queued++;
 
-		if (ddir_rw(io_u->ddir) || ddir_sync(io_u->ddir))
+		if (ddir_rw(io_u->ddir) ||
+		    (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING))
 			td->ts.total_io_u[io_u->ddir]++;
 
 		if (td->io_u_queued >= td->o.iodepth_batch)
diff --git a/t/strided.py b/t/strided.py
new file mode 100755
index 00000000..47ce5523
--- /dev/null
+++ b/t/strided.py
@@ -0,0 +1,350 @@
+#!/usr/bin/python
+# Note: this script is python2 and python3 compatible.
+#
+# strided.py
+#
+# Test zonemode=strided. This uses the null ioengine when no file is
+# specified. If a file is specified, use it for randdom read testing.
+# Some of the zoneranges in the tests are 16MiB. So when using a file
+# a minimum size of 32MiB is recommended.
+#
+# USAGE
+# python strided.py fio-executable [-f file/device]
+#
+# EXAMPLES
+# python t/strided.py ./fio
+# python t/strided.py ./fio -f /dev/sda
+# dd if=/dev/zero of=temp bs=1M count=32
+# python t/strided.py ./fio -f temp
+#
+# REQUIREMENTS
+# Python 2.6+
+#
+# ===TEST MATRIX===
+#
+# --zonemode=strided, zoneskip >= 0
+#   w/ randommap and LFSR
+#       zonesize=zonerange  all blocks in zonerange touched
+#       zonesize>zonerange  all blocks touched and roll-over back into zone
+#       zonesize<zonerange  all blocks inside zone
+#
+#   w/o randommap       all blocks inside zone
+#
+
+from __future__ import absolute_import
+from __future__ import print_function
+import os
+import sys
+import argparse
+import subprocess
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('fio',
+                        help='path to fio executable (e.g., ./fio)')
+    parser.add_argument('-f', '--filename', help="file/device to test")
+    args = parser.parse_args()
+
+    return args
+
+
+def run_fio(fio, test, index):
+    filename = "strided"
+    fio_args = [
+                "--name=strided",
+                "--zonemode=strided",
+                "--log_offset=1",
+                "--randrepeat=0",
+                "--rw=randread",
+                "--zoneskip=0",
+                "--write_iops_log={0}{1:03d}".format(filename, index),
+                "--output={0}{1:03d}.out".format(filename, index),
+                "--zonerange={zonerange}".format(**test),
+                "--zonesize={zonesize}".format(**test),
+                "--bs={bs}".format(**test),
+               ]
+    if 'norandommap' in test:
+        fio_args.append('--norandommap')
+    if 'random_generator' in test:
+        fio_args.append('--random_generator={random_generator}'.format(**test))
+    if 'offset' in test:
+        fio_args.append('--offset={offset}'.format(**test))
+    if 'filename' in test:
+        fio_args.append('--filename={filename}'.format(**test))
+        fio_args.append('--filesize={filesize})'.format(**test))
+    else:
+        fio_args.append('--ioengine=null')
+        fio_args.append('--size={size}'.format(**test))
+        fio_args.append('--io_size={io_size}'.format(**test))
+        fio_args.append('--filesize={size})'.format(**test))
+
+    output = subprocess.check_output([fio] + fio_args, universal_newlines=True)
+
+    f = open("{0}{1:03d}_iops.1.log".format(filename, index), "r")
+    log = f.read()
+    f.close()
+
+    return log
+
+
+def check_output(iops_log, test):
+    zonestart = 0 if 'offset' not in test else test['offset']
+    iospersize = test['zonesize'] / test['bs']
+    iosperrange = test['zonerange'] / test['bs']
+    iosperzone = 0
+    lines = iops_log.split('\n')
+    zoneset = set()
+
+    for line in lines:
+        if len(line) == 0:
+            continue
+
+        if iosperzone == iospersize:
+            # time to move to a new zone
+            iosperzone = 0
+            zoneset = set()
+            zonestart += test['zonerange']
+            if zonestart >= test['filesize']:
+                zonestart = 0 if 'offset' not in test else test['offset']
+
+        iosperzone = iosperzone + 1
+        tokens = line.split(',')
+        offset = int(tokens[4])
+        if offset < zonestart or offset >= zonestart + test['zonerange']:
+            print("Offset {0} outside of zone starting at {1}".format(
+                    offset, zonestart))
+            return False
+
+        # skip next section if norandommap is enabled with no
+        # random_generator or with a random_generator != lfsr
+        if 'norandommap' in test:
+            if 'random_generator' in test:
+                if test['random_generator'] != 'lfsr':
+                    continue
+            else:
+                continue
+
+        # we either have a random map enabled or we
+        # are using an LFSR
+        # so all blocks should be unique and we should have
+        # covered the entire zone when iosperzone % iosperrange == 0
+        block = (offset - zonestart) / test['bs']
+        if block in zoneset:
+            print("Offset {0} in zone already touched".format(offset))
+            return False
+
+        zoneset.add(block)
+        if iosperzone % iosperrange == 0:
+            if len(zoneset) != iosperrange:
+                print("Expected {0} blocks in zone but only saw {1}".format(
+                        iosperrange, len(zoneset)))
+                return False
+            zoneset = set()
+
+    return True
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    tests = [   # randommap enabled
+                {
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "offset": 8*4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 16*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "zonerange": 4096,
+                    "zonesize": 4*4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 32*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "zonerange": 8192,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 8*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                # lfsr
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "offset": 8*4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 16*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 4096,
+                    "zonesize": 4*4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 32*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 8192,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "random_generator": "lfsr",
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 8*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                # norandommap
+                {
+                    "norandommap": 1,
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "offset": 8*4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 4096,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 16*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 4096,
+                    "zonesize": 8192,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 32*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 8192,
+                    "zonesize": 4096,
+                    "bs": 4096,
+                    "size": 16*4096,
+                    "io_size": 16*4096,
+                },
+                {
+                    "norandommap": 1,
+                    "zonerange": 16*1024*1024,
+                    "zonesize": 8*1024*1024,
+                    "bs": 4096,
+                    "size": 256*1024*1024,
+                    "io_size": 256*1024*204,
+                },
+
+            ]
+
+    index = 1
+    passed = 0
+    failed = 0
+
+    if args.filename:
+        statinfo = os.stat(args.filename)
+        filesize = statinfo.st_size
+        if filesize == 0:
+            f = os.open(args.filename, os.O_RDONLY)
+            filesize = os.lseek(f, 0, os.SEEK_END)
+            os.close(f)
+
+    for test in tests:
+        if args.filename:
+            test['filename'] = args.filename
+            test['filesize'] = filesize
+        else:
+            test['filesize'] = test['size']
+        iops_log = run_fio(args.fio, test, index)
+        status = check_output(iops_log, test)
+        print("Test {0} {1}".format(index, ("PASSED" if status else "FAILED")))
+        if status:
+            passed = passed + 1
+        else:
+            failed = failed + 1
+        index = index + 1
+
+    print("{0} tests passed, {1} failed".format(passed, failed))
+
+    sys.exit(failed)

