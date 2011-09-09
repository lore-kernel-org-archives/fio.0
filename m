Return-Path: <fio-owner@vger.kernel.org>
Received: from www7149u.sakura.ne.jp ([59.106.184.187]:45117 "EHLO
	i.rakugaki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab1IIF14 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Sep 2011 01:27:56 -0400
Received: from [10.253.0.10] (KD125053235206.ppp-bb.dion.ne.jp [125.53.235.206])
	by i.rakugaki.org (Postfix) with ESMTPSA id E6117202EA
	for <fio@vger.kernel.org>; Fri,  9 Sep 2011 14:21:21 +0900 (JST)
Message-ID: <4E69A048.6050509@rakugaki.org>
Date: Fri, 09 Sep 2011 14:12:40 +0900
From: Taisuke Yamada <tai@rakugaki.org>
MIME-Version: 1.0
Subject: [PATCH 1/2] Added replay_rebase option to run multi-threaded log
 replay on different disk sectors.
Content-Type: multipart/mixed;
 boundary="------------040706050404010506000309"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------040706050404010506000309
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi.

I'm now trying to run multi-threaded log replay, and noticed
all threads are accessing same sector on a disk. Of course,
this is an expected behavior of "replay".

But since I also wanted to have each thread accessing different
parts of the disk to increase a load, but still following the
access pattern of the original, I added "replay_rebase" option to
shift offset of IO request for each thread.

Althrough there's "1/2" in the subject, this patch is complete
by itself. Next one (2/2) is related, but handles different issue.

Signed-off-by: Taisuke Yamada <tai@rakugaki.org>
---
 fio.h     |    1 +
 log.c     |    2 +-
 options.c |    8 ++++++++
 3 files changed, 10 insertions(+), 1 deletions(-)



--------------040706050404010506000309
Content-Type: text/x-patch;
 name="0001-Added-replay_rebase-option-to-run-multi-threaded-log.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Added-replay_rebase-option-to-run-multi-threaded-log.pa";
 filename*1="tch"

diff --git a/fio.h b/fio.h
index 6eb270d..b28e0ae 100644
--- a/fio.h
+++ b/fio.h
@@ -358,6 +358,7 @@ struct thread_options {
 	unsigned int gtod_offload;
 	enum fio_cs clocksource;
 	unsigned int no_stall;
+	unsigned int replay_rebase;
 	unsigned int trim_percentage;
 	unsigned int trim_batch;
 	unsigned int trim_zero;
diff --git a/log.c b/log.c
index f962864..57fc0f4 100644
--- a/log.c
+++ b/log.c
@@ -129,7 +129,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 
 		io_u->ddir = ipo->ddir;
 		if (ipo->ddir != DDIR_WAIT) {
-			io_u->offset = ipo->offset;
+			io_u->offset = ipo->offset + td->o.replay_rebase * td->thread_number;
 			io_u->buflen = ipo->len;
 			io_u->file = td->files[ipo->fileno];
 			get_file(io_u->file);
diff --git a/options.c b/options.c
index 74c24d0..aba14b1 100644
--- a/options.c
+++ b/options.c
@@ -1654,6 +1654,14 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Replay all I/O onto this device, regardless of trace device",
 	},
 	{
+		.name	= "replay_rebase",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(replay_rebase),
+		.def	= "0",
+		.parent	= "read_iolog",
+		.help	= "Apply given offset for IO replay. Mainly for parallel replay.",
+	},
+	{
 		.name	= "exec_prerun",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(exec_prerun),


--------------040706050404010506000309--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


