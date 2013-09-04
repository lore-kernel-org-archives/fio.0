Return-Path: <grundler@chromium.org>
From: Grant Grundler <grundler@chromium.org>
Subject: [PATCH] Remove duplicate LDFLAGS on -o lines
Date: Wed,  4 Sep 2013 13:00:27 -0700
Message-Id: <1378324827-10970-1-git-send-email-grundler@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Juan Casse <jcasse@chromium.org>, fio@vger.kernel.org, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

Only need to list LDFLAGS once on each line. :)

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index eb0e892..7c0e798 100644
--- a/Makefile
+++ b/Makefile
@@ -246,25 +246,25 @@ printing.o: printing.c printing.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c printing.c
 
 t/stest: $(T_SMALLOC_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS)
 
 t/ieee754: $(T_IEEE_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS)
 
 fio: $(FIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS)
 
 gfio: $(GFIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LIBS) -o gfio $(GFIO_OBJS) $(LIBS) $(GTK_LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o gfio $(GFIO_OBJS) $(LIBS) $(GTK_LDFLAGS)
 
 t/genzipf: $(T_ZIPF_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
 
 t/axmap: $(T_AXMAP_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_AXMAP_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_AXMAP_OBJS) $(LIBS)
 
 t/lfsr-test: $(T_LFSR_TEST_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS) $(LDFLAGS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
 clean: FORCE
 	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d config-host.mak config-host.h
-- 
1.8.4


