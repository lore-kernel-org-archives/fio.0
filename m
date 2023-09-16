Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BDBCD37BB
	for <fio@archiver.kernel.org>; Sat, 16 Sep 2023 12:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjIPMAU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 16 Sep 2023 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjIPMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Sep 2023 08:00:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393B7CCB
        for <fio@vger.kernel.org>; Sat, 16 Sep 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IYbM7wCvAd3UAwAcPcMFXcjrzUSinY0KL2FK/mSffPU=; b=CeoAMo5JvYay+FHmHD3maA+NE3
        JP5P434wvfNcfHvsbrK5zvBn+tWgRvci2gXbRA1JSbvaFhC2fRO5aYsnxlBAssDhOVy0ydmcK40jk
        AMPYAsan0kJAsvfseqDyTPX8s6T5awR8y0DHq9GzDSUlgsLyaR3qZTkYNVVlelWSGaFyG4vpLU3Fb
        7LPCfF2M0uaJyvslpp8RnMiCiN8Ovpi2sUGYjFK8U4PhCxfYf3uopqQzjV6jWGj45M5R21IiiXSDp
        Uj8y/6PSsT0M2o0nCvpTwq3LBoLEbFccQ3pMRUfstM2Z+puRA4HW6pXVMLagmPX3qnXaEmUrnBHRn
        sBQI1stg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qhTxz-00AL3a-2l
        for fio@vger.kernel.org;
        Sat, 16 Sep 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6BB6B1BC015F; Sat, 16 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230916120001.6BB6B1BC015F@kernel.dk>
Date:   Sat, 16 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e4a9812dee084b058eca6ebde9634a3d573a0079:

  engines:nvme: fill command fields as per pi check bits (2023-09-11 10:55:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2c5f17e3559cc7c96706cd75c2609f12675c60b:

  verify: open state file in binary mode on Windows (2023-09-14 18:54:25 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      verify: open state file in binary mode on Windows

 verify.c | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index 2848b686..f7355f30 100644
--- a/verify.c
+++ b/verify.c
@@ -1648,6 +1648,10 @@ static int open_state_file(const char *name, const char *prefix, int num,
 	else
 		flags = O_RDONLY;
 
+#ifdef _WIN32
+	flags |= O_BINARY;
+#endif
+
 	verify_state_gen_name(out, sizeof(out), name, prefix, num);
 
 	fd = open(out, flags, 0644);
