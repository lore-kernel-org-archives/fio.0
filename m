Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbFFMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Jun 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z1Clf-0002yy-9b
	for fio@vger.kernel.org; Sat, 06 Jun 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150606120002.3054A2C0102@kernel.dk>
Date: Sat,  6 Jun 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2236df3d9d6bc053039a5c2185cff43ea5015111:

  init: automate displaying debug categories (2015-06-04 13:45:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c44ff5115df69f0040aef9677bf48966d72adb81:

  configure: add some missing help options (2015-06-05 08:33:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      configure: add some missing help options

Tomohiro Kusumi (1):
      Fix compile error on non Linux-or-BSDs

 configure        | 2 ++
 lib/mountcheck.c | 8 ++++++++
 2 files changed, 10 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 835a3b9..e459d63 100755
--- a/configure
+++ b/configure
@@ -190,7 +190,9 @@ if test "$show_help" = "yes" ; then
   echo "--esx                  Configure build options for esx"
   echo "--enable-gfio          Enable building of gtk gfio"
   echo "--disable-numa         Disable libnuma even if found"
+  echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
+  echo "--disable-shm          Disable SHM support"
   exit $exit_val
 fi
 
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index 2eedcc7..e37e9f9 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -51,4 +51,12 @@ int device_is_mounted(const char *dev)
 	return 0;
 }
 
+#else
+/* others */
+
+int device_is_mounted(const char *dev)
+{
+	return 0;
+}
+
 #endif
