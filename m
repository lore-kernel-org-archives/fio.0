Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E743C54EE9
	for <fio@archiver.kernel.org>; Fri, 16 Sep 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIPMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiIPMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Sep 2022 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1512E9E5
        for <fio@vger.kernel.org>; Fri, 16 Sep 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=M2uXdPZByBivxQ8eg10IXXHTzMvSKx23S+XT9ZtJl60=; b=UAgYMwEtQTe0Az3HEtA/s4ilRE
        VxbAAN4W9qsiB5SlMfY4doM7u+59PDAWlVxBWgRaVortsoiJwHwLv6f0MAwtClnJdFLCNexIBoPi3
        qe6QXltWjqxLRIUG0MXSxICGFiiVcQLdfYElVjPyw22htwYSFAA48xQSIyzbsfG7a8C1eCdb5StNp
        5fPkg1TBgO54+rCbpntDbCxQTOJ8bhs95IRs+bu4rBVg1hEPYr32ZhhgXKi9cUn9R2+jRzzZn1T9s
        1TEUIj/tnSJqXPL0rApfBUjKhxQrqD37Q//ozaiz59o8Rc91jHKJFordwEXMuSDk4Dc/0OzZfScJK
        TXtNzHhA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oZA0t-002AQb-5O
        for fio@vger.kernel.org; Fri, 16 Sep 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9D5B91BC0142; Fri, 16 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220916120001.9D5B91BC0142@kernel.dk>
Date:   Fri, 16 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 08996af41b2566565cbcdee71766030a2c8ba377:

  backend: number of ios not as expected for trimwrite (2022-09-13 15:03:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5932cf0f2a03396b5f3f0b4667f5e66f7d8477e5:

  Merge branch 'fix-example-disk-zone-profile' of github.com:cvubrugier/fio (2022-09-15 11:02:49 -0400)

----------------------------------------------------------------
Christophe Vu-Brugier (2):
      examples: set zonemode to strided in disk-zone-profile.fio
      examples: fix bandwidth logs generation in disk-zone-profile.fio

Vincent Fu (2):
      Merge branch 'master' of github.com:uniontech-lilinjie/fio
      Merge branch 'fix-example-disk-zone-profile' of github.com:cvubrugier/fio

lilinjie (1):
      fix spelling error

 examples/disk-zone-profile.fio | 9 ++++++---
 fio.1                          | 4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/examples/disk-zone-profile.fio b/examples/disk-zone-profile.fio
index 96e56695..577820eb 100644
--- a/examples/disk-zone-profile.fio
+++ b/examples/disk-zone-profile.fio
@@ -1,4 +1,4 @@
-; Read disk in zones of 128m/2g, generating a plot of that afterwards
+; Read disk in zones of 256m/2g. Generating a plot of that afterwards
 ; should give a nice picture of the zoning of this drive
 
 [global]
@@ -7,8 +7,11 @@ direct=1
 rw=read
 ioengine=libaio
 iodepth=2
+zonemode=strided
 zonesize=256m
 zoneskip=2g
-write_bw_log
 
-[/dev/sdb]
+[disk-zone-profile]
+filename=/dev/sdb
+write_bw_log
+log_offset=1
diff --git a/fio.1 b/fio.1
index c67bd464..39d6b4f4 100644
--- a/fio.1
+++ b/fio.1
@@ -2491,11 +2491,11 @@ Specify the label or UUID of the DAOS pool to connect to.
 Specify the label or UUID of the DAOS container to open.
 .TP
 .BI (dfs)chunk_size
-Specificy a different chunk size (in bytes) for the dfs file.
+Specify a different chunk size (in bytes) for the dfs file.
 Use DAOS container's chunk size by default.
 .TP
 .BI (dfs)object_class
-Specificy a different object class for the dfs file.
+Specify a different object class for the dfs file.
 Use DAOS container's object class by default.
 .TP
 .BI (nfs)nfs_url
