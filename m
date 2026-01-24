Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BC2242D78
	for <fio@vger.kernel.org>; Sat, 24 Jan 2026 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769259615; cv=none; b=kn/pZHKN2ECrNC3z2JzWq+bqaaWxGAGxDuDsEQ2zd4npxyX0n3bUK9+998ihWZUBZH8Ke2DXn8APNVBL+dMoLT4jQNS8OCWfWmKQ+xQVonPdZw/9gOy6LNg/hKkrLj352suuRo5wNhL9a1H0Jq7Qpo1z0PP87tTjdhZ09hrbxGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769259615; c=relaxed/simple;
	bh=NT47QmlESn/7P2mJbWPyvHSiWCA4EraRQ3iVHygaNbE=;
	h=Subject:From:To:Date:Message-Id; b=p6tjuvSlSXi6qVD3DCxkfzndahe+nqAOF5CZ+UwAZAloaEUFrLerJ6/OZ7f/+tJ+6+nrIrVzfEgcsqYq3QxAfzqa9Rr+0i5TS47uYL/4YjKWKMn7XQqPwUS3qGw2Az7ANTVcTKRQdtKUtSBrmGgq9qJoSbSm8gTFwivslutyPiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jFmGe4p8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jFmGe4p8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=v2iQrup+nXbFCstJevwGzcaRf8LHHjjVkpvfY9Xl9PA=; b=jFmGe4p8m7y1lLtozcGAGliEdM
	+yfQONP3GXAJJ5sXDy5vlHjs0E0Nyx5t7BlgOZ+xiPUC4/cHfq7pkhW+OnkwzM8hYBpPhOBfjqyOT
	8MHtSQAJ3NQKtbPYlGfhVToNdS7/82OUGfAfKlFqldx+7GjphETZdBD32leLKFFfF12qIgbGoDi8W
	Iu+dqZt/5LMMGV8b54CGliWjEzeGa/wL8DWDV/V9V1lsy9g3ThcDkNZ5jIvW+y6YuJezEnfnqAkKv
	l2IAf+4dSye5B5E6e831UfiM4h2RjdzP+SAU2TYcVJaqtyZTsX0ac6xUBBTbgUdUKyjgtmiTS5VeG
	WMUGJL8g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vjdFJ-00000003Wuz-1f9s
	for fio@vger.kernel.org;
	Sat, 24 Jan 2026 13:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2B9811BC0197; Sat, 24 Jan 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 24 Jan 2026 06:00:02 -0700
Message-Id: <20260124130002.2B9811BC0197@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit bfe306e16932382069d4c4de3eb0bae9de1e9b09:

  Fixups for rbd luks support (2026-01-20 12:56:59 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2e90ae52be17877d61bb58cf50e9781810d3d49:

  Merge branch 'issue_1499' of https://github.com/gautammenghani/fio (2026-01-23 12:55:48 -0500)

----------------------------------------------------------------
Gautam Menghani (1):
      man: Update the description for `verify_only` explaining phantom writes

Vincent Fu (1):
      Merge branch 'issue_1499' of https://github.com/gautammenghani/fio

 HOWTO.rst | 3 ++-
 fio.1     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index fb607aa4..d566c18e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3945,7 +3945,8 @@ Verification
 	for workloads that write data, and does not support workloads with the
 	:option:`time_based` option set. :option:`verify_write_sequence` and
 	:option:`verify_header_seed` will be disabled in this mode, unless they are
-	explicitly enabled.
+	explicitly enabled. The writes reported in the output when this option is
+	specified are phantom writes, since no writes are actually issued.
 
 .. option:: do_verify=bool
 
diff --git a/fio.1 b/fio.1
index 071ad0e9..4ecfc658 100644
--- a/fio.1
+++ b/fio.1
@@ -3654,7 +3654,8 @@ times at a later date without overwriting it. This option makes sense only
 for workloads that write data, and does not support workloads with the
 \fBtime_based\fR option set. Options \fBverify_write_sequence\fR and
 \fBverify_header_seed\fR will be disabled in this mode, unless they are
-explicitly enabled.
+explicitly enabled. The writes reported in the output when this option is
+specified are phantom writes, since no writes are actually issued.
 .TP
 .BI do_verify \fR=\fPbool
 Run the verify phase after a write phase. Only valid if \fBverify\fR is
