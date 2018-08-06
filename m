Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60432 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbeHFOIv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Aug 2018 10:08:51 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fmeBA-0008Uj-DW
        for fio@vger.kernel.org; Mon, 06 Aug 2018 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180806120002.4CB4F2C0311@kernel.dk>
Date: Mon,  6 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1d73ff2a4a8f02905cf338b2f0286d76d64e7c2a:

  iolog: move the chunked items-to-fetch logic into separate function (2018-08-03 14:40:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b87ed299820c26e8c4271294b0c5037e8d0a3d4a:

  client: support --status-interval option in client/server mode (2018-08-05 15:12:12 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (1):
      client: support --status-interval option in client/server mode

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index ede0a8b..06f6971 100644
--- a/init.c
+++ b/init.c
@@ -258,7 +258,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	{
 		.name		= (char *) "status-interval",
 		.has_arg	= required_argument,
-		.val		= 'L',
+		.val		= 'L' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "trigger-file",
