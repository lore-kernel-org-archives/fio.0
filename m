Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2DRSje (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Apr 2012 14:39:34 -0400
Message-ID: <4F8F0A62.80101@kernel.dk>
Date: Wed, 18 Apr 2012 20:39:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segfault runninng fio against 2048 jobs
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@xyratex.com>
Cc: fio@vger.kernel.org

On 2012-04-18 19:27, Roger Sibert wrote:
> Heres hoping Outlook doesn't inject html into the message again.
> 
> [global]
> direct=1
> ioengine=libaio
> zonesize=1g
> randrepeat=1
> write_bw_log
> write_lat_log
> time_based
> ramp_time=15s
> runtime=15s
> ;
> [sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
> description=[sdf-iodepth1-rw-readwrite_mix_5050-bs128k-2048]
> stonewall
> filename=/dev/sdf
> iodepth=1
> rw=rw
> rwmixread=50
> rwmixwrite=50
> bs=128k
> 
> Running just the 2048 job on its own doesn't cause any issues.
> 
> I did a fresh git clone and ended up with fio-2.0.7-10-g8430 (which was
> compiled on the local system without making any changes to the code) and
> re-ran the test using the full 2048 to verify that the segfault still
> occurs, which it does.  I also noted that the segfault is about
> immediate once seeing Jobs: 1 (f=xxx) print and stays that way until you
> reduce it down to 535.  At about 535 it runs for about 15 or so seconds
> before segfaulting, 500 is still running after about 3 minutes.

OK, pretty silly error. Guess not that many people use more than ~500
jobs. What you run into is a simple stack smash. The below should help,
I'm committing it now.

diff --git a/eta.c b/eta.c
index 7e837ba..4679a21 100644
--- a/eta.c
+++ b/eta.c
@@ -360,7 +360,7 @@ void display_thread_status(struct jobs_eta *je)
 {
 	static int linelen_last;
 	static int eta_good;
-	char output[512], *p = output;
+	char output[REAL_MAX_JOBS + 512], *p = output;
 	char eta_str[128];
 	double perc = 0.0;
 	int i2p = 0;
@@ -385,6 +385,7 @@ void display_thread_status(struct jobs_eta *je)
 		char perc_str[32];
 		char *iops_str[2];
 		char *rate_str[2];
+		size_t left;
 		int l;
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
@@ -401,7 +402,9 @@ void display_thread_status(struct jobs_eta *je)
 		iops_str[0] = num2str(je->iops[0], 4, 1, 0);
 		iops_str[1] = num2str(je->iops[1], 4, 1, 0);
 
-		l = sprintf(p, ": [%s] [%s] [%s/%s /s] [%s/%s iops] [eta %s]",
+		left = sizeof(output) - (p - output) - 1;
+
+		l = snprintf(p, left, ": [%s] [%s] [%s/%s /s] [%s/%s iops] [eta %s]",
 				je->run_str, perc_str, rate_str[0],
 				rate_str[1], iops_str[0], iops_str[1], eta_str);
 		p += l;

-- 
Jens Axboe

