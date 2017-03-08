Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52365 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdCHNyi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Mar 2017 08:54:38 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1clbCE-0001p8-Vi
        for fio@vger.kernel.org; Wed, 08 Mar 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170308130002.2048C2C1C4C@kernel.dk>
Date: Wed,  8 Mar 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4ed22fe532123f81e618269e9a77b7b41e0e9cad:

  fio: fix overflow trying to use 'd' suffix (2017-02-24 01:45:07 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8f7630813305a4f4f04a5f9ba20b2a7d486c0cfb:

  io_u: don't add slat samples if we are in ramp time (2017-03-07 10:18:53 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io_u: don't add slat samples if we are in ramp time

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 46d9731..e12382b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1994,7 +1994,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
  */
 void io_u_queued(struct thread_data *td, struct io_u *io_u)
 {
-	if (!td->o.disable_slat) {
+	if (!td->o.disable_slat && ramp_time_over(td)) {
 		unsigned long slat_time;
 
 		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
