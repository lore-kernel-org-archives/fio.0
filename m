Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860AbcAZNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jan 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aO3E3-0003MH-V0
	for fio@vger.kernel.org; Tue, 26 Jan 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160126130001.66FA42C00E6@kernel.dk>
Date: Tue, 26 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ab917e33e8c0353e2e17b0340e7193e7df6591b0:

  Fix Windows build: define rand_r() (2016-01-22 15:24:58 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c5dd5d977884648f78c266e9873f667a3ed98bda:

  powerpc: fix cpus_online() to get correct max CPU number for powerpc64 (2016-01-25 08:29:50 -0700)

----------------------------------------------------------------
Dan Qing Zhang (1):
      powerpc: fix cpus_online() to get correct max CPU number for powerpc64

 os/os.h | 8 ++++++++
 1 file changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/os/os.h b/os/os.h
index fd47f22..02ab40d 100644
--- a/os/os.h
+++ b/os/os.h
@@ -343,6 +343,14 @@ static inline unsigned long long get_fs_free_size(const char *path)
 }
 #endif
 
+#ifdef __powerpc64__
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+static inline unsigned int cpus_online(void)
+{
+        return sysconf(_SC_NPROCESSORS_CONF);
+}
+#endif
+
 #ifndef FIO_HAVE_CPU_ONLINE_SYSCONF
 static inline unsigned int cpus_online(void)
 {
