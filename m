Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:42450 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab3CNF6P (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Mar 2013 01:58:15 -0400
Received: From
	localhost.localdomain ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Thu, 14 Mar 2013 16:58:12 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 16:57:41 +1100
Subject: [PATCH 4/4] Android: remove static Android configuration
Message-Id: <1363240661-4499-5-git-send-email-aaronc@cse.unsw.edu.au>
In-Reply-To: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
References: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Android can now be configured dynamically, so remove the static config.
For this we need to modify the socklen_t check #includes which appear to
be wrong anyway.

Signed-off-by: Aaron Carroll <aaronc@cse.unsw.edu.au>
---
 configure |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/configure b/configure
index 965623d..2859891 100755
--- a/configure
+++ b/configure
@@ -233,16 +233,6 @@ CYGWIN*)
   echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
   exit 0
   ;;
-Android)
-  output_sym "CONFIG_32BIT"
-  output_sym "CONFIG_LITTLE_ENDIAN"
-  output_sym "CONFIG_SOCKLEN_T"
-  output_sym "CONFIG_GETTIMEOFDAY"
-  output_sym "CONFIG_CLOCK_GETTIME"
-  output_sym "CONFIG_CLOCK_MONOTONIC"
-  echo "CC=$cc" >> $config_host_mak
-  echo "EXTFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
-  exit 0
 esac
 
 if test ! -z "$cpu" ; then
@@ -874,8 +864,7 @@ echo "inet_aton                     $inet_aton"
 # socklen_t probe
 socklen_t="no"
 cat > $TMPC << EOF
-#include <string.h>
-#include <netinet/in.h>
+#include <sys/socket.h>
 int main(int argc, char **argv)
 {
   socklen_t len = 0;
-- 
1.7.0.4

