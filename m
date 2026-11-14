Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794661216;
	b=czL+HXhBqFlnl9TbdQTy8nh7pG6DrYw2FkMk4lgvgleSUP47D+elPNYKGANRlClMiT9x
	 r1aZ7YHy1Krf/g0BDzGlXKVlfyp28YNiTlLV3jz+CasteDTndvMHDsqLJ4r431iI8X4ye
	 r0kIYvoDsWDXegOYhH65io1vg9jdBbswgElCmqrlGqggLfCirInrD5ay/Cevrl2u7LxBG
	 wakxJneMAQobaQ2DpKzBi5XhaQdI8qMkJZKU3tUY4uYVIQ8c7KFF9rEtkrL/DUJnhpOM5
	 PWH1bJ1MXbx64JOxTbaeeFrsDVMF7Q3QD+27T2BEa2g1Xq/8q3V2JVf7Rzj/x58lxHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794661216;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=vz5R3AwAgvJWXxXWPxS/vm9qqnCZ2M792lQPC1EXNPA=;
	b=09uTqnwo+BQwarAfISR7EEcvnok7JP9aCho21uVyqwpFCa2FBnUPm3uQQAXu+0aZBbN4
	 hFOJDT2BK2yMGZ2djou2l160epICKj1eEN35jdzIA95UNgEJmSGeTv+Tl+nIfGliaf83W
	 DhXPrSxoQa2cp3dEY3euwVTJXcjMeKevy79Z+AA+taVvoLT3yztx3j0pKi9ji35BihA7m
	 g2ZsqbH7cpW3RqonJdBPFbrY7wgkFQR612KP5G2RyJgOHg+C0Q3Nriv33vfYzq8e1OCsj
	 PuSknQIWR3v6n13j7ZRF2VSDgHDwBVNnML7pzpQ6KrfoXr7aMWge5htPzUo9yA6+jlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=LdpHLENU;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8099E606A331
	for <fio@vger.kernel.org>; Sat, 14 Nov 2026 13:00:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8099E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=LdpHLENU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vz5R3AwAgvJWXxXWPxS/vm9qqnCZ2M792lQPC1EXNPA=; b=LdpHLENUx73rHm0pSvFxRyKshh
	p5LHCsxLOX21KjfiR6OXMIpbnOPeemfC8ewftaA0CcXvZIVfzmDJTXI3QB9SDS8KvTRd7HQ5I6Tla
	dWRo6m85ynRmpwBWlVdDYElzPY7BL2P1Lk5Fd0pCAIo1j9S0VZdgaI51ZnqhP4ubCfx7E305AXK8Q
	/SQTvDUtU1HzVKGZTKZokaDT1w8ORUG+4q8k7j7Z7hvrNOX+7oJJjpDN8U2BfClkY/XGQRRUfvzis
	2Watddnrlmxea5I/p8NbhZkJ6cITAA+A0Q4pQ1MlqccrxOktMPZUV18aFftiaA3JQIT5CwW9pYsvZ
	htqHvNxg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSDMT-0000000CIPq-1hKr
	for fio@vger.kernel.org;
	Sat, 14 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 344651BC0157; Sat, 14 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 14 Nov 2026 06:00:02 -0700
Message-Id: <20261114130002.344651BC0157@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 52315cbbe713ec2895e0d9228b3052fb534871bd:

  Merge branch 'docs/support-readme-link-20261111' of https://github.com/ooonea/fio into HEAD (2026-11-11 10:40:53 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6679c58e0524eb0f6bc9ac4981df5314ba450a31:

  iolog: fix macro bugs (2026-11-13 13:13:59 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      iolog: fix macro bugs

 iolog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 166d2fc4..41a3102c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -446,10 +446,10 @@ int64_t iolog_items_to_fetch(struct thread_data *td)
 	return items_to_fetch;
 }
 
-#define io_act(_td, _r) (((_td)->io_log_version == 3 && (r) == 5) || \
-					((_td)->io_log_version == 2 && (r) == 4))
-#define file_act(_td, _r) (((_td)->io_log_version == 3 && (r) == 3) || \
-					((_td)->io_log_version == 2 && (r) == 2))
+#define io_act(_td, _r) (((_td)->io_log_version == 3 && (_r) == 5) || \
+					((_td)->io_log_version == 2 && (_r) == 4))
+#define file_act(_td, _r) (((_td)->io_log_version == 3 && (_r) == 3) || \
+					((_td)->io_log_version == 2 && (_r) == 2))
 
 /*
  * Parse one line of a version 2 or 3 iolog. Returns the number of fields
