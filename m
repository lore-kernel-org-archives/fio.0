Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34183 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEAMHM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 May 2014 08:07:12 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so2211548eek.6
        for <fio@vger.kernel.org>; Thu, 01 May 2014 05:07:10 -0700 (PDT)
From: Daniel Gollub <daniel.gollub@gmail.com>
Subject: [PATCH 1/4] Replace CONFIG_CPU_COUNT with plain CPU_COUNT
Date: Thu,  1 May 2014 14:07:01 +0200
Message-Id: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@gmail.com>

Fixes double-declartion issue of CPU_COUNT when fio.h is included by
third-party projects.

Checking for a define of CPU_COUNT seems to be a common approach
to deal with different versions of sched.h

Signed-off-by: Daniel Gollub <daniel.gollub@gmail.com>
---
 configure |   19 -------------------
 os/os.h   |    2 +-
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/configure b/configure
index 4757d67..2ba1daf 100755
--- a/configure
+++ b/configure
@@ -652,22 +652,6 @@ echo "sched_setaffinity(3 arg)      $linux_3arg_affinity"
 echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
 
 ##########################################
-# CPU_COUNT test
-cpu_count="no"
-cat > $TMPC << EOF
-#include <sched.h>
-int main(int argc, char **argv)
-{
-  cpu_set_t mask;
-  return CPU_COUNT(&mask);
-}
-EOF
-if compile_prog "" "" "cpu_count"; then
-  cpu_count="yes"
-fi
-echo "CPU_COUNT                     $cpu_count"
-
-##########################################
 # clock_gettime probe
 clock_gettime="no"
 cat > $TMPC << EOF
@@ -1335,9 +1319,6 @@ fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
-if test "$cpu_count" = "yes" ; then
-  output_sym "CONFIG_CPU_COUNT"
-fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
diff --git a/os/os.h b/os/os.h
index 2f2d069..98b4532 100644
--- a/os/os.h
+++ b/os/os.h
@@ -321,7 +321,7 @@ static inline unsigned int cpus_online(void)
 }
 #endif
 
-#ifndef CONFIG_CPU_COUNT
+#ifndef CPU_COUNT
 #ifdef FIO_HAVE_CPU_AFFINITY
 static inline int CPU_COUNT(os_cpu_mask_t *mask)
 {
-- 
1.7.10.4

