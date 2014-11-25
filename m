Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaKYNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Nov 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XtFiv-0001PN-KL
	for fio@vger.kernel.org; Tue, 25 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141125130003.3A9C140128@lyth.info>
Date: Tue, 25 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6f49f8bc80fbeff3d24cf84278d2611db0ec6f6c:

  lfsr: don't pass in last value to lfsr_next() (2014-11-23 18:41:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dd9bd2b2e0ed9665325240fdd5a40253fe23bca6:

  Fixup t/ test apps for lfsr_next change() (2014-11-24 08:07:03 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Fixup t/ test apps for lfsr_next change()

 t/axmap.c     |    2 +-
 t/lfsr-test.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/axmap.c b/t/axmap.c
index 57c585b..e32ff98 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -37,7 +37,7 @@ static int test_regular(size_t size, int seed)
 	while (size--) {
 		uint64_t val;
 
-		if (lfsr_next(&lfsr, &val, osize)) {
+		if (lfsr_next(&lfsr, &val)) {
 			printf("lfsr: short loop\n");
 			err = 1;
 			break;
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index 4b54248..901f1a6 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -89,7 +89,7 @@ int main(int argc, char *argv[])
 	 */
 	fprintf(stderr, "\nTest initiated... ");
 	fio_gettime(&start, NULL);
-	while (!lfsr_next(fl, &i, fl->max_val)) {
+	while (!lfsr_next(fl, &i)) {
 		if (verify)
 			*(uint8_t *)(v + i) += 1;
 	}
