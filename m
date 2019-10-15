Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfJOMAB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Oct 2019 08:00:01 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKLUf-000719-C2
        for fio@vger.kernel.org; Tue, 15 Oct 2019 12:00:01 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191015120001.E07C72C03CF@kernel.dk>
Date: Tue, 15 Oct 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9663e751c25d3bf52e959d8c9025460d2f645b1e:

  Merge branch 'fix-corrupt-hist-log' of https://github.com/sitsofe/fio (2019-10-13 11:02:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5cd4efe903798f2185a347911a9440324558c89f:

  parse: improve detection of bad input string (2019-10-14 08:03:53 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      parse: improve detection of bad input string

 parse.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index c4fd4626..483a62f6 100644
--- a/parse.c
+++ b/parse.c
@@ -373,12 +373,16 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 #endif
 
 	if (rc == 1) {
+		char *endptr;
+
 		if (strstr(str, "0x") || strstr(str, "0X"))
 			base = 16;
 		else
 			base = 10;
 
-		*val = strtoll(str, NULL, base);
+		*val = strtoll(str, &endptr, base);
+		if (*val == 0 && endptr == str)
+			return 1;
 		if (*val == LONG_MAX && errno == ERANGE)
 			return 1;
 	}

