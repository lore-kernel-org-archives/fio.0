Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:44198 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdESOJt (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 19 May 2017 10:09:49 -0400
Date: Fri, 19 May 2017 16:09:27 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH] stat: Re-add output of basic bw information if bw_log is not
 written
Message-ID: <20170519140927.GA27177@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org


Starting with 9e4438f ("stat: don't trust per_unit_log() if log is
NULL") fio no longer provides basic bw information (e.g. min, max,
p_agg, mean, stdev) when write_bw_log is not used. Thus you have to
write a bw_log to obtain these values. (But in this case you can
compute those values yourself.) I think this doesn't make sense.  Not
writing entire bw log shouldn't prevent general sampling and
calculation of bw stats.

This patch reactivates sampling for bw and iops to be able to
calculate basic stats for both independend of writing of entire
{bw,iops}_logs.

Also check for log that is really of interest in __add_samples() it
doesn't make sense to check for bw_log if iops information needs to be
written.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 stat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

[Resend due to broken subject line in prev posting.] 

I don't know the background why the original fix was required in its
form and at which exact point the sigbus error happened on sparc. Was
it in per_unit_log(td->bw_log) or somewhere in add_bw_samples or
add_iops_samples? Maybe the original code version (just using
!per_unit_log(td->bw_log)) was fine and the sigbus happened due to the
bug in __add_samples (checking for the wrong log file)?


Regards,
Andreas

diff --git a/stat.c b/stat.c
index 6e47c34..5b48413 100644
--- a/stat.c
+++ b/stat.c
@@ -2465,7 +2465,7 @@ static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
 
 		add_stat_sample(&stat[ddir], rate);
 
-		if (td->bw_log) {
+		if (log) {
 			unsigned int bs = 0;
 
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
@@ -2541,12 +2541,14 @@ int calc_log_samples(void)
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
 			continue;
 		}
-		if (td->bw_log && !per_unit_log(td->bw_log)) {
+		if (!td->bw_log ||
+			(td->bw_log && !per_unit_log(td->bw_log))) {
 			tmp = add_bw_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
 		}
-		if (td->iops_log && !per_unit_log(td->iops_log)) {
+		if (!td->iops_log ||
+			(td->iops_log && !per_unit_log(td->iops_log))) {
 			tmp = add_iops_samples(td, &now);
 			if (tmp < next)
 				next = tmp;
-- 
2.7.4

