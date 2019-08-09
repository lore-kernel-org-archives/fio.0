Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406435AbfHIMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Aug 2019 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hw3Yy-0006gQ-SG
        for fio@vger.kernel.org; Fri, 09 Aug 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190809120001.CC3632C0099@kernel.dk>
Date: Fri,  9 Aug 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c1f6f32ea74316df1e8707eba4fb95ab14fae6f7:

  Add tests from t/ to the Windows installer (2019-08-05 14:45:50 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 937ec971236d98089b63217635294c788ea00bce:

  t/zbd: Fix I/O bytes rounding errors (2019-08-08 21:36:32 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      t/zbd: Fix I/O bytes rounding errors

 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 10c78e9a..6fb48ef0 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -85,7 +85,8 @@ run_fio() {
 
     fio=$(dirname "$0")/../../fio
 
-    opts=("--aux-path=/tmp" "--allow_file_create=0" "$@")
+    opts=("--aux-path=/tmp" "--allow_file_create=0" \
+			    "--significant_figures=10" "$@")
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"

