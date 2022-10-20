Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA84C4332F
	for <fio@archiver.kernel.org>; Thu, 20 Oct 2022 12:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJTMAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Oct 2022 08:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJTMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2022 08:00:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE13C5130
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fiFyw2yNeozQkyDxIvRYLHDAa7px+A/xckT+kbkxntc=; b=QlF6LdnkdEbyvVOfX8/5c6Rsn6
        1TC0hkNrJXW7S6tfr/2RN4QsaatwdmRU0DUQesWf9dtzwYfie9QGgEDTiQsKlZsYiqZ7yaNGoCOdw
        qRVzQ5cMmvzcIj3L/mudOaLW/OaScISkYnw5Qx3UZ7syzxG7urAKKaMejp98p3y60/QiSgeuMzYx8
        BDThocsuj8kryiZ4z3EZlvBWt4B+wjwA9ZWXLfL+5oC/CoTfglKRre2OpbjMJAmZybiLCYtlYS4TW
        /wIZand3oG9nUtVpnlgJe+wZdNAcAQnBkLLTYcBzsQO6V2FrCULRJPXLklYFrw6+tL/DhPfN+53dB
        bPlJY5FQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1olUDV-0051YK-Ag
        for fio@vger.kernel.org; Thu, 20 Oct 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DEF0A1BC015C; Thu, 20 Oct 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221020120001.DEF0A1BC015C@kernel.dk>
Date:   Thu, 20 Oct 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2f160e0c8848bab566427a11eee116d8e834bcf0:

  test: change GitHub actions checkout from v2 to v3 (2022-10-18 11:13:03 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 548f1269e3772c666cac4148453d9c63bdfa65c4:

  Merge branch 'issue-1213' of https://github.com/SystemFabricWorks/fio (2022-10-19 12:04:50 -0400)

----------------------------------------------------------------
Brian T. Smith (2):
      fix configure probe for libcufile
      libcufile: use generic_get_file_size

Vincent Fu (1):
      Merge branch 'issue-1213' of https://github.com/SystemFabricWorks/fio

 configure           | 4 ++--
 engines/libcufile.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 546541a2..24c599a8 100755
--- a/configure
+++ b/configure
@@ -2723,9 +2723,9 @@ int main(int argc, char* argv[]) {
    return 0;
 }
 EOF
-  if compile_prog "" "-lcuda -lcudart -lcufile" "libcufile"; then
+  if compile_prog "" "-lcuda -lcudart -lcufile -ldl" "libcufile"; then
     libcufile="yes"
-    LIBS="-lcuda -lcudart -lcufile $LIBS"
+    LIBS="-lcuda -lcudart -lcufile -ldl $LIBS"
   else
     if test "$libcufile" = "yes" ; then
       feature_not_found "libcufile" ""
diff --git a/engines/libcufile.c b/engines/libcufile.c
index e575b786..2bedf261 100644
--- a/engines/libcufile.c
+++ b/engines/libcufile.c
@@ -606,6 +606,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.version             = FIO_IOOPS_VERSION,
 	.init                = fio_libcufile_init,
 	.queue               = fio_libcufile_queue,
+	.get_file_size       = generic_get_file_size,
 	.open_file           = fio_libcufile_open_file,
 	.close_file          = fio_libcufile_close_file,
 	.iomem_alloc         = fio_libcufile_iomem_alloc,
