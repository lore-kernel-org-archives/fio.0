Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD678C43334
	for <fio@archiver.kernel.org>; Mon, 20 Jun 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiFTMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 20 Jun 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240480AbiFTMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Jun 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555FFCB
        for <fio@vger.kernel.org>; Mon, 20 Jun 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=LtW99BwpJZg5TJj61E3QLJEwDE7kkdTNz6/On+VrXAA=; b=RKZOiG3tcuwqOSsVsV03cDZlC7
        Oiyf9nW5iAdimio9Kp5sZP+FuYdwdqhyd1VfDkavFPoE3Nv2/xeR8bDtHjfgJT8tPefGvXulwgQuF
        s26gt8QZueRXCmgeaNzw1rysGKMNmHgRcTKsRtmOuzkJ2FBeFf8cncyfvcDONpXHZbia0yvYkA7wT
        7fQ+GFDOEvmiCnODuHFPEnjJzR2qFp9g+Z9VIsvuzad0SbPqz/v0WN+vSupOQy+YcfLS2MTd593ll
        3M8M0YKi9pkL9+XMBj95Xrqs55pmHaPQLq814GGN0jX5bSS6U7FWvIn6wcS8OYIG29zBIUgMzhnvV
        2BAGr+wA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3G4b-00584j-3p
        for fio@vger.kernel.org; Mon, 20 Jun 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 436591BC0129; Mon, 20 Jun 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220620120002.436591BC0129@kernel.dk>
Date:   Mon, 20 Jun 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e4d384755e4831cf5bbaa97e0c5b79a3598efbc4:

  Merge branch 'master' of https://github.com/useche/fio (2022-06-15 18:38:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d4bf5e6193b97c5e5490fdb93b069d149a38777c:

  gettime: fix whitespace damage (2022-06-19 12:04:19 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      gettime: fix whitespace damage

 gettime.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 099e9d9f..14462420 100644
--- a/gettime.c
+++ b/gettime.c
@@ -431,22 +431,22 @@ void fio_clock_init(void)
 
 uint64_t ntime_since(const struct timespec *s, const struct timespec *e)
 {
-       int64_t sec, nsec;
+	int64_t sec, nsec;
 
-       sec = e->tv_sec - s->tv_sec;
-       nsec = e->tv_nsec - s->tv_nsec;
-       if (sec > 0 && nsec < 0) {
-	       sec--;
-	       nsec += 1000000000LL;
-       }
+	sec = e->tv_sec - s->tv_sec;
+	nsec = e->tv_nsec - s->tv_nsec;
+	if (sec > 0 && nsec < 0) {
+		sec--;
+		nsec += 1000000000LL;
+	}
 
        /*
 	* time warp bug on some kernels?
 	*/
-       if (sec < 0 || (sec == 0 && nsec < 0))
-	       return 0;
+	if (sec < 0 || (sec == 0 && nsec < 0))
+		return 0;
 
-       return nsec + (sec * 1000000000LL);
+	return nsec + (sec * 1000000000LL);
 }
 
 uint64_t ntime_since_now(const struct timespec *s)
