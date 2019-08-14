Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 7/7] Makefile: Add 'fulltest' target
Date: Tue, 13 Aug 2019 19:20:38 -0700
Message-Id: <20190814022038.30941-8-bvanassche@acm.org>
In-Reply-To: <20190814022038.30941-1-bvanassche@acm.org>
References: <20190814022038.30941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

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
2.22.0


