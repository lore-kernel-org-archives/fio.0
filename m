Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730845AbgCPMAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Mar 2020 08:00:22 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDoPs-0002LJ-RZ
        for fio@vger.kernel.org; Mon, 16 Mar 2020 12:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200316120002.4D39D1BC01A0@kernel.dk>
Date: Mon, 16 Mar 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f75248a9d9554b668484b089713e7c2b0a154ad6:

  Fio 3.19 (2020-03-12 11:12:50 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dcdfc515ab7a245f9086c901a675a246e3b4db4e:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2020-03-15 18:59:19 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/neheb/fio

Rosen Penev (1):
      configure: fix vasprintf check under musl

 configure | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 5de86ca2..d17929f1 100755
--- a/configure
+++ b/configure
@@ -892,7 +892,8 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-  return vasprintf(NULL, "%s", NULL) == 0;
+  va_list ap;
+  return vasprintf(NULL, "%s", ap) == 0;
 }
 EOF
 if compile_prog "" "" "have_vasprintf"; then

