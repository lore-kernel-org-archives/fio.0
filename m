Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CF2C43334
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242172AbiFNMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiFNMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C9047063
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=LQDbjy1JxNRWRiDCoZbzjFyfdtQ0lyjG/3jp5dXzFjs=; b=m3a4RbJdKAQ0Gfod4t7cx+LLSu
        nCRmwh8/I6erUBhEW0wPSTTZvcBXEP5t7JcNEwS55smn/nSCATjt11dHJJUWBsfx/0MZthgfEinhq
        qlIXJ1nXNXZoxg6yKVUz32lAIQh3C9rNCqISDj4u4W48vt/fgWLDa2VgmzBtWYYfJlpOiJfSmYy4Q
        GzK4hPXKehtRMLU0HbG92M8nvABDI0p6ll3HYKfYnrCf5TiU8gHLUnebuTS5JTUXILbOXocr74f0n
        9ZBnPAoe/eyvjqee5Cr4a/0GYRx1ErRWOvvnRsjiNf/rTH/dKnD5YJnG0oiK5TbedcotOUSNPKMVp
        SteWaHtA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o15DH-0008eK-QD
        for fio@vger.kernel.org; Tue, 14 Jun 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 91B521BC0151; Tue, 14 Jun 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220614120001.91B521BC0151@kernel.dk>
Date:   Tue, 14 Jun 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 26faead0f3c6e7608b89a51373f1455b91377fcb:

  t/zbd: skip test case #13 when max_open_zones is too small (2022-06-02 03:58:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b5f3adf9e1e40c7bdb76a9e433aa580f7eead740:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-06-13 18:14:26 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      configure: Support gcc 12
      configure: Fix libzbc detection on SUSE Linux

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 configure | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 8182322b..510af424 100755
--- a/configure
+++ b/configure
@@ -1128,7 +1128,8 @@ cat > $TMPC << EOF
 #include <sched.h>
 int main(int argc, char **argv)
 {
-  cpu_set_t mask;
+  cpu_set_t mask = { };
+
   return sched_setaffinity(0, sizeof(mask), &mask);
 }
 EOF
@@ -1139,7 +1140,8 @@ else
 #include <sched.h>
 int main(int argc, char **argv)
 {
-  cpu_set_t mask;
+  cpu_set_t mask = { };
+
   return sched_setaffinity(0, &mask);
 }
 EOF
@@ -1621,7 +1623,8 @@ cat > $TMPC << EOF
 #include <sched.h>
 int main(int argc, char **argv)
 {
-  struct sched_param p;
+  struct sched_param p = { };
+
   return sched_setscheduler(0, SCHED_IDLE, &p);
 }
 EOF
@@ -1743,7 +1746,9 @@ cat > $TMPC << EOF
 #include <sys/uio.h>
 int main(int argc, char **argv)
 {
-  return pwritev(0, NULL, 1, 0) + preadv(0, NULL, 1, 0);
+  struct iovec iov[1] = { };
+
+  return pwritev(0, iov, 1, 0) + preadv(0, iov, 1, 0);
 }
 EOF
 if compile_prog "" "" "pwritev"; then
@@ -1761,7 +1766,9 @@ cat > $TMPC << EOF
 #include <sys/uio.h>
 int main(int argc, char **argv)
 {
-  return pwritev2(0, NULL, 1, 0, 0) + preadv2(0, NULL, 1, 0, 0);
+  struct iovec iov[1] = { };
+
+  return pwritev2(0, iov, 1, 0, 0) + preadv2(0, iov, 1, 0, 0);
 }
 EOF
 if compile_prog "" "" "pwritev2"; then
@@ -1787,14 +1794,14 @@ cat > $TMPC << EOF
 #include <stdio.h>
 int main(int argc, char **argv)
 {
-  struct addrinfo hints;
-  struct in6_addr addr;
+  struct addrinfo hints = { };
+  struct in6_addr addr = in6addr_any;
   int ret;
 
   ret = getaddrinfo(NULL, NULL, &hints, NULL);
   freeaddrinfo(NULL);
-  printf("%s\n", gai_strerror(ret));
-  addr = in6addr_any;
+  printf("%s %d\n", gai_strerror(ret), addr.s6_addr[0]);
+
   return 0;
 }
 EOF
@@ -2155,9 +2162,7 @@ cat > $TMPC << EOF
 #include <stdlib.h>
 int main(int argc, char **argv)
 {
-  int rc;
-  rc = pmem_is_pmem(NULL, 0);
-  return 0;
+  return pmem_is_pmem(NULL, 0);
 }
 EOF
 if compile_prog "" "-lpmem" "libpmem"; then
@@ -2176,7 +2181,7 @@ if test "$libpmem" = "yes"; then
 #include <stdlib.h>
 int main(int argc, char **argv)
 {
-  pmem_memcpy(NULL, NULL, NULL, NULL);
+  pmem_memcpy(NULL, NULL, 0, 0);
   return 0;
 }
 EOF
@@ -2392,7 +2397,7 @@ int main(int argc, char **argv)
   FILE *mtab = setmntent(NULL, "r");
   struct mntent *mnt = getmntent(mtab);
   endmntent(mtab);
-  return 0;
+  return mnt != NULL;
 }
 EOF
 if compile_prog "" "" "getmntent"; then
@@ -2573,6 +2578,10 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$libzbc" != "no" ; then
+  if [ -e /usr/include/libzbc/libzbc ]; then
+    # SUSE Linux.
+    CFLAGS="$CFLAGS -I/usr/include/libzbc"
+  fi
   if compile_prog "" "-lzbc" "libzbc"; then
     libzbc="yes"
     if ! check_min_lib_version libzbc 5; then
