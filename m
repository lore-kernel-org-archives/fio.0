Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C1480DCC
	for <fio@vger.kernel.org>; Wed,  1 Jul 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782907209; cv=none; b=jsrcyD6BQAZ/0LcNLr1j31nTm5hPbUv4iekaXqYxUJXz+iJE0Eh34EiAZz4oN2/dYs5YagKtayLzNdRX67NSYI+Hsef/A/tNuUq0mOB/T8m8mDWWuHUj6KvWXSQ5noXmRPU2yj1lFH9+j6vavncijhnDUjuIYGOvXddK2BlJBd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782907209; c=relaxed/simple;
	bh=88I2B7iga4zgNxMBIth5kV6S+/j9/oNkyMGdn8BW6C8=;
	h=Subject:From:To:Date:Message-Id; b=n0OZy7WITdgdyn3aa6ZRx8P1VgCzPVsr1mUxyWL9YcJ8giI+8t4GNXXPvC5tG9XSrRZRLFSasaUgsLLVdq/XamMRcDlKlL9GmEAQVxqDFBtpyfS30uWNb6Q4NZ76xobQUSnNaxE/TZW75PECO45BjTPFK3SvE61IEtTfmp1/KDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BpSh+JqI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BpSh+JqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZtOFiyl5xsmb3stHE61xIm+jIn0SRs70wyrLwg/LV2U=; b=BpSh+JqIWmjd4f6a+40qOEfEIG
	ge50Cbrn75dTUw8W35gHMUIcIvdaq8lE6tQN++FyHDP7rSTGx/4tcC/PLZvLEFDU394+92Jzr7ese
	cG2UpbpKsBPM29vligZKKaJWoecDwLsKER337gylUz6kOhUxLtmm1Pv4XAZoNeWdUyxdk3qzrmh8A
	rZCdE0Mnmy/BqsA+/wg4FocpnDRkrWdxnTyvqfevDO5AgHwjSg7dCJy9QoURdW6/yxroPVrnwTjtd
	CPHX+hbPwlOUr1ICj6SAlXa4EPzSyJPArL7kt+ttlAgIpHWjr8R48gkUpA0/XgkUZWSqztvzZ9rbB
	AMuHEhoA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wetbp-00000006Z7c-0mCH
	for fio@vger.kernel.org;
	Wed, 01 Jul 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CA2C61BC017C; Wed,  1 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  1 Jul 2026 06:00:01 -0600
Message-Id: <20260701120001.CA2C61BC017C@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 855d7e24e4188a357a150a7569c3150267106630:

  t/run-fio-tests: add t/sequence.py (2026-06-26 12:35:04 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f80c50d9ff50a746cd1a111f1986648963bbf7dd:

  Merge branch 'fix-issue-1542' of https://github.com/cenhuil/fio (2026-06-30 12:23:27 -0600)

----------------------------------------------------------------
Huilin Cen (1):
      server: reap child processes on SIGINT to prevent assertion crash

Jens Axboe (1):
      Merge branch 'fix-issue-1542' of https://github.com/cenhuil/fio

 server.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index cde7fdf3..16ccf52b 100644
--- a/server.c
+++ b/server.c
@@ -822,6 +822,30 @@ static void fio_server_fork_item_done(struct fio_fork_item *ffi, bool stop)
 	free(ffi);
 }
 
+static void fio_server_terminate_fork_items(struct flist_head *list, bool stop)
+{
+	struct flist_head *entry, *tmp;
+	struct fio_fork_item *ffi;
+
+	flist_for_each_safe(entry, tmp, list) {
+		ffi = flist_entry(entry, struct fio_fork_item, list);
+#ifdef WIN32
+		if (!ffi->element.is_thread) {
+			TerminateProcess(ffi->element.hProcess, 0);
+			CloseHandle(ffi->element.hProcess);
+		}
+#else
+		kill(ffi->pid, SIGTERM);
+		do {
+			int ret = waitpid(ffi->pid, NULL, 0);
+			if (ret != -1 || errno != EINTR)
+				break;
+		} while (1);
+#endif
+		fio_server_fork_item_done(ffi, stop);
+	}
+}
+
 static void fio_server_check_fork_items(struct flist_head *list, bool stop)
 {
 	struct flist_head *entry, *tmp;
@@ -1402,6 +1426,8 @@ static int handle_connection(struct sk_out *sk_out)
 
 	handle_xmits(sk_out);
 
+	fio_server_terminate_fork_items(&job_list, false);
+
 	close(sk_out->sk);
 	sk_out->sk = -1;
 	__sk_out_drop(sk_out);
@@ -1617,6 +1643,8 @@ static int accept_loop(int listen_sk)
 #endif
 	}
 
+	fio_server_terminate_fork_items(&conn_list, false);
+
 	return exitval;
 }
 
@@ -2759,6 +2787,7 @@ static void set_sig_handlers(void)
 	};
 
 	sigaction(SIGINT, &act, NULL);
+	sigaction(SIGTERM, &act, NULL);
 
 	/* Windows uses SIGBREAK as a quit signal from other applications */
 #ifdef WIN32
