Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Jun 2019 08:00:07 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hX2gB-00040v-8H
        for fio@vger.kernel.org; Sat, 01 Jun 2019 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190601120001.7B7302C005C@kernel.dk>
Date: Sat,  1 Jun 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ce4d13ca162df4127ec3b5911553802c53396705:

  glusterfs: update for new API (2019-05-23 14:57:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 971341ad741db8d2ae57d8f9b368d75f6c02c1a9:

  Merge branch 'wip-tcmalloc' of https://github.com/dillaman/fio (2019-05-31 15:37:18 -0600)

----------------------------------------------------------------
Helmut Grohne (2):
      configure: apply ${cross_prefix} to pkg-config calls
      configure: check for gtk version using pkg-config

Jason Dillaman (1):
      configure: attempt to link against tcmalloc by default if available

Jens Axboe (1):
      Merge branch 'wip-tcmalloc' of https://github.com/dillaman/fio

 configure | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index b0052dc1..a0692d58 100755
--- a/configure
+++ b/configure
@@ -207,6 +207,8 @@ for opt do
   ;;
   --enable-libiscsi) libiscsi="yes"
   ;;
+  --disable-tcmalloc) disable_tcmalloc="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -243,6 +245,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-native        Don't build for native host"
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
+  echo "--disable-tcmalloc	Disable tcmalloc support"
   exit $exit_val
 fi
 
@@ -1344,31 +1347,30 @@ int main(void)
   return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
-GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
+GTK_CFLAGS=$(${cross_prefix}pkg-config --cflags gtk+-2.0 gthread-2.0)
 ORG_LDFLAGS=$LDFLAGS
 LDFLAGS=$(echo $LDFLAGS | sed s/"-static"//g)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-GTK_LIBS=$(pkg-config --libs gtk+-2.0 gthread-2.0)
+GTK_LIBS=$(${cross_prefix}pkg-config --libs gtk+-2.0 gthread-2.0)
 if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
-  $TMPE
-  if test "$?" = "0" ; then
+if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
+  echo "GTK found, but need version 2.18 or higher"
+  gfio="no"
+else
+  if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
     gfio="yes"
     GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
   else
-    echo "GTK found, but need version 2.18 or higher"
+    echo "Please install gtk and gdk libraries"
     gfio="no"
   fi
-else
-  echo "Please install gtk and gdk libraries"
-  gfio="no"
 fi
 LDFLAGS=$ORG_LDFLAGS
 fi
@@ -2696,6 +2698,19 @@ if test "$libiscsi" = "yes" ; then
   echo "LIBISCSI_CFLAGS=$libiscsi_cflags" >> $config_host_mak
   echo "LIBISCSI_LIBS=$libiscsi_libs" >> $config_host_mak
 fi
+cat > $TMPC << EOF
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if test "$disable_tcmalloc" != "yes"  && compile_prog "" "-ltcmalloc" "tcmalloc"; then
+  LIBS="-ltcmalloc $LIBS"
+  tcmalloc="yes"
+else
+  tcmalloc="no"
+fi
+print_config "TCMalloc support" "$tcmalloc"
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak

