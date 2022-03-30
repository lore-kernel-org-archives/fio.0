Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E123C433EF
	for <fio@archiver.kernel.org>; Wed, 30 Mar 2022 12:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbiC3MLc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346688AbiC3MF3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Mar 2022 08:05:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2802921D2
        for <fio@vger.kernel.org>; Wed, 30 Mar 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=v6eWvdOjTZYebWQRo/31WrMYWpJ+0BQH/p9AWVnXXqo=; b=UeaRjyiFZQq6rCu1qxeamJvgRB
        7TXDx8XY6p+QolX1x33tcsKEi/xSSSaUQZqdn7t2hc0UYy2LloiWnzhd/0qw7lExYfdXtSBiIqSjf
        c4dSfKUJIeg4UyDlyBgZ/300rsc0Zm3uocNMvdqrY18+Dx9YzOwuV1zt41HFcUvhMcM04Nv8rkij+
        ggTM5Olm27qioHyC/5cFFeBfh4VbvHAW/c9RnKl/MCbk5qsgyh6beZCxWC+AHWgNw66mR6jx4gnlZ
        gmzq6PllW0J2HK8p8JX+ZzJtLV9cMGj8S5zhi+mjTfCXbU21A6IYLhia2/3gx7wLYvge/h3uxJcTx
        IMGSCUqw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZWzd-006Cfq-5r
        for fio@vger.kernel.org; Wed, 30 Mar 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 26A771BC016E; Wed, 30 Mar 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220330120002.26A771BC016E@kernel.dk>
Date:   Wed, 30 Mar 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a57d3fdce796f1bb516c74db95d016bb6db170c1:

  Merge branch 'master' of https://github.com/cccheng/fio (2022-03-28 06:43:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5e644771eb91e91dd0fa32f4b51f90c44853a2b1:

  Merge branch 'status-interval-finished-jobs' of https://github.com/mmkayPL/fio (2022-03-29 06:30:44 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'status-interval-finished-jobs' of https://github.com/mmkayPL/fio

Kozlowski Mateusz (1):
      Handle finished jobs when using status-interval

 stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 7947edb4..356083e2 100644
--- a/stat.c
+++ b/stat.c
@@ -2731,6 +2731,9 @@ int __show_running_run_stats(void)
 	fio_gettime(&ts, NULL);
 
 	for_each_td(td, i) {
+		if (td->runstate >= TD_EXITED)
+			continue;
+
 		td->update_rusage = 1;
 		for_each_rw_ddir(ddir) {
 			td->ts.io_bytes[ddir] = td->io_bytes[ddir];
@@ -2759,6 +2762,9 @@ int __show_running_run_stats(void)
 	__show_run_stats();
 
 	for_each_td(td, i) {
+		if (td->runstate >= TD_EXITED)
+			continue;
+
 		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
 			td->ts.runtime[DDIR_READ] -= rt[i];
 		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
