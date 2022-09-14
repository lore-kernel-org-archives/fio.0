Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E9FECAAD3
	for <fio@archiver.kernel.org>; Wed, 14 Sep 2022 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiINMA3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 14 Sep 2022 08:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiINMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Sep 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32765721C
        for <fio@vger.kernel.org>; Wed, 14 Sep 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=D43dKwbEDFGpDn00Lrqw09xepZFqrTNvGizTgJeXiLw=; b=BzCzgYzmr8qRIMZDVDPPL/R+yJ
        9kdj0NuRrrjTD1AY/wVOFCPJ86gikB5HluDXJS/Hz9zLvBJSj9CJCsvdHHAyGg2kfDBG3KePYqZWn
        omzETDh2aDee1YnhHCbttjcWA6nZixARjhir/15VoPcBr+RFJGE0vTTn0y+cWbF/QOQbOJjGSSGn2
        kUMXCYubhVtxySb+wII3RIUp1ys/ItrCODXCLqqGbmN7VfOtxSWt++JYz+r69yZTLCHoNn4SpWp7h
        KjCPaO1yXr8xbrQ7Jr5tjKkqZTz0syiNrH+xKpcz10hRzQYlNFmHfpsBVqhuVlKpzCJHtTQ5YRopa
        uPW5Rqjg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oYR3l-00CLgn-II
        for fio@vger.kernel.org; Wed, 14 Sep 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 793581BC0167; Wed, 14 Sep 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220914120002.793581BC0167@kernel.dk>
Date:   Wed, 14 Sep 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 53c82bb879532b994451c6abc7be80c94241d03b:

  stat: fix comment about memory consumption (2022-09-12 10:45:56 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 08996af41b2566565cbcdee71766030a2c8ba377:

  backend: number of ios not as expected for trimwrite (2022-09-13 15:03:21 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      backend: number of ios not as expected for trimwrite

 HOWTO.rst | 6 +++++-
 backend.c | 6 ++++--
 fio.1     | 5 ++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2c6c6dbe..924f5ed9 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1129,7 +1129,11 @@ I/O type
 				Random mixed reads and writes.
 		**trimwrite**
 				Sequential trim+write sequences. Blocks will be trimmed first,
-				then the same blocks will be written to.
+				then the same blocks will be written to. So if ``io_size=64K``
+				is specified, Fio will trim a total of 64K bytes and also
+				write 64K bytes on the same trimmed blocks. This behaviour
+				will be consistent with ``number_ios`` or other Fio options
+				limiting the total bytes or number of I/O's.
 
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
diff --git a/backend.c b/backend.c
index fe614f6e..ec535bcc 100644
--- a/backend.c
+++ b/backend.c
@@ -971,9 +971,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		total_bytes += td->o.size;
 
 	/* In trimwrite mode, each byte is trimmed and then written, so
-	 * allow total_bytes to be twice as big */
-	if (td_trimwrite(td))
+	 * allow total_bytes or number of ios to be twice as big */
+	if (td_trimwrite(td)) {
 		total_bytes += td->total_io_size;
+		td->o.number_ios *= 2;
+	}
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
diff --git a/fio.1 b/fio.1
index 67d7c710..c67bd464 100644
--- a/fio.1
+++ b/fio.1
@@ -900,7 +900,10 @@ Random mixed reads and writes.
 .TP
 .B trimwrite
 Sequential trim+write sequences. Blocks will be trimmed first,
-then the same blocks will be written to.
+then the same blocks will be written to. So if `io_size=64K' is specified,
+Fio will trim a total of 64K bytes and also write 64K bytes on the same
+trimmed blocks. This behaviour will be consistent with `number_ios' or
+other Fio options limiting the total bytes or number of I/O's.
 .RE
 .P
 Fio defaults to read if the option is not specified. For the mixed I/O
