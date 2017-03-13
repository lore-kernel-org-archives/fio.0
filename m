Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55323 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbdCMMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Mar 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cnOdu-0007E8-De
        for fio@vger.kernel.org; Mon, 13 Mar 2017 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170313120001.98BE52C1C4D@kernel.dk>
Date: Mon, 13 Mar 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca205a752c3d6ebe7de74a3dfe81808e48a502e3:

  configure: Make Cygwin take regular configure path (2017-03-10 14:43:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e9bd687d147d5aee710d56854524bbada5a34650:

  Makefile: make test target use thread (2017-03-12 21:04:45 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: make test target use thread

Theodore Ts'o (1):
      Only enable arm64 CRC32 acceleration if the required header files are there

 Makefile  | 2 +-
 configure | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 4112410..37150c6 100644
--- a/Makefile
+++ b/Makefile
@@ -449,7 +449,7 @@ doc: tools/plot/fio2gnuplot.1
 	@man -t tools/hist/fiologparser_hist.py.1 | ps2pdf - fiologparser_hist.pdf
 
 test: fio
-	./fio --minimal --ioengine=null --runtime=1s --name=nulltest --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifynulltest --rw=write --verify=crc32c --verify_state_save=0 --size=100M
+	./fio --minimal --thread --ioengine=null --runtime=1s --name=nulltest --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifynulltest --rw=write --verify=crc32c --verify_state_save=0 --size=100M
 
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
diff --git a/configure b/configure
index 7b55711..a7610b1 100755
--- a/configure
+++ b/configure
@@ -1943,6 +1943,10 @@ if test "$march_armv8_a_crc_crypto" != "yes" ; then
 fi
 if test "$cpu" = "arm64" ; then
   cat > $TMPC <<EOF
+#include <sys/auxv.h>
+#include <arm_acle.h>
+#include <arm_neon.h>
+
 int main(void)
 {
   return 0;
