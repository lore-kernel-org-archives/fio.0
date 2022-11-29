Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C730C4321E
	for <fio@archiver.kernel.org>; Tue, 29 Nov 2022 13:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiK2NAS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiK2NAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Nov 2022 08:00:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74A72656B
        for <fio@vger.kernel.org>; Tue, 29 Nov 2022 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xsBnVAQWcHRyi57Mxt5ON+pFcVGR/e8QEZPCuxYqPFM=; b=DS3CCF5q5S9Djyr5GwBmEvnwcn
        YIBRWpnKYjcaInN5vi4vn7Fp1IJLB4s6E2jcCx+RhoPhWRgahsbPM18Nzjlc+nsm3BgyDH7FdI9oH
        uPeLV8TL9kXwh6FZO/C3XyO7K0X52/XqpFI85Z4UGzcS2pydYVdjVDqXyAdwzecSoFnfVQE4LNirN
        NvaxFD2tqqA/U/7SdvsKJvABoTdGzy+r4ZhwbyXpVHffQUm5PEN3ceU+whBAmIXgZfi+Pd7HHceGP
        19QfIrY5VG8u3k4E8WvchbeljVBBek8Kw5yeXFlj3gJLmDqINJ9rB6/L65VdOlt+45mh5xVXrNPEF
        ygv+/lng==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p00De-00DozV-5C
        for fio@vger.kernel.org; Tue, 29 Nov 2022 13:00:16 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 28A7F1BC0134; Tue, 29 Nov 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221129130002.28A7F1BC0134@kernel.dk>
Date:   Tue, 29 Nov 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 72044c66ac7055a98c9b3021c298c81849e3c990:

  doc: update about sqthread_poll (2022-11-23 14:06:03 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 01fd7497328f55622ec989a8edb015f2cccb94eb:

  Merge branch 'lintian-manpage-fixes' of https://github.com/hoexter/fio (2022-11-28 12:54:53 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'lintian-manpage-fixes' of https://github.com/hoexter/fio

Sven Hoexter (2):
      Spelling: Fix allows to -> allows one to in man 1 fio
      Use correct backslash escape in man 1 fio

 fio.1 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index a156bf5d..a28ec032 100644
--- a/fio.1
+++ b/fio.1
@@ -569,7 +569,7 @@ by this option will be \fBsize\fR divided by number of files unless an
 explicit size is specified by \fBfilesize\fR.
 .RS
 .P
-Each colon in the wanted path must be escaped with a '\\'
+Each colon in the wanted path must be escaped with a '\e'
 character. For instance, if the path is `/dev/dsk/foo@3,0:c' then you
 would use `filename=/dev/dsk/foo@3,0\\:c' and if the path is
 `F:\\filename' then you would use `filename=F\\:\\filename'.
@@ -830,7 +830,7 @@ so. Default: false.
 .BI max_open_zones \fR=\fPint
 When running a random write test across an entire drive many more zones will be
 open than in a typical application workload. Hence this command line option
-that allows to limit the number of open zones. The number of open zones is
+that allows one to limit the number of open zones. The number of open zones is
 defined as the number of zones to which write commands are issued by all
 threads/processes.
 .TP
@@ -1224,7 +1224,7 @@ map. For the \fBnormal\fR distribution, a normal (Gaussian) deviation is
 supplied as a value between 0 and 100.
 .P
 The second, optional float is allowed for \fBpareto\fR, \fBzipf\fR and \fBnormal\fR
-distributions. It allows to set base of distribution in non-default place, giving
+distributions. It allows one to set base of distribution in non-default place, giving
 more control over most probable outcome. This value is in range [0-1] which maps linearly to
 range of possible random values.
 Defaults are: random for \fBpareto\fR and \fBzipf\fR, and 0.5 for \fBnormal\fR.
@@ -4213,7 +4213,7 @@ This format is not supported in fio versions >= 1.20\-rc3.
 .TP
 .B Trace file format v2
 The second version of the trace file format was added in fio version 1.17. It
-allows to access more then one file per trace and has a bigger set of possible
+allows one to access more then one file per trace and has a bigger set of possible
 file actions.
 .RS
 .P
