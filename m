Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFA97FBDC
	for <fio@vger.kernel.org>; Wed,  6 Mar 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709730011; cv=none; b=PC2aA+sblNTJa546qd3f5SGHs7QIx4jdQiXd/YI9POVcaaDhDuW1djZLabXrh2cktX/p04gc2lh1Q4VwDVdcBpyZjaAU0VCSMsXpTX8CguK8Gy/fQPVC+GMloNST2EZTqIb66e3qq2/hx+Ixkw0i0iVqkgLp8Y8o2Hmng4DEoA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709730011; c=relaxed/simple;
	bh=V9NAAyMQFO8ArzEENFF1H9+hV0VcN7+YCxueQI6jHzE=;
	h=Subject:From:To:Message-Id:Date; b=rSHrb18pwtf5qbjNflLHLAI7z3ISJKBhGG2ip6VFny+YCRy6KSTPHysORS6xUzJxE7oslL2etKsjdvXn706FobBFborxvgVH46F/IaDMLeVAPv1gQst7DIH23b9uAbQ/ACzMeKs5v7tAWh/nFebr2BdOIoiRET4vG5ojqY9Pkho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UhA1ZxYZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UhA1ZxYZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=grxc9BSxwiweHs+8CZ+wrbkUHw7l99hkDAto4HGkEJ8=; b=UhA1ZxYZ9B3GWyRTH7RjMmbS4P
	c23fJlVeOSsyCkuJtWLVkxS/diBSL7OkQ7sjtn/cJGwtHDL4B6QdB2nX2UP8iun4faDNTGCN7PLQG
	dlJvciWdMwYowILYKDK+ACKBsqoVN6fka9MOAnl6TW9ff5NxhTti2J9nKAGHq1edJilACuZShM+hQ
	bKWiVDujVfEb/S7yaGqefAxSyFwxS01TGm/scF1waQUq1Z7OUsLTMRdeEeavQZna/oU82c+QxutTM
	jztrnHZam7HYJAPtUSLYdMqLfynbFywjW0lttwRggMHtTFOsOGe/t5//xdpd0PKgL0I6H6ctzrCQC
	2OYawcNQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhqsN-000000066fs-2zwl
	for fio@vger.kernel.org;
	Wed, 06 Mar 2024 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5FFAE1BC0167; Wed,  6 Mar 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240306130001.5FFAE1BC0167@kernel.dk>
Date: Wed,  6 Mar 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2dddfd35396e2f7a1bb06cc7c92aa1e283be084e:

  Merge branch 'patch-ioengines' of https://github.com/kcoms555/fio (2024-03-04 07:31:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9b699fb150bbed56939d317ffc004b3bf19f098f:

  Doc: Make note of using bsrange with ':' (2024-03-05 10:54:36 -0500)

----------------------------------------------------------------
Avri Altman (5):
      fio: Some minor code cleanups
      t/jobs: Further clarify regression test 7
      t/jobs: Rename test job 15
      t/jobs: Fix a typo in jobs 23 & 24
      Doc: Make note of using bsrange with ':'

 HOWTO.rst                                         | 4 ++--
 backend.c                                         | 4 ++--
 eta.c                                             | 8 +++++---
 fio.1                                             | 2 +-
 io_u.c                                            | 3 ++-
 parse.h                                           | 2 +-
 stat.h                                            | 1 -
 t/jobs/t0007-37cf9e3c.fio                         | 5 ++++-
 t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
 t/jobs/t0023.fio                                  | 4 ++--
 t/jobs/t0024.fio                                  | 2 +-
 t/run-fio-tests.py                                | 2 +-
 12 files changed, 21 insertions(+), 16 deletions(-)
 rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 169cdc2a..2386d806 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1631,7 +1631,7 @@ Block size
 	Comma-separated ranges may be specified for reads, writes, and trims as
 	described in :option:`blocksize`.
 
-	Example: ``bsrange=1k-4k,2k-8k``.
+	Example: ``bsrange=1k-4k,2k-8k`` also the ':' delimiter ``bsrange=1k:4k,2k:8k``.
 
 .. option:: bssplit=str[,str][,str]
 
@@ -2786,7 +2786,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: sg_write_mode=str : [sg]
 
-	Specify the type of write commands to issue. This option can take three values:
+	Specify the type of write commands to issue. This option can take ten values:
 
 	**write**
 		This is the default where write opcodes are issued as usual.
diff --git a/backend.c b/backend.c
index 2f2221bf..fb7dc68a 100644
--- a/backend.c
+++ b/backend.c
@@ -2094,14 +2094,14 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 			 uint64_t *m_rate)
 {
 	unsigned int cputhreads, realthreads, pending;
-	int status, ret;
+	int ret;
 
 	/*
 	 * reap exited threads (TD_EXITED -> TD_REAPED)
 	 */
 	realthreads = pending = cputhreads = 0;
 	for_each_td(td) {
-		int flags = 0;
+		int flags = 0, status;
 
 		if (!strcmp(td->o.ioengine, "cpuio"))
 			cputhreads++;
diff --git a/eta.c b/eta.c
index cc342461..7d07708f 100644
--- a/eta.c
+++ b/eta.c
@@ -215,8 +215,9 @@ static unsigned long thread_eta(struct thread_data *td)
 				perc = td->o.rwmix[DDIR_WRITE];
 
 			bytes_total += (bytes_total * perc) / 100;
-		} else
+		} else {
 			bytes_total <<= 1;
+		}
 	}
 
 	if (td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING) {
@@ -228,8 +229,9 @@ static unsigned long thread_eta(struct thread_data *td)
 			perc = (double) bytes_done / (double) bytes_total;
 			if (perc > 1.0)
 				perc = 1.0;
-		} else
+		} else {
 			perc = 0.0;
+		}
 
 		if (td->o.time_based) {
 			if (timeout) {
@@ -395,7 +397,7 @@ static bool skip_eta()
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
  */
-bool calc_thread_status(struct jobs_eta *je, int force)
+static bool calc_thread_status(struct jobs_eta *je, int force)
 {
 	int unified_rw_rep;
 	bool any_td_in_ramp;
diff --git a/fio.1 b/fio.1
index e6b291a7..d955385d 100644
--- a/fio.1
+++ b/fio.1
@@ -1434,7 +1434,7 @@ described in \fBblocksize\fR. Example:
 .RS
 .RS
 .P
-bsrange=1k\-4k,2k\-8k
+bsrange=1k\-4k,2k\-8k or bsrange=1k:4k,2k:8k
 .RE
 .RE
 .TP
diff --git a/io_u.c b/io_u.c
index 2b8e17f8..09e5f15a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1895,8 +1895,9 @@ struct io_u *get_io_u(struct thread_data *td)
 					io_u->buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS) &&
-				   !(td->flags & TD_F_DO_VERIFY))
+				   !(td->flags & TD_F_DO_VERIFY)) {
 				do_scramble = 1;
+			}
 		} else if (io_u->ddir == DDIR_READ) {
 			/*
 			 * Reset the buf_filled parameters so next time if the
diff --git a/parse.h b/parse.h
index d68484ea..806a76ee 100644
--- a/parse.h
+++ b/parse.h
@@ -32,7 +32,7 @@ enum fio_opt_type {
  */
 struct value_pair {
 	const char *ival;		/* string option */
-	unsigned long long oval;/* output value */
+	unsigned long long oval;	/* output value */
 	const char *help;		/* help text for sub option */
 	int orval;			/* OR value */
 	void *cb;			/* sub-option callback */
diff --git a/stat.h b/stat.h
index bd986d4e..0d57cceb 100644
--- a/stat.h
+++ b/stat.h
@@ -345,7 +345,6 @@ extern void stat_exit(void);
 
 extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct flist_head *, struct buf_output *);
 extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
-extern bool calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void __show_run_stats(void);
 extern int __show_running_run_stats(void);
diff --git a/t/jobs/t0007-37cf9e3c.fio b/t/jobs/t0007-37cf9e3c.fio
index d3c98751..b2592694 100644
--- a/t/jobs/t0007-37cf9e3c.fio
+++ b/t/jobs/t0007-37cf9e3c.fio
@@ -1,4 +1,7 @@
-# Expected result: fio reads 87040KB of data
+# Expected result: fio reads 87040KB of data:
+# first read is at offset 0, then 2nd read is at offset 1.5m, then the 3rd
+# read is at offset 3m, and after the last read at offset 127m - we have only
+# read 87,040K data.
 # Buggy result: fio reads the full 128MB of data
 [foo]
 size=128mb
diff --git a/t/jobs/t0015-e78980ff.fio b/t/jobs/t0015-4e7e7898.fio
similarity index 100%
rename from t/jobs/t0015-e78980ff.fio
rename to t/jobs/t0015-4e7e7898.fio
diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
index 4f0bef89..8e14a110 100644
--- a/t/jobs/t0023.fio
+++ b/t/jobs/t0023.fio
@@ -33,7 +33,7 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 
 # Expected result: 	trim issued to random offset followed by write to same offset
 # 			block sizes match
@@ -59,5 +59,5 @@ norandommap=1
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit_no_rm]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
 norandommap=1
diff --git a/t/jobs/t0024.fio b/t/jobs/t0024.fio
index 393a2b70..2b3dc94c 100644
--- a/t/jobs/t0024.fio
+++ b/t/jobs/t0024.fio
@@ -33,4 +33,4 @@ bsrange=512-4k
 # 			block sizes match
 # Buggy result: 	something else
 [bssplit]
-bsrange=512/25:1k:25:2k:25:4k/25
+bssplit=512/25:1k/:2k/:4k/
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d4742e96..08134e50 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -722,7 +722,7 @@ TEST_LIST = [
     {
         'test_id':          15,
         'test_class':       FioJobFileTest_t0015,
-        'job':              't0015-e78980ff.fio',
+        'job':              't0015-4e7e7898.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
