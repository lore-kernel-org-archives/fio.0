Return-Path: <fio-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:36417 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965027AbcCPMAw (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 16 Mar 2016 08:00:52 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1agA7P-0007jC-Iu
	for fio@vger.kernel.org; Wed, 16 Mar 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160316120002.3A34B2C0C38@kernel.dk>
Date: Wed, 16 Mar 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5f2f35697b1559cc4fff47c7c94cb983e6f2a460:

  lib/rand: make __init_randX() static (2016-03-10 12:12:09 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a7ef38c4f0bb5ff11f46968e7fa5fa9a54c16de0:

  Fio 2.8 (2016-03-15 09:10:37 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Revert "options: move pattern_fmt_desc where we need it"
      verify: clear IO verify state all_io_list before writing
      Fio 2.8

 FIO-VERSION-GEN        |  2 +-
 options.c              | 19 ++++++++++---------
 os/windows/install.wxs |  2 +-
 verify.c               |  1 +
 4 files changed, 13 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index a4ff012..502d4fe 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.7
+DEF_VER=fio-2.8
 
 LF='
 '
diff --git a/options.c b/options.c
index 7075d84..062abb4 100644
--- a/options.c
+++ b/options.c
@@ -20,6 +20,14 @@
 
 char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
+struct pattern_fmt_desc fmt_desc[] = {
+	{
+		.fmt   = "%o",
+		.len   = FIELD_SIZE(struct io_u *, offset),
+		.paste = paste_blockoff
+	}
+};
+
 /*
  * Check if mmap/mmaphuge has a :/foo/bar/file at the end. If so, return that.
  */
@@ -1184,20 +1192,13 @@ static int str_dedupe_cb(void *data, unsigned long long *il)
 
 static int str_verify_pattern_cb(void *data, const char *input)
 {
-	struct pattern_fmt_desc fmt_desc[] = {
-		{
-			.fmt   = "%o",
-			.len   = FIELD_SIZE(struct io_u *, offset),
-			.paste = paste_blockoff
-		}
-	};
 	struct thread_data *td = data;
 	int ret;
 
 	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
 	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
-			MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
-			td->o.verify_fmt, &td->o.verify_fmt_sz);
+				     MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
+				     td->o.verify_fmt, &td->o.verify_fmt_sz);
 	if (ret < 0)
 		return 1;
 
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index ed9f98b..366547d 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.7">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.8">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/verify.c b/verify.c
index 5d491d7..0f43a3e 100644
--- a/verify.c
+++ b/verify.c
@@ -1385,6 +1385,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	*sz += nr * sizeof(struct thread_io_list);
 	*sz += depth * sizeof(uint64_t);
 	rep = malloc(*sz);
+	memset(rep, 0, *sz);
 
 	rep->threads = cpu_to_le64((uint64_t) nr);
 
