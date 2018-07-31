Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55138 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731639AbeGaNkM (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 Jul 2018 09:40:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fkTK0-0005l7-3P
        for fio@vger.kernel.org; Tue, 31 Jul 2018 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180731120002.6292C2C0311@kernel.dk>
Date: Tue, 31 Jul 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a871240086ca6bdc52f79d7459ed283c5a359299:

  Merge branch 'sgunmap2' of https://github.com/vincentkfu/fio (2018-07-26 11:47:28 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 284226f333be2fb7d859287fd3ab3c51b3636a92:

  Merge branch 'fio-histo-fix' of https://github.com/parallel-fs-utils/fio (2018-07-30 08:24:20 -0600)

----------------------------------------------------------------
Ben England (1):
      clean up argparse usage

Jens Axboe (1):
      Merge branch 'fio-histo-fix' of https://github.com/parallel-fs-utils/fio

 tools/hist/fio-histo-log-pctiles.py | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index bad6887..c398113 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -311,7 +311,7 @@ def compute_percentiles_from_logs():
         default="6", type=int, 
         help="fio histogram buckets-per-group bits (default=6 means 64 buckets/group)")
     parser.add_argument("--percentiles", dest="pctiles_wanted", 
-        default="0 50 95 99 100", type=float, nargs='+',
+        default=[ 0., 50., 95., 99., 100.], type=float, nargs='+',
         help="fio histogram buckets-per-group bits (default=6 means 64 buckets/group)")
     parser.add_argument("--time-quantum", dest="time_quantum", 
         default="1", type=int,
@@ -319,20 +319,17 @@ def compute_percentiles_from_logs():
     parser.add_argument("--output-unit", dest="output_unit", 
         default="usec", type=str,
         help="Latency percentile output unit: msec|usec|nsec (default usec)")
-    parser.add_argument("file_list", nargs='+')
+    parser.add_argument("file_list", nargs='+', 
+        help='list of files, preceded by " -- " if necessary')
     args = parser.parse_args()
-    print(args)
 
-    if not args.bucket_groups:
-        # default changes based on fio version
-        if fio_version == 2:
-            args.bucket_groups = 19
-        else:
-            # default in fio 3.x
-            args.bucket_groups = 29
+    # default changes based on fio version
+    if args.fio_version == 2:
+        args.bucket_groups = 19
 
     # print parameters
 
+    print('fio version = %d' % args.fio_version)
     print('bucket groups = %d' % args.bucket_groups)
     print('bucket bits = %d' % args.bucket_bits)
     print('time quantum = %d sec' % args.time_quantum)
