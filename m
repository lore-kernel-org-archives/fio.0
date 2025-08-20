Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3988E2E7178
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691211; cv=none; b=dM2s3kq7xeVdCTevcAA90mTwi2xd52aL9hNbB6imREeMB41mLYZbVc9QiwXVuYKhbGqDPnJsJs2ZIt6GdSzCT50AmSlVwr/ohsMnpPMbXmMkF8rA1OamvH4X60hdWrMn4ThP0GzfG7+sbSUUfEU2u0tlwBSCvWEOvsY7xtQVX+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691211; c=relaxed/simple;
	bh=wg4AsteT7uyqOMZJFbfZlTfXBa5OPC3H46hLxCIvsI4=;
	h=Subject:From:To:Message-Id:Date; b=gljJbZPu8jnf+7ibMhJHAoLVvNkpxjNRGJwb7HWssFJL5CuVlp40GFu5pVxfpb/6HPe6VtYrJjCLyMHzFaqLqxi9d/PpaGSTmMPZxLhHhP1OsuykzbVcIsPb5w9drOecYKGe5wvY3V68+bgFKA/KqY+0GW3KPvF7h7IavalVt1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZImumnKW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZImumnKW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=e8DHrYD2Me659+O89bwAGcNezp4eHMTqWIzvql6iRzo=; b=ZImumnKWaKcinaZ9+9B6ONiwX2
	KbwJ8ea7Xph5KVl+6WnGi0U0BdfoXPb3fFtXKLz4qJic5B2qIpC45QXsPBI35R9+b1Im+guOAd24o
	LnB9kqzD+Vq0I4SqoOz3GDLF5maT/NrFwNNP995SFHJk7APsEKAZjJZGpmORFl0cUvWqUVhIMC5Mz
	TXKWD5NCf3UqjefuPCQsCDOK1ozGxBhBf46ktM0zwxHkIRVFK2gGD30y+o59BHUL1PcVZZPH1T3ZF
	eO+aJeNFlxC+gpAbliU3jKeadhWV950rmeLs04LgKnZn8NAJVgW/dCyyuzsit87vEgcRvNlOw/Yl2
	7MVXiX7w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uohU3-00000005w8K-3smQ
	for fio@vger.kernel.org;
	Wed, 20 Aug 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C182E1BC0166; Wed, 20 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250820120001.C182E1BC0166@kernel.dk>
Date: Wed, 20 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 7664dccc0b2e3de04a0fd6f0be63402716c5f6b7:

  Merge branch 'http-range-header' of https://github.com/sfc-gh-rnarubin/fio (2025-08-18 13:53:46 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to efaeeea4a8b04e1c315943684aabd84f3198256b:

  Merge branch 'fix-install-paths' of https://github.com/kubo326/fio (2025-08-19 11:09:24 -0400)

----------------------------------------------------------------
Kubo Saburo (1):
      Makefile: fix man and share install paths on macOS

Vincent Fu (1):
      Merge branch 'fix-install-paths' of https://github.com/kubo326/fio

 Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f3a80882..ec6249f3 100644
--- a/Makefile
+++ b/Makefile
@@ -484,14 +484,8 @@ endif
 prefix = $(INSTALL_PREFIX)
 bindir = $(prefix)/bin
 libdir = $(prefix)/lib/fio
-
-ifeq ($(CONFIG_TARGET_OS), Darwin)
-mandir = /usr/share/man
-sharedir = /usr/share/fio
-else
-mandir = $(prefix)/man
+mandir = $(prefix)/share/man
 sharedir = $(prefix)/share/fio
-endif
 
 all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) $(ENGS_OBJS) FORCE
 
