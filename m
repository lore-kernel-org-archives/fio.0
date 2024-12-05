Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FE218AB4
	for <fio@vger.kernel.org>; Thu,  5 Dec 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733403612; cv=none; b=AILwDvYEFGyfFOCb22cnpFcJuqCxqfQ7ykag65AaFhnKPOL4yS2HIf4Zl+7UMNcvAztiHwqX4A+ofUNTbMocEas+rRvBD6o5liSWtc7lYAPsDGfTkFA+qPWEM1VVXF3EsIrbZ/bDRiwv/e6TsKwIyEUN36UdZX/nevYjbTgIbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733403612; c=relaxed/simple;
	bh=efhT/RlmvDMg2ywHfho3QeXfGq+Vig6MkAzjqPbs/Gw=;
	h=Subject:From:To:Message-Id:Date; b=WWNVSblXTKU2zN886AVTw4nD0IYGRxcgGjoBg7m267NA23qYLbKJF71yb0ouYn/5tTUNFeMKGo+tJt9k8h0hJ9U4PHTyqOe03yOZ4MnkM5+15TOAftTJYrlXF6kAKeU6zJPvjMXZkk0/kcKjgMAdFPs/geR7nzUGfJJj/bXESMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AvziVvzB; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AvziVvzB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=m5ncMdm6+UJQ1hcRTUcW6eCvv/3S8wghaJusJ7ff0yY=; b=AvziVvzBGSXQxzLa7M0g3jAdQF
	r1IGJaAxmVMOQ7rbDAqRqoRezc8nOJN4121DfJfdSqf4haJ/zdM1xvLb8dXE254wFFNxV4qxX4ZeG
	bbzydGOM3Jo5ddG0uWK/zvpgJ5/0Sym/ZVQWgnoKMBM6J1NGgtCutXh7hKoz+0S8wUOHk0UhbBxjV
	x1e+KbP3RK13l1MgtgcopZqAMgyGzZRf9apJCzDjJD8G6bwSWpDuTqhmUym1sSwi7uiWKClETEi0j
	7NzttYcX3Yat+FqjmXPRnKnZhtlYi5+r5fnXofDVTZ5SUkwi2kGJTc6IfNrNMlc8bc/yp456VmIou
	9l7n4nzA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJBSg-00000002tO0-3wro
	for fio@vger.kernel.org;
	Thu, 05 Dec 2024 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D0B851BC016A; Thu,  5 Dec 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241205130001.D0B851BC016A@kernel.dk>
Date: Thu,  5 Dec 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit dc03e3788e2b47281b67e9354a7ff02a3053264a:

  docs: explain type of memory allocated by md_per_io_size (2024-11-22 19:50:06 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6f3de5cefec65b1fd31abd79274089282ea6569e:

  stat: fix unified_rw_reporting=both BW and IOPS (2024-12-04 19:00:53 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      stat: fix unified_rw_reporting=both BW and IOPS

 stat.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index c5413f2f..f1984dce 100644
--- a/stat.c
+++ b/stat.c
@@ -507,6 +507,7 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
 	ts_lcl->slat_percentiles = ts->slat_percentiles;
 	ts_lcl->percentile_precision = ts->percentile_precision;
 	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
+	ts_lcl->sig_figs = ts->sig_figs;
 
 	sum_thread_stats(ts_lcl, ts);
 
