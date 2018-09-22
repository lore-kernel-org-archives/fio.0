Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35284 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbeIVRxb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Sep 2018 13:53:31 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g3ga3-00067R-E7
        for fio@vger.kernel.org; Sat, 22 Sep 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180922120001.BF67F2C031B@kernel.dk>
Date: Sat, 22 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4d2707ef027cc5b2418ab5de622318e0f70c096a:

  blktrace: fix leak of 'merge_buf' (2018-09-20 14:25:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 843c6b5e081900394da002b45253e541b794ac54:

  Merge branch 'steadystate-doc' of https://github.com/vincentkfu/fio (2018-09-21 09:50:07 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/http: work-around crash in certain libssl versions
      Merge branch 'steadystate-doc' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      docs: clarify usage of steadystate detection feature

 HOWTO          | 4 ++++
 engines/http.c | 2 ++
 fio.1          | 6 ++++++
 3 files changed, 12 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 45cf0bd..9528904 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3000,6 +3000,10 @@ Steady state
 	data from the rolling collection window. Threshold limits can be expressed
 	as a fixed value or as a percentage of the mean in the collection window.
 
+	When using this feature, most jobs should include the :option:`time_based`
+	and :option:`runtime` options or the :option:`loops` option so that fio does not
+	stop running after it has covered the full size of the specified file(s) or device(s).
+
 		**iops**
 			Collect IOPS data. Stop the job if all individual IOPS measurements
 			are within the specified limit of the mean IOPS (e.g., ``iops:2``
diff --git a/engines/http.c b/engines/http.c
index 93fcd0d..d81e428 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -273,6 +273,8 @@ static void _hmac(unsigned char *md, void *key, int key_len, char *data) {
 	ctx = HMAC_CTX_new();
 #else
 	ctx = &_ctx;
+	/* work-around crash in certain versions of libssl */
+	HMAC_CTX_init(ctx);
 #endif
 	HMAC_Init_ex(ctx, key, key_len, EVP_sha256(), NULL);
 	HMAC_Update(ctx, (unsigned char*)data, strlen(data));
diff --git a/fio.1 b/fio.1
index 81164ae..5c11d96 100644
--- a/fio.1
+++ b/fio.1
@@ -2671,6 +2671,12 @@ steady state assessment criteria. All assessments are carried out using only
 data from the rolling collection window. Threshold limits can be expressed
 as a fixed value or as a percentage of the mean in the collection window.
 .RS
+.P
+When using this feature, most jobs should include the \fBtime_based\fR
+and \fBruntime\fR options or the \fBloops\fR option so that fio does not
+stop running after it has covered the full size of the specified file(s)
+or device(s).
+.RS
 .RS
 .TP
 .B iops

