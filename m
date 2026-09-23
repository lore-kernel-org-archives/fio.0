Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1E949AA4A
	for <fio@vger.kernel.org>; Wed, 23 Sep 2026 11:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163811; cv=none; b=u8H+SGC8If9TES9P9JBCP3CGBKvPpTlrXb69cLm+IfMbOYAoaFTXbr56IvlzPkc22RxRSQqpPn5jCtD6zT/qmMgKZ7qZqUueccxUdRhl6qrRmiU+4EURoigOoipgMqeQd2c35BabY67oFU9dSZDq1Lb9Mvc10lH0NWraO7fg+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163811; c=relaxed/simple;
	bh=kywrJUNFpfYORr1TUZj/kXO0OQvTXr1BWb7YhUdJuco=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=V/Jq1gpDWWD6v4BQHgCzCAsLUnC0KaHrhsyAPUY1KmMbqtgnuQp+EVXXRct2zgOEBZlgOUZQFka0i4uzyqAzlMIR3U7RU/PZaP4WEJGeyKAfOGi1Dxx9u9cRrkMw5hhbWohFbOSxjROw4PsMKmJlRGPZJVbSl2P83xbA7wKR0l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=P3Acn1Ny; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P3Acn1Ny"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260923114316epoutp03fc8dd1445626cd127fcf7af2638aaa16~X8H0FrWm30066900669epoutp03o
	for <fio@vger.kernel.org>; Wed, 23 Sep 2026 11:43:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260923114316epoutp03fc8dd1445626cd127fcf7af2638aaa16~X8H0FrWm30066900669epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790163796;
	bh=Zu+4r5XJijS0qmshnk1y5OI/kElqbkZszFndhXM3rpk=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=P3Acn1Nyuh0LC4hOrVDQOSD1fgXZwcM3wsOLojyN77+KWtQBJkp46i6gH83Vyfxsk
	 TJf9GfhWrge9otq3VMQ8GDcjquRE21eWoX+23pSQG1m3FXtsVVap6czknJ7a08sZ4k
	 vmWYSQPGxuSaFZSx/bGLZjdv8bBw3/fJUnvOZVZ8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260923114315epcas2p36c605ea6d78a8cba56e9beffc5539dcd~X8HzWeRwA1787817878epcas2p3_;
	Wed, 23 Sep 2026 11:43:15 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.209]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hqZpq3NQKz3hhT3; Wed, 23 Sep
	2026 11:43:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2] examples: add mobile storage test
Reply-To: jieon.seol@samsung.com
Sender: Jieon Seol <jieon.seol@samsung.com>
From: Jieon Seol <jieon.seol@samsung.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
CC: "vincentfu@gmail.com" <vincentfu@gmail.com>, Jinyoung Choi
	<j-young.choi@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
Date: Wed, 23 Sep 2026 20:43:14 +0900
X-CMS-MailID: 20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce
References: <CGME20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>

Add an example job file for basic mobile storage performance testing.

The sequential workloads use 512 KiB I/O with a single job and
transfer 1 GiB. The random workloads use 4 KiB I/O with eight jobs,
each transferring 128 MiB against the same 1 GiB test file.

Use direct I/O and run the sequential read, sequential write, random
read, and random write workloads serially.

Signed-off-by: Jieon Seol <jieon.seol@samsung.com>
---
Changes since v1:
- Rework the patch as an example test for mobile storage.
- Rename the job file to examples/mobile-storage.fio.
- Use a single 1 GiB test file for all four workloads.

 examples/mobile-storage.fio | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 examples/mobile-storage.fio

diff --git a/examples/mobile-storage.fio b/examples/mobile-storage.fio
new file mode 100644
index 00000000..c8664588
--- /dev/null
+++ b/examples/mobile-storage.fio
@@ -0,0 +1,31 @@
+[global]
+filename=mobile-storage-test
+filesize=1g
+direct=1
+group_reporting
+
+[seq-read]
+rw=read
+bs=512k
+size=1g
+
+[seq-write]
+stonewall
+rw=write
+bs=512k
+size=1g
+
+[rand-read]
+stonewall
+rw=randread
+bs=4k
+numjobs=8
+size=128m
+
+[rand-write]
+stonewall
+rw=randwrite
+bs=4k
+numjobs=8
+size=128m
+unlink=1
-- 
2.34.1
