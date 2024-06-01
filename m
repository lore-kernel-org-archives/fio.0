Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E914F132
	for <fio@vger.kernel.org>; Sat,  1 Jun 2024 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717243212; cv=none; b=D6qewmtjQbDhouEsqOwhJcXo3IClpNJEhCK6dxn2XzyJNcaA0oah/AmdIyBq4FmgNrjbvxtAglSi20irZRfjoBcnO3StDYXhImAj4+hw3Tx/CWkxWdPNXrkcPoFljkiYBN0GF2YYpJy9xwDu367M593tRouscsvwL49Mm0wlIks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717243212; c=relaxed/simple;
	bh=vdIV6JUXFMb5lVzpRfnPa7F5At0YL2OIciyv3HMKim0=;
	h=Subject:From:To:Message-Id:Date; b=a+C7s8yqiy1Xgh53Hc7xn1P20kmD7PdsEYgjHKULfsn9G48OXHkfAnYOv9/xEQ+1u8aAP4AvrqNsu5Qt4p0L0+ksNUwzAksBvPjvN/z7CHQ9UQVyzlngvVggVhPOMGLiM4wxMB4hre6yNSX3h95pseLdnnsIL49TRc0K8OXtSrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZgyWTk35; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZgyWTk35"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DqcF83oCpXPVxadYDr/O0eBSgZdgyj/K1MFwxBX718E=; b=ZgyWTk35hTRG2WIfHwXyD0nKU2
	pki1WF9CZM8v+FFh+DT9w0BeFPLbZBVtG28VBsggXI23TaJCL0i9UdrzLxHP5elTbEJ5yFT5uamZM
	bZ2zvvsYpVwNjaY6+65RiKgIg86EfV6TZCf4/ow0sQ2mpds2Xi11hpkWgh4sTt+5nCv3U5NLKD+Ai
	7hqAnS+rK+GOtRAe4aIvD2ddIsTRXEd/aL4X+QQnauZsUJ0BCriiQ1BdDc1zNYD8trMTyPvGIoBHc
	KA67oAgBhiV8HMblcRKage5iwNYoWw/326hQgHcY2drbGIj7QJHKxaxm0K1NWX+UiyrJ5TMOeJthC
	weOixPuQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDNP1-0000000F1VR-3eQp
	for fio@vger.kernel.org;
	Sat, 01 Jun 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 326871BC0124; Sat,  1 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240601120001.326871BC0124@kernel.dk>
Date: Sat,  1 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d5fbe84b83999d862838f36ea0d4a499e31f0653:

  Merge branch 'enable-dataplacement-while-replaying-io' of https://github.com/parkvibes/fio (2024-05-28 14:19:19 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93dc85482a998440f8e40814014da8cbfe9cf5e8:

  Merge branch 'fix-coverity-scan-defect' of https://github.com/parkvibes/fio (2024-05-31 09:46:59 -0400)

----------------------------------------------------------------
Hyunwoo Park (2):
      iolog: fix Null pointer dereferences (FORWARD_NULL)
      iolog: fix Error handling issues (NEGATIVE_RETURNS)

Vincent Fu (1):
      Merge branch 'fix-coverity-scan-defect' of https://github.com/parkvibes/fio

 iolog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 37ad0d2a..b57f845e 100644
--- a/iolog.c
+++ b/iolog.c
@@ -145,7 +145,7 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 				int dp_init_ret = dp_init(td);
 
 				if (dp_init_ret != 0) {
-					td_verror(td, dp_init_ret, "dp_init");
+					td_verror(td, abs(dp_init_ret), "dp_init");
 					return -1;
 				}
 			}
@@ -236,15 +236,15 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 						io_u->buflen, io_u->file->file_name);
 			if (ipo->delay)
 				iolog_delay(td, ipo->delay);
+
+			if (td->o.dp_type != FIO_DP_NONE)
+				dp_fill_dspec_data(td, io_u);
 		} else {
 			elapsed = mtime_since_genesis();
 			if (ipo->delay > elapsed)
 				usec_sleep(td, (ipo->delay - elapsed) * 1000);
 		}
 
-		if (td->o.dp_type != FIO_DP_NONE)
-			dp_fill_dspec_data(td, io_u);
-
 		free(ipo);
 
 		if (io_u->ddir != DDIR_WAIT)
