Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeCNMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Mar 2018 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ew54i-00042L-9E
        for fio@vger.kernel.org; Wed, 14 Mar 2018 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180314120002.5C9832C1D65@kernel.dk>
Date: Wed, 14 Mar 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c4bf91427a4fd1fbdb662667307189eabacf45b5:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-12 18:13:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 69b98f11d62cb12482130fac79b8ebf00c0bb139:

  io_u: only rewind file position if it's non-zero (2018-03-13 11:49:55 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      configure: don't disable lex on FreeBSD
      io_u: only rewind file position if it's non-zero

 configure | 2 +-
 io_u.c    | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index a73b61e..f38e9c7 100755
--- a/configure
+++ b/configure
@@ -282,7 +282,7 @@ fi
 # cross-compiling to one of these OSes then you'll need to specify
 # the correct CPU with the --cpu option.
 case $targetos in
-AIX|*BSD)
+AIX|OpenBSD|NetBSD)
   # Unless explicitly enabled, turn off lex.
   # OpenBSD will hit syntax error when enabled.
   if test -z "$disable_lex" ; then
diff --git a/io_u.c b/io_u.c
index a37b723..01b3693 100644
--- a/io_u.c
+++ b/io_u.c
@@ -430,7 +430,11 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
-		if (f->last_pos[ddir] == f->file_offset && o->ddir_seq_add < 0) {
+		/*
+		 * Only rewind if we already hit the end
+		 */
+		if (f->last_pos[ddir] == f->file_offset &&
+		    f->file_offset && o->ddir_seq_add < 0) {
 			if (f->real_file_size > f->io_size)
 				f->last_pos[ddir] = f->io_size;
 			else
