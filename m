Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbbIRMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 Sep 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZcuKh-0006pm-DH
	for fio@vger.kernel.org; Fri, 18 Sep 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150918120002.48C462C225F@kernel.dk>
Date: Fri, 18 Sep 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5193b4e5000e7a11bd86ad2661f750e4e2a11fe0:

  Merge branch 'patch-1' of git://github.com/Tfindelkind/fio (2015-09-16 15:43:28 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 01cbd4d913d4eed56dc51256cddfe327b9c28d4c:

  Update fio2gnuplot (2015-09-17 19:42:34 +0200)

----------------------------------------------------------------
Thomas Findelkind (1):
      Update fio2gnuplot

 tools/plot/fio2gnuplot | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 1aef047..1009ae0 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -458,7 +458,15 @@ def main(argv):
     fio_data_file=find_file('.',pattern)
     if len(fio_data_file) == 0:
 	    print "No log file found with pattern %s!" % pattern
-	    sys.exit(1)
+	    # Try numjob log file format if per_numjob_logs=1
+            if (pattern == '*_bw.log'):
+                fio_data_file=find_file('.','*_bw.*.log')
+            if (pattern == '*_iops.log'):
+                fio_data_file=find_file('.','*_iops.*.log')
+            if len(fio_data_file) == 0:
+                sys.exit(1)
+            else:
+                print "Using log file per job format instead"
     else:
 	    print "%d files Selected with pattern '%s'" % (len(fio_data_file), pattern)
 
