Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920409;
	b=Us1epLeyayLPmGplIyHAnzXjWEiowyKJuvaDbxbKhJYHAhuLqIqQhKU2nRwT+JcYUy1P
	 opyb1WCe1J44yRElMIJMQYZjlMy5EF8Ak70Ui8nh6fESA9+9Em8KYzklHrIZfyW81yd0G
	 03taovpoJy9dk3VzTIgmCPrmU2EoW4TqwDMjtNos/JiviKEMoDK5VOhvzOx2mpUBKFf4k
	 1EEBJGZbpPsf0i+2JZmrbeJx9j8nXcs3middNlPYRXtEbNQ7Xq65ry9d10e1ZzQ1a4HPj
	 FhrW7lqe987tTcthFt3Ikk1tZE57IqmrPgEquQGEkyza4P73IkUv8pLgbuY2OKrWisA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920409;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=EXkHX2xs4wTYV57IE9r9WWsyv2C11iZa29xIvBeFMzk=;
	b=g/0gNw8QF3DuhTdRt4SmlBzfBS2sj9Q50HceWuihAngXevS22iXKfdCMgZ1K/hRLRj2k
	 vVRLyd5EVmSJg15LFMRnDwGr0sqDxNZlY4SxB/GrZHx0o7fyfk5w35tMGlOOTcF/fr8tQ
	 BZFztOaq5f2eTF01/KH6lfPaPaaSnU/SnK6CjeIIsVXh+2d8qmSRCqabeuwZ3Nci1i3eQ
	 TCB0Lqg80HvuQMEDkax5IV24u3PLlx+j2vJvCTvPPUx1DDFkskrQx1q+2/TKpmQqH3FNX
	 q+EV4KBvDvy3YeQ8/MEeqnjo1zGVUbgfivSHdPJMCB0hBp4o55/arqQnZBmkVUCOJ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=v8iVTyfs;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3A8606A8AC
	for <fio@vger.kernel.org>; Tue, 17 Nov 2026 13:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF3A8606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=v8iVTyfs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=EXkHX2xs4wTYV57IE9r9WWsyv2C11iZa29xIvBeFMzk=; b=v8iVTyfsqOl847GRJDOw93LuLf
	S+wjlZU6DA7x7OLt34wms2TiYzMjKZpHD+nlqH/dWSH3OsNimhGUcV54rbsPYSFfvW9s9AKp+af53
	QEQga5dv6fN77em6smtxfVoeO2KJMz6oTL5DHb6IllXelNLZeuEgCIPb5rctaJctdfYTzic3SoNmz
	WtoPln0JDcLBoZutNSuKLz1nnTToOCaIJd5jyOmEzQBpJHBhCpj0S7lrBMvwghyiFaGDoxqB6hYAK
	yC5WftPFLceiuCo2WwsQ3kihuOO563Jcvqd3iZ4VVQK1PnbE3Xrk4SoMxV+Id3ksxPP8w0DdZHgMF
	h498oTLQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTIn7-0000000FsaT-2VVU
	for fio@vger.kernel.org;
	Tue, 17 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1FF171BC0159; Tue, 17 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 17 Nov 2026 06:00:02 -0700
Message-Id: <20261117130002.1FF171BC0159@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 6679c58e0524eb0f6bc9ac4981df5314ba450a31:

  iolog: fix macro bugs (2026-11-13 13:13:59 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6abe06547f4ad296ea62cd1a2d55fc5274059c77:

  Merge branch 'fix/verify-default-stack-20261111' of https://github.com/ooonea/fio (2026-11-16 11:25:16 -0500)

----------------------------------------------------------------
Giuseppe Piscitelli (1):
      verify: bound the stack size for async workers

Vincent Fu (1):
      Merge branch 'fix/verify-default-stack-20261111' of https://github.com/ooonea/fio

 verify.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index a978aff0..fadb3033 100644
--- a/verify.c
+++ b/verify.c
@@ -1598,7 +1598,8 @@ int verify_async_init(struct thread_data *td)
 	pthread_attr_t attr;
 
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, 2 * PTHREAD_STACK_MIN);
+	pthread_attr_setstacksize(&attr, max((size_t) 256 * 1024,
+					   (size_t) PTHREAD_STACK_MIN * 2));
 
 	td->verify_thread_exit = 0;
 
