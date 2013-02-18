Return-Path: <fio-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:46767 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265Ab3BRER1 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 17 Feb 2013 23:17:27 -0500
Received: From
	[192.168.1.100] ([124.168.163.25] == 124-168-163-25.dyn.iinet.net.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By note With Smtp ;
	Mon, 18 Feb 2013 15:17:24 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Mon, 18 Feb 2013 15:17:24 +1100
Message-ID: <5121AB54.5090507@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: [PATCH] configure: missing Android config options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

We need this for the run-time endianness check to pass.  Add supported
clock monotonic while we're at it.

---
 configure |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/configure b/configure
index 8267e1c..caaf30e 100755
--- a/configure
+++ b/configure
@@ -227,9 +227,11 @@ CYGWIN*)
   ;;
 Android)
   output_sym "CONFIG_32BIT"
+  output_sym "CONFIG_LITTLE_ENDIAN"
   output_sym "CONFIG_SOCKLEN_T"
   output_sym "CONFIG_GETTIMEOFDAY"
   output_sym "CONFIG_CLOCK_GETTIME"
+  output_sym "CONFIG_CLOCK_MONOTONIC"
   echo "CC=$cc" >> $config_host_mak
   echo "EXTFLAGS=$CFLAGS -include config-host.h -DFIO_NO_HAVE_SHM_H
-D_GNU_SOURCE" >> $config_host_mak
   exit 0
-- 
1.7.0.4

