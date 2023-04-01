Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0912C76196
	for <fio@archiver.kernel.org>; Sat,  1 Apr 2023 12:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjDAMAW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 1 Apr 2023 08:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDAMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Apr 2023 08:00:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A151D922
        for <fio@vger.kernel.org>; Sat,  1 Apr 2023 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ljICIXP70eVkb2dbscxD0AQxuRX/CsoYzZqkixIT6oc=; b=qGk9y22apFn5AOFTG78aYN2XSA
        ns3wwuB0Z+zvZ5krjIHYGf+qU5UnsUxHYFAqsVZSwV+NUxwsOUC97QCy7eA66g/7Ohn/Kxr0sY3LB
        6Ln737y4qfkOZomXkJVi+Rc5lepJ8pgBIgZRVMylrlysU0gX+4l4JQlUqaBqk94TPwQVA2kPB7WtB
        8Wo7XAXzijhOP4APdIfKvpefUMxCM/0Y+nm5vZUObvksPTK/gDCrNQ75pMkOuzFCpZpdruAJ8zCTN
        UATul+x/SZMq63Yupl08qgjBlHCfmqfJ9MHAxFyQLv8IN9YXCC8nQUAEerQQv79HiV216Je+6IbF9
        +VbKGeVw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1piZtr-00CPWI-QN
        for fio@vger.kernel.org; Sat, 01 Apr 2023 12:00:03 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4E3231BC0166; Sat,  1 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230401120001.4E3231BC0166@kernel.dk>
Date:   Sat,  1 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d86ac3e9f4c703b7d7c9add96e69f2d02affdc65:

  Merge branch 'trim-support' of https://github.com/ankit-sam/fio (2023-03-27 13:21:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 638689b15af35bd746f9114a3e8895e7a983ed83:

  Only expose fadvise_hint=noreuse if supported (2023-03-31 12:52:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Only expose fadvise_hint=noreuse if supported

Yuanchu Xie (2):
      fio: add support for POSIX_FADV_NOREUSE
      docs: add noreuse fadvise_hint option

 HOWTO.rst   | 5 +++++
 fio.1       | 5 +++++
 fio.h       | 1 +
 ioengines.c | 4 ++++
 options.c   | 7 +++++++
 5 files changed, 22 insertions(+)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 5240f9da..cb0f9834 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1308,6 +1308,11 @@ I/O type
 		**random**
 			Advise using **FADV_RANDOM**.
 
+		**noreuse**
+			Advise using **FADV_NOREUSE**. This may be a no-op on older Linux
+			kernels. Since Linux 6.3, it provides a hint to the LRU algorithm.
+			See the :manpage:`posix_fadvise(2)` man page.
+
 .. option:: write_hint=str
 
 	Use :manpage:`fcntl(2)` to advise the kernel what life time to expect
diff --git a/fio.1 b/fio.1
index e2db3a3f..311b16d8 100644
--- a/fio.1
+++ b/fio.1
@@ -1098,6 +1098,11 @@ Advise using FADV_SEQUENTIAL.
 .TP
 .B random
 Advise using FADV_RANDOM.
+.TP
+.B noreuse
+Advise using FADV_NOREUSE. This may be a no-op on older Linux
+kernels. Since Linux 6.3, it provides a hint to the LRU algorithm.
+See the \fBposix_fadvise\fR\|(2) man page.
 .RE
 .RE
 .TP
diff --git a/fio.h b/fio.h
index 32535517..f2acd430 100644
--- a/fio.h
+++ b/fio.h
@@ -163,6 +163,7 @@ enum {
 	F_ADV_TYPE,
 	F_ADV_RANDOM,
 	F_ADV_SEQUENTIAL,
+	F_ADV_NOREUSE,
 };
 
 /*
diff --git a/ioengines.c b/ioengines.c
index e2316ee4..742f97dd 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -565,6 +565,10 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 			flags = POSIX_FADV_RANDOM;
 		else if (td->o.fadvise_hint == F_ADV_SEQUENTIAL)
 			flags = POSIX_FADV_SEQUENTIAL;
+#ifdef POSIX_FADV_NOREUSE
+		else if (td->o.fadvise_hint == F_ADV_NOREUSE)
+			flags = POSIX_FADV_NOREUSE;
+#endif
 		else {
 			log_err("fio: unknown fadvise type %d\n",
 							td->o.fadvise_hint);
diff --git a/options.c b/options.c
index 18857795..440bff37 100644
--- a/options.c
+++ b/options.c
@@ -4,6 +4,7 @@
 #include <ctype.h>
 #include <string.h>
 #include <assert.h>
+#include <fcntl.h>
 #include <sys/stat.h>
 #include <netinet/in.h>
 
@@ -2740,6 +2741,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = F_ADV_SEQUENTIAL,
 			    .help = "Advise using FADV_SEQUENTIAL",
 			  },
+#ifdef POSIX_FADV_NOREUSE
+			  { .ival = "noreuse",
+			    .oval = F_ADV_NOREUSE,
+			    .help = "Advise using FADV_NOREUSE",
+			  },
+#endif
 		},
 		.help	= "Use fadvise() to advise the kernel on IO pattern",
 		.def	= "1",
