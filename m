Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbhAJNAr (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 10 Jan 2021 08:00:47 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A576BC061786
        for <fio@vger.kernel.org>; Sun, 10 Jan 2021 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kyaKC-0004UC-5Y
        for fio@vger.kernel.org; Sun, 10 Jan 2021 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210110130001.A4D2B1BC0119@kernel.dk>
Date: Sun, 10 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8f14dc61422df3b1eaee1293a7d10ba791c8084c:

  Merge branch 'cpu-engine' of https://github.com/bvanassche/fio (2021-01-07 20:53:00 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 674428a527931d86bfb164abcc847508b3be2742:

  Merge branch 'num2str-patch' of https://github.com/gloit042/fio (2021-01-09 15:28:44 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'num2str-patch' of https://github.com/gloit042/fio

gloit042 (1):
      num2str: fix precision loss bug when the fractional part is close to 1

 lib/num2str.c | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/lib/num2str.c b/lib/num2str.c
index 3597de2f..cd89a0e5 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -110,6 +110,9 @@ done:
 	sprintf(tmp, "%.*f", (int)(maxlen - strlen(tmp) - 1),
 		(double)modulo / (double)thousand);
 
+	if (tmp[0] == '1')
+		num++;
+
 	if (asprintf(&buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
 		     unitprefix[post_index], unitstr[units]) < 0)
 		buf = NULL;

