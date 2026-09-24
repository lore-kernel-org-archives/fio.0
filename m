Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED8447B42F
	for <fio@vger.kernel.org>; Thu, 24 Sep 2026 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790251218; cv=none; b=uexfzv34sn+b6QGZHQQCue7qWFAY4b5v2m4WKOSc/ydPWULu+yD7dxkyaLFKt2f3SqePXFVVnR1sZW7yv3DWiUEomPsHW7l2ojO0oBQT1aCZCtssz6eTv+yc+2zwgK3K449nqHhq+74PTIy25o5IaXxqm1YinYZSK8B6gODkbc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790251218; c=relaxed/simple;
	bh=070mO64lO4oSo16vFkfWl/hwrJJG+CIdt6suDkVWcUU=;
	h=Subject:From:To:Date:Message-Id; b=W2RPbK9UcRea6VifPQijSsbnp7iVfDRErDMYp/F4JcsZr+b07lm3m+MbcX+FbSR+nd2ICvdGJr4FqVhokZj5HVElGVDWgFxjdhBG/inJ06unLGsDYh+jyElRPTNavVEq0xF6mAVJB7HKsT4SmUGNI7hHcvX3b5OU+6FrmodM67o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SC79wafO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SC79wafO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xgYaSFMDxrO2CuoT/SESktfFcHV+CUL1wj1nRJK0RaQ=; b=SC79wafO8ZSeqQP3ByRvabpidK
	wgv+8Amte7afmob1QKnq/2osAm3Y0JttQ+fdcivotulCmp9KNEXPS4uc2wh4W+oOygnvQimZ5NMtv
	JYUIvYRY7v6v2++c/IzVIVV+poQs6KQJ2vHRC+c9yHMQrAuDmb5ICiOZGbQHFsqonn0i5roGFzKS4
	/iySQbg4t+THz9D8d2Wkg5/Mdc4as6T02MKF4DD2PesjqxO2jlp+MIVrOz2gm3abF691uZtpQu4rF
	uZ1Gymki+REbP5923kZoHFgZJLajguVMBe/v12jgjRj+gVa47kgMiCFNHXopzV0Jwnzj7iAJNZVyy
	f+gm+MuQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9i7R-0000000GaLX-3W3W
	for fio@vger.kernel.org;
	Thu, 24 Sep 2026 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 370BB1BC014D; Thu, 24 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 24 Sep 2026 06:00:01 -0600
Message-Id: <20260924120001.370BB1BC014D@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 47c14c6f35b1c94650faf49b19db568cf38c38d4:

  Merge branch 'metadata' of https://github.com/sc108-lee/fio (2026-09-21 18:16:20 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 270b6fb4e295ef1f24545b72eda33281088b46e0:

  examples: add mobile storage test (2026-09-23 13:34:06 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Fio 3.43

Jieon Seol (1):
      examples: add mobile storage test

 FIO-VERSION-GEN             |  2 +-
 examples/mobile-storage.fio | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)
 create mode 100644 examples/mobile-storage.fio

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index e5ada1de..06ec9777 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.42
+DEF_VER=fio-3.43
 
 LF='
 '
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
