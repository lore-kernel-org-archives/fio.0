Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKZNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Nov 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XtcCS-0006Ar-Gi
	for fio@vger.kernel.org; Wed, 26 Nov 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141126130003.5B67F40129@lyth.info>
Date: Wed, 26 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dd9bd2b2e0ed9665325240fdd5a40253fe23bca6:

  Fixup t/ test apps for lfsr_next change() (2014-11-24 08:07:03 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 867198458145fc405d1925e339719f779fb671c2:

  Make gfio build with --build-static (2014-11-25 16:02:52 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Make gfio build with --build-static

 Makefile  |    2 +-
 configure |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8a28f62..ff00c0c 100644
--- a/Makefile
+++ b/Makefile
@@ -334,7 +334,7 @@ fio: $(FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
 
 gfio: $(GFIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) -o gfio $(GFIO_OBJS) $(LIBS) $(GTK_LDFLAGS)
+	$(QUIET_LINK)$(CC) $(filter-out -static, $(LDFLAGS)) -o gfio $(GFIO_OBJS) $(LIBS) $(GFIO_LIBS) $(GTK_LDFLAGS)
 
 t/fio-genzipf: $(T_ZIPF_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
diff --git a/configure b/configure
index aaad70e..5e5596d 100755
--- a/configure
+++ b/configure
@@ -1010,6 +1010,8 @@ int main(void)
 }
 EOF
 GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
+ORG_LDFLAGS=$LDFLAGS
+LDFLAGS=$(echo $LDFLAGS | sed s/"-static"//g)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
@@ -1023,7 +1025,7 @@ if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
   r=$($TMPE)
   if test "$r" != "0" ; then
     gfio="yes"
-    LIBS="$LIBS $GTK_LIBS"
+    GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
   else
     echo "GTK found, but need version 2.18 or higher"
@@ -1033,6 +1035,7 @@ else
   echo "Please install gtk and gdk libraries"
   gfio="no"
 fi
+LDFLAGS=$ORG_LDFLAGS
 fi
 
 if test "$gfio_check" = "yes" ; then
@@ -1578,6 +1581,7 @@ if test "$zlib" = "no" ; then
 fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
+echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
 echo "LDFLAGS+=$LDFLAGS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
