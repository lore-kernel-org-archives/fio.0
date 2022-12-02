Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26609C4321E
	for <fio@archiver.kernel.org>; Fri,  2 Dec 2022 13:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiLBNCR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 2 Dec 2022 08:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiLBNCQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Dec 2022 08:02:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B52FBE6BD
        for <fio@vger.kernel.org>; Fri,  2 Dec 2022 05:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CkAy0y7+j8rUvhvKt60Jh7vsOO3gCRENzfMKEAOlt0I=; b=jEXckvHLeUTCclCgF1EWhqhW4/
        OIeTGimcw6n0SlYxy1Dt1Pcuv1bFRm9c1DzoZNJyM+zSYu5TkAPbC8UdxkoUsHBtm46narM1AWf8Y
        xWTHBcRUiltxoPiWcIMsZXJp4jU3gd2CDUKJIZUtC0bh0nCVz3rSFeid7Is+fEcqVGhNwuCo2cwdE
        my4tupB1oe7i3j+BQlQ4um4OJk0Wv+y9DIA7cJPSet1FW9h47tsc4Ho/2o79sPRA0/TTqhoWpRgQK
        Fm5ysTjSrHHr46lUAt5fZznYA/efzoIcMIhAJEufZJJ/xAPzgAA1k2IJmhK7NY6/loRfMCywGLnuR
        EJj1PKMA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p15eA-006jcI-Tz
        for fio@vger.kernel.org; Fri, 02 Dec 2022 13:02:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 50EF01BC0119; Fri,  2 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221202130002.50EF01BC0119@kernel.dk>
Date:   Fri,  2 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6d8fe6e847bb43cf7db5eee4cf58fd490f12be47:

  backend: respect return value of init_io_u_buffers (2022-11-30 19:58:34 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 942d66c85ee8f007ea5f1097d097cf9a44b662a0:

  doc: update about size (2022-12-01 11:12:35 -0500)

----------------------------------------------------------------
Ankit Kumar (1):
      doc: update about size

 HOWTO.rst | 7 +++++--
 fio.1     | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 2ea84558..0aaf033a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1875,8 +1875,11 @@ I/O size
 .. option:: size=int
 
 	The total size of file I/O for each thread of this job. Fio will run until
-	this many bytes has been transferred, unless runtime is limited by other options
-	(such as :option:`runtime`, for instance, or increased/decreased by :option:`io_size`).
+	this many bytes has been transferred, unless runtime is altered by other means
+	such as (1) :option:`runtime`, (2) :option:`io_size` (3) :option:`number_ios`,
+	(4) gaps/holes while doing I/O's such as ``rw=read:16K``, or (5) sequential
+	I/O reaching end of the file which is possible when :option:`percentage_random`
+	is less than 100.
 	Fio will divide this size between the available files determined by options
 	such as :option:`nrfiles`, :option:`filename`, unless :option:`filesize` is
 	specified by the job. If the result of division happens to be 0, the size is
diff --git a/fio.1 b/fio.1
index 746c4472..62af0bd2 100644
--- a/fio.1
+++ b/fio.1
@@ -1676,8 +1676,11 @@ simulate a smaller amount of memory. The amount specified is per worker.
 .TP
 .BI size \fR=\fPint[%|z]
 The total size of file I/O for each thread of this job. Fio will run until
-this many bytes has been transferred, unless runtime is limited by other options
-(such as \fBruntime\fR, for instance, or increased/decreased by \fBio_size\fR).
+this many bytes has been transferred, unless runtime is altered by other means
+such as (1) \fBruntime\fR, (2) \fBio_size\fR, (3) \fBnumber_ios\fR, (4)
+gaps/holes while doing I/O's such as `rw=read:16K', or (5) sequential I/O
+reaching end of the file which is possible when \fBpercentage_random\fR is
+less than 100.
 Fio will divide this size between the available files determined by options
 such as \fBnrfiles\fR, \fBfilename\fR, unless \fBfilesize\fR is
 specified by the job. If the result of division happens to be 0, the size is
