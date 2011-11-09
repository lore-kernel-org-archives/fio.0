Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49286 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1KIBLD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Nov 2011 20:11:03 -0500
Received: by gyc15 with SMTP id 15so1202298gyc.19
        for <fio@vger.kernel.org>; Tue, 08 Nov 2011 17:11:02 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Tue, 8 Nov 2011 17:10:41 -0800
Message-ID: <CAAUT-yO+0SPX9Hrf_ck20S_A-amYcW1ev_me+2gtHpayfg6SNA@mail.gmail.com>
Subject: [PATCH] Improve accuracy of rate= option
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I noticed that the rate= option is not terribly precise in some cases.
 It gets worse the higher the selected rate.  For example:
$ fio -name=load -size=100g -ioengine=null -runtime=10 -rate=30m
One would expect that to read 300MB (307200KB) at close to 30MB/s
(30720KB/s).  However it writes 315024KB at 31499KB/s.  Further
experimentation shows that even higher rates can show bigger
discrepancies.  At the extreme end...
$ fio -name=load -size=100g -ioengine=null -runtime=10 -rate=500m
One would expect this to write 5000MB at a rate of 500MB/s
(512000KB/s).  However it writes close to double that (9536.8MB) at a
rate of over 953MB/s.  At a rate of 1GB/s and higher, the rate
limiting is effectively ignored.

This patch improves the accuracy of the rate= option across the whole
range of rates, at the cost of being very slightly more
computationally expensive.


diff --git a/fio.h b/fio.h
index be684ca..a5405e3 100644
--- a/fio.h
+++ b/fio.h
@@ -357,7 +357,7 @@ struct thread_data {
 	/*
 	 * Rate state
 	 */
-	unsigned long rate_nsec_cycle[2];
+	unsigned long long rate_bps[2];
 	long rate_pending_usleep[2];
 	unsigned long rate_bytes[2];
 	unsigned long rate_blocks[2];
diff --git a/init.c b/init.c
index 9fafadf..01e4371 100644
--- a/init.c
+++ b/init.c
@@ -327,21 +327,19 @@ static void put_job(struct thread_data *td)
 static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 {
 	unsigned int bs = td->o.min_bs[ddir];
-	unsigned long long bytes_per_sec;

 	assert(ddir_rw(ddir));

 	if (td->o.rate[ddir])
-		bytes_per_sec = td->o.rate[ddir];
+		td->rate_bps[ddir] = td->o.rate[ddir];
 	else
-		bytes_per_sec = td->o.rate_iops[ddir] * bs;
+		td->rate_bps[ddir] = td->o.rate_iops[ddir] * bs;

-	if (!bytes_per_sec) {
+	if (!td->rate_bps[ddir]) {
 		log_err("rate lower than supported\n");
 		return -1;
 	}

-	td->rate_nsec_cycle[ddir] = 1000000000ULL / bytes_per_sec;
 	td->rate_pending_usleep[ddir] = 0;
 	return 0;
 }
diff --git a/io_u.c b/io_u.c
index fc3ee49..0ff66f9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1296,6 +1296,16 @@ static void account_io_completion(struct
thread_data *td, struct io_u *io_u,
 	add_iops_sample(td, idx, &icd->time);
 }

+static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
+{
+	unsigned long long secs, remainder, bps, bytes;
+	bytes = td->this_io_bytes[ddir];
+	bps = td->rate_bps[ddir];
+	secs = bytes / bps;
+	remainder = bytes % bps;
+	return remainder * 1000000 / bps + secs * 1000000;
+}
+
 static void io_completed(struct thread_data *td, struct io_u *io_u,
 			 struct io_completion_data *icd)
 {
@@ -1354,14 +1364,12 @@ static void io_completed(struct thread_data
*td, struct io_u *io_u,

 			if (__should_check_rate(td, idx)) {
 				td->rate_pending_usleep[idx] =
-					((td->this_io_bytes[idx] *
-					  td->rate_nsec_cycle[idx]) / 1000 -
+					(usec_for_io(td, idx) -
 					 utime_since_now(&td->start));
 			}
-			if (__should_check_rate(td, idx ^ 1))
+			if (__should_check_rate(td, odx))
 				td->rate_pending_usleep[odx] =
-					((td->this_io_bytes[odx] *
-					  td->rate_nsec_cycle[odx]) / 1000 -
+					(usec_for_io(td, odx) -
 					 utime_since_now(&td->start));
 		}
