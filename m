Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaHHMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Aug 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XFiq5-0002uX-I3
	for fio@vger.kernel.org; Fri, 08 Aug 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140808120003.B4123401E8@lyth.info>
Date: Fri,  8 Aug 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae7e055f755e77dfa71ae9040250ce8eec238721:

  crc/test: a few more cleanups and code unifications (2014-07-25 15:15:46 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b7f5c00db0d450aff09b35301bedf16e26e25d3a:

  verify: turn off numberio verification for meta and time_based (2014-08-07 15:27:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      verify: turn off numberio verification for meta and time_based

 verify.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index 3d7c5de..35d8969 100644
--- a/verify.c
+++ b/verify.c
@@ -411,7 +411,8 @@ static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
 	 * state of numberio, that would have been written to each block
 	 * in a previous run of fio, has been reached.
 	 */
-	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)))
+	if ((td_write(td) || td_rw(td)) && (td_min_bs(td) == td_max_bs(td)) &&
+	    !td->o.time_based)
 		if (!td->o.verify_only || td->o.loops == 0)
 			if (vh->numberio != io_u->numberio)
 				ret = EILSEQ;
