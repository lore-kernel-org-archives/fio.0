Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3ILEAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Sep 2013 00:00:09 -0400
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1VJy4e-00029A-6I
	for fio@vger.kernel.org; Thu, 12 Sep 2013 04:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20130912040001.C9DB221155@kernel.dk>
Date: Thu, 12 Sep 2013 04:00:01 +0000 (UTC)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f713350f74dbeb333ff1ad2790cb60381ceaf463:

  Fix broken requeue of io_us (2013-09-09 15:16:28 -0600)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (1):
      debug: ensure that __dprint() is also logged over the network

 debug.c |    4 ++--
 log.c   |    2 ++
 log.h   |    1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/debug.c b/debug.c
index 5e98063..013cd53 100644
--- a/debug.c
+++ b/debug.c
@@ -16,8 +16,8 @@ void __dprint(int type, const char *str, ...)
 	    && pid != *fio_debug_jobp)
 		return;
 
-	log_local("%-8s ", debug_levels[type].name);
-	log_local("%-5u ", (int) pid);
+	log_info("%-8s ", debug_levels[type].name);
+	log_info("%-5u ", (int) pid);
 
 	va_start(args, str);
 	log_valist(str, args);
diff --git a/log.c b/log.c
index 4822c33..a05a7ec 100644
--- a/log.c
+++ b/log.c
@@ -14,6 +14,8 @@ int log_valist(const char *str, va_list args)
 	len = vsnprintf(buffer, sizeof(buffer), str, args);
 	len = min(len, sizeof(buffer) - 1);
 
+	if (is_backend)
+		len = fio_server_text_output(FIO_LOG_INFO, buffer, len);
 	if (log_syslog)
 		syslog(LOG_INFO, "%s", buffer);
 	else
diff --git a/log.h b/log.h
index a885be7..e509313 100644
--- a/log.h
+++ b/log.h
@@ -9,7 +9,6 @@ extern FILE *f_err;
 
 extern int log_err(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern int log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
-extern int log_local(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern int log_valist(const char *str, va_list);
 extern int log_local_buf(const char *buf, size_t);
 extern int log_info_flush(void);
