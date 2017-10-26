Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37770 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbdJZMA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Oct 2017 08:00:27 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e7gpm-0000Nq-BY
        for fio@vger.kernel.org; Thu, 26 Oct 2017 12:00:26 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171026120002.517492C0098@kernel.dk>
Date: Thu, 26 Oct 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 71aa48eb4eed51adb719d159810ab0044b2a7154:

  doc: minor formatting fixes (2017-10-20 07:16:40 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ff523a66e5af357e67602caf33de1e2cd0521b08:

  parse: minimum options values are signed (2017-10-25 13:06:40 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      parse: minimum options values are signed

 parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index ecce8b8..68229d0 100644
--- a/parse.c
+++ b/parse.c
@@ -556,8 +556,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			return 1;
 		}
 		if (o->minval && ull < o->minval) {
-			log_err("min value out of range: %llu"
-					" (%u min)\n", ull, o->minval);
+			log_err("min value out of range: %lld"
+					" (%d min)\n", ull, o->minval);
 			return 1;
 		}
 		if (o->posval[0].ival) {
