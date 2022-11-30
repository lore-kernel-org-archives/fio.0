Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578C7C433FE
	for <fio@archiver.kernel.org>; Wed, 30 Nov 2022 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiK3NAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Nov 2022 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiK3NAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Nov 2022 08:00:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6964AF1E
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bXtt+8mLqg5oaw1ko5A2MEG0su9BpRolKsM7igZgxyM=; b=ld1FSufvVfk2KQrwzRiPP0z3UY
        BF62VlWR57dLbDDRXUvchYQG7GZlE4HAG+ivZyfKGPcpba6DpIi38iX8eE4Q6sKiYd1Mci/R2N8gA
        WvwqZUGOOemYQihL/lMnWpdPdncjyblMEQZBGtjNOh/y9nUZfvGyXY64+bwTxDtHneFS2l6FIbpAQ
        R5j4b2PLkSPSi8ALotrqupmonVr/whh4nysEbnAbZ8w1Njn1I7MOzHbg2mNQrf2elg1637wAnI2dV
        dUJeHE97YjaQwxJJxTyKJZhda73TYvOl3KfMviVsItzrgYwh8M7QbEpboLmuwdqgwcTjoaLMktNKC
        CHe2tt7Q==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0Mh9-00Ez7U-NB
        for fio@vger.kernel.org; Wed, 30 Nov 2022 13:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 44C131BC0162; Wed, 30 Nov 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221130130002.44C131BC0162@kernel.dk>
Date:   Wed, 30 Nov 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 01fd7497328f55622ec989a8edb015f2cccb94eb:

  Merge branch 'lintian-manpage-fixes' of https://github.com/hoexter/fio (2022-11-28 12:54:53 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 967c5441fa3d3932ec50ea5623411cc6e8589463:

  docs: description for experimental_verify (2022-11-29 17:09:41 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      docs: synchronize fio.1 and HOWTO changes
      docs: description for experimental_verify

 HOWTO.rst | 11 +++++++----
 fio.1     |  6 ++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 4419ee1b..2ea84558 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1054,7 +1054,7 @@ Target file/device
 
 	When running a random write test across an entire drive many more
 	zones will be open than in a typical application workload. Hence this
-	command line option that allows to limit the number of open zones. The
+	command line option that allows one to limit the number of open zones. The
 	number of open zones is defined as the number of zones to which write
 	commands are issued.
 
@@ -1446,7 +1446,7 @@ I/O type
 	supplied as a value between 0 and 100.
 
 	The second, optional float is allowed for **pareto**, **zipf** and **normal** distributions.
-	It allows to set base of distribution in non-default place, giving more control
+	It allows one to set base of distribution in non-default place, giving more control
 	over most probable outcome. This value is in range [0-1] which maps linearly to
 	range of possible random values.
 	Defaults are: random for **pareto** and **zipf**, and 0.5 for **normal**.
@@ -3612,7 +3612,10 @@ Verification
 
 .. option:: experimental_verify=bool
 
-	Enable experimental verification.
+        Enable experimental verification. Standard verify records I/O metadata
+        for later use during the verification phase. Experimental verify
+        instead resets the file after the write phase and then replays I/Os for
+        the verification phase.
 
 Steady state
 ~~~~~~~~~~~~
@@ -4503,7 +4506,7 @@ Trace file format v2
 ~~~~~~~~~~~~~~~~~~~~
 
 The second version of the trace file format was added in fio version 1.17.  It
-allows to access more than one file per trace and has a bigger set of possible
+allows one to access more than one file per trace and has a bigger set of possible
 file actions.
 
 The first line of the trace file has to be::
diff --git a/fio.1 b/fio.1
index a28ec032..746c4472 100644
--- a/fio.1
+++ b/fio.1
@@ -3324,7 +3324,9 @@ Verify that trim/discarded blocks are returned as zeros.
 Trim this number of I/O blocks.
 .TP
 .BI experimental_verify \fR=\fPbool
-Enable experimental verification.
+Enable experimental verification. Standard verify records I/O metadata for
+later use during the verification phase. Experimental verify instead resets the
+file after the write phase and then replays I/Os for the verification phase.
 .SS "Steady state"
 .TP
 .BI steadystate \fR=\fPstr:float "\fR,\fP ss" \fR=\fPstr:float
@@ -4213,7 +4215,7 @@ This format is not supported in fio versions >= 1.20\-rc3.
 .TP
 .B Trace file format v2
 The second version of the trace file format was added in fio version 1.17. It
-allows one to access more then one file per trace and has a bigger set of possible
+allows one to access more than one file per trace and has a bigger set of possible
 file actions.
 .RS
 .P
