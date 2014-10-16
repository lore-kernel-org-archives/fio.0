Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJPMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xejiu-0005J8-Hl
	for fio@vger.kernel.org; Thu, 16 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141016120003.57CB840080@lyth.info>
Date: Thu, 16 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit de06a46881e1a8876b5fd1de5e002d6189a90a30:

  Get rid if --header-file argument for lex (2014-10-14 21:12:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0f9940ad60550da5198e2d1e63e11803f5aef914:

  BSD Yacc doesn't understand --no-lines, so use -l instead (2014-10-15 14:16:35 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      BSD Yacc doesn't understand --no-lines, so use -l instead

Jens Axboe (1):
      engines/net: get rid of conversion warning on clang/OSX

 Makefile      |    2 +-
 engines/net.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 0f77df9..55a93fc 100644
--- a/Makefile
+++ b/Makefile
@@ -276,7 +276,7 @@ y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 
 y.tab.c: exp/expression-parser.y
-	$(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) -l -d -b y exp/expression-parser.y
 
 y.tab.h: y.tab.c
 
diff --git a/engines/net.c b/engines/net.c
index aa7de96..7a0fe69 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -485,7 +485,7 @@ static void store_udp_seq(struct netio_data *nd, struct io_u *io_u)
 	struct udp_seq *us;
 
 	us = io_u->xfer_buf + io_u->xfer_buflen - sizeof(*us);
-	us->magic = cpu_to_le64(FIO_UDP_SEQ_MAGIC);
+	us->magic = cpu_to_le64((uint64_t) FIO_UDP_SEQ_MAGIC);
 	us->bs = cpu_to_le64((uint64_t) io_u->xfer_buflen);
 	us->seq = cpu_to_le64(nd->udp_send_seq++);
 }
