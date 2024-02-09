Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B1E37160
	for <fio@vger.kernel.org>; Fri,  9 Feb 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483610; cv=none; b=YQ2zuacaQrB3KIZQWSnWALKI7q/RaGx7NdRxIxWaODDNq/PRYV2/hlZQwGjemH2iOtXqlkekJQtFexXuxyM0iEE8NqO2ZBOlTiPeK+bBC0HHDMtaNO10R9gqjswTpi5PJA8Pvx5dkjf6trXqUuDhV1dclAS6yhO6bgckVggcaSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483610; c=relaxed/simple;
	bh=Tzufd3iTFA0Kg2n+mOYknOxn5eXixUT7XiReRHDcGK8=;
	h=Subject:From:To:Message-Id:Date; b=Fd6vI/yy6LpOoHHnsn2CvcLXPRHzCUZh4PrMgVOIv0skYKyjW0+hcvxD4QjOpF5GwsbgBdqHwHEIlo4jNgcZo16jPYlPdHRjFk7gIldVcIEnknacVyRqZwH4J93QQ7QwQKu1QS/O3OTZ/RjKhqjDn4ma3GUX7yitTi/feFMh5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SUKyxWJG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SUKyxWJG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9nRSPeTXYqH2kC6fvcTdPdj35LFO3G5Uu6HorYZ3ZA8=; b=SUKyxWJGB4xAFBX4xFuTw2/Lu7
	Z5fOoP5gnrU0Ziz9ouRWoMjFwk/EnkR4LoXLjt7E61xffUGN5eE53VxDhaqPbtXp4FLLAC3KY69+8
	a5zZmXGBTAlJkYnnOEcMfcV0/18S8nDEnkaWgEVqhXbEdBPle3M0BfoC5RzEMN51qbSho1ETZoHL9
	e7EWAAqUwjHU5P6GcILR4qpVVwcgnN4w4nn/Hm4G0yIwl8mI5ZoWMeALVyvjtcrlRP9SpzUNnOpgf
	NsN0O3Qvj1Gib5qyuI+vOhRmtEpoOBm2Mkt9lYU9NgZxOT/Zm2U9N8hZlvBm1EZu8Gyuhwa0waYDZ
	EDEUKk9A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rYQU6-00000002xUR-3KCc
	for fio@vger.kernel.org;
	Fri, 09 Feb 2024 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 688AF1BC0175; Fri,  9 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240209130001.688AF1BC0175@kernel.dk>
Date: Fri,  9 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 12067650d11d4777dee0cd64a136923c2fd2d073:

  t/zbd: add -s option to test-zbd-support script (2024-02-07 08:43:13 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9cfa60d874e9a1da057677619a370409428ea3cf:

  verify: fix potential overflow before widen (2024-02-08 17:45:41 -0500)

----------------------------------------------------------------
Oleg Krasnov (1):
      fix wrong offset for VERIFY_PATTERN_NO_HDR

Vincent Fu (2):
      Merge branch 'fix-offset' of https://github.com/onkrasnov/fio
      verify: fix potential overflow before widen

 verify.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index 78f333e6..b438eed6 100644
--- a/verify.c
+++ b/verify.c
@@ -338,12 +338,20 @@ static void dump_verify_buffers(struct verify_header *hdr, struct vcont *vc)
 static void log_verify_failure(struct verify_header *hdr, struct vcont *vc)
 {
 	unsigned long long offset;
+	uint32_t len;
+	struct thread_data *td = vc->td;
 
 	offset = vc->io_u->verify_offset;
-	offset += vc->hdr_num * hdr->len;
+	if (td->o.verify != VERIFY_PATTERN_NO_HDR) {
+		len = hdr->len;
+		offset += (unsigned long long) vc->hdr_num * len;
+	} else {
+		len = vc->io_u->buflen;
+	}
+
 	log_err("%.8s: verify failed at file %s offset %llu, length %u"
 			" (requested block: offset=%llu, length=%llu, flags=%x)\n",
-			vc->name, vc->io_u->file->file_name, offset, hdr->len,
+			vc->name, vc->io_u->file->file_name, offset, len,
 			vc->io_u->verify_offset, vc->io_u->buflen, vc->io_u->flags);
 
 	if (vc->good_crc && vc->bad_crc) {
