Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2DDC433EF
	for <fio@archiver.kernel.org>; Thu, 10 Mar 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiCJNBJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Mar 2022 08:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiCJNBI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Mar 2022 08:01:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE0A58E49
        for <fio@vger.kernel.org>; Thu, 10 Mar 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8I0/AQ/QyZrGZ749wfh555fwgZ/7TZUly7XcH7btv3I=; b=oarSY9UMeP8rL8AhOLsV1scvJR
        u4RgIeqDZIHmc6YXaXSbtbrq9LmYVn8k9xUBLik23IiuBX67DTqVvUOAeMsiK9ON+e2onQBaiulVW
        PHm4CXlqEshSEyxMYQS/91jrh+NJ27TX53FQBrmwOh/udS0m6szwxm7imeXHitExcUNfINSv54GVk
        prVNQgau3l4BWwZCejfLfzetRp8pqCmpfH6qO2AUjS+uquCKiMUk0B+tyYJ/HWZHC6p9Zh4VRCk8E
        SX1HNHsIZp0ruVyymBpurnUQ40ilNhJmsJsdM7b8ORBaoybRYUGCbDuublMnt/oiQHYPjOv7KAU3A
        VXHKhgNQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSIOh-000XPD-LR
        for fio@vger.kernel.org; Thu, 10 Mar 2022 13:00:03 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id ED3AB1BC0153; Thu, 10 Mar 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220310130001.ED3AB1BC0153@kernel.dk>
Date:   Thu, 10 Mar 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a24ef2702e2c1b948df37080eb3f18cca60d414b:

  Merge branch 'master' of https://github.com/dpronin/fio (2022-03-08 16:42:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df0ab55ff9e28f4b85c199e207aec904f8a76440:

  Merge branch 'master' of https://github.com/dpronin/fio (2022-03-09 06:20:31 -0700)

----------------------------------------------------------------
Denis Pronin (3):
      - freeing job_sections array of strings upon freeing each its item in init.c
      - fixed memory leak, which is happening when parsing options, claimed by ASAN
      - fixed memory leak in parent process detected by ASAN when forking and not freeing memory in the parent process allocated for fork_data

Jens Axboe (3):
      Merge branch 'fix/asan-memleak' of https://github.com/dpronin/fio
      Merge branch 'fix/asan-memleak-forkdata' of https://github.com/dpronin/fio
      Merge branch 'master' of https://github.com/dpronin/fio

 backend.c | 2 ++
 init.c    | 4 ++++
 parse.c   | 2 ++
 3 files changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index a21dfef6..cd7f4e5f 100644
--- a/backend.c
+++ b/backend.c
@@ -2441,6 +2441,8 @@ reap:
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
+				free(fd);
+				fd = NULL;
 			}
 			dprint(FD_MUTEX, "wait on startup_sem\n");
 			if (fio_sem_down_timeout(startup_sem, 10000)) {
diff --git a/init.c b/init.c
index 81c30f8c..b7f866e6 100644
--- a/init.c
+++ b/init.c
@@ -2185,6 +2185,10 @@ static int __parse_jobs_ini(struct thread_data *td,
 		i++;
 	}
 
+	free(job_sections);
+	job_sections = NULL;
+	nr_job_sections = 0;
+
 	free(opts);
 out:
 	free(string);
diff --git a/parse.c b/parse.c
index d086ee48..e0bee004 100644
--- a/parse.c
+++ b/parse.c
@@ -817,6 +817,8 @@ store_option_value:
 
 		if (o->off1) {
 			cp = td_var(data, o, o->off1);
+			if (*cp)
+				free(*cp);
 			*cp = strdup(ptr);
 			if (strlen(ptr) > o->maxlen - 1) {
 				log_err("value exceeds max length of %d\n",
