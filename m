Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488409;
	b=p7tAv1QWmQNs5foq5MWHYjrK+mxS88HfGfR2AVdzHKmADozDVfMPzso7c3QKoE13tjGT
	 LcF6LvkOiW1ZORIhWdv7vI6PtiKSqrLiTLOKPZ5EKcd4Pn3vcIcaspiIgcAupA54HYpGg
	 /jDrtZo9mzrVmdmkWJF1e2FeGH1K4QtZhsbzBWyJTcoDoRdsj3/dHPOJ/T6lrYm/KTF/r
	 NP1F/nUQP2YuiolNGe5r+LzSTpr5+Heay0PoT7o+x6iJPO3g0B7pr4UYSiy+kcM2csN+u
	 F2Y8XQnQOsB/EAYytGAYh6s27TahtPEfdYVBcVTANE6yyj0xMz5hH39HxybCJIj6ibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488409;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=/EvLqxYBUT7522UMbW/A8nE5cLP5Boje7/gbIKLUIbY=;
	b=bUReZZx0fp9It1huqKl77MwGyf1SfVf5N1ZtmAGmbMkM+aTzuDk+9V8FzKksPweKx99z
	 4MqCTR9piE9W3vQehzmpkws2crWLOnsMRkO5diXIzguJHdNQ1A7cmnp0sJ9fDhDDkTDt9
	 AQyzbiWt9r6dx0Goexl3a80fvXTVo5evz+/OKYmjdMC8JEDPL05x1PJ2OOsgF9kBNIOoS
	 0DSO2Ho0DzYsaNoEljrULBrCIvcUHWP4yE5oz44OHlFZZ87w1lVoN1E/ixwjHV7AGUkOM
	 K8P2A3+c83fSxfwDj6T0zhQ37YyWkQV5xBi6o1DJ1HU+BJ1eM3jlJXN5TKSyJn7cKbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=lFxOOUKB;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C4C606A89A
	for <fio@vger.kernel.org>; Thu, 12 Nov 2026 13:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0C4C606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=lFxOOUKB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/EvLqxYBUT7522UMbW/A8nE5cLP5Boje7/gbIKLUIbY=; b=lFxOOUKBYdFcZvAzMDQ8WVs7G7
	eLDsfVQdHs6CG9zADYYF7LfeOCiZaRtdOitYo0sPiBwpPLEZ7TyZ9ye8cHdj9NjypXMlzMeLa8NL0
	LFcfcvhuMZ3qZd0rZTXX3bOSo2o9wOam6JFZTiE+zKDQr2AAneNEVy++NHVS12nnq2RAzQwmKk6Vk
	ySc4/lCoO7OfcQEDhGtggq+CBSM8qGb9TfFLDaUl20BlfIUmsiP2vjt4/Os+E/PcROOghjsGH9BUW
	EXQMN5pXZXO/versLvno3ucD9m7xEIAQ+7mTMuKAwqjvXkAtEOrebKICSL509Kbvb3iClClysIsPF
	KZqo8AFg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRUPM-0000000ALVx-3WGO
	for fio@vger.kernel.org;
	Thu, 12 Nov 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 082A51BC0199; Thu, 12 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 12 Nov 2026 06:00:02 -0700
Message-Id: <20261112130002.082A51BC0199@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 290c2b255c6144b2601a665f0582590fcf735a76:

  Merge branch 'fsync_flags' of https://github.com/Panky-codes/fio (2026-11-10 12:56:55 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 52315cbbe713ec2895e0d9228b3052fb534871bd:

  Merge branch 'docs/support-readme-link-20261111' of https://github.com/ooonea/fio into HEAD (2026-11-11 10:40:53 -0500)

----------------------------------------------------------------
Giuseppe Piscitelli (1):
      doc: Fix the support page README link

Vincent Fu (1):
      Merge branch 'docs/support-readme-link-20261111' of https://github.com/ooonea/fio into HEAD

 .github/SUPPORT.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/.github/SUPPORT.md b/.github/SUPPORT.md
index 8d9df863..fa368868 100644
--- a/.github/SUPPORT.md
+++ b/.github/SUPPORT.md
@@ -30,7 +30,7 @@ pictures of screenshots as these are not searchable/selectable.
 
 <!-- Definitions -->
 
-[readme]: ../README
+[readme]: ../README.rst
 [reportingbugs]: ../REPORTING-BUGS
 [releases]: ../../../releases
 [quotingcode]: https://docs.github.com/en/free-pro-team@latest/github/writing-on-github/basic-writing-and-formatting-syntax#quoting-code
