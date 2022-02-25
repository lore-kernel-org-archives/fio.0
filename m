Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46035C433F5
	for <fio@archiver.kernel.org>; Fri, 25 Feb 2022 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiBYNAj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 25 Feb 2022 08:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiBYNAi (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Feb 2022 08:00:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6791DA001
        for <fio@vger.kernel.org>; Fri, 25 Feb 2022 05:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lHKo+gnHGCy/defl6M1M27cdPsAocWs17hZVDY+7l4M=; b=shamDH3V4AHu29zyXcaha4O2I/
        MhDbQTBq8hY7LeWIdUT0Wuw87AywNF3urIcxTZFcD/bWfP64I55+bAC7+VMx9N1TnVNXGZEnULsfS
        q9g2vmhOxIk2OTiLkc+bUoDSjG69XUhttewig6fy3PlVOtMcSUS0JvX0itoXs6Emr4ACWYCNjGuJD
        WCbv1Zz2oQI9b4tWmZjnMxRdPPWQug3MNAodZHOq0WuxJubiM5eKpC/yC3/01ELSna+3DYZhPB1p5
        ZLjH8CN30ipSfSnc5dWt0Hr/uhwNGFxQz1l9zlDiap2gHJe7R46D/hUsdizVpi3ydQ0nhXU6WdEv8
        NI8l574Q==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNaCa-005n87-46
        for fio@vger.kernel.org; Fri, 25 Feb 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C84D91BC0144; Fri, 25 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220225130001.C84D91BC0144@kernel.dk>
Date:   Fri, 25 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c377f4f85943e5b155b3daaab1ce5213077531d8:

  io_uring: use syscall helpers for the hot path (2022-02-21 09:43:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cf2511565f40be1b78b3fc1194e823baf305f0a0:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-02-24 12:40:19 -0700)

----------------------------------------------------------------
Bart Van Assche (1):
      Fix three compiler warnings

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 engines/cmdprio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index dd358754..979a81b6 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -319,7 +319,7 @@ static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cmdprio)
 {
 	struct cmdprio_options *options = cmdprio->options;
 	struct cmdprio_prio *prio;
-	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {};
 	struct thread_stat *ts = &td->ts;
 	enum fio_ddir ddir;
 	int ret;
@@ -368,8 +368,8 @@ static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
 					     struct cmdprio *cmdprio)
 {
 	struct cmdprio_options *options = cmdprio->options;
-	struct cmdprio_parse_result parse_res[CMDPRIO_RWDIR_CNT] = {0};
-	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
+	struct cmdprio_parse_result parse_res[CMDPRIO_RWDIR_CNT] = {};
+	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {};
 	struct thread_stat *ts = &td->ts;
 	int ret, implicit_cmdprio;
 	enum fio_ddir ddir;
