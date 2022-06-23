Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CB0C43334
	for <fio@archiver.kernel.org>; Thu, 23 Jun 2022 12:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiFWMB5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 23 Jun 2022 08:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiFWMBe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Jun 2022 08:01:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00B44F1CD
        for <fio@vger.kernel.org>; Thu, 23 Jun 2022 05:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Eiopvv+ih6hJ2foS7OD5v0JPtmVAPbaTGmYTLaf6bUs=; b=QKHM9WMZRZUx1wVQN6Uxra8A4L
        j5qNBapN5DBq/CMwbFeD1L6eeR9kB1bXNdoNhNHhBz4UNRrPYXljxr6GTTpQvoobpXt1+Qyter6hO
        VhBJz5SSPslw2yGNjVlPXya4jOeL5fYuBetO+UHNxBVQvDZiHLcENueZJGlXdzPCZFBg0xRmUpVIv
        88pCAqATSQocyEbobthQv2U2c5JTJefLxXyhYah//v2KI/+PIHGN5OpKIscUkMcdNYMgoqIjUk0hN
        BTWsABOju+RpYE8qcJsN/7NTz4A1m5ipFq20bZsENMeXhEjXQIS9NOAFnZXy9jb9qVAzNHmmQe2PV
        wkP0NSuw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4LVE-007qBS-T4
        for fio@vger.kernel.org; Thu, 23 Jun 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1055B1BC0117; Thu, 23 Jun 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220623120002.1055B1BC0117@kernel.dk>
Date:   Thu, 23 Jun 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d4bf5e6193b97c5e5490fdb93b069d149a38777c:

  gettime: fix whitespace damage (2022-06-19 12:04:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6aaebfbe7269f95164ac83a04505869f96f5f83a:

  configure: add option to disable xnvme build (2022-06-22 11:45:32 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      configure: add option to disable xnvme build

 configure | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 510af424..04a1d0e2 100755
--- a/configure
+++ b/configure
@@ -171,7 +171,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libnfs="no"
-xnvme="no"
+xnvme=""
 libzbc=""
 dfs=""
 dynamic_engines="no"
@@ -241,7 +241,7 @@ for opt do
   ;;
   --disable-libzbc) libzbc="no"
   ;;
-  --enable-xnvme) xnvme="yes"
+  --disable-xnvme) xnvme="no"
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
@@ -294,7 +294,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
-  echo "--enable-xnvme          Enable xnvme support"
+  echo "--disable-xnvme         Disable xnvme support even if found"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
   echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
@@ -2619,7 +2619,7 @@ fi
 
 ##########################################
 # Check if we have xnvme
-if test "$xnvme" != "yes" ; then
+if test "$xnvme" != "no" ; then
   if check_min_lib_version xnvme 0.2.0; then
     xnvme="yes"
     xnvme_cflags=$(pkg-config --cflags xnvme)
