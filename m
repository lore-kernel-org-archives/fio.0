Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62705 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030260Ab2CPDMx (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Mar 2012 23:12:53 -0400
Received: by faaa19 with SMTP id a19so165922faa.1
        for <fio@vger.kernel.org>; Thu, 15 Mar 2012 20:12:51 -0700 (PDT)
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] time_based: Avoid restarting main I/O loop
Date: Thu, 15 Mar 2012 20:12:47 -0700
Message-Id: <1331867567-25371-1-git-send-email-dehrenberg@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: nauman@google.com, egouriou@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>

Previously, when fio had written a volume of I/O equal to the size
argument, it restarted the main do_io loop.

This patch allows time_based tests to be run for longer than one
cycle in the do_io main loop. This has a couple of advantages:
 * The random number generator is not reset on each iteration
   of the loop, so running longer will reach different locations.
 * There is not a throughput-reducing point where all operations
   must be reaped before new operations are submitted.

The implementation consists of two minor changes:
 * In the do_io loop, a time_based test will not exit the loop for
   reading or writing too much data.
 * When reading or writing sequentially, the operations wrap around
   to the beginning after reading the end within the
   get_next_seq_block function.
---
 backend.c |    3 ++-
 io_u.c    |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/backend.c b/backend.c
index 7343286..1d9b0a2 100644
--- a/backend.c
+++ b/backend.c
@@ -555,7 +555,8 @@ static void do_io(struct thread_data *td)
 		td_set_runstate(td, TD_RUNNING);
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td)) {
+		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
+		td->o.time_based) {
 		struct timeval comp_time;
 		unsigned long bytes_done[2] = { 0, 0 };
 		int min_evts = 0;
diff --git a/io_u.c b/io_u.c
index 20794c3..a3ea43d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -252,6 +252,9 @@ static int get_next_seq_block(struct thread_data *td, struct fio_file *f,
 {
 	assert(ddir_rw(ddir));
 
+       if (f->last_pos >= f->io_size && td->o.time_based)
+               f->last_pos = f->last_pos - f->io_size;
+
 	if (f->last_pos < f->real_file_size) {
 		unsigned long long pos;
 
-- 
1.7.7.3

