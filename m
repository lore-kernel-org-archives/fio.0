Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837641C2F6
	for <fio@vger.kernel.org>; Wed,  8 Jul 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783512010; cv=none; b=UEyOli465QQt8DNy/FSVUGr1f0H7EqZmWlwpc2EIpCnoy8PWzPehxgsZNZANAdU/ySwvEADBuXxHh6BlWNZgJUwCi4NLN/CuPSVNQYTLwdeajTHsE5mdWXXD68XvRv4tzVPWBQTfnw3TR+MaDpMwoZqnGdPVSHT1Ln2lofn813A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783512010; c=relaxed/simple;
	bh=wCjUdCU1CPWnhe8fpr+R9biDrqV39fCLd6tSgO04+nk=;
	h=Subject:From:To:Date:Message-Id; b=AZZ1H0aur7ugLyW5bhRLlCRvKjndom0h7JYDeuh+UpLaJwm9Q9p1GEtwmvXkjsuEEyjRLCjCPbUteiv7Ciov8hw9TnMLr0KEwF2rBUGbjzjlGVCIZxvxRZ0zfC5JQ7iYc2zfgiJfnK+5Cp8mlkbaiisLcoaRxWEaYGXSJSkusCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hjsWiDCf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hjsWiDCf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PslkGxyi6a1Bra8B414tVj1rk68budi6vmoxrL5c1Jw=; b=hjsWiDCf6SxCUi28qcGhyua5k1
	5wZLnTI2ZdXZMcNeI7MziCtzef/mtca84Tehn+dhCvw/rrtushS9PZimCJXpGA0/PvgkQF+w57pcQ
	5zWUpV/poOdF661fZBUU4KzzT7wKY5AcJnnyG9Qqr6Bkjv4Eka39eYdRKpjg6Yavsvrq6jJieIUq/
	1LSlsrlNxk7p9q1p+7bBMq9ha/tnEk97wiNses5q0tMU4Wzb+7anpx8XEoJPANi3BkyZ5hG57uJAc
	9UmUrN5fX7tAaJHnxtbAoAABwl2ty5ddX/hKxCHaAh1Gv4wfeKaTYVt0l+CP1fWKQ1YuYO0N+yZen
	Jq9bTFdQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whQwf-00000002GpY-0fuD
	for fio@vger.kernel.org;
	Wed, 08 Jul 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 042B91BC015A; Wed,  8 Jul 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  8 Jul 2026 06:00:01 -0600
Message-Id: <20260708120002.042B91BC015A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ed3e687f27802ae0daa60ae96ae9b798ee1b6511:

  Merge branch 'fix-pending-log-iodepth-assert' of https://github.com/SAY-5/fio (2026-07-02 08:46:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 179fb9c335020ab6993ace93d4c2de7487f05a09:

  parse: use signed format specifier for debug print (2026-07-07 16:22:15 -0400)

----------------------------------------------------------------
Bart Van Assche (3):
      io_ddir: add "syncfs" to io_ddir_name() array
      ioengines: record all sync io_u completions under DDIR_SYNC in total_io_u
      blktrace: fix error handling in merge_blktrace_iologs

Huilin Cen (1):
      parse: ignore leading minus sign when splitting options

Jens Axboe (1):
      Merge branch 'master' of github.com:bvanassche/fio

Vincent Fu (3):
      engines/io_uring: set sync trim flag when async trim fails
      Merge branch 'fix-issue-1657' of https://github.com/cenhuil/fio
      parse: use signed format specifier for debug print

 blktrace.c         |  7 +++----
 engines/io_uring.c |  2 ++
 io_ddir.h          | 15 +++++++++++----
 ioengines.c        | 11 +++++++----
 parse.c            | 14 ++++++++++++--
 5 files changed, 35 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index 045c4eb6..71d21122 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -710,7 +710,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 					     nr_logs);
 	struct blktrace_cursor *bc;
 	FILE *merge_fp;
-	char *str, *ptr, *name, *merge_buf;
+	char *str, *ptr, *name, *merge_buf = NULL;
 	int i, ret;
 
 	ret = init_merge_param_list(td->o.merge_blktrace_scalars, bcs, nr_logs,
@@ -738,7 +738,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 		goto err_out_file;
 	ret = setvbuf(merge_fp, merge_buf, _IOFBF, 128 * 1024);
 	if (ret)
-		goto err_merge_buf;
+		goto err_out_file;
 
 	/* setup input files */
 	str = ptr = strdup(td->o.read_iolog_file);
@@ -800,10 +800,9 @@ err_file:
 	for (i = 0; i < nr_logs; i++) {
 		fclose(bcs[i].f);
 	}
-err_merge_buf:
+err_out_file:
 	fflush(merge_fp);
 	fclose(merge_fp);
-err_out_file:
 	free(merge_buf);
 err_param:
 	free(bcs);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index bc7e33da..fd5475cc 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -889,6 +889,8 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 
 	if (io_u->ddir == DDIR_TRIM) {
 		ld->async_trim_fail = 1;
+		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
+		td_set_ioengine_flags(td);
 		cqe->res = 0;
 	}
 	if (cqe->res > io_u->xfer_buflen)
diff --git a/io_ddir.h b/io_ddir.h
index 203b6898..c2b6266a 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -22,11 +22,18 @@ enum fio_ddir {
 
 static inline const char *io_ddir_name(enum fio_ddir ddir)
 {
-	static const char *name[] = { "read", "write", "trim", "sync",
-					"datasync", "sync_file_range",
-					"wait", };
+	static const char *name[] = {
+		[DDIR_READ] = "read",
+		[DDIR_WRITE] = "write",
+		[DDIR_TRIM] = "trim",
+		[DDIR_SYNC] = "sync",
+		[DDIR_DATASYNC] = "datasync",
+		[DDIR_SYNC_FILE_RANGE] = "sync_file_range",
+		[DDIR_SYNCFS] = "syncfs",
+		[DDIR_WAIT] = "wait",
+	};
 
-	if (ddir >= 0 && ddir < DDIR_LAST)
+	if (ddir >= 0 && ddir < sizeof(name) / sizeof(name[0]) && name[ddir])
 		return name[ddir];
 
 	return "invalid";
diff --git a/ioengines.c b/ioengines.c
index 60565e03..a2816817 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -441,19 +441,22 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
-		if (ddir_rw(io_u->ddir) ||
-		    (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING)) {
+		if (ddir_rw(io_u->ddir)) {
 			io_u_mark_depth(td, 1);
 			td->ts.total_io_u[io_u->ddir]++;
+		} else if (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING) {
+			io_u_mark_depth(td, 1);
+			td->ts.total_io_u[DDIR_SYNC]++;
 		}
 
 		td->last_ddir_issued = ddir;
 	} else if (ret == FIO_Q_QUEUED) {
 		td->io_u_queued++;
 
-		if (ddir_rw(io_u->ddir) ||
-		    (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING))
+		if (ddir_rw(io_u->ddir))
 			td->ts.total_io_u[io_u->ddir]++;
+		else if (ddir_sync(io_u->ddir) && td->runstate != TD_FSYNCING)
+			td->ts.total_io_u[DDIR_SYNC]++;
 
 		if (td->io_u_queued >= td->o.iodepth_batch)
 			td_io_commit(td);
diff --git a/parse.c b/parse.c
index 5bb55bff..e2ec4fcc 100644
--- a/parse.c
+++ b/parse.c
@@ -650,7 +650,10 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		else
 			ret = check_str_bytes(tmp, &ull, data);
 
-		dprint(FD_PARSE, "  ret=%d, out=%llu\n", ret, ull);
+		if (o->type == FIO_OPT_INT)
+			dprint(FD_PARSE, "  ret=%d, out=%lld\n", ret, ull);
+		else
+			dprint(FD_PARSE, "  ret=%d, out=%llu\n", ret, ull);
 
 		if (ret)
 			break;
@@ -1041,8 +1044,15 @@ static int handle_option(const struct fio_option *o, const char *__ptr,
 			if (o->type != FIO_OPT_STR_MULTI && o->type != FIO_OPT_RANGE) {
 				if (!ptr2)
 					ptr2 = strchr(ptr, ':');
-				if (!ptr2)
+				if (!ptr2) {
 					ptr2 = strchr(ptr, '-');
+					/*
+					 * If the first character is a minus sign, it's
+					 * likely a negative number, not a delimiter.
+					 */
+					if (ptr2 == ptr)
+						ptr2 = strchr(ptr + 1, '-');
+				}
 			}
 		} else if (ptr && o->type == FIO_OPT_FLOAT_LIST) {
 			ptr2 = strchr(ptr, ':');
