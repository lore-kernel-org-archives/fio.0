Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6593B7F481
	for <fio@vger.kernel.org>; Tue, 19 Mar 2024 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710849619; cv=none; b=Ac/mUyuk9+PiV81tT238OT/CnqhItTqrhnhr7WGD9zyJpXr+caoYOXbTDB35i73lB/htDrPVN19NYjuY/RMjqO2cJLWyQzfcBQE4XJ65i5gnM1zG0R3gOGorgSMbYCefR2XSZ9ge9NO2TKwDFqo8Y3Y58t/AeCQMLLvHq98wCcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710849619; c=relaxed/simple;
	bh=9upFhlFmP4gADn8qOnxjC2oWkrQMZJDCQvxf7Lmj+FA=;
	h=Subject:From:To:Message-Id:Date; b=nFY8Rwk8bCsMl68qvV8KjzEWvlKFnzhU0MYbqDqA1QXaN6gqZbDXK7wzccGf5VDwZXl9zDK4buMR6wqab7By6HobCqprM84plQl0JoFA3AFj+20UKY0YeLvgSoZsOogkmJOOuuoFW/0MUkcpUIvRlnfY4lCtDvPqhw6v+Qy0N2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ton3Sn2x; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ton3Sn2x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=dMMR9l+szlVqrfLcHZCrcQIMTaAueXKQeKJ9se7GUKg=; b=Ton3Sn2xnCsd5rz1C9vsPmNtwu
	+saoqqagvlLmiq+/f9nGnygmJa11pWNmUPgOpigckALGPbBmSEMnP7YYSurLTBGqyjG4INHw6Matm
	SXO7jI4enkqs72FAeIQIEQH2LbcyHAxaBMMiAtXuATgYvlVXeWjvkMDQxXh4AiSJ6/KJ8CxdVUM6+
	M1oZiGwKaBSdWLWi9qmh8WkhVkz9ZUjbHAYnBCW5JIIOgSwEfEfd4V2m0PmGYb5YK0On4MX2KWtuX
	UFM4o1w+KKTQOjcFXhBY1e8Mxd/1vTjAIKJ+Xjy/OBhrSGSom3LQS8pnzgXhWRK2GS/jkW4NXz8Hz
	Wio2GG9w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmY8Y-0000000DBc0-2ZY3
	for fio@vger.kernel.org;
	Tue, 19 Mar 2024 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 91CF61BC0133; Tue, 19 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240319120001.91CF61BC0133@kernel.dk>
Date: Tue, 19 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b140fc5e484638a467480e369485b91290288d58:

  t/nvmept_pi: add support for xNVMe ioengine (2024-03-07 19:36:30 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7d6c99e917f7d68ffebbd1750802f7aed9c3d461:

  docs: fix documentation for rate_cycle (2024-03-18 14:51:10 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      docs: fix documentation for rate_cycle

 HOWTO.rst | 4 ++--
 fio.1     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2386d806..4c8ac331 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3323,8 +3323,8 @@ I/O rate
 
 .. option:: rate_cycle=int
 
-	Average bandwidth for :option:`rate` and :option:`rate_min` over this number
-	of milliseconds. Defaults to 1000.
+        Average bandwidth for :option:`rate_min` and :option:`rate_iops_min`
+        over this number of milliseconds. Defaults to 1000.
 
 
 I/O latency
diff --git a/fio.1 b/fio.1
index d955385d..09c6b621 100644
--- a/fio.1
+++ b/fio.1
@@ -3064,7 +3064,7 @@ ignore the thinktime and continue doing IO at the specified rate, instead of
 entering a catch-up mode after thinktime is done.
 .TP
 .BI rate_cycle \fR=\fPint
-Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
+Average bandwidth for \fBrate_min\fR and \fBrate_iops_min\fR over this number
 of milliseconds. Defaults to 1000.
 .SS "I/O latency"
 .TP
