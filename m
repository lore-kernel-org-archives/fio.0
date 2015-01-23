Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbAWNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 23 Jan 2015 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YEdqJ-0008VP-Fo
	for fio@vger.kernel.org; Fri, 23 Jan 2015 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150123130003.8B5DE4018D@lyth.info>
Date: Fri, 23 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 64666f8fe2242cbe4d804df2305924a9e43e8699:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2015-01-22 00:57:00 +0100)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 209e10374bb57565f0a61286d1ed8effd50fa95c:

  parse: ensure strings are pre-terminated when using strncpy() (2015-01-22 14:51:56 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      parse: ensure strings are pre-terminated when using strncpy()

 parse.c |    2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index e70ed20..7912212 100644
--- a/parse.c
+++ b/parse.c
@@ -506,6 +506,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 		if (!is_time && o->is_time)
 			is_time = o->is_time;
 
+		tmp[sizeof(tmp) - 1] = '\0';
 		strncpy(tmp, ptr, sizeof(tmp) - 1);
 		p = strchr(tmp, ',');
 		if (p)
@@ -705,6 +706,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 		char tmp[128];
 		char *p1, *p2;
 
+		tmp[sizeof(tmp) - 1] = '\0';
 		strncpy(tmp, ptr, sizeof(tmp) - 1);
 
 		/* Handle bsrange with separate read,write values: */
