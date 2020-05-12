Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgELMAc (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 May 2020 08:00:32 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F373C061A0C
        for <fio@vger.kernel.org>; Tue, 12 May 2020 05:00:32 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYTa3-0001ep-Gt
        for fio@vger.kernel.org; Tue, 12 May 2020 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200512120002.3E67B1BC019C@kernel.dk>
Date: Tue, 12 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b2ed1c4a07c6afc4ae90482ca5f70026a4bc34e6:

  Merge branch 'helper_thread_test' of https://github.com/vincentkfu/fio (2020-04-29 09:05:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9bc878ed59deb6c4a031f4f3a8d1ff3bbdbbd14d:

  Merge branch 'btrace2fio' of https://github.com/liu-song-6/fio (2020-05-11 12:09:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'btrace2fio' of https://github.com/liu-song-6/fio

Song Liu (1):
      btrace2fio: create separate jobs for pid with both read/write and trim

 t/btrace2fio.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index a8a9d629..6dca39cb 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -645,7 +645,8 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 	printf("\n");
 }
 
-static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
+static int __output_p_fio(struct btrace_pid *p, unsigned long *ios,
+			  const char *name_postfix)
 {
 	struct btrace_out *o = &p->o;
 	unsigned long total;
@@ -654,15 +655,30 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 	int i, j;
 
 	if ((o->ios[0] + o->ios[1]) && o->ios[2]) {
-		log_err("fio: trace has both read/write and trim\n");
-		return 1;
+		unsigned long ios_bak[DDIR_RWDIR_CNT];
+
+		memcpy(ios_bak, o->ios, DDIR_RWDIR_CNT * sizeof(unsigned long));
+
+		/* create job for read/write */
+		o->ios[2] = 0;
+		__output_p_fio(p, ios, "");
+		o->ios[2] = ios_bak[2];
+
+		/* create job for trim */
+		o->ios[0] = 0;
+		o->ios[1] = 0;
+		__output_p_fio(p, ios, "_trim");
+		o->ios[0] = ios_bak[0];
+		o->ios[1] = ios_bak[1];
+
+		return 0;
 	}
 	if (!p->nr_files) {
 		log_err("fio: no devices found\n");
 		return 1;
 	}
 
-	printf("[pid%u", p->pid);
+	printf("[pid%u%s", p->pid, name_postfix);
 	if (p->nr_merge_pids)
 		for (i = 0; i < p->nr_merge_pids; i++)
 			printf(",pid%u", p->merge_pids[i]);
@@ -783,7 +799,7 @@ static int __output_p(struct btrace_pid *p, unsigned long *ios)
 	if (output_ascii)
 		__output_p_ascii(p, ios);
 	else
-		ret = __output_p_fio(p, ios);
+		ret = __output_p_fio(p, ios, "");
 
 	return ret;
 }
@@ -1037,7 +1053,7 @@ static int trace_needs_swap(const char *trace_file, int *swap)
 	int fd, ret;
 
 	*swap = -1;
-	
+
 	fd = open(trace_file, O_RDONLY);
 	if (fd < 0) {
 		perror("open");

