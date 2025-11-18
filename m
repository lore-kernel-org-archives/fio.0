Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CB2D63FC
	for <fio@vger.kernel.org>; Tue, 18 Nov 2025 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763470815; cv=none; b=oiDZ4XioZExiiEKxs9ErXIoZGCWwWAb2UIZmprxnRN1mFy2nBrdUvgIzacRlwwYJrSyImNqnQ2dHrZr4abNc+0XAs1jQYU/tHALg0rcLJ0xiJxUkDDybUPowuNMB85hpbRTSOHgs0I4KvgoTtYI0n7LC4OxiY0yLK8DIaTM4ncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763470815; c=relaxed/simple;
	bh=qBTHfdozGYl88ykN5zqCtCr+oYbS7XPyV2eGSoaczfw=;
	h=Subject:From:To:Date:Message-Id; b=HV1mQwhRe48AzlKRDtVxrOdpGX6ph6Gbq0GIWOme2z1PrHlb6MnerLgj4bl7V8ae0Q74cv4BId9v5UqPuaCGEH0v6c21qmHUlIxWGTLSWmcmgJGKNrQoGfne5et1PgvEYBDWuFdT5KOpf0KkPOc+lxCh4UFuFDW3nOIEJlTLvec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c3ZcLGhx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c3ZcLGhx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=etKYZAeiWTLVzMcGnSq0S4c+oUQaSzGO+H3Zvw5V1Jw=; b=c3ZcLGhxTmwRt8tmBYxq1B5Kwc
	rULDHypBxpPZrWONOZOZIMcrteLnmTqE4IqOJn04HLI87yv5/ME/yBcRhnMBre9tBcAisj3CydgHv
	FscEf2eCcIh1O7Nx9NOqt3FFlQ+Jbk/2c8/jVYfq6PcQ6QANrECYEDK2NRdn/Ymky+ocpfN/c5NDH
	Z3jfU7JN0mjOwEgotcykNI2ImfnxanaVIqdvX1PLQquMQVjDrarxB1ofqvGHNZTKhwiDC1EYpCskz
	A/zvWHK+58J4/FTE3UZYrS4ygwiuIZkwIV6sxmSXCHcLxp/l2oNXMfh0v0r5NQ9nGpLGbYDZ+7qVe
	m3BL0/Zw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLKRu-00000009gGu-0cgU
	for fio@vger.kernel.org;
	Tue, 18 Nov 2025 12:04:42 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4EEC11BC0108; Tue, 18 Nov 2025 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 18 Nov 2025 06:00:02 -0700
Message-Id: <20251118130002.4EEC11BC0108@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1ad9ac9f54641d737128183dd5639d76fbe24571:

  ci: switch to macos version 15 (2025-11-14 11:05:03 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b2c62314298db2269df5fe9c2454faef677bf464:

  Merge branch 'fix/zero-numberio' of https://github.com/minwooim/fio (2025-11-17 11:41:39 -0500)

----------------------------------------------------------------
Minwoo Im (1):
      backend: fix zero-numberio in dry-run

Vincent Fu (1):
      Merge branch 'fix/zero-numberio' of https://github.com/minwooim/fio

 backend.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 684ea0de..e09c210a 100644
--- a/backend.c
+++ b/backend.c
@@ -1703,8 +1703,11 @@ static uint64_t do_dry_run(struct thread_data *td)
 		io_u_set(td, io_u, IO_U_F_FLIGHT);
 		io_u->error = 0;
 		io_u->resid = 0;
-		if (ddir_rw(acct_ddir(io_u)))
+		if (ddir_rw(acct_ddir(io_u))) {
+			io_u->numberio = td->io_issues[acct_ddir(io_u)];
 			td->io_issues[acct_ddir(io_u)]++;
+		}
+
 		if (ddir_rw(io_u->ddir)) {
 			io_u_mark_depth(td, 1);
 			td->ts.total_io_u[io_u->ddir]++;
