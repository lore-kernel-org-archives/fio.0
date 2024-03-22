Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD020DC5
	for <fio@vger.kernel.org>; Fri, 22 Mar 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108810; cv=none; b=gnQQ/FlQCfd3lxndBkbQh7p4wkIYVEwmooK0Wr1AAofDf5zZBmZTjiDR7pVF5xBQnjV3qI9KKFbjEN2KaDLrbfehfJ57GRCTE+FgRqx7Y6qt318tWqiD6ZskWfZTUA65ssP2Ts67dh1W7xRlrbp/ORFg7tlIsHLiCRX9BsTH5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108810; c=relaxed/simple;
	bh=AN17L3dB4jL8I9wN5ocAuBwZ/6mSggb78pXyP/Tt0nI=;
	h=Subject:From:To:Message-Id:Date; b=fLa6kauAzvjhhq6DzlEs5F08ftWlaF1+9DfimLhe29rWg5s85+ZFPZqJx2tl5EVxPE8PX1JdX1h/UDmua2GwarN3ZBdEZT1Hh+CRPqg7ldO40l5aOVchAELJqruq/keqZWmFV6cmKH0xYupm7wv3N2y+HurLsS9AWX8baLtOnwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OjblL6Zv; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OjblL6Zv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=U5gREQ9YL0zHKKu/zvGkjDstiKfyk0zGiiZHIbIAGio=; b=OjblL6ZvfOL+f7eMnX1yzLlDdf
	bzZ8H13a8NjEUbjPuJxYrvYHMB2mNU+t9G28N0WBIxIw+Ygq/EGS3czuGtjVoBE/ir9c8hRvSw1DT
	hd10KmEHYD/gZ5vHu9oRKpR/bcnIaQIbOT2TDbboUbJYShea1159NCRSxxpG02RY6GCTi1BPtJHAH
	D0WlgDGptHA4uzDfPamQc0aDbwvTNT6OpjQmIZZxjGgUyug+LG5vg2M/Bl4lEIIT6v8bsjjGBj2YE
	UhnDWyn6n6G3O+CuyGdmEDz+jStZ40oACKcuNtg1hI/KDCkKkc2kqFXq1ejU1SICiTkEBWSBg2PDa
	W62gBGVg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rndZ5-0000000Elvs-2MvN
	for fio@vger.kernel.org;
	Fri, 22 Mar 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 383391BC0163; Fri, 22 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240322120001.383391BC0163@kernel.dk>
Date: Fri, 22 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 140c58beeee44a10358a817c7699b66c5c7290f9:

  test: add the test for regrow logs with asynchronous I/O replay (2024-03-21 05:57:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 20f42c101f7876648705a4fb8a9e2a647dc936ce:

  t/run-fio-tests: restrict t0031 to Linux only (2024-03-21 08:36:14 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      t/run-fio-tests: restrict t0031 to Linux only

 t/run-fio-tests.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 1b884d87..22580613 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -876,7 +876,7 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'pre_job':          't0031-pre.fio',
         'pre_success':      SUCCESS_DEFAULT,
-        'requirements':     [],
+        'requirements':     [Requirements.linux, Requirements.libaio],
     },
     {
         'test_id':          1000,
