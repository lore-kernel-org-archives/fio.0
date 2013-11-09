Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3KIE5v (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Nov 2013 23:57:51 -0500
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Vf0cI-0003j1-Rb
	for fio@vger.kernel.org; Sat, 09 Nov 2013 04:57:50 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20131109050001.F10CA2313C@kernel.dk>
Date: Sat,  9 Nov 2013 06:00:01 +0100 (CET)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6348b5dee54f24f2e78872948653942336f4c14e:

  server: make job/connection lists private (2013-11-07 13:37:09 -0700)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (1):
      Fix access-outside-array of o->rwmix[]

 server.h         |    2 +-
 thread_options.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/server.h b/server.h
index aefd418..5d9b6cc 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 25,
+	FIO_SERVER_VER			= 26,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
diff --git a/thread_options.h b/thread_options.h
index 3f345c5..484b16a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -157,7 +157,7 @@ struct thread_options {
 #endif
 	unsigned int iolog;
 	unsigned int rwmixcycle;
-	unsigned int rwmix[2];
+	unsigned int rwmix[DDIR_RWDIR_CNT];
 	unsigned int nice;
 	unsigned int ioprio;
 	unsigned int ioprio_class;
@@ -362,7 +362,7 @@ struct thread_options_pack {
 	uint32_t verify_cpumask_set;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
-	uint32_t rwmix[2];
+	uint32_t rwmix[DDIR_RWDIR_CNT];
 	uint32_t nice;
 	uint32_t ioprio;
 	uint32_t ioprio_class;
