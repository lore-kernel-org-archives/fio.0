Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE72DE6EF
	for <fio@vger.kernel.org>; Sat,  1 Nov 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761998421; cv=none; b=gMQp7T+0lqeidmXVAScXvHkYEykcV8DxlpZM7g1hysMk+kyYCCjPBExJy8iy8UVyI5sZOgwZKuqFTGJiHNfGHrNh3NiPAXvQ6WhvxeSwMM9SNYvgN/oe94oG2hRWHU+EO2pVgN7+upgbwkNbsFY7tTmgJxdwk0JDCdjntx4Wsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761998421; c=relaxed/simple;
	bh=KCp8eOHhhamIu+YAXC7wAxQWGGABpFmoaQy8EYaq40g=;
	h=Subject:From:To:Date:Message-Id; b=bhbqOzqGlAady9BVQd8RAbwrY2KHo9KNDTcKHB1C3JMQO6feLlMWOzvpBELKxmVUAvbO9AKEodf7roIP3auVc3YAPkkH1cB+cRx8rNdjbHUdiv1hCBuR5B8Wb2fk42duPWcbajN4MQJJjh2bsdiiw3jrpF2/mXPyKBD/kBiMBpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FjoD1Su0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FjoD1Su0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=56oBZ6C6ZI6nkuM38BMSUYGY1aKb7JgFQw5IugQN6Jg=; b=FjoD1Su0K7SEi7Ll6t9z77DePG
	59Tt5WjvF8P3fuHEgQ7yxaKbg3kVTRe2NeMiyav1fZX0FFnTo1pKxNAk7XdSseA6l3WLhH8mgTG8Y
	6mnIgFwrqQvPqVjgh+VsxSUztCdRwCt4/PW8pm2Qzo+jBq4YiqcXvOnCtP7KL6heVfkT2MYQfciuL
	YsdBSGOQGoDWWVXXiW7fo61q4DcESDQsrB21J7K7wxHpMSLvBMYuj6CCnBk0n7Xp2HNu8ogb2+VcM
	a5Um07swOA8bK/weMG/gs8WBa0vczI2ef6P8YtyfirTW+FIB9+FbM8Yp88Rz/tQl3uAkejNv+7qW9
	1GlMVSnA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFAHB-0000000AT1k-10Fj
	for fio@vger.kernel.org;
	Sat, 01 Nov 2025 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D66001BC0131; Sat,  1 Nov 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat,  1 Nov 2025 06:00:01 -0600
Message-Id: <20251101120001.D66001BC0131@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 30c2e6ee56a9f0e6f0a0196ff91dbf4500318efc:

  Merge branch 'clock_gettime' of https://github.com/betonmischer86/fio (2025-10-30 14:42:29 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f87cd24973b122a8c8eda9bfbcee81edcac5112:

  engines/ftruncate: update git tree reference (2025-10-31 14:53:05 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Remove all references to git.kernel.dk
      Fix an URL typo
      engines/ftruncate: update git tree reference

Vincent Fu (1):
      Merge branch 'fix-experimental-verify-iocb-issue' of https://github.com/yehormalikov/fio

Yehor Malikov (1):
      backend.c: fix async ioengine prep/queue direction mismatch in experimental verify

 README.rst             | 2 +-
 backend.c              | 8 ++++++++
 engines/e4defrag.c     | 2 +-
 engines/falloc.c       | 2 +-
 engines/ftruncate.c    | 2 +-
 engines/io_uring.c     | 4 +---
 fio.1                  | 6 +++---
 gfio.c                 | 2 +-
 os/windows/install.wxs | 2 +-
 t/run-fio-tests.py     | 2 +-
 10 files changed, 19 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index c4688921..06fa971e 100644
--- a/README.rst
+++ b/README.rst
@@ -27,7 +27,7 @@ Source
 
 Fio resides in a git repo, the canonical place is:
 
-	https://git.kernel.dk/cgit/fio/
+	https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio
 
 Snapshots are frequently generated and :file:`fio-git-*.tar.gz` include the git
 meta data as well. Other tarballs are archives of official fio releases.
diff --git a/backend.c b/backend.c
index c8a64d38..684ea0de 100644
--- a/backend.c
+++ b/backend.c
@@ -666,12 +666,20 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				} else if (io_u->ddir == DDIR_TRIM) {
 					io_u->ddir = DDIR_READ;
 					io_u_set(td, io_u, IO_U_F_TRIMMED);
+					if (td_io_prep(td, io_u)) {
+						put_io_u(td, io_u);
+						continue;
+					}
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
 					io_u->numberio = td->verify_read_issues;
 					td->verify_read_issues++;
 					populate_verify_io_u(td, io_u);
+					if (td_io_prep(td, io_u)) {
+						put_io_u(td, io_u);
+						continue;
+					}
 					break;
 				} else {
 					put_io_u(td, io_u);
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 65ef0da7..e3a15fac 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -1,5 +1,5 @@
 /*
- * ioe_e4defrag:  ioengine for git://git.kernel.dk/fio.git
+ * ioe_e4defrag:  ioengine for https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio
  *
  * IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
  * defragment activity
diff --git a/engines/falloc.c b/engines/falloc.c
index 4b05ed68..290b980f 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -1,5 +1,5 @@
 /*
- * falloc: ioengine for git://git.kernel.dk/fio.git
+ * falloc: ioengine for https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio
  *
  * IO engine that does regular fallocate to simulate data transfer 
  * as fio ioengine.
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index c7ad038c..d1757b79 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -1,5 +1,5 @@
 /*
- * ftruncate: ioengine for git://git.kernel.dk/fio.git
+ * ftruncate: ioengine for https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio
  *
  * IO engine that does regular truncates to simulate data transfer
  * as fio ioengine.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 89f44044..bc29d3d8 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1,9 +1,7 @@
 /*
  * io_uring engine
  *
- * IO engine using the new native Linux aio io_uring interface. See:
- *
- * http://git.kernel.dk/cgit/linux-block/log/?h=io_uring
+ * IO engine using the new native Linux aio io_uring interface.
  *
  */
 #include <stdlib.h>
diff --git a/fio.1 b/fio.1
index 5036b4f9..9c4ff08c 100644
--- a/fio.1
+++ b/fio.1
@@ -5286,7 +5286,7 @@ Report bugs to the \fBfio\fR mailing list <fio@vger.kernel.org>.
 .br
 See \fBREPORTING\-BUGS\fR.
 .P
-\fBREPORTING\-BUGS\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/REPORTING\-BUGS\fR
+\fBREPORTING\-BUGS\fR: \fIhttps://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git/tree/REPORTING\-BUGS\fR
 .SH "SEE ALSO"
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
@@ -5294,6 +5294,6 @@ Sample jobfiles are available in the `examples/' directory.
 .br
 These are typically located under `/usr/share/doc/fio'.
 .P
-\fBHOWTO\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/HOWTO\fR
+\fBHOWTO\fR: \fIhttps://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git/tree/HOWTO\fR
 .br
-\fBREADME\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/README\fR
+\fBREADME\fR: \fIhttps://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git/tree/README.rst\fR
diff --git a/gfio.c b/gfio.c
index 10c9b094..b97337fc 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1242,7 +1242,7 @@ static void about_dialog(GtkWidget *w, gpointer data)
 		"program-name", "gfio",
 		"comments", "Gtk2 UI for fio",
 		"license", license_trans,
-		"website", "http://git.kernel.dk/cgit/fio/",
+		"website", "https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git/",
 		"authors", authors,
 		"version", fio_version_string,
 		"copyright", "© 2012-2017 Jens Axboe <axboe@kernel.dk>",
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index f2753289..d1b89dbc 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -100,7 +100,7 @@
 		<ComponentRef Id="fio_verify_state.exe"/>
 	</Feature>
 
-	<Property Id="ARPURLINFOABOUT" Value="http://git.kernel.dk/cgit/fio/" />
+	<Property Id="ARPURLINFOABOUT" Value="https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git/" />
 	<Property Id='ARPCONTACT'>fio@vger.kernel.org</Property>
 	<Property Id='ARPHELPLINK'>http://www.spinics.net/lists/fio/</Property>
 	<Property Id='ARPURLUPDATEINFO'>https://bluestop.org/fio/</Property>
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 363f2058..85112878 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -14,7 +14,7 @@
 #
 #
 # EXAMPLE
-# # git clone git://git.kernel.dk/fio.git
+# # git clone https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio
 # # cd fio
 # # make -j
 # # python3 t/run-fio-tests.py
