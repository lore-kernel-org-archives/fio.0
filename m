Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3B4C43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 13:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiLANAr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 08:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiLANAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 08:00:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C4790779
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6FOi9FIZqA4nPDJc/TQje2vSW66E4kvIREo+zj5KcnQ=; b=Rp0sFxm4ZU8uCPIBGzaF3spvvL
        pfRjqRrxzlHOMpGHohTOwwDUj8AaI9v5SriBh25HHI9ynR5Hmixu1nMznxGJlhMJoJMDXp2tRyYnp
        A54tNxlejU7RHVIYct81T8AOgIqEDX438iJk+Jjco9y6UkHgBVDzobc6GeYSQmnRq5RRVvqxwUHKt
        q3k3IlO9gtfdhHrXDSlJvu/3tJkGdTdj2GS3rRqLxyhSuKV6vNYviNpce7SyEi+IEgqjPXxsEoPG8
        /zgLccihSVGU9yu1muHuWtll8aICJkhm+oDiuzHq0i5/z+PmUHA2Myli7KUytxloxht+qHzyWpiYH
        m5YBlvbQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0jAi-00FwgY-NL
        for fio@vger.kernel.org; Thu, 01 Dec 2022 13:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4F1011BC0139; Thu,  1 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221201130002.4F1011BC0139@kernel.dk>
Date:   Thu,  1 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 967c5441fa3d3932ec50ea5623411cc6e8589463:

  docs: description for experimental_verify (2022-11-29 17:09:41 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6d8fe6e847bb43cf7db5eee4cf58fd490f12be47:

  backend: respect return value of init_io_u_buffers (2022-11-30 19:58:34 -0700)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      backend: respect return value of init_io_u_buffers

 backend.c  | 3 ++-
 blktrace.c | 3 ++-
 iolog.c    | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index ba954a6b..928e524a 100644
--- a/backend.c
+++ b/backend.c
@@ -1301,7 +1301,8 @@ static int init_io_u(struct thread_data *td)
 		}
 	}
 
-	init_io_u_buffers(td);
+	if (init_io_u_buffers(td))
+		return 1;
 
 	if (init_file_completion_logging(td, max_units))
 		return 1;
diff --git a/blktrace.c b/blktrace.c
index 00e5f9a9..d5c8aee7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -545,7 +545,8 @@ bool read_blktrace(struct thread_data* td)
 			td->o.max_bs[DDIR_TRIM] = max(td->o.max_bs[DDIR_TRIM], rw_bs[DDIR_TRIM]);
 			io_u_quiesce(td);
 			free_io_mem(td);
-			init_io_u_buffers(td);
+			if (init_io_u_buffers(td))
+				return false;
 		}
 		return true;
 	}
diff --git a/iolog.c b/iolog.c
index aa9c3bb1..62f2f524 100644
--- a/iolog.c
+++ b/iolog.c
@@ -620,7 +620,8 @@ static bool read_iolog(struct thread_data *td)
 		{
 			io_u_quiesce(td);
 			free_io_mem(td);
-			init_io_u_buffers(td);
+			if (init_io_u_buffers(td))
+				return false;
 		}
 		return true;
 	}
