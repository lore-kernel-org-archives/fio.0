Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaCFRmi (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Mar 2014 12:42:38 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 2/2] Detect Windows operating system in ./configure
Date: Thu,  6 Mar 2014 18:41:59 +0100
Message-Id: <1394127719-3105-3-git-send-email-stefanha@redhat.com>
In-Reply-To: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@fb.com

We should not rely on `uname -s` if we ever want cross-compiling to
work, so detect _WIN32.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 configure | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure b/configure
index 7b1d79a..63aa02d 100755
--- a/configure
+++ b/configure
@@ -184,6 +184,8 @@ elif check_define __OpenBSD__ ; then
 elif check_define __sun__ ; then
   targetos='SunOS'
   CFLAGS="$CFLAGS -D_REENTRANT"
+elif check_define _WIN32 ; then
+  targetos='CYGWIN'
 else
   targetos=`uname -s`
 fi
-- 
1.8.5.3

