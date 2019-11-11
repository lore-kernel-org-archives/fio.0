Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/3] io_u: move to next zone even if zoneskip is unset
Date: Mon, 11 Nov 2019 11:30:54 -0500
Message-Id: <20191111163055.7358-3-vincentfu@gmail.com>
In-Reply-To: <20191111163055.7358-1-vincentfu@gmail.com>
References: <20191111163055.7358-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

This patch makes fio's behavior under zonemode=strided conform to the
documentation:

    I/O happens in a single zone until zonesize bytes have been
    transferred. After that number of bytes has been transferred
    processing of the next zone starts.

With zonemode=strided, before commit 35f561eb, fio would only move to
the next zone when zoneskip > 0 and zonesize bytes were written. There
would always be zoneskip bytes between the end of one zone and the
beginning of the next zone. If zoneskip was not set or set to 0, all IO
would happen in the first zone.

Commit 35f561eb changed this so that fio would move to the next zone
upon writing zonesize bytes if zoneskip was explicitly set to a value >=
0. This option made it possible for zones to be contiguous. The
documentation was not updated to reflect the new behavior.

I originally intended to submit a patch to update fio's documentation,
but upon further reflection it seems better to change fio's behavior and
have a clean user interface than to change the documentation to note
that zoneskip must be explciitly set in order for fio to move to the
next zone.

This patch also updates t/strided.py to reflect the new behavior.
---
 io_u.c       | 3 +--
 t/strided.py | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

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
-- 
2.17.1


