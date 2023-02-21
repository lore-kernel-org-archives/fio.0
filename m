Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5304C6379F
	for <fio@archiver.kernel.org>; Tue, 21 Feb 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjBUNAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Feb 2023 08:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjBUNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Feb 2023 08:00:11 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D099EEA
        for <fio@vger.kernel.org>; Tue, 21 Feb 2023 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FaAvADR9y01ZO9VSJX9+LPc7qjsY7pJpwRA4vAUsjwk=; b=bnGt0jNoAh6FL15MuWVAtC12U7
        o88qaBtZiziDQE7k4DS1uUY+Guc3Ym7SHPJsGpnMhdjMD7EiWFWYUU3QCSii+LsnqQoTTvIOi/u/T
        20aNY2AXELNv/U6zydWgOo54f3/62SoQVdTR+IDzr2mThD5OqBLXhPkSS/DsiBlLmC7P4KhFxnzrD
        i9jBWiDwKiT2cT0woejjnVugUfPPxhYzCJUmWL8UQm+VzFXnL3FU84SEIsE/4zd5qdGklKZKQKjd/
        67JozHTcDEFd2UMXizrN7wsgC4L3b/iaoJbQepbrt2JbiPRg1m5YNnaBeoz0q9nsSvGzv5av4MGXQ
        y8vW2TyQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUSFY-00CAUC-27
        for fio@vger.kernel.org;
        Tue, 21 Feb 2023 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 1395F1BC018A; Tue, 21 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230221130002.1395F1BC018A@kernel.dk>
Date:   Tue, 21 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f9fc7a27cae5ea2dbb310c05f7b693c68ba15537:

  backend: fix runtime when used with thinktime (2023-02-17 19:52:50 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a3a166c6c43e45de1c8085254fbdd011c572f05:

  configure: restore dev-dax and libpmem (2023-02-20 08:53:23 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      configure: restore dev-dax and libpmem

 configure | 8 ++++++++
 1 file changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 0d02bce8..45d10a31 100755
--- a/configure
+++ b/configure
@@ -2228,6 +2228,14 @@ if compile_prog "" "-lpmem2" "libpmem2"; then
 fi
 print_config "libpmem2" "$libpmem2"
 
+# Choose libpmem-based ioengines
+if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
+  devdax="yes"
+  if test "$libpmem1_5" = "yes"; then
+    pmem="yes"
+  fi
+fi
+
 ##########################################
 # Report whether dev-dax engine is enabled
 print_config "PMDK dev-dax engine" "$devdax"
