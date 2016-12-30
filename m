Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55738 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753882AbcL3NAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Dec 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cMwmx-0002MK-EK
        for fio@vger.kernel.org; Fri, 30 Dec 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161230130001.B266D2C1D80@kernel.dk>
Date: Fri, 30 Dec 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 35448275f6577483f2a5f98db27f28bd3257ddb5:

  rbd: style fixups (2016-12-23 19:54:47 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 915ca9807717762e288ded3eba0fe5fc82a2ddcd:

  options: mark steadystate option parents (2016-12-29 09:07:57 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      options: mark steadystate option parents

 options.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index b81db23..d8b4012 100644
--- a/options.c
+++ b/options.c
@@ -4321,6 +4321,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name   = "steadystate_duration",
 		.lname  = "Steady state duration",
 		.alias  = "ss_dur",
+		.parent	= "steadystate",
 		.type   = FIO_OPT_STR_VAL_TIME,
 		.off1   = offsetof(struct thread_options, ss_dur),
 		.help   = "Stop workload upon attaining steady state for specified duration",
@@ -4334,6 +4335,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name   = "steadystate_ramp_time",
 		.lname  = "Steady state ramp time",
 		.alias  = "ss_ramp",
+		.parent	= "steadystate",
 		.type   = FIO_OPT_STR_VAL_TIME,
 		.off1   = offsetof(struct thread_options, ss_ramp_time),
 		.help   = "Delay before initiation of data collection for steady state job termination testing",
