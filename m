Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34703 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfHMCB4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Aug 2019 22:01:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so144125pfp.1
        for <fio@vger.kernel.org>; Mon, 12 Aug 2019 19:01:56 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/5] make test: Also run zbd tests
Date: Mon, 12 Aug 2019 19:01:36 -0700
Message-Id: <20190813020136.15798-6-bvanassche@acm.org>
In-Reply-To: <20190813020136.15798-1-bvanassche@acm.org>
References: <20190813020136.15798-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>

Include the ZBD tests in Travis runs such that the ZBD tests are run when
a fio pull request is submitted from the github website.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 .travis.yml |  3 +++
 Makefile    | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index 4a87fe6c45f8..26ed74ab7416 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,7 @@
 language: c
+sudo: required
+# Choose trusty because the default dist (xenial) does not have null_blk
+dist: trusty
 os:
   - linux
 compiler:
diff --git a/Makefile b/Makefile
index fe02bf1df86f..803074e7db7f 100644
--- a/Makefile
+++ b/Makefile
@@ -530,6 +530,20 @@ doc: tools/plot/fio2gnuplot.1
 
 test: fio
 	./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
+	if modinfo null_blk >/dev/null 2>&1 &&				       \
+		sudo modprobe null_blk &&				       \
+		[ -e /sys/kernel/config/nullb ]; then			       \
+		git clone https://github.com/hgst/libzbc &&		       \
+		(cd libzbc &&						       \
+		./autogen.sh &&						       \
+		./configure --prefix=/usr &&				       \
+		make -j &&						       \
+		sudo make install) &&					       \
+		sudo t/zbd/run-tests-against-regular-nullb &&		       \
+		if modinfo null_blk | grep -q '^parm:[[:blank:]]*zoned:'; then \
+			sudo t/zbd/run-tests-against-zoned-nullb;	       \
+		fi;							       \
+	fi
 
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
-- 
2.22.0


