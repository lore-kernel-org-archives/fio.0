Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C725EB64D9
	for <fio@archiver.kernel.org>; Sat, 17 Jun 2023 12:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjFQMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 17 Jun 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjFQMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Jun 2023 08:00:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE509E5B
        for <fio@vger.kernel.org>; Sat, 17 Jun 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=T7qKuU1fKtt5UHxvgVI3m4dT/VU6pJ+T4KC2ghiFAzs=; b=OLBZ1ek3d6zd0nTLJGnT7pv0ca
        CfONMCjTu4ZwLHzXaWxMYg12hhVyyrFAteZjVJkXQ9MDoGturaHtStA2xfN4WfQUp4I2OkOzZyXGl
        QnxfGcaezycUGhDU1zZ4fNaKAIuVDIdJlHP8LLaxT3fpp/kQR/7PhM9/OMHdWvSuSy+YWoI3QqgC7
        ERdfYxREugCh1a+DrtMQAMCpCG4BcQHvznv+nyWyuj9IlmtE4p/CqlnSPyigGPERRjXsLQHzNiGiJ
        rvhced+sGx49NVl7ih8fibjcWZPIjRKiCOdl3muABy1xfLkH6jGUXw3f9gPn9izXrMgGFHMd4wdxy
        BfclQHTw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qAUbB-009v7j-Sw
        for fio@vger.kernel.org; Sat, 17 Jun 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 89F971BC015E; Sat, 17 Jun 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230617120001.89F971BC015E@kernel.dk>
Date:   Sat, 17 Jun 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 62ac66490f5077e5fca1bd5b49165147cafc5a0d:

  zbd: avoid Coverity defect report (2023-06-09 18:04:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8ce9c4003aeaafa91c3278c1c7de4a32fadc5ea0:

  docs: clarify opendir description (2023-06-16 10:41:25 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      docs: clarify opendir description

 HOWTO.rst | 4 +++-
 fio.1     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 32fff5ec..2e1e55c2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -843,7 +843,9 @@ Target file/device
 
 .. option:: opendir=str
 
-	Recursively open any files below directory `str`.
+        Recursively open any files below directory `str`. This accepts only a
+        single directory and unlike related options, colons appearing in the
+        path must not be escaped.
 
 .. option:: lockfile=str
 
diff --git a/fio.1 b/fio.1
index 80bf3371..73b7e8c9 100644
--- a/fio.1
+++ b/fio.1
@@ -627,7 +627,9 @@ generated filenames (with a directory specified) with the source of the
 client connecting. To disable this behavior, set this option to 0.
 .TP
 .BI opendir \fR=\fPstr
-Recursively open any files below directory \fIstr\fR.
+Recursively open any files below directory \fIstr\fR. This accepts only a
+single directory and unlike related options, colons appearing in the path must
+not be escaped.
 .TP
 .BI lockfile \fR=\fPstr
 Fio defaults to not locking any files before it does I/O to them. If a file
