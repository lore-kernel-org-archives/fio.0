Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43890 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEIMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 9 May 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yr3QL-0000bk-3D
	for fio@vger.kernel.org; Sat, 09 May 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150509120002.431992C1079@kernel.dk>
Date: Sat,  9 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 81f3d8e9b0c7e178fc308e6416fade2756898fed:

  Fio 2.2.8 (2015-05-07 18:19:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 94d8288ef299b544d518da69f21a6df9a04eb086:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2015-05-08 09:21:17 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      random: document default seed value
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 HOWTO     |  1 +
 init.c    | 10 +++-------
 options.c |  1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0808cc3..d62d408 100644
--- a/HOWTO
+++ b/HOWTO
@@ -435,6 +435,7 @@ unified_rw_reporting=bool	Fio normally reports statistics on a per
 
 randrepeat=bool	For random IO workloads, seed the generator in a predictable
 		way so that results are repeatable across repetitions.
+		Defaults to true.
 
 randseed=int	Seed the random number generators based on this seed value, to
 		be able to control what sequence of output is being generated.
diff --git a/init.c b/init.c
index fa50d3c..ba5bf2f 100644
--- a/init.c
+++ b/init.c
@@ -749,7 +749,7 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * If randseed is set, that overrides randrepeat
 	 */
-	if (td->o.rand_seed)
+	if (fio_option_is_set(&td->o, rand_seed))
 		td->o.rand_repeatable = 0;
 
 	if ((td->io_ops->flags & FIO_NOEXTEND) && td->o.file_append) {
@@ -966,14 +966,10 @@ static int setup_random_seeds(struct thread_data *td)
 	unsigned long seed;
 	unsigned int i;
 
-	if (!td->o.rand_repeatable && !td->o.rand_seed)
+	if (!td->o.rand_repeatable && !fio_option_is_set(&td->o, rand_seed))
 		return init_random_state(td, td->rand_seeds, sizeof(td->rand_seeds));
 
-	if (!td->o.rand_seed)
-		seed = 0x89;
-	else
-		seed = td->o.rand_seed;
-
+	seed = td->o.rand_seed;
 	for (i = 0; i < 4; i++)
 		seed *= 0x9e370001UL;
 
diff --git a/options.c b/options.c
index f21ed26..e306b28 100644
--- a/options.c
+++ b/options.c
@@ -1845,6 +1845,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= td_var_offset(rand_seed),
 		.help	= "Set the random generator seed value",
+		.def	= "0x89",
 		.parent = "rw",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RANDOM,
