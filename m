Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10732BF3D
	for <fio@vger.kernel.org>; Tue,  9 Sep 2025 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757419212; cv=none; b=JfZ5ZLZ9VKXzsfSYlc5nK2zB2s/OrWMyisQwqpEaXAtS79g52KnIwAXGcQaqzqxtwYqyVpYnUmEcy+cNwpuk6M6IKKou0u1d+bvevC0CEntTLIRnh50Qiyludj8L5JyHbCLOFnReRi0SJ8sYZ8u9U4RzfRz5XfN7qk2OLegPD8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757419212; c=relaxed/simple;
	bh=W+17sQ8VLrsOaoqnQwRcfnWaXwz+gpRLN7uzI3RB27U=;
	h=Subject:From:To:Message-Id:Date; b=Ii75y9SQQDHOph6kY+2cXXawzrnorgFrTQC8FlUGIhJq/e1ns4rQUkxI5QjBBznZgfsdVN/jL2aXVjoyn26ut0YW6bH5F2eFhdLvci3zfhKXQ5eQna34IUSQsIcrXJCamdVkuGWJ5H/JlB9rti2ldQRlIhNuIFZklHOuy9wiBbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CEBASHJD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CEBASHJD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SHtHS5Y4U+qNJjdAshYVesiOdN0HLjKuvWw9mRIXtgM=; b=CEBASHJDNS6kzORhYJ8lq1lqJg
	FrR29NGC9y6zqxNxws6VCUgGuKFIvFJFkv99UQD9KVKE7rYRLNodWH5DIQOv2i08+vbTiIoVMuYdg
	pKZP18hi+IuJfzz9XCpeU20sIQgajrSi9nZLsUc3g/Cp/1M+2/Ra60uTSCoDomk/0uvbwIz2KHpmo
	XEpWpW4D+uszoRRQn+r/NvInOJycqqhhS/70kO6nu/3vIxhj3mf1dDIdoGHzJFaJeuCrtyvn1bl4G
	CVVyiS2VkMJE6w2M/6Td0dnya21WgFBCjGyQBeydThiugTO5ofVbUfsZloUTVJ5LMMImEW0soIDZ9
	uKNuYS6A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvx13-00000007GW9-2KZd
	for fio@vger.kernel.org;
	Tue, 09 Sep 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2B81B1BC017A; Tue,  9 Sep 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250909120002.2B81B1BC017A@kernel.dk>
Date: Tue,  9 Sep 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fc8f9c7f98156d42fc73fbd6df3c4aa9683df621:

  Merge branch 'improve_flushing_darwin' of https://github.com/Developer-Ecosystem-Engineering/fio (2025-09-05 18:05:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 84787adffac2435e72f6f08336e32559fd31e3a0:

  Merge branch 'master' of https://github.com/Meiye-lj/fio (2025-09-08 07:57:10 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/Meiye-lj/fio

Meiye-lj (1):
      Makefile: fix missing test tool and unit test dependencies

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 2fef67d3..aa6e27df 100644
--- a/Makefile
+++ b/Makefile
@@ -320,7 +320,7 @@ FIO_OBJS += lex.yy.o y.tab.o
 GFIO_OBJS += lex.yy.o y.tab.o
 endif
 
--include $(OBJS:.o=.d)
+-include $(OBJS:.o=.d) $(T_OBJS:.o=.d) $(UT_OBJS:.o=.d)
 
 T_SMALLOC_OBJS = t/stest.o
 T_SMALLOC_OBJS += gettime.o fio_sem.o pshared.o smalloc.o t/log.o t/debug.o \
