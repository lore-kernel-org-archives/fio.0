Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbbIYMAc (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Sep 2015 08:00:32 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZfRg0-0004eJ-Hb
	for fio@vger.kernel.org; Fri, 25 Sep 2015 12:00:32 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150925120001.A24582C0608@kernel.dk>
Date: Fri, 25 Sep 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 01cbd4d913d4eed56dc51256cddfe327b9c28d4c:

  Update fio2gnuplot (2015-09-17 19:42:34 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 194fffd042d374d5e13af61a14fe16734c396d8c:

  Fix integer overflow in rate_iops (2015-09-24 20:35:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fix integer overflow in rate_iops

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index cdb98c5..684cd60 100644
--- a/init.c
+++ b/init.c
@@ -465,7 +465,7 @@ static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.rate[ddir])
 		td->rate_bps[ddir] = td->o.rate[ddir];
 	else
-		td->rate_bps[ddir] = td->o.rate_iops[ddir] * bs;
+		td->rate_bps[ddir] = (uint64_t) td->o.rate_iops[ddir] * bs;
 
 	if (!td->rate_bps[ddir]) {
 		log_err("rate lower than supported\n");
