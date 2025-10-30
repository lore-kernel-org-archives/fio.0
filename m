Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE6333F37F
	for <fio@vger.kernel.org>; Thu, 30 Oct 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761825612; cv=none; b=r8O05Mk/h33swZgk73HA1XOVGH9ZWmx4cg1rmi9Kugc9JUQW03oHLobyUcJfRHzP44nrpE6RLi7b+Xwtx8rx6frqxBnNnbOZ1QZhXy6RNTwXbBwcXHlHJ+XY3SjnCWc6ZMQQ9CuuIptZ/nt0U/6/2yh486Cx50GraCCLUgB6SkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761825612; c=relaxed/simple;
	bh=jiZddGDro4D6xV/qm6jk8o8ArnvUjDaNgmJhK8CAmkI=;
	h=Subject:From:To:Date:Message-Id; b=pao61RkWCMTQmqFWMcxLlzoil7kjObw5ZakCqSTJEt2ypQi+Da6fZ7xX1sygmiLW+jZSQ3bOdTWL6TsBfbXKdo5KZeso0L7a4AqWchcZe8/ZZZw9VnEfzYGyLLbHzIdP5OFVDAJc29lMnBCNPTSjy5ugNXp/P4frpBJ2ZYVWS/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hxDl5T2M; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hxDl5T2M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pilBn4OWVBHneSwfcQhIS9iOoVwbZCS6FfWdA1f3q5I=; b=hxDl5T2Mqx6LhQXdIdg7U2WEkz
	YubfneZGDEHcWcUZkVarP9X8it7rCL6+7wlDqMnQ9amg0gTHO7HEdxruQisWCEzn5YVHDo2zVmTpJ
	Gkjhi3N0PMZmoEojbFtJpyMr91Up6ZpXPrF+KFeFVUwl85LvU67LdyOYx0waX+xSHRMtuXQgGU4+V
	Ir24I9DvHNUUR24d7InjKBiVfobhzaR3+GD976ndmusqty6WpdygscGU0CJag8ObS3OjFfTZtg5+U
	2c1bIIjFtqtAyNZe1LdxUwQ1MFu8Y5ytw8q2ezCGGt1RHHQV83J72P7zTxK7mhsEjRW3e8XFWyDcW
	D/WoyXUA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEQSH-000000091WG-1yo9
	for fio@vger.kernel.org;
	Thu, 30 Oct 2025 11:04:33 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 97CBB1BC014F; Thu, 30 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 30 Oct 2025 06:00:01 -0600
Message-Id: <20251030120001.97CBB1BC014F@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 967de14b99c124aa0bd8269cbfa230147faffab6:

  Merge branch 'hist_coarseness' of https://github.com/tachyonwill/fio (2025-10-28 12:41:15 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1eb3adeed3eebab22dc5d7bed82ee23012fe360e:

  Merge branch 'master' of https://github.com/pirDOL/fio (2025-10-29 10:57:59 -0400)

----------------------------------------------------------------
TOGO Li (1):
      configure: support --extra-ldflags

Vincent Fu (1):
      Merge branch 'master' of https://github.com/pirDOL/fio

 configure | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 43e20ca9..b1009f70 100755
--- a/configure
+++ b/configure
@@ -215,6 +215,8 @@ for opt do
   ;;
   --extra-cflags=*) CFLAGS="$CFLAGS $optarg"
   ;;
+  --extra-ldflags=*) LDFLAGS="$LDFLAGS $optarg"
+  ;;
   --build-32bit-win) build_32bit_win="yes"
   ;;
   --target-win-ver=*) target_win_ver="$optarg"
