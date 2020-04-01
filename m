Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49542 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgDAMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Apr 2020 08:00:04 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJc2M-0003XL-L6
        for fio@vger.kernel.org; Wed, 01 Apr 2020 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200401120001.74E7D1BC016C@kernel.dk>
Date: Wed,  1 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 983319d02626347d178b34320ac5835ae7ecad02:

  Merge branch 'jsonplus2csv' of https://github.com/vincentkfu/fio (2020-03-26 09:03:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 839f607b5771081e96942977a1ff9f1b24b77bca:

  Merge branch 'github-issue-947' of https://github.com/vincentkfu/fio (2020-03-31 10:21:48 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'github-issue-947' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      stat: eliminate extra log samples

 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index d8c01d14..efa811d2 100644
--- a/stat.c
+++ b/stat.c
@@ -2749,7 +2749,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0, priority_bit);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0, priority_bit);
 
 	iolog->avg_last[ddir] = elapsed - (this_window - iolog->avg_msec);
 	return iolog->avg_msec;

