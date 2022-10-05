Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2120C433F5
	for <fio@archiver.kernel.org>; Wed,  5 Oct 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJEMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Oct 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJEMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Oct 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F20B21244
        for <fio@vger.kernel.org>; Wed,  5 Oct 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pFqXIUEva2kB20b/yEZGaBukPMfpIZ2eOnVxtyU5zUo=; b=nYktGkd8kbIb87o09431XDsV0f
        pM8HeEim2iHpN6UiBEOD/Edp9cjzuzNERwJ343Ie/izKYoPEch+7nmD6VacOv59RzdmIOvIoLGiQa
        QpEXkeDV9lT/uEZaFzW249JRVatDGLye+4CDt5Dr5AW+dT3OodqKV7AjDqtQu0kkYI3ISiKJcJkIB
        mxqwZyeUBz9TNSXG/Wpw4tVVoR/yD5OA85nIRgBYbZbyFuJ0gIyuwjNb3ZsIR87izPYbZ1PV4am99
        9YG6f2VnFLdOPSy+Y78pvS4suMvX011n7h/atl0qwjS5vppkWFUjbwlmPDo1V29TeuSj6eNxyKS9x
        RqPZI4Xg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1og34K-000KvN-GK
        for fio@vger.kernel.org; Wed, 05 Oct 2022 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DF03B1BC013E; Wed,  5 Oct 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221005120001.DF03B1BC013E@kernel.dk>
Date:   Wed,  5 Oct 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 793b868671d14f9a3e4fa76ac129545987084a8d:

  randtrimwrite: fix corner case with variable block sizes (2022-10-03 17:36:57 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0474b83f022f1f1cc14208c05b7ccda682e01263:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-10-04 14:25:09 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      Android: Fix the build of the 'sg' engine
      Android: Enable the 'sg' engine

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 Makefile     | 3 ++-
 engines/sg.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f947f11c..7bd572d7 100644
--- a/Makefile
+++ b/Makefile
@@ -249,7 +249,8 @@ endif
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
-		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
+		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c \
+		engines/sg.c
   cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
diff --git a/engines/sg.c b/engines/sg.c
index 72ee07ba..24783374 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1331,10 +1331,12 @@ static char *fio_sgio_errdetails(struct io_u *io_u)
 			strlcat(msg, ". ", MAXERRDETAIL);
 		}
 		if (hdr->sb_len_wr) {
+			const uint8_t *const sbp = hdr->sbp;
+
 			snprintf(msgchunk, MAXMSGCHUNK, "Sense Data (%d bytes):", hdr->sb_len_wr);
 			strlcat(msg, msgchunk, MAXERRDETAIL);
 			for (i = 0; i < hdr->sb_len_wr; i++) {
-				snprintf(msgchunk, MAXMSGCHUNK, " %02x", hdr->sbp[i]);
+				snprintf(msgchunk, MAXMSGCHUNK, " %02x", sbp[i]);
 				strlcat(msg, msgchunk, MAXERRDETAIL);
 			}
 			strlcat(msg, ". ", MAXERRDETAIL);
