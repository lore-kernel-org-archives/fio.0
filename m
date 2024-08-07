Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605091E4EF2
	for <fio@vger.kernel.org>; Wed,  7 Aug 2024 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723032010; cv=none; b=FS2NoE3WqbenWMr1y9iUncgnT41QtXA5aIBoBZ2BkVPRjWpGglKQ+RKBXa14OqfJcJn/RmVTTC0j8c7wrdRotvpXbQKctqhwznNMhvVJoDfdp1wpwidNKN7JTv7udYgbjrcrpIiy56KWCxo7EjEJu72763+YhhIa8pYlx/cBnBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723032010; c=relaxed/simple;
	bh=MMT3cw0wzJyjB86W+vb4qDpgtogkjPV7ZaeGuk0pml4=;
	h=Subject:From:To:Message-Id:Date; b=pv1BooVFTjxljdue3gBYKbMzMIcuCC2fiWheY72cfwN6U8MM4LHnrLn5+fhCMwhvAtqz/h6abrhzCFqK15yK9Bb8zH/VnWAIZRQkcQjvp7t214scvjgmNCXLEoIasN9fziMDLffQTn08u238UIZ4lhKx+GslfuDsN3u54IhhF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k72JOwA5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k72JOwA5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Sa8JLs2+HBFGwQYaByiY7+9uaaxR9KGYeeL4mLA42y0=; b=k72JOwA5/DRaCHRz1CeHYjYPwq
	rd/d8O8+lTAFDkCM/LbTW4wvQl+uGVIP2p/rh760C1hh8kACSiy2cuNqqTtsTPZ314rj18XxONtif
	jflDuj1nDKFUGOlrG5715YGqF7NUbCWJ/bDpIy55itTGWhtfUb+dl4HMJk1Jr31cO62XCGHOt591j
	XqykWWJkvqQY8p9JY/NV85ydl7xE5wO9/w6nZ3YiDwzg+hokAHSl8UdmRhsLOJ7QhJwsM+/Qt/O6+
	wB26osxPt5RsZFqmDh1w6aNfa924i9h1uZSr6Wm5XRuXqh45Y3JGNnw1AoxvuKX/nCdIxnKycgZt/
	VmBXpjyw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbfKl-00000007G8I-3IlQ
	for fio@vger.kernel.org;
	Wed, 07 Aug 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A42F91BC0163; Wed,  7 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240807120001.A42F91BC0163@kernel.dk>
Date: Wed,  7 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 8ac0eec77e9c25a054ff1fbff243ffdffcd6e858:

  nvme/streams: avoid allocating too large a buffer (2024-08-05 18:15:24 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 55b10ccca6a2ba623360a38c3fdf7332461646bb:

  Merge branch 'master' of https://github.com/scaleoutsean/fio (2024-08-06 09:17:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/scaleoutsean/fio

Sean Lee (1):
      Improve http_host, filename in docs and example/http-s3.fio

 HOWTO.rst            | 14 ++++++++++++--
 examples/http-s3.fio | 16 +++++++++++++---
 fio.1                | 11 +++++++++--
 3 files changed, 34 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 9eeb203e..11b1c669 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -805,6 +805,11 @@ Target file/device
 	Note: Windows and FreeBSD (refer to geom(4)) prevent write access to areas
 	of the disk containing in-use data (e.g. filesystems).
 
+	For HTTP and S3 access, specify a valid URL path or S3 key, respectively.
+	A filename for path-style S3 includes a bucket name (:file:`/bucket/k/e.y`)
+	while a virtual-hosted-style S3 filename :file:`/k/e.y` does not because 
+	its bucket name is specified in :option:`http_host`.
+
 	The filename "`-`" is a reserved name, meaning *stdin* or *stdout*.  Which
 	of the two depends on the read/write direction set.
 
@@ -2934,8 +2939,13 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: http_host=str : [http]
 
-	Hostname to connect to. For S3, this could be the bucket hostname.
-	Default is **localhost**
+	Hostname to connect to. HTTP port 80 is used automatically when the value of 
+	the https parameter is *off*, and HTTPS port 443 if it is *on*. A 
+	virtual-hosted-style S3 hostname starts with a bucket name, while a 
+	path-style S3 hostname does not. See 
+	https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html for 
+	detailed examples.
+	Default is **localhost** (path-style S3 hostname)
 
 .. option:: http_user=str : [http]
 
diff --git a/examples/http-s3.fio b/examples/http-s3.fio
index 2dcae364..c16e89b1 100644
--- a/examples/http-s3.fio
+++ b/examples/http-s3.fio
@@ -1,19 +1,29 @@
 # Example test for the HTTP engine's S3 support against Amazon AWS.
 # Obviously, you have to adjust the S3 credentials; for this example,
 # they're passed in via the environment.
-#
+# For non-AWS S3 implementations, refer to your S3 vendor's region 
+# settings. Note that the region value appears twice, in http_host and 
+# http_s3_region.
+# This example uses virtual-hosted-style requests:
+# https://bucket-name.s3.region-code.amazonaws.com/k/e.y
+# For path-style, prefix the key with the bucket name in the filename
+# so that filename=/bucket-name/k/e.y:
+# https://s3.region-code.amazonaws.com/bucket-name/k/e.y
+
+# Reference for Virtual-hosted-style vs. Path-style URLs:
+# https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html
 
 [global]
 ioengine=http
 name=test
 direct=1
-filename=/larsmb-fio-test/object
+filename=/k/e.y
 http_verbose=0
 https=on
 http_mode=s3
 http_s3_key=${S3_KEY}
 http_s3_keyid=${S3_ID}
-http_host=s3.eu-central-1.amazonaws.com
+http_host=bucket-name.s3.eu-central-1.amazonaws.com
 http_s3_region=eu-central-1
 group_reporting
 
diff --git a/fio.1 b/fio.1
index 15bafbf9..6db76b2c 100644
--- a/fio.1
+++ b/fio.1
@@ -585,6 +585,11 @@ the first device, `\\\\.\\PhysicalDrive1' for the second etc.
 Note: Windows and FreeBSD prevent write access to areas
 of the disk containing in-use data (e.g. filesystems).
 .P
+For HTTP and S3 access, specify a valid URL path or S3 key, respectively. 
+A filename for path-style S3 includes a bucket name (`/bucket/k/e.y') 
+while a virtual-hosted-style S3 filename (`/k/e.y') does not because its 
+bucket name is specified in \fBhttp_host\fR.
+.P
 The filename `\-' is a reserved name, meaning *stdin* or *stdout*. Which
 of the two depends on the read/write direction set.
 .RE
@@ -2554,8 +2559,10 @@ Touching all objects affects ceph caches and likely impacts test results.
 Enabled by default.
 .TP
 .BI (http)http_host \fR=\fPstr
-Hostname to connect to. For S3, this could be the bucket name. Default
-is \fBlocalhost\fR
+Hostname to connect to.  HTTP port 80 is used automatically when the value 
+of the \fBhttps\fP parameter is \fRoff\fP, and HTTPS port 443 if it is \Ron\fP.  
+A virtual-hosted-style S3 hostname starts with a bucket name, while a 
+path-style S3 hostname does not.  Default is \fBlocalhost\fR.
 .TP
 .BI (http)http_user \fR=\fPstr
 Username for HTTP authentication.
