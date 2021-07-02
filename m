Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhGBMCi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Jul 2021 08:02:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98E5C061762
        for <fio@vger.kernel.org>; Fri,  2 Jul 2021 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzHq0-00DqnQ-SE
        for fio@vger.kernel.org; Fri, 02 Jul 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210702120002.09B851BC0165@kernel.dk>
Date: Fri,  2 Jul 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ea51055cbb2fcbca3935e25c78e8b6d358ca2b3f:

  zbd: ensure that global max open zones limit is respected (2021-06-29 07:43:30 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 77c72e0f504364adf6a0e8f1155fdf3fd68ef248:

  Merge branch 'dedupe_bugfix' of https://github.com/bardavid/fio (2021-07-01 13:27:39 -0600)

----------------------------------------------------------------
Bar David (1):
      dedupe: fixing bug with subsequent dedupe buffer generation

Jens Axboe (1):
      Merge branch 'dedupe_bugfix' of https://github.com/bardavid/fio

 fio.h  |  1 +
 io_u.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index b05cb3df..83334652 100644
--- a/fio.h
+++ b/fio.h
@@ -259,6 +259,7 @@ struct thread_data {
 
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
+	struct frand_state buf_state_ret;
 	struct frand_state dedupe_state;
 	struct frand_state zone_state;
 	struct frand_state prio_state;
diff --git a/io_u.c b/io_u.c
index b421a579..b60488a3 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2182,8 +2182,16 @@ static struct frand_state *get_buf_state(struct thread_data *td)
 
 	v = rand_between(&td->dedupe_state, 1, 100);
 
-	if (v <= td->o.dedupe_percentage)
-		return &td->buf_state_prev;
+	if (v <= td->o.dedupe_percentage) {
+		/*
+		 * The caller advances the returned frand_state.
+		 * A copy of prev should be returned instead since
+		 * a subsequent intention to generate a deduped buffer
+		 * might result in generating a unique one
+		 */
+		frand_copy(&td->buf_state_ret, &td->buf_state_prev);
+		return &td->buf_state_ret;
+	}
 
 	return &td->buf_state;
 }

