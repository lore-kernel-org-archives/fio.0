Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56476 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbeIMRJP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Sep 2018 13:09:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g0QI0-0002Vj-Tv
        for fio@vger.kernel.org; Thu, 13 Sep 2018 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180913120002.23DD22C0311@kernel.dk>
Date: Thu, 13 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e8ed50bc3ce67f449714c55c3fbf2f8eb50730c2:

  windows: fix the most egregious posix.c style errors (2018-09-11 16:54:39 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e26029be10ee2c570cba2c4cc2b1987568306cd2:

  Merge branch 'histo-log-dup-timestamp' of https://github.com/parallel-fs-utils/fio (2018-09-12 14:33:04 -0600)

----------------------------------------------------------------
Ben England (1):
      filter out records with duplicate timestamps

Jens Axboe (2):
      windows: make win_to_posix_error() more resilient
      Merge branch 'histo-log-dup-timestamp' of https://github.com/parallel-fs-utils/fio

 os/windows/posix.c                  |  2 ++
 tools/hist/fio-histo-log-pctiles.py | 11 +++++++++++
 2 files changed, 13 insertions(+)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index 5b72bea..fd1d558 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -35,6 +35,8 @@ HRESULT WINAPI StringCchPrintfA(char *pszDest, size_t cchDest, const char *pszFo
 int win_to_posix_error(DWORD winerr)
 {
 	switch (winerr) {
+	case ERROR_SUCCESS:
+		return 0;
 	case ERROR_FILE_NOT_FOUND:
 		return ENOENT;
 	case ERROR_PATH_NOT_FOUND:
diff --git a/tools/hist/fio-histo-log-pctiles.py b/tools/hist/fio-histo-log-pctiles.py
index bb016ea..1e7b631 100755
--- a/tools/hist/fio-histo-log-pctiles.py
+++ b/tools/hist/fio-histo-log-pctiles.py
@@ -64,6 +64,8 @@ def parse_hist_file(logfn, buckets_per_interval):
     with open(logfn, 'r') as f:
         records = [ l.strip() for l in f.readlines() ]
     intervals = []
+    last_time_ms = -1
+    last_direction = -1
     for k, r in enumerate(records):
         if r == '':
             continue
@@ -96,6 +98,15 @@ def parse_hist_file(logfn, buckets_per_interval):
         if len(buckets) != buckets_per_interval:
             raise FioHistoLogExc('%d buckets per interval but %d expected in %s' % 
                     (len(buckets), buckets_per_interval, exception_suffix(k+1, logfn)))
+
+        # hack to filter out records with the same timestamp
+        # we should not have to do this if fio logs histogram records correctly
+
+        if time_ms == last_time_ms and direction == last_direction:
+            continue
+        last_time_ms = time_ms
+        last_direction = direction
+
         intervals.append((time_ms, direction, bsz, buckets))
     if len(intervals) == 0:
         raise FioHistoLogExc('no records in %s' % logfn)

