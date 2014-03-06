Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaCFRmH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Mar 2014 12:42:07 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 1/2] Honor ./configure --cc= option
Date: Thu,  6 Mar 2014 18:41:58 +0100
Message-Id: <1394127719-3105-2-git-send-email-stefanha@redhat.com>
In-Reply-To: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@fb.com

The cc variable is assigned before parsing command-line options.  This
effectively ignores the ./configure --cc= option.  Move the cc variable
assigned below option parsing.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 configure | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 4a8d352..7b1d79a 100755
--- a/configure
+++ b/configure
@@ -130,9 +130,6 @@ output_sym() {
 targetos=""
 cpu=""
 
-cross_prefix=${cross_prefix-${CROSS_COMPILE}}
-cc="${CC-${cross_prefix}gcc}"
-
 # default options
 show_help="no"
 exit_val=0
@@ -175,6 +172,9 @@ if test "$show_help" = "yes" ; then
   exit $exit_val
 fi
 
+cross_prefix=${cross_prefix-${CROSS_COMPILE}}
+cc="${CC-${cross_prefix}gcc}"
+
 if check_define __ANDROID__ ; then
   targetos="Android"
 elif check_define __linux__ ; then
-- 
1.8.5.3

