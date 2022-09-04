Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4DBECAAD4
	for <fio@archiver.kernel.org>; Sun,  4 Sep 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiIDMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 4 Sep 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiIDMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 4 Sep 2022 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8FD2124F
        for <fio@vger.kernel.org>; Sun,  4 Sep 2022 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=448LhpjHrchy6Ro9vjZqQ7I0h5dpg5lm5ZbaZ9VYqpU=; b=kl53KA9b62yNsw5OzrSRCah9Jj
        Y8NG3Tma48JTrUSVuxXuay0uYuAkWF7TgITRKtv0YLvWLapsoQG70e1jnpHrKDrY1pshayJt5vTS/
        CCPt13cDTiUZ4f5qR/s+U/s1J9oFiPkqSSw3KE6IXnSqY5XjN4/Ef7uLn3uDlP/abvZsWkpSlcqvX
        djML9FGl/hlz82v+Q/gFv5BL9GG/dBQ5rctOL23E/9JGJgdNGnBlVOghckZ8UzZNdmKbjOwbwCI9H
        wM9I/w9TGSisBFqixrpkbTIgENhk8+HDDssR+JUNFeeHCLxceHtHDhYRHSGKzsTX6FqPbvYJJLk8o
        52ptsK7Q==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oUoIF-009BHi-Ms
        for fio@vger.kernel.org; Sun, 04 Sep 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C8E1E1BC013B; Sun,  4 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220904120001.C8E1E1BC013B@kernel.dk>
Date:   Sun,  4 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0b2c736174402afc742a7ed97c37f872fa93ee25:

  Merge branch 'fiopr_windows_log_compression_storage_fixes' of https://github.com/PCPartPicker/fio (2022-09-02 17:29:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 021ce718f5ae4bfd5f4e42290993578adb7c7bd5:

  t/io_uring: enable support for registered buffers for passthrough (2022-09-03 11:04:06 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      Merge branch 'fix/help-terse-version-5' of https://github.com/scop/fio
      Merge branch 'doc/showcmd-usage' of https://github.com/scop/fio
      Merge branch 'fix/howto-spelling' of https://github.com/scop/fio
      t/io_uring: properly detect numa nodes for passthrough mode
      t/io_uring: enable support for registered buffers for passthrough

Ville Skyttä (3):
      init: include 5 in --terse-version help
      HOWTO: spelling fixes
      doc: fix --showcmd usage

 HOWTO.rst           | 8 ++++----
 fio.1               | 4 ++--
 init.c              | 2 +-
 os/linux/io_uring.h | 8 ++++++++
 t/io_uring.c        | 9 ++++++++-
 5 files changed, 23 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 08be687c..2c6c6dbe 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -167,9 +167,9 @@ Command line options
 	defined by `ioengine`.  If no `ioengine` is given, list all
 	available ioengines.
 
-.. option:: --showcmd=jobfile
+.. option:: --showcmd
 
-	Convert `jobfile` to a set of command-line options.
+	Convert given job files to a set of command-line options.
 
 .. option:: --readonly
 
@@ -2550,7 +2550,7 @@ with the caveat that when used on the command line, they must come after the
 
    [dfs]
 
-	Specificy a different chunk size (in bytes) for the dfs file.
+	Specify a different chunk size (in bytes) for the dfs file.
 	Use DAOS container's chunk size by default.
 
    [libhdfs]
@@ -2559,7 +2559,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: object_class=str : [dfs]
 
-	Specificy a different object class for the dfs file.
+	Specify a different object class for the dfs file.
 	Use DAOS container's object class by default.
 
 .. option:: skip_bad=bool : [mtd]
diff --git a/fio.1 b/fio.1
index 27454b0b..67d7c710 100644
--- a/fio.1
+++ b/fio.1
@@ -67,8 +67,8 @@ List all commands defined by \fIioengine\fR, or print help for \fIcommand\fR
 defined by \fIioengine\fR. If no \fIioengine\fR is given, list all
 available ioengines.
 .TP
-.BI \-\-showcmd \fR=\fPjobfile
-Convert \fIjobfile\fR to a set of command\-line options.
+.BI \-\-showcmd
+Convert given \fIjobfile\fRs to a set of command\-line options.
 .TP
 .BI \-\-readonly
 Turn on safety read\-only checks, preventing writes and trims. The \fB\-\-readonly\fR
diff --git a/init.c b/init.c
index da800776..f6a8056a 100644
--- a/init.c
+++ b/init.c
@@ -2269,7 +2269,7 @@ static void usage(const char *name)
 	printf("  --minimal\t\tMinimal (terse) output\n");
 	printf("  --output-format=type\tOutput format (terse,json,json+,normal)\n");
 	printf("  --terse-version=type\tSet terse version output format"
-		" (default 3, or 2 or 4)\n");
+		" (default 3, or 2 or 4 or 5)\n");
 	printf("  --version\t\tPrint version info and exit\n");
 	printf("  --help\t\tPrint this page\n");
 	printf("  --cpuclock-test\tPerform test/validation of CPU clock\n");
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 6604e736..c7a24ad8 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -46,6 +46,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		uring_cmd_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -197,6 +198,13 @@ enum {
 	IORING_OP_LAST,
 };
 
+/*
+ * sqe->uring_cmd_flags
+ * IORING_URING_CMD_FIXED	use registered buffer; pass thig flag
+ *				along with setting sqe->buf_index.
+ */
+#define IORING_URING_CMD_FIXED	(1U << 0)
+
 /*
  * sqe->fsync_flags
  */
diff --git a/t/io_uring.c b/t/io_uring.c
index 9d580b5a..b9353ac8 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -650,6 +650,10 @@ static void init_io_pt(struct submitter *s, unsigned index)
 	cmd->cdw12 = nlb;
 	cmd->addr = (unsigned long) s->iovecs[index].iov_base;
 	cmd->data_len = bs;
+	if (fixedbufs) {
+		sqe->uring_cmd_flags = IORING_URING_CMD_FIXED;
+		sqe->buf_index = index;
+	}
 	cmd->nsid = f->nsid;
 	cmd->opcode = 2;
 }
@@ -856,7 +860,10 @@ static int detect_node(struct submitter *s, const char *name)
 	char str[128];
 	int ret, fd, node;
 
-	sprintf(str, "/sys/block/%s/device/numa_node", base);
+	if (pt)
+		sprintf(str, "/sys/class/nvme-generic/%s/device/numa_node", base);
+	else
+		sprintf(str, "/sys/block/%s/device/numa_node", base);
 	fd = open(str, O_RDONLY);
 	if (fd < 0)
 		return -1;
