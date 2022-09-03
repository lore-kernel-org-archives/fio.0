Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE64BECAAD4
	for <fio@archiver.kernel.org>; Sat,  3 Sep 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiICMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 3 Sep 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiICMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Sep 2022 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF6C48E83
        for <fio@vger.kernel.org>; Sat,  3 Sep 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=w6Z55emUVs0NW++K4lefHJDdysJ9Wx3UgcAFEzMNREI=; b=fb2BkERgUnPt9eye+O6Wuo1CfF
        T0N+/C1luTMWx1qrrVuahxbmp+53Z87CuTKrE5BkkKC+9Rh6b35y4sv80psXtsxej1eyRUjDolN2/
        N2lUj1Sm38oYdyiVt37y+O7BpCqGXDqZ6uZll9VBi+I/YhpbuUUVKs37y5zVLM7w6wLYe33tDcUtD
        Bx+QE9Ft6e0nuONK2GCAOe1oQQpiIXtSAPfLJyPgAOeZ2NFo8jOiMUTcmDilsHqmP0h50JCaD8kv9
        SCBcyqMDctdpHZQ1I8BkElxb5E/5DKeqhmweQHO/4kUd/e1l2aTmdgzJkHqtokj/julcHDrsDlVT+
        nMuiGHOQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oURoi-008vKB-KD
        for fio@vger.kernel.org; Sat, 03 Sep 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DCEF81BC016E; Sat,  3 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220903120001.DCEF81BC016E@kernel.dk>
Date:   Sat,  3 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e57758c12bdb24885e32ba143a04fcc8f98565ca:

  Merge branch 'fiopr_compressfixes' of https://github.com/PCPartPicker/fio (2022-09-01 12:03:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0b2c736174402afc742a7ed97c37f872fa93ee25:

  Merge branch 'fiopr_windows_log_compression_storage_fixes' of https://github.com/PCPartPicker/fio (2022-09-02 17:29:45 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fiopr_windows_log_compression_storage_fixes' of https://github.com/PCPartPicker/fio

aggieNick02 (1):
      Fix log compression storage on windows

 iolog.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 41d3e473..aa9c3bb1 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1218,7 +1218,7 @@ int iolog_file_inflate(const char *file)
 	void *buf;
 	FILE *f;
 
-	f = fopen(file, "r");
+	f = fopen(file, "rb");
 	if (!f) {
 		perror("fopen");
 		return 1;
@@ -1300,10 +1300,21 @@ void flush_log(struct io_log *log, bool do_append)
 	void *buf;
 	FILE *f;
 
+	/*
+	 * If log_gz_store is true, we are writing a binary file.
+	 * Set the mode appropriately (on all platforms) to avoid issues
+	 * on windows (line-ending conversions, etc.)
+	 */
 	if (!do_append)
-		f = fopen(log->filename, "w");
+		if (log->log_gz_store)
+			f = fopen(log->filename, "wb");
+		else
+			f = fopen(log->filename, "w");
 	else
-		f = fopen(log->filename, "a");
+		if (log->log_gz_store)
+			f = fopen(log->filename, "ab");
+		else
+			f = fopen(log->filename, "a");
 	if (!f) {
 		perror("fopen log");
 		return;
