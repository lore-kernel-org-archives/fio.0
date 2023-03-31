Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFDCC761A6
	for <fio@archiver.kernel.org>; Fri, 31 Mar 2023 18:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjCaShS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjCaShR (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 14:37:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6131CBA2
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:37:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso22639561ybi.2
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680287832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JgG6Nnyig0BEaSKPRq5wlvl5KMSaIt8tQ123NSyeQGY=;
        b=DIgCEU9aeFtpb7MYEHChCZK8K8USG1ATrpA1P/bjFmbUcFfz7ZfdSaUj8yVNdD74t4
         I23Cd6DQxBaDPSDneu3WQ7Av1J8BPb9EEDqzwhEnVvmP240FizheSIWzWVJM8V9x0Jrg
         4KyfzP/S5TccSq80gbvcZhMxATQex9U3JlDVyEtYVL2pwZYLjKhSQc6uJOtFhvNoBaD+
         HrejfuL4bYskzdnd1PDC8137fLkuAKk6i5UQQ97eNAWHSZHdItiOj6c5+A/Kxvdjgs9W
         EFcYhOhabF44G4xUDhqNHXMnD2f8KoJ2w4wLNOs6P0nRUg8CkS+7jQmjR/u+/l8+oBhR
         uDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680287832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JgG6Nnyig0BEaSKPRq5wlvl5KMSaIt8tQ123NSyeQGY=;
        b=c6feZ/6oLp8De1EQN8LbRRfwICR+2r5GD/rI/gEgVfCvugE7A17qEnuPUjbHnWuSaW
         pMOSVT70u8WQevQoW6lLTGtEf/b9h2csV5jDXr184IY7NPTfm1qwOVXInmL76qArz2oA
         tk6PI6cp2vqCESfZ10spq/j07gFpfCv+BcDuQT+bGOFGfQU60jV6nbLO80f3++mlPyD/
         SBSrTrWtEr9tKHzOoN6+1FLbD2FjAnXZ8fH11LU2Mkos0zdJ/1ndzfS7f7ubuqQi28Go
         I/ozixTBHU3xi5JXH+4HPsWqTX2ws8CuOelw8rBvs+1NiWRyg2GOVUY+GibdSlYQfyM5
         LGDg==
X-Gm-Message-State: AAQBX9daPKAOL/r/8h1bsm048AXPT4LaJzr8NAdOoP/fMZUWa20QGbx4
        aQ006es2wTonz2FdtVl5Y7Bc9tbipN6b
X-Google-Smtp-Source: AKy350bvx7QTrq8EkemLX+zlIi0CB32da/41fRSJ2THpsBWIdnOtO2PhPLKrT9Mv7XiSJGsBvrjVO2sDN6jz
X-Received: from yuanchu.svl.corp.google.com ([2620:15c:2d4:203:a16:7b48:234e:4e85])
 (user=yuanchu job=sendgmr) by 2002:a81:e405:0:b0:544:d5ce:eb33 with SMTP id
 r5-20020a81e405000000b00544d5ceeb33mr13309220ywl.8.1680287832592; Fri, 31 Mar
 2023 11:37:12 -0700 (PDT)
Date:   Fri, 31 Mar 2023 11:37:03 -0700
In-Reply-To: <20230331183703.3145788-1-yuanchu@google.com>
Mime-Version: 1.0
References: <20230331183703.3145788-1-yuanchu@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331183703.3145788-2-yuanchu@google.com>
Subject: [PATCH v2 2/2] docs: add noreuse fadvise_hint option
From:   Yuanchu Xie <yuanchu@google.com>
To:     Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        fio@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>,
        Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

noreuse was added as an fadvise_hint option to apply POSIX_FADV_NOREUSE,
so we add it to the docs as well.

Signed-off-by: Yuanchu Xie <yuanchu@google.com>
---
 HOWTO.rst | 5 +++++
 fio.1     | 5 +++++
 2 files changed, 10 insertions(+)

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
-- 
2.40.0.348.gf938b09366-goog

