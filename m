Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34785 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbfHNUKb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Aug 2019 16:10:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so142870pgc.1
        for <fio@vger.kernel.org>; Wed, 14 Aug 2019 13:10:31 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 7/7] Makefile: Add 'fulltest' target
Date: Wed, 14 Aug 2019 13:10:12 -0700
Message-Id: <20190814201012.253060-8-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
References: <20190814201012.253060-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

Make it easier to run the zoned block device tests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Makefile | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index fe02bf1df86f..7c21ef8316f7 100644
--- a/Makefile
+++ b/Makefile
@@ -531,6 +531,21 @@ doc: tools/plot/fio2gnuplot.1
 test: fio
 	./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
 
+fulltest:
+	sudo modprobe null_blk &&				 	\
+	if [ ! -e /usr/include/libzbc/zbc.h ]; then			\
+	  git clone https://github.com/hgst/libzbc &&		 	\
+	  (cd libzbc &&						 	\
+	   ./autogen.sh &&					 	\
+	   ./configure --prefix=/usr &&				 	\
+	   make -j &&						 	\
+	   sudo make install)						\
+	fi &&					 			\
+	sudo t/zbd/run-tests-against-regular-nullb &&		 	\
+	if [ -e /sys/module/null_blk/parameters/zoned ]; then		\
+		sudo t/zbd/run-tests-against-zoned-nullb;	 	\
+	fi
+
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
@@ -541,3 +556,5 @@ install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 644 $(SRCDIR)/tools/hist/fiologparser_hist.py.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
 	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/*gpm $(DESTDIR)$(sharedir)/
+
+.PHONY: test fulltest
-- 
2.22.0.rc1


