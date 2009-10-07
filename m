Return-Path: <fio-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:16744 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZJGTPS (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Oct 2009 15:15:18 -0400
From: Roland Dreier <rdreier@cisco.com>
Subject: "Fix wrong clock source in mutex" broke fio for me
Date: Tue, 06 Oct 2009 23:56:25 -0700
Message-ID: <ada1vlfqan3.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, fio@vger.kernel.org

With the latest fio git tree, I get:

    fio: job startup hung? exiting.

on startup, and it looks like the latest commit, 69a852f5 ("Fix wrong
clock source in mutex") breaks things for me (Ubuntu 9.10 beta).  My
system seems to use CLOCK_REALTIME for pthread_cond_timedwait() by
default.

The cleanest solution seems to be to explicitly set which clock to use
in pthread_cond_timedwait() via pthread_condattr_setclock() when
initializing the condition variable, although I'm not sure how portable
this is away from modern Linux (ie do all platforms that fio cares about
have pthread_condattr_setclock()?).

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 mutex.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mutex.c b/mutex.c
index 9f0f094..34b3324 100644
--- a/mutex.c
+++ b/mutex.c
@@ -72,6 +72,7 @@ struct fio_mutex *fio_mutex_init(int value)
 
 	pthread_condattr_init(&cond);
 	pthread_condattr_setpshared(&cond, mflag);
+	pthread_condattr_setclock(&cond, CLOCK_MONOTONIC);
 	pthread_cond_init(&mutex->cond, &cond);
 
 	ret = pthread_mutex_init(&mutex->lock, &attr);

