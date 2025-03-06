Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B320B7FD
	for <fio@vger.kernel.org>; Thu,  6 Mar 2025 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741266017; cv=none; b=Aikv/9AcBXuGv4bJ7hQkxhE5/sJouasYBBesJDGkdPUUsTQtzjdgJ27lOsjykvwkwdn0zftu131ILAhn7gIdpcNiy3ECkjlZBgB9B45joSU2qjRAwPQU1YqcXFTqcKN7jsgvNftZXjgemGxcYODaZezkJqU1FimPYRn2brQAHCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741266017; c=relaxed/simple;
	bh=OkBxwsARTBm8n9qRKDeu2pgIoyV/sj/bDnlSUk4N3CY=;
	h=Subject:From:To:Message-Id:Date; b=lBGxM9KLef6nJiDBSuOTZeFUKKBErUe4BPKlqDI1tE2Mdyn5i/2wjANT7ez8d1XWayrmylVAn/0tBUnJRigNdav63EYh9OR8oqqz9qTmHL+dmeznHBh4qCbYS4rBsv8dMPPMuY5wwcnWxJ43Byiyj1jUd/mTU7rQFSPN/uXb3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j0uUCFiU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j0uUCFiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=P7Z8UU1Gn8HxViqdRrAV0aT3BA43QdeYNGOTxzBMrAU=; b=j0uUCFiUkRvectzEu9qoxNqQ+y
	4VGyZ8Oj09Mxq+PovMLQgzYdOs8WYA2jf8fp3ALu3CPjI+8s0BHFBz4zUdiR3CrsW2TyvvnOpMMXI
	qzuXtCFfdD2SEOl4mkgD12xGGiGnsUf5FIvyf9N47F24mbbjQhB9UuGaFaXS9GOn+t8Fce4PWEMdT
	mgTwheVXZr7i4+L6M24yyGaXuwUq1bU2vp3871UegU6vYNF8MLwakCq/GHvmXz2HFC9VgCOJpe97R
	ZcV8fH4G9LjPIrJBY8p/R0/oxQZF1lOEZDXOUT0rAFV0vSRpEeW88R6RcfZY6gV7lNme25tu9xo4s
	JqMLyfXA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tqApa-00000009SxD-0NI8
	for fio@vger.kernel.org;
	Thu, 06 Mar 2025 13:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A6B141BC017E; Thu,  6 Mar 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250306130001.A6B141BC017E@kernel.dk>
Date: Thu,  6 Mar 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 43c67b9f3a8808274bc1e0a3b7b70c56bb8a007f:

  Re-introduce RWF_DONTCACHE (2025-02-20 13:07:41 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df60924e4d854cd6fdf4b730d37282c6b6b4c0a1:

  Merge branch 'update-docs-for-compare' of https://github.com/minwooim/fio (2025-03-05 12:05:52 -0500)

----------------------------------------------------------------
Minwoo Im (1):
      docs: update docs for verify_mode=compare of io_uring_cmd

Vincent Fu (1):
      Merge branch 'update-docs-for-compare' of https://github.com/minwooim/fio

 HOWTO.rst | 4 +++-
 fio.1     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3f2bde18..62537b65 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2896,7 +2896,9 @@ with the caveat that when used on the command line, they must come after the
                 **read**
                         Use Read commands for data verification
                 **compare**
-                        Use Compare commands for data verification
+                        Use Compare commands for data verification.  This option is only valid with
+                        specific pattern(s), which means it *must* be given with `verify=pattern` and
+                        `verify_pattern=<pattern>`.
 
 .. option:: sg_write_mode=str : [sg]
 
diff --git a/fio.1 b/fio.1
index 3c5f02b3..1581797a 100644
--- a/fio.1
+++ b/fio.1
@@ -2686,7 +2686,9 @@ Specifies the type of command to be used in the verification phase. Defaults to
 Use Read commands for data verification
 .TP
 .B compare
-Use Compare commands for data verification
+Use Compare commands for data verification.  This option is only valid with
+specific pattern(s), which means it *must* be given with `verify=pattern` and
+`verify_pattern=<pattern>`.
 .TP
 .RE
 .RE
