Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37300 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbeJSUF4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Oct 2018 16:05:56 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gDTRp-0004cc-Ol
        for fio@vger.kernel.org; Fri, 19 Oct 2018 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181019120002.0F82B2C0083@kernel.dk>
Date: Fri, 19 Oct 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d5dbacf662b1cc3fb09b5cd70b236ab98d1c0dbe:

  Merge branch 'offload-serialize-overlap2' of https://github.com/vincentkfu/fio (2018-10-15 14:09:18 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8eb142ddd8bc3fe9428cd46b9fd98f32b2bc8c67:

  fio: reset more counters when ramp time has elapsed (2018-10-18 15:33:05 -0600)

----------------------------------------------------------------
Vincent Fu (1):
      fio: reset more counters when ramp time has elapsed

 time.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/time.c b/time.c
index c887682..1999969 100644
--- a/time.c
+++ b/time.c
@@ -118,6 +118,7 @@ bool ramp_time_over(struct thread_data *td)
 	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
 		td->ramp_time_over = true;
 		reset_all_stats(td);
+		reset_io_stats(td);
 		td_set_runstate(td, TD_RAMP);
 
 		/*

