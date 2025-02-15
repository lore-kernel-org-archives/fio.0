Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172B1A2545
	for <fio@vger.kernel.org>; Sat, 15 Feb 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739624411; cv=none; b=h1pH/1l67FGyh7PGVPdh/LvxnG70ObsG+IoYAoEYdPIhWY+rLDMVh7pSG7b3duTz6N1KrwQ1E+sZW1Zsbp+6gu+xIRvuJpJVkYcOuqQ/nlnczZkI6gOQdsOpCqhLdfhasg6YRIkhlB7icSeoxMzSwSjyr0N3f7ubor8HUeWbkSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739624411; c=relaxed/simple;
	bh=mfLGisIBZaNtIbh9SJeoxw1H06hn4h7Lk2UjEqf5yJo=;
	h=Subject:From:To:Message-Id:Date; b=WgqY9PoNTS5NZx81DliiTP48zpnTWc71Y9YalMilY//QszSM3cyBAtlNCsKW9UmfS/GoAQ+Y1kHtJSaFjY1BF8E4lye27F3sJCYu2E4bQhD018N9UMUlgKocvIy09onFGXfdDWiorlHc3/sfbg2J4nGXytxu0RprC/Pg6F+Bih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A4+sEAFF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A4+sEAFF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aiaHLPZtxTXfjXqrPyiLtwdRo0LbF90O6qaA/QVJY+U=; b=A4+sEAFFtPi1AJmpkkhdPvJ6KM
	DgRZOc4X+luJyOo1zkzSusAd56YBjYtbtcacpLQQxs2hXtJoyv7DXS6+nfj1zYj7uN9U2QxHCG01v
	jX60vdU8U9pbZ4lukTi47h2vJazytoxlSUVVkOT09R7pTJDPXa1/VztB4SJbU3HxxnOAWq0C1Hgg4
	0oz03QjoABWnpEoEGp9iaPKey7RZIYM0wLV8G2uXbFWHVl9frhiHdkfdX28WpguIP8CRBUXStQ6mP
	a0Zt8naXodd+kF9akko4mr0k4X1dFk6ifJ4oUyPdgea9CRkjtQboe6tDi7dv7eDtkU9xUbr+mpfmB
	HJFGMCCg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjHm9-00000001U5R-0T9a
	for fio@vger.kernel.org;
	Sat, 15 Feb 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 003E91BC0147; Sat, 15 Feb 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250215130002.003E91BC0147@kernel.dk>
Date: Sat, 15 Feb 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e2d375856c5a443b340b06a33fb40740dda7fee9:

  t/io_uring: fix passthrough fixed buffer support (2025-02-13 08:58:17 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2768c33ec1a34cbc03f122876fea72a630da9ccb:

  Merge branch 't0036-0037' of https://github.com/kawasaki/fio (2025-02-14 09:26:48 -0500)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/jobs/t0036,0037: add tests for verify_state_save/load options

Vincent Fu (1):
      Merge branch 't0036-0037' of https://github.com/kawasaki/fio

 t/jobs/t0036-post.fio |  8 ++++++++
 t/jobs/t0036-pre.fio  |  8 ++++++++
 t/jobs/t0037-post.fio | 12 ++++++++++++
 t/jobs/t0037-pre.fio  | 12 ++++++++++++
 t/run-fio-tests.py    | 18 ++++++++++++++++++
 5 files changed, 58 insertions(+)
 create mode 100644 t/jobs/t0036-post.fio
 create mode 100644 t/jobs/t0036-pre.fio
 create mode 100644 t/jobs/t0037-post.fio
 create mode 100644 t/jobs/t0037-pre.fio

---

Diff of recent changes:

diff --git a/t/jobs/t0036-post.fio b/t/jobs/t0036-post.fio
new file mode 100644
index 00000000..13653c65
--- /dev/null
+++ b/t/jobs/t0036-post.fio
@@ -0,0 +1,8 @@
+[global]
+filename=t0036file
+verify=md5
+size=512k
+
+[job]
+readwrite=read
+verify_state_load=1
diff --git a/t/jobs/t0036-pre.fio b/t/jobs/t0036-pre.fio
new file mode 100644
index 00000000..ae94c88f
--- /dev/null
+++ b/t/jobs/t0036-pre.fio
@@ -0,0 +1,8 @@
+[global]
+filename=t0036file
+verify=md5
+size=512k
+
+[job]
+readwrite=write
+verify_state_save=1
diff --git a/t/jobs/t0037-post.fio b/t/jobs/t0037-post.fio
new file mode 100644
index 00000000..90ccc0c8
--- /dev/null
+++ b/t/jobs/t0037-post.fio
@@ -0,0 +1,12 @@
+[global]
+filename=t0037file.1:t0037file.2:t0037file.3:t0037file.4
+verify=md5
+ioengine=libaio
+iodepth=32
+size=512k
+loops=4
+
+[job]
+readwrite=read
+verify_state_load=1
+
diff --git a/t/jobs/t0037-pre.fio b/t/jobs/t0037-pre.fio
new file mode 100644
index 00000000..4a5e30dc
--- /dev/null
+++ b/t/jobs/t0037-pre.fio
@@ -0,0 +1,12 @@
+[global]
+filename=t0037file.1:t0037file.2:t0037file.3:t0037file.4
+verify=md5
+ioengine=libaio
+iodepth=32
+size=512k
+loops=4
+
+[job]
+readwrite=write
+verify_state_save=1
+
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 4ab670de..101e95f7 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -951,6 +951,24 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          36,
+        'test_class':       FioJobFileTest,
+        'job':              't0036-post.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0036-pre.fio',
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          37,
+        'test_class':       FioJobFileTest,
+        'job':              't0037-post.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0037-pre.fio',
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
