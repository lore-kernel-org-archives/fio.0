Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E7223DDE
	for <fio@vger.kernel.org>; Thu,  8 May 2025 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705612; cv=none; b=nPV2ynQrGyTlQCKw1lUAnx5gcCPx521Nw16jyO+4lEsY2RzaVor/+rOgxes4ZDOi2MJUYTNejAZ/veFKYbdjrlXaXbuaEcI2yNzFMYhrwbmNPyIz9MhLvWUHOlDxkiWg6FyVba/SsnYF5KyL0m1xEnz4uFJpAz1Sh8IsmnohRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705612; c=relaxed/simple;
	bh=2goCj0HnaZ+/VPHMdcPXhOovwrVl1uH0ZCivEtvtHAM=;
	h=Subject:From:To:Message-Id:Date; b=OxE8UrL4vM3aaHTs57Y+qMc6/8nxXtE0JuCZghLSf76UTvJPAPyF26k1EPgZjHR5PJv9FsPWJ6SB5MFL5LsYIZ55pZxXvx4qccST7+VU/i5bdWp5csvdnYVtxIyJk5m+rEI+Jyuc64zDQ3y9X1U+tow2teF7aXu3UIcNNWbCCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JWHmMM4V; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JWHmMM4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ED7+dA57ykiBKEz5grDMZYewh8MwdtZZLz/FdFES3u8=; b=JWHmMM4VK+Kn3mkfnKAjneZTwq
	vFemw7hrfd2i4tGHgREElBUzrtoN6E4mnUuou+CUczq+07aAZlhwqO+6L9e3aTjimp8vVU9u/RBVk
	t1Hh7FqPMei3TzNGvM+nSGMICFDxqe4bfZtvezooVWoFNAmMvYA+9ACLLCEtpoxW4ddU466olPf7E
	8fgVJZ4ECrh8k2C5yp0JmtO0AonXKcLN/tjDozyWNK+MgFwVupXkBflWG/kSPwR0gsfb6idE2VG72
	/hUEpzQekhBtPwKuucpPc9MZmj4xpUVODME4piRRr0Qbnw3YhtyM2Jex6SE+X4l0qIIqS8DVCo4lX
	lDcIkmDg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCzv5-00000000U9O-05QE
	for fio@vger.kernel.org;
	Thu, 08 May 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 893CE1BC0162; Thu,  8 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250508120001.893CE1BC0162@kernel.dk>
Date: Thu,  8 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4dc6c8da6ed938f12a42f167839100ab551ae8d1:

  t/zbd: add run-tests-against-scsi_debug (2025-05-07 05:28:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1276068fa9ecfede2fcfb2068f4670a553a6dfa4:

  Merge branch 'continue_on_error_fix_up' of https://github.com/kawasaki/fio (2025-05-07 19:18:57 -0600)

----------------------------------------------------------------
Avritt Rohwer (1):
      Document expected filename format for s3 http engine.

Jens Axboe (3):
      Merge branch 'patch-1' of https://github.com/avrittrohwer/fio
      HOWTO: fix bad whitespace
      Merge branch 'continue_on_error_fix_up' of https://github.com/kawasaki/fio

Shin'ichiro Kawasaki (1):
      oslib: blkzoned: add missing blkzoned_move_zone_wp() stub

 HOWTO.rst            | 5 ++++-
 README.rst           | 4 ++++
 examples/http-s3.fio | 7 +++++++
 oslib/blkzoned.h     | 6 ++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index a7e2f693..a5033d82 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -808,7 +808,10 @@ Target file/device
 	For HTTP and S3 access, specify a valid URL path or S3 key, respectively.
 	A filename for path-style S3 includes a bucket name (:file:`/bucket/k/e.y`)
 	while a virtual-hosted-style S3 filename :file:`/k/e.y` does not because 
-	its bucket name is specified in :option:`http_host`.
+	its bucket name is specified in :option:`http_host`. In both cases, the
+	filename should begin with a ``/``. The HTTP engine does not automatically
+	add a leading ``/`` when constructing URLs from :option:`http_host` and
+	:option:`filename`.
 
 	The filename "`-`" is a reserved name, meaning *stdin* or *stdout*.  Which
 	of the two depends on the read/write direction set.
diff --git a/README.rst b/README.rst
index e672ce64..c4688921 100644
--- a/README.rst
+++ b/README.rst
@@ -165,6 +165,10 @@ Configure will attempt to determine the target platform automatically.
 It's possible to build fio for ESX as well, use the ``--esx`` switch to
 configure.
 
+The HTTP engine is enabled depending on if the curl and openssl shared libraries
+are detected on the system. For Ubuntu, these packages are libcurl4-openssl-dev
+and libssl-dev.
+
 
 Windows
 ~~~~~~~
diff --git a/examples/http-s3.fio b/examples/http-s3.fio
index c16e89b1..043426ba 100644
--- a/examples/http-s3.fio
+++ b/examples/http-s3.fio
@@ -9,6 +9,13 @@
 # For path-style, prefix the key with the bucket name in the filename
 # so that filename=/bucket-name/k/e.y:
 # https://s3.region-code.amazonaws.com/bucket-name/k/e.y
+#
+# IMPORTANT: filename needs to begin with a '/':
+# FIO formats the url as `"http://%s%s", o->host, object`, so if 
+# filename does not begin with a '/' DNS will fail. For example, if
+# http_host=amazonaws.com and filename=k/1, URL will be set to 
+# amazonaws.comk/1 and curl will attempt to resolve amazonaws.comk
+# which will fail.
 
 # Reference for Virtual-hosted-style vs. Path-style URLs:
 # https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 3a4c73c2..a8e4a948 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -54,6 +54,12 @@ static inline int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 {
 	return -EIO;
 }
+static inline int blkzoned_move_zone_wp(struct thread_data *td,
+					struct fio_file *f, struct zbd_zone *z,
+					uint64_t length, const char *buf)
+{
+	return -EIO;
+}
 static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 					      unsigned int *max_open_zones)
 {
