Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43130 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbeDGMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Apr 2018 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f4mVr-00060K-Iv
        for fio@vger.kernel.org; Sat, 07 Apr 2018 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180407120002.6E4A12C006D@kernel.dk>
Date: Sat,  7 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2b8b8f0dccb4c7e97aee3b7d7e13d8528467d64e:

  Fix return value checking of fread() in iolog.c (2018-04-04 19:18:50 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 465964a6c8ff3ccac62b92e9af57377075e04579:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-04-06 17:59:20 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Fix floating point option range formatting

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 parse.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index deb4120..3993471 100644
--- a/parse.c
+++ b/parse.c
@@ -71,13 +71,17 @@ static void show_option_range(const struct fio_option *o,
 			      size_t (*logger)(const char *format, ...))
 {
 	if (o->type == FIO_OPT_FLOAT_LIST) {
+		const char *sep = "";
 		if (!o->minfp && !o->maxfp)
 			return;
 
-		if (o->minfp != DBL_MIN)
-			logger("%20s: min=%f", "range", o->minfp);
+		logger("%20s: ", "range");
+		if (o->minfp != DBL_MIN) {
+			logger("min=%f", o->minfp);
+			sep = ", ";
+		}
 		if (o->maxfp != DBL_MAX)
-			logger(", max=%f", o->maxfp);
+			logger("%smax=%f", sep, o->maxfp);
 		logger("\n");
 	} else if (!o->posval[0].ival) {
 		if (!o->minval && !o->maxval)
