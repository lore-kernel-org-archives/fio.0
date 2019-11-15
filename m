Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKONAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Nov 2019 08:00:16 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVbCx-0002Yj-DT
        for fio@vger.kernel.org; Fri, 15 Nov 2019 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191115130002.2CB181BC003D@kernel.dk>
Date: Fri, 15 Nov 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cc16261082a4d0f027cef9d019ad023129bf6012:

  Merge branch 'testing' of https://github.com/vincentkfu/fio (2019-11-06 17:04:17 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b048455fef67dad4ef96ce0393937322e3165b58:

  t/run-fio-tests: improve error handling (2019-11-14 14:07:25 -0700)

----------------------------------------------------------------
Vincent Fu (3):
      filesetup: improve LFSR init failure error message
      io_u: move to next zone even if zoneskip is unset
      t/run-fio-tests: improve error handling

 filesetup.c        |  3 +++
 io_u.c             |  3 +--
 t/run-fio-tests.py | 10 ++++++----
 t/strided.py       |  3 +--
 4 files changed, 11 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 1d3094c1..7d54c9f1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1354,6 +1354,9 @@ bool init_random_map(struct thread_data *td)
 			if (!lfsr_init(&f->lfsr, blocks, seed, 0)) {
 				fio_file_set_lfsr(f);
 				continue;
+			} else {
+				log_err("fio: failed initializing LFSR\n");
+				return false;
 			}
 		} else if (!td->o.norandommap) {
 			f->io_axmap = axmap_new(blocks);
diff --git a/io_u.c b/io_u.c
index 5cbbe85a..b5c31335 100644
--- a/io_u.c
+++ b/io_u.c
@@ -850,8 +850,7 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 	/*
 	 * See if it's time to switch to a new zone
 	 */
-	if (td->zone_bytes >= td->o.zone_size &&
-			fio_option_is_set(&td->o, zone_skip)) {
+	if (td->zone_bytes >= td->o.zone_size) {
 		td->zone_bytes = 0;
 		f->file_offset += td->o.zone_range + td->o.zone_skip;
 
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1b8ca0a2..cf8de093 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -14,7 +14,7 @@
 #
 #
 # EXAMPLE
-# # git clone [fio-repository]
+# # git clone git://git.kernel.dk/fio.git
 # # cd fio
 # # make -j
 # # python3 t/run-fio-tests.py
@@ -123,6 +123,7 @@ class FioExeTest(FioTest):
         stderr_file = open(self.stderr_file, "w+")
         exticode_file = open(self.exticode_file, "w+")
         try:
+            proc = None
             # Avoid using subprocess.run() here because when a timeout occurs,
             # fio will be stopped with SIGKILL. This does not give fio a
             # chance to clean up and means that child processes may continue
@@ -142,9 +143,10 @@ class FioExeTest(FioTest):
             assert proc.poll()
             self.output['failure'] = 'timeout'
         except Exception:
-            if not proc.poll():
-                proc.terminate()
-                proc.communicate()
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
             self.output['failure'] = 'exception'
             self.output['exc_info'] = sys.exc_info()
         finally:
diff --git a/t/strided.py b/t/strided.py
index c159dc0b..aac15d10 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -22,7 +22,7 @@
 #
 # ===TEST MATRIX===
 #
-# --zonemode=strided, zoneskip >= 0
+# --zonemode=strided, zoneskip unset
 #   w/ randommap and LFSR
 #       zonesize=zonerange  all blocks in zonerange touched
 #       zonesize>zonerange  all blocks touched and roll-over back into zone
@@ -57,7 +57,6 @@ def run_fio(fio, test, index):
                 "--log_offset=1",
                 "--randrepeat=0",
                 "--rw=randread",
-                "--zoneskip=0",
                 "--write_iops_log={0}{1:03d}".format(filename, index),
                 "--output={0}{1:03d}.out".format(filename, index),
                 "--zonerange={zonerange}".format(**test),

