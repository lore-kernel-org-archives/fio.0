Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbcFJMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jun 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bBL6Z-0006c0-VU
	for fio@vger.kernel.org; Fri, 10 Jun 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160610120002.A0A542C00A7@kernel.dk>
Date: Fri, 10 Jun 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a275c37ab0001b62b1961e3430e58a2d42ee3dc9:

  options: mark unsupported options as such (2016-06-08 11:13:08 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 54d0a3150d44adca3ee4047fabd85651c6ea2db1:

  options: fix typos (2016-06-09 13:30:52 -0600)

----------------------------------------------------------------
Vincent Fu (1):
      options: fix typos

 options.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index e8c0b7f..5199823 100644
--- a/options.c
+++ b/options.c
@@ -2190,6 +2190,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 #else
+	{
 		.name	= "fadvise_stream",
 		.lname	= "Fadvise stream",
 		.type	= FIO_OPT_UNSUPPORTED,
@@ -2259,6 +2260,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 #else
+	{
 		.name	= "sync_file_range",
 		.lname	= "Sync file range",
 		.type	= FIO_OPT_UNSUPPORTED,
@@ -2700,7 +2702,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "verify_async_cpus",
 		.lname	= "Async verify CPUs",
 		.type	= FIO_OPT_UNSUPPORTED,
-		.help	"Your platform does not support CPU affinities",
+		.help	= "Your platform does not support CPU affinities",
 	},
 #endif
 	{
