Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Feb 2020 08:00:12 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6Zoh-0008MZ-PK
        for fio@vger.kernel.org; Tue, 25 Feb 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200225130001.999D81BC017D@kernel.dk>
Date: Tue, 25 Feb 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1b5e13beb3acc2a08321ce687727e2cbbb3b954f:

  Merge branch 'master' of https://github.com/vincentkfu/fio (2020-02-06 12:17:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fb34110eac72f01651543095656693f196d895ca:

  Merge branch 'div-by-zero' of https://github.com/vincentkfu/fio (2020-02-24 08:23:52 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'div-by-zero' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      t/latency_percentiles: avoid division by zero

 t/latency_percentiles.py | 5 +++++
 1 file changed, 5 insertions(+)

---

Diff of recent changes:

diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index 0c8d0c19..5cdd49cf 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -395,6 +395,11 @@ class FioLatTest():
         approximation   value of the bin used by fio to store a given latency
         actual          actual latency value
         """
+
+        # Avoid a division by zero. The smallest latency values have no error.
+        if actual == 0:
+            return approximation == 0
+
         delta = abs(approximation - actual) / actual
         return delta <= 1/128
 

