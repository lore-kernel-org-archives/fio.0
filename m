Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIPMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Sep 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XTrQS-00005b-91
	for fio@vger.kernel.org; Tue, 16 Sep 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140916120002.EFD87401F8@lyth.info>
Date: Tue, 16 Sep 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8a91fd4b0d42c730d48b5cd672df869609975a0a:

  Fio 2.1.12 (2014-09-12 12:09:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b7c88f86c9a5a92883effc1f119f6c7b36d087e0:

  options: fix single use if / for bssplit (2014-09-15 18:51:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      options: fix single use if / for bssplit

 options.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index bc07885..ce95513 100644
--- a/options.c
+++ b/options.c
@@ -133,7 +133,7 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 			perc += bsp->perc;
 	}
 
-	if (perc > 100) {
+	if (perc > 100 && perc_missing > 1) {
 		log_err("fio: bssplit percentages add to more than 100%%\n");
 		free(bssplit);
 		return 1;
@@ -143,6 +143,8 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 	 * them.
 	 */
 	if (perc_missing) {
+		if (perc_missing == 1)
+			perc = 100;
 		for (i = 0; i < o->bssplit_nr[ddir]; i++) {
 			struct bssplit *bsp = &bssplit[i];
 
