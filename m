Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7525DC636CD
	for <fio@archiver.kernel.org>; Wed,  1 Feb 2023 13:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBANAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Feb 2023 08:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjBANAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Feb 2023 08:00:14 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36EBB451
        for <fio@vger.kernel.org>; Wed,  1 Feb 2023 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2Bo4WnePlU0r2nNXd5bpVsn8KdJYyB1WYxdtlXt4ft4=; b=SAi0AN12yfS6q3Wd74+C3xD/1O
        MmKvKST+4mDRdk3nJlCIroplPfWcqP8R58jvcFJJWJYyw995jzza7qjWusH51KmiKTBm56mRk4obU
        IiASasdS2m0cQV+8pcShKGJdkAOHojNjzzLeAGLFIpxwguXjfrwPIXgmaNViNx1DRkbn34HRQZvSQ
        B5sW4i0hOozyvu7GhwvKim623vLSfIAXYjXhrLQPt8yzw6SgQvDakNjSTKJOuofPx3jl57FOZnNO2
        /iRmf/idVf/gzx94dfIjeNl5l/01MCxHCp5lWnzHZGP8mod9hkY59lsdEo8/sxdUINY4QI0gYIUHk
        nFNQ2IAg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pNCi1-004m7m-1M
        for fio@vger.kernel.org;
        Wed, 01 Feb 2023 12:59:36 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 461861BC012D; Wed,  1 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230201130002.461861BC012D@kernel.dk>
Date:   Wed,  1 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c6cade164bc7e35e95ba88f816be4f44475e4e23:

  lib/pattern: Fix seg fault when calculating pattern length (2023-01-30 10:46:22 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7d7a704638a1e957c845c04eeac82bdeda0c674c:

  lib/pattern: fix formatting (2023-01-31 10:44:54 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      test: add test for lib/pattern segfault issue
      lib/pattern: fix formatting

 lib/pattern.c             | 4 ++--
 t/jobs/t0028-c6cade16.fio | 5 +++++
 t/run-fio-tests.py        | 9 +++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)
 create mode 100644 t/jobs/t0028-c6cade16.fio

---

Diff of recent changes:

diff --git a/lib/pattern.c b/lib/pattern.c
index e31d4734..9fca643e 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -386,9 +386,9 @@ static int parse_and_fill_pattern(const char *in, unsigned int in_len,
 		assert(filled);
 		assert(filled <= out_len);
 		out_len -= filled;
-		if (out)
-			out     += filled;
 		total   += filled;
+		if (out)
+			out += filled;
 
 	} while (in_len);
 
diff --git a/t/jobs/t0028-c6cade16.fio b/t/jobs/t0028-c6cade16.fio
new file mode 100644
index 00000000..a0096d80
--- /dev/null
+++ b/t/jobs/t0028-c6cade16.fio
@@ -0,0 +1,5 @@
+[test]
+size=16k
+readwrite=write
+buffer_pattern="abcd"-120xdeadface
+ioengine=null
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 70ff4371..c3091b68 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1246,6 +1246,15 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          28,
+        'test_class':       FioJobTest,
+        'job':              't0028-c6cade16.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
