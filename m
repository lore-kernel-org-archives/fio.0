Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A3314533F
	for <fio@vger.kernel.org>; Fri, 26 Apr 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714132810; cv=none; b=u2nK7rg6ojUpJX5uxM16OAYJwMB2xYfH+MV0UecuT/G6jSq51+0cUE6vcNlD/eh+PFt1BF+9LWO67QBVPa58zAYBiQpzIn6GQeWPZryY5UnvrLumO8NeqTy0JyMMtaJ5ElmSrt992vvHrZh1mROnSr5NkJ1DyEZcMPcKr7zcyV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714132810; c=relaxed/simple;
	bh=/70R3DbLKXJ/PbLNwBZe+CHN5UTUfWMHoHQQjbxcDac=;
	h=Subject:From:To:Message-Id:Date; b=sV8Z4SqwBYmA55FLomgAkduBESdMOrQ3oR8rPDwTJ6DRf/0xpi0RduB5lFUCPXdw+aaA+WL8lfEDpImta7uHkzE+ZFbdOiy6bgk4vSamuUL5sPkK08EpTgreA7UFa/jukHr98EREPeCeDC0fD4fbkk8pXm5Y4ovZE1INLF1ufjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HFQ4047C; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HFQ4047C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WJB6oL89nARiqTHsb2nY67R+UrpC5n+Tc2RApFF6MI0=; b=HFQ4047C7vpbL+4W9yrDb5BvZE
	idkHLfbX4uL1qdgHQqvZrFddlWCRxM7FjJkJgC5sD+1knAhCA66+yY2i6GNA+infjdPxA5pjsQc5G
	d2CtSkqobkIaOeeNydpKPGenkeaYqP2eTXRrMNWq8lu2tDsvdncYq0MIZ0nLvUYHSRQdzigfANaH4
	3LcSWPcUdWLNUvD+alaDpVybqNNM8frFOJImmesIZ3NHqZhWK7EYFmWg1Sq9dQEToAzFptu7FVIQL
	l3Zf8crFSWKj4V5u/q1abKseXpl/hmUvYBXa9MpvjYKub/USu+bx1KwxJLaquqNOIadcVQq+ySNdP
	YJl9UslA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0KFJ-000000058w7-0R4e
	for fio@vger.kernel.org;
	Fri, 26 Apr 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A41A91BC0168; Fri, 26 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240426120001.A41A91BC0168@kernel.dk>
Date: Fri, 26 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 349bbcb2e36658db05d5247ef8cbcb285d58dfbf:

  docs: update for new data placement options (2024-04-24 13:44:09 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a9a9bd2c524a7ef58d2fb8181038408155902b8:

  t/nvmept_trim: increase transfer size for some tests (2024-04-25 14:25:54 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      t/nvmept_trim: increase transfer size for some tests

 t/nvmept_trim.py | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/t/nvmept_trim.py b/t/nvmept_trim.py
index 57568384..c990747d 100755
--- a/t/nvmept_trim.py
+++ b/t/nvmept_trim.py
@@ -470,6 +470,7 @@ TEST_LIST = [
             "output-format": 'json',
             "buffer_pattern": 0x0f,
             "size": 256*1024*1024,
+            "bs": 256*1024,
             },
         "test_class": TrimTest,
     },
@@ -481,6 +482,7 @@ TEST_LIST = [
             "verify_pattern": 0x0f,
             "verify": "pattern",
             "size": 256*1024*1024,
+            "bs": 256*1024,
             },
         "test_class": TrimTest,
     },
@@ -491,6 +493,7 @@ TEST_LIST = [
             "num_range": 8,
             "output-format": 'json',
             "size": 128*1024*1024,
+            "bs": 256*1024,
             },
         "test_class": TrimTest,
     },
@@ -511,6 +514,7 @@ TEST_LIST = [
             "verify_pattern": 0x0f,
             "verify": "pattern",
             "size": 128*1024*1024,
+            "bs": 256*1024,
             },
         "test_class": TrimTest,
         "success": SUCCESS_NONZERO,
@@ -524,6 +528,7 @@ TEST_LIST = [
             "verify": "pattern",
             "offset": 128*1024*1024,
             "size": 128*1024*1024,
+            "bs": 256*1024,
             },
         "test_class": TrimTest,
     },
