Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E438BF6
	for <fio@vger.kernel.org>; Sat, 30 Dec 2023 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JiBH/ySf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=z/v1gaWV+7Yb7jZQIRowbHrYiFCE1jSvJNbO2reZwM4=; b=JiBH/ySfEYllKgp9y0aKkKHbML
	EvJ65yp1h6LWFHAx4VQg8bBJVBWrwcXC5bWS0LxQSojFWThyxqWpJcNv2HfHY3yvfhV1r1qdnyU6I
	pqw62s/Oowwzs5UkILlnzvjmpBE65xc9fT40VKNod6vzO9ImWOEpdnjsaaH7p1UCpeHn1LXLbYHwg
	BPLHRc/K+RHQpIhHhSo7g6DJX4Kqtdb0XRRgNi+7KcAIMv7/9e5mSx6wbomHuA++U6FAd/QIFBjtP
	/+8m9IgF4k/uT3Y/RFB7r6ZnBNPa/81mbrH8CeXAPoTVbGw02MziWkj1fa3veur1Shl+j1aV5AbTF
	jwVKjhJg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rJYwg-002AUy-0z
	for fio@vger.kernel.org;
	Sat, 30 Dec 2023 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2DEB21BC0147; Sat, 30 Dec 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231230130002.2DEB21BC0147@kernel.dk>
Date: Sat, 30 Dec 2023 06:00:02 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit be943a3ef5d94d8a9fefa11dc004789f66beb8e6:

  t/zbd: add test case to confirm no write with rwmixwrite=0 option (2023-12-19 19:52:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 06c40418f97811092c0aece1760487400bcdd506:

  t/strided: check_result() has no return value (2023-12-28 22:19:44 -0500)

----------------------------------------------------------------
Vincent Fu (4):
      t/nvmept: call parent class check_result()
      t/random_seed: call parent class check_result()
      t/strided: call parent class check_result()
      t/strided: check_result() has no return value

 t/nvmept.py      |  2 ++
 t/random_seed.py |  8 ++++++++
 t/strided.py     | 12 +++++++-----
 3 files changed, 17 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/t/nvmept.py b/t/nvmept.py
index c08fb350..1ade64dc 100755
--- a/t/nvmept.py
+++ b/t/nvmept.py
@@ -55,6 +55,8 @@ class PassThruTest(FioJobCmdTest):
 
 
     def check_result(self):
+        super().check_result()
+
         if 'rw' not in self.fio_opts:
             return
 
diff --git a/t/random_seed.py b/t/random_seed.py
index 02187046..82beca65 100755
--- a/t/random_seed.py
+++ b/t/random_seed.py
@@ -91,6 +91,10 @@ class TestRR(FioRandTest):
     def check_result(self):
         """Check output for allrandrepeat=1."""
 
+        super().check_result()
+        if not self.passed:
+            return
+
         opt = 'randrepeat' if 'randrepeat' in self.fio_opts else 'allrandrepeat'
         rr = self.fio_opts[opt]
         rand_seeds = self.get_rand_seeds()
@@ -131,6 +135,10 @@ class TestRS(FioRandTest):
     def check_result(self):
         """Check output for randseed=something."""
 
+        super().check_result()
+        if not self.passed:
+            return
+
         rand_seeds = self.get_rand_seeds()
         randseed = self.fio_opts['randseed']
 
diff --git a/t/strided.py b/t/strided.py
index b7655e1e..75c429e4 100755
--- a/t/strided.py
+++ b/t/strided.py
@@ -71,6 +71,10 @@ class StridedTest(FioJobCmdTest):
         super().setup(fio_args)
 
     def check_result(self):
+        super().check_result()
+        if not self.passed:
+            return
+
         zonestart = 0 if 'offset' not in self.fio_opts else self.fio_opts['offset']
         iospersize = self.fio_opts['zonesize'] / self.fio_opts['bs']
         iosperrange = self.fio_opts['zonerange'] / self.fio_opts['bs']
@@ -95,7 +99,7 @@ class StridedTest(FioJobCmdTest):
             offset = int(tokens[4])
             if offset < zonestart or offset >= zonestart + self.fio_opts['zonerange']:
                 print(f"Offset {offset} outside of zone starting at {zonestart}")
-                return False
+                return
 
             # skip next section if norandommap is enabled with no
             # random_generator or with a random_generator != lfsr
@@ -113,17 +117,15 @@ class StridedTest(FioJobCmdTest):
             block = (offset - zonestart) / self.fio_opts['bs']
             if block in zoneset:
                 print(f"Offset {offset} in zone already touched")
-                return False
+                return
 
             zoneset.add(block)
             if iosperzone % iosperrange == 0:
                 if len(zoneset) != iosperrange:
                     print(f"Expected {iosperrange} blocks in zone but only saw {len(zoneset)}")
-                    return False
+                    return
                 zoneset = set()
 
-        return True
-
 
 TEST_LIST = [   # randommap enabled
     {
