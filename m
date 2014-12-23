Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaLWNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Dec 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y3P4G-0005lB-5b
	for fio@vger.kernel.org; Tue, 23 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141223130003.21E4F40195@lyth.info>
Date: Tue, 23 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b04f590551050b23768a3969d47371d363aa8745:

  Fix default scrambling of buffers (2014-12-20 14:44:45 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3c6c5a29a74cf5727c0572b82907c330c38cea61:

  Fio 2.2.3 (2014-12-22 20:06:45 -0700)

----------------------------------------------------------------
fio v2.2.3

----------------------------------------------------------------
Jens Axboe (3):
      Fio 2.2.2
      options: ensure that we check all candidates on is_set check
      Fio 2.2.3

 FIO-VERSION-GEN        |    2 +-
 options.c              |   46 ++++++++++++++++++++++++++++++++++++----------
 os/windows/install.wxs |    2 +-
 3 files changed, 38 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d124e36..a26eb2e 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.1
+DEF_VER=fio-2.2.3
 
 LF='
 '
diff --git a/options.c b/options.c
index e3c9c87..3e783c1 100644
--- a/options.c
+++ b/options.c
@@ -4191,21 +4191,32 @@ struct fio_option *fio_option_find(const char *name)
 	return find_option(fio_options, name);
 }
 
-int __fio_option_is_set(struct thread_options *o, unsigned int off1)
+static struct fio_option *find_next_opt(struct thread_options *o,
+					struct fio_option *from,
+					unsigned int off1)
 {
-	unsigned int opt_off, index, offset;
-	struct fio_option *opt = NULL;
-	int i;
+	struct fio_option *opt;
 
-	for (i = 0; fio_options[i].name; i++) {
-		if (off1 == fio_options[i].off1) {
-			opt = &fio_options[i];
+	if (!from)
+		from = &fio_options[0];
+	else
+		from++;
+
+	opt = NULL;
+	do {
+		if (off1 == from->off1) {
+			opt = from;
 			break;
 		}
-	}
+		from++;
+	} while (from->name);
 
-	if (!opt)
-		return -1;
+	return opt;
+}
+
+static int opt_is_set(struct thread_options *o, struct fio_option *opt)
+{
+	unsigned int opt_off, index, offset;
 
 	opt_off = opt - &fio_options[0];
 	index = opt_off / (8 * sizeof(uint64_t));
@@ -4213,6 +4224,21 @@ int __fio_option_is_set(struct thread_options *o, unsigned int off1)
 	return (o->set_options[index] & (1UL << offset)) != 0;
 }
 
+int __fio_option_is_set(struct thread_options *o, unsigned int off1)
+{
+	struct fio_option *opt, *next;
+
+	next = NULL;
+	while ((opt = find_next_opt(o, next, off1)) != NULL) {
+		if (opt_is_set(o, opt))
+			return 1;
+
+		next = opt;
+	}
+
+	return 0;
+}
+
 void fio_option_mark_set(struct thread_options *o, struct fio_option *opt)
 {
 	unsigned int opt_off, index, offset;
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 5db099b..405b05b 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.1">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.3">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
