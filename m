Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883609;
	b=b9iyYnyCjFfk4O6eKv9l7KSsErBl/Vw/UIs5akDKUkL2qXxvBckynburad2l40XfTPon
	 tk8KjHYGy3U8E671nR4bagcpTAj//Y9SiXkvPXfiUk7uU9Q9hZv1fwgCBRg9GLVvmfYkf
	 6z18sCDX0m1UNi5LW3FnuJDRgmBr1ME/v82a/5tuuq5r5OW7ejoGw5aAWJXI7gw75C/Iy
	 Hq+hUU3Z5HmPbKVl4VNqb/Q/MHMhufmCnGk57nlrzT/t/sWgCl5193ughuOEyp+ijb8qC
	 Fw8Kic6hfNITEKkiIA32RsEcFpPHG5j7bO2SkMHqEKu/VgHWA+yRU7IpneEgdcdDPIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883609;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=PRt4m9MeEPTIceYIWn68Xwr0ZyJuGMEELsYv0hDtJls=;
	b=acLqeCLik71l8txM7v/V+C6ljvQ0c25Oz0E88yvBzGd/CSl5fFSHnmkqL+URpqbifl2F
	 wgdULnm8h1YzzFN6JVsYpSf3f5FuH0hgFc4yGEDSqDWObm8bk4GaAkqf3CQcW0WOWsvs3
	 W0AFtRV4rj44UcE1MsViOGNkeyxjQRQCS8i0rAP7buXxamLge3goh50ebHbjgizqL22t0
	 FmsnNQQvqBXvm6x6z3DpZ/KV8/x3xVKNHRidf6gvITA3g2S04DcEeB2ManQLnai35pbm/
	 WSLO03j2VPL3RQsbOi23spnYEvWOQ8+JegzjelGaYi8BZmKVOpSOTwvpFmHMncD2Kaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b="aaj/M2bk";
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC476606A31B
	for <fio@vger.kernel.org>; Thu,  5 Nov 2026 13:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC476606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=aaj/M2bk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PRt4m9MeEPTIceYIWn68Xwr0ZyJuGMEELsYv0hDtJls=; b=aaj/M2bkWg94sAncwmuuXm8ayp
	dATtDa+64cem2yOoOmAdoz/LluTkBp2B/byFF37Lw1BIxoOPP56m4HLU2s2yuZ1oOnpX8HmHVITvg
	du8UnAhnKbSapxqOCKDomqB/IKBNb5snV7ypu09xzGCzQeWezx42E59nWesiTOAtZRc944tXPmylz
	ycrR0wrqxWZrQyPi329CQo9s+l1S4MQB9M1UIjjJ3fqcbCW3Hp9iByPSWeuxog3adirRrk+m67oZE
	2ZqXP/0XUMj62sFMRYxAoFzbvUyLcmtcEavOxFrhBsL2IK5wIcjzskMel8Y5ty85crTf5AhtiP972
	aebxtPRA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOx4W-00000008Ols-3ivK
	for fio@vger.kernel.org;
	Thu, 05 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4FF231BC014D; Thu,  5 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  5 Nov 2026 06:00:01 -0700
Message-Id: <20261105130001.4FF231BC014D@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit d645e90502dd740f8c7b6df8b17d35151df8bf3e:

  Merge branch 'fix/io_u-offset-stuck-fill-device' of https://github.com/hmi-jeon/fio (2026-11-03 20:02:51 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a4370979fc878d914db27673f2bd7f8b933b8fe:

  Merge branch 'fix-read-iolog-sync-max-bs' of https://github.com/arethusa/fio (2026-11-04 10:30:29 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'fix-read-iolog-sync-max-bs' of https://github.com/arethusa/fio

Willy Yang (1):
      iolog: don't index max_bs[] with sync ddirs in read_iolog()

 iolog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index cc13ecbb..0926053d 100644
--- a/iolog.c
+++ b/iolog.c
@@ -610,7 +610,7 @@ static bool read_iolog(struct thread_data *td)
 			ipo_bytes_align(td->o.replay_align, ipo);
 
 			ipo->len = bytes;
-			if (rw != DDIR_INVAL && bytes > td->o.max_bs[rw]) {
+			if (ddir_rw(rw) && bytes > td->o.max_bs[rw]) {
 				realloc = true;
 				td->o.max_bs[rw] = bytes;
 			}
