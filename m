Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FDA25550
	for <fio@vger.kernel.org>; Thu, 18 Jan 2024 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705582812; cv=none; b=pp5BEU1ACQA+828bEJypeTMxKGTOLjk8QJ7OWylGzoy1SWX7HNuPUS/AsIFgfPa4wMH6CGs6/QXjzFPmUCtselHmgdu+Z7iW/1bIVoyszaiEHmsGEElCZM+LgQkgxN9SvSONPoIaD71IOV6yAtmE0YG9yybRKq/gucPF+hkY7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705582812; c=relaxed/simple;
	bh=3aeRjZAjs1epCY1QdOJo1JwUxo3YMF/CYQpiXXY+nW4=;
	h=DKIM-Signature:Received:Received:Subject:From:To:X-Mailer:
	 Message-Id:Date; b=AwYS9gQk8jWKESU/B8XtZxv86/tzluZyY7UZAnTDJpqQyf+jVjmohGCI/cbT7urh9QiDpIMJfWSYvf/6O4BzUJV03GbVuL2oJ7xRqlbbRl92cC+3Coj2Y8cXo0SMP3JJA0YJQwKExwWV98bPGDdhEBSpDmfKt+OaObXmW1N3Oz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fPpdZJux; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fPpdZJux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aFbGy5KwV6ovrlYjm6SkjIYD2vgMWXxBMRIF6vvjVzo=; b=fPpdZJux949yA63oqxrMHs3Ocd
	QlBjN5AvPy8wgTUzsM5yxABC4ip8+KsnAoqQpzlrWNflr8HQdGUXV9xZW0wk3V3Ziek9tUG9MbZFI
	QuyKnLktOIIo1Mhr5hOwNKbFU1qpUAWwgDEr+K3c/ehIqrIH9Vkg5hRJ2cXjXi1cKU4CHzFBukkVQ
	DbQ9mU/bJ55seyl+WgsST6Q7LLS6fUbyUr9Bs83whj4LtA9StbMEarygfAKv6rkr8cKCDQQ1tRUnn
	iPst7zMyIxt6h9mkHC0IMybIkXwAcwt9VCDnYTTnjbBZkau2BuXorGXqa4HKxpXgwq8LWWOKmx4R+
	OYK1meAA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rQS05-00000002DFT-41GO
	for fio@vger.kernel.org;
	Thu, 18 Jan 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3F5FB1BC019B; Thu, 18 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240118130001.3F5FB1BC019B@kernel.dk>
Date: Thu, 18 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 9f9340cc3a15bca2aa6e883bd5be3d0c9471f573:

  Merge branch 'group_reporting_indentation' of https://github.com/0mp/fio (2024-01-16 09:03:35 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9eefdcc1dd820a936684168468fa9c81960ea461:

  configure: enable NVME_URING_CMD checking for Android (2024-01-17 09:11:15 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      configure: enable NVME_URING_CMD checking for Android

 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 420d97db..f86fcf77 100755
--- a/configure
+++ b/configure
@@ -2656,7 +2656,7 @@ if test "$libzbc" != "no" ; then
 fi
 print_config "libzbc engine" "$libzbc"
 
-if test "$targetos" = "Linux" ; then
+if test "$targetos" = "Linux" || test "$targetos" = "Android"; then
 ##########################################
 # Check NVME_URING_CMD support
 cat > $TMPC << EOF
