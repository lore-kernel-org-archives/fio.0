Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E09C433EF
	for <fio@archiver.kernel.org>; Fri, 26 Nov 2021 13:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348501AbhKZNqc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhKZNob (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Nov 2021 08:44:31 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3478C0619E7
        for <fio@vger.kernel.org>; Fri, 26 Nov 2021 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=I7wzjcLx+coegQoCW4SZOrHNkgPkGssdpB3E2j9CEB8=; b=Tu7KTOfeg8E2TJeGUgjRcJ7dPF
        +8p5USATlAQIsqVNnG55z4nMXpRW44wjgD1KAQ7qisY5Fm64NrKAxm0rS/CgGIpGm2Cs9hZYuJfD/
        mF92ELztvYlYSOmlgoOHXn4NVTz/HLccKEKzJKGGtjGmNex4B/QgP507ylIshUzYIPajm585v+MR4
        s7H+1SEHBFdZNoFy7xJere2Q5Su32N4sRu0dj0VFFu3VYjZgbxaGCKP+viyQZ7r5K7GWAJ335XWg+
        Dr7r/In9uAJ/GcI8opIYdelDYkMZq3vbgl8EmWYBux8vbQAv0uJw/HqOdL4aC3zUrgbu2bujZGJS6
        egF2Clwg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqaph-000iMl-A8
        for fio@vger.kernel.org; Fri, 26 Nov 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 7272E1BC016C; Fri, 26 Nov 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211126130002.7272E1BC016C@kernel.dk>
Date:   Fri, 26 Nov 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2b00ac1c82d54795911343c9b3b3f4ef64c92d92:

  Merge branch 'fix-parse-sync-file-range' of https://github.com/oleglatin/fio (2021-11-24 10:27:20 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ed7f3a07363d62c6d6147b0c568f87f079d241a8:

  stat: make add lat percentile functions inline (2021-11-25 09:03:10 -0700)

----------------------------------------------------------------
Niklas Cassel (6):
      docs: document quirky implementation of per priority stats reporting
      stat: add comments describing the quirky behavior of clat prio samples
      stat: rename add_lat_percentile_sample()
      stat: rename add_lat_percentile_sample_noprio()
      stat: simplify add_lat_percentile_prio_sample()
      stat: make add lat percentile functions inline

 HOWTO  |  6 +++++-
 fio.1  |  5 ++++-
 stat.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 48 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a3b3acfe..8c9e4135 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2169,7 +2169,11 @@ with the caveat that when used on the command line, they must come after the
     Default: 0. A single value applies to reads and writes. Comma-separated
     values may be specified for reads and writes. For this option to be
     effective, NCQ priority must be supported and enabled, and `direct=1'
-    option must be used. fio must also be run as the root user.
+    option must be used. fio must also be run as the root user. Unlike
+    slat/clat/lat stats, which can be tracked and reported independently, per
+    priority stats only track and report a single type of latency. By default,
+    completion latency (clat) will be reported, if :option:`lat_percentiles` is
+    set, total latency (lat) will be reported.
 
 .. option:: cmdprio_class=int[,int] : [io_uring] [libaio]
 
diff --git a/fio.1 b/fio.1
index a6469541..a3ebb67d 100644
--- a/fio.1
+++ b/fio.1
@@ -1967,7 +1967,10 @@ Set the percentage of I/O that will be issued with the highest priority.
 Default: 0. A single value applies to reads and writes. Comma-separated
 values may be specified for reads and writes. For this option to be effective,
 NCQ priority must be supported and enabled, and `direct=1' option must be
-used. fio must also be run as the root user.
+used. fio must also be run as the root user. Unlike slat/clat/lat stats, which
+can be tracked and reported independently, per priority stats only track and
+report a single type of latency. By default, completion latency (clat) will be
+reported, if \fBlat_percentiles\fR is set, total latency (lat) will be reported.
 .TP
 .BI (io_uring,libaio)cmdprio_class \fR=\fPint[,int]
 Set the I/O priority class to use for I/Os that must be issued with a
diff --git a/stat.c b/stat.c
index e0dc99b6..7e84058d 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,8 +3052,10 @@ void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
 
-static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, enum fio_lat lat)
+static inline void add_lat_percentile_sample(struct thread_stat *ts,
+					     unsigned long long nsec,
+					     enum fio_ddir ddir,
+					     enum fio_lat lat)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3061,14 +3063,13 @@ static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
 
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir,
-				bool high_prio, enum fio_lat lat)
+static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
+						  unsigned long long nsec,
+						  enum fio_ddir ddir,
+						  bool high_prio)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 
-	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
-
 	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
 	else
@@ -3089,6 +3090,15 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
+	/*
+	 * When lat_percentiles=1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, add a prio stat sample only when
+	 * lat_percentiles=0. add_lat_sample() will add the prio stat sample
+	 * when lat_percentiles=1.
+	 */
 	if (!ts->lat_percentiles) {
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
@@ -3101,10 +3111,15 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			       offset, ioprio);
 
 	if (ts->clat_percentiles) {
-		if (ts->lat_percentiles)
-			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
-		else
-			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
+		/*
+		 * Because of the above definition, add a prio lat percentile
+		 * sample only when lat_percentiles=0. add_lat_sample() will add
+		 * the prio lat percentile sample when lat_percentiles=1.
+		 */
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
+		if (!ts->lat_percentiles)
+			add_lat_percentile_prio_sample(ts, nsec, ddir,
+						       high_prio);
 	}
 
 	if (iolog && iolog->hist_msec) {
@@ -3169,7 +3184,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 			       offset, ioprio);
 
 	if (ts->slat_percentiles)
-		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
 
 	if (needs_lock)
 		__td_io_u_unlock(td);
@@ -3194,8 +3209,19 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset, ioprio);
 
+	/*
+	 * When lat_percentiles=1 (default 0), the reported high/low priority
+	 * percentiles and stats are used for describing total latency values,
+	 * even though the variable names themselves start with clat_.
+	 *
+	 * Because of the above definition, add a prio stat and prio lat
+	 * percentile sample only when lat_percentiles=1. add_clat_sample() will
+	 * add the prio stat and prio lat percentile sample when
+	 * lat_percentiles=0.
+	 */
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
