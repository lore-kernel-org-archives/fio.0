Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F44C636CC
	for <fio@archiver.kernel.org>; Sat,  4 Feb 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjBDNAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 4 Feb 2023 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjBDNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Feb 2023 08:00:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F3B47E
        for <fio@vger.kernel.org>; Sat,  4 Feb 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3wBP3w4fT2A1rSctzSc8W1lEN3BMjgx1Kzj4MOW4p6E=; b=LzIKg8sXdL19uiC9SOMxWZVl3q
        H0S0Yn9kEHJmrugluPeJrEmJQvCpR9JcNJKBbcbDcPGhJRS40RjFvsinOHzKVnl66tfJnoz35DJid
        rDaOsJ8S8Aa8mk/RcS4LvUwpNqLTk95/5f4QOkOeC9qJsik1P6HTrPIMWHbUwf7inAb+WXjI2fF0g
        Tj2Neb89P5Eno8pzl2VpSzKxgr1ooYssCP44527EcFdmAefpvwlNaQS6o4b872HTANR9hl476HA8y
        r3rhlm14hMbJU6Qg6beJOqJDCprkI/Z/41zz2QgFA6IQR/8GlpiarOtr50k8484GNUfWSjpVHM7sb
        8Lfi7+yQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOI9E-00FB1D-Fg
        for fio@vger.kernel.org; Sat, 04 Feb 2023 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 467031BC0155; Sat,  4 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230204130002.467031BC0155@kernel.dk>
Date:   Sat,  4 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7d7a704638a1e957c845c04eeac82bdeda0c674c:

  lib/pattern: fix formatting (2023-01-31 10:44:54 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d72b10e3ca2f7e3b7ef4e54ea98e4e964a67192d:

  fio: add FIO_RO_NEEDS_RW_OPEN ioengine flag (2023-02-03 13:26:32 -0500)

----------------------------------------------------------------
Horshack (1):
      Add -replay_skip support for fio-generated I/O logs

Vincent Fu (2):
      Merge branch 'master' of https://github.com/horshack-dpreview/fio
      fio: add FIO_RO_NEEDS_RW_OPEN ioengine flag

 engines/sg.c |  2 +-
 filesetup.c  |  2 +-
 ioengines.h  |  2 ++
 iolog.c      | 20 ++++++++++++++------
 4 files changed, 18 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index 24783374..0bb5be4a 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1428,7 +1428,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= fio_sgio_open,
 	.close_file	= fio_sgio_close,
 	.get_file_size	= fio_sgio_get_file_size,
-	.flags		= FIO_SYNCIO | FIO_RAWIO,
+	.flags		= FIO_SYNCIO | FIO_RAWIO | FIO_RO_NEEDS_RW_OPEN,
 	.options	= options,
 	.option_struct_size	= sizeof(struct sg_options)
 };
diff --git a/filesetup.c b/filesetup.c
index 1d3cc5ad..cb7047c5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -768,7 +768,7 @@ open_again:
 		else
 			from_hash = file_lookup_open(f, flags);
 	} else if (td_read(td)) {
-		if (f->filetype == FIO_TYPE_CHAR && !read_only)
+		if (td_ioengine_flagged(td, FIO_RO_NEEDS_RW_OPEN) && !read_only)
 			flags |= O_RDWR;
 		else
 			flags |= O_RDONLY;
diff --git a/ioengines.h b/ioengines.h
index d43540d0..2cb9743e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -89,6 +89,8 @@ enum fio_ioengine_flags {
 			= 1 << 16,	/* async ioengine with commit function that sets issue_time */
 	FIO_SKIPPABLE_IOMEM_ALLOC
 			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
+	FIO_RO_NEEDS_RW_OPEN
+			= 1 << 18,	/* open files in rw mode even if we have a read job */
 };
 
 /*
diff --git a/iolog.c b/iolog.c
index 62f2f524..3b296cd7 100644
--- a/iolog.c
+++ b/iolog.c
@@ -492,17 +492,25 @@ static bool read_iolog(struct thread_data *td)
 			 */
 			if (!strcmp(act, "wait"))
 				rw = DDIR_WAIT;
-			else if (!strcmp(act, "read"))
+			else if (!strcmp(act, "read")) {
+				if (td->o.replay_skip & (1u << DDIR_READ))
+					continue;
 				rw = DDIR_READ;
-			else if (!strcmp(act, "write"))
+			} else if (!strcmp(act, "write")) {
+				if (td->o.replay_skip & (1u << DDIR_WRITE))
+					continue;
 				rw = DDIR_WRITE;
-			else if (!strcmp(act, "sync"))
+			} else if (!strcmp(act, "sync")) {
+				if (td->o.replay_skip & (1u << DDIR_SYNC))
+					continue;
 				rw = DDIR_SYNC;
-			else if (!strcmp(act, "datasync"))
+			} else if (!strcmp(act, "datasync"))
 				rw = DDIR_DATASYNC;
-			else if (!strcmp(act, "trim"))
+			else if (!strcmp(act, "trim")) {
+				if (td->o.replay_skip & (1u << DDIR_TRIM))
+					continue;
 				rw = DDIR_TRIM;
-			else {
+			} else {
 				log_err("fio: bad iolog file action: %s\n",
 									act);
 				continue;
