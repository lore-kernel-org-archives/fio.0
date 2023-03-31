Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459B9C761A6
	for <fio@archiver.kernel.org>; Fri, 31 Mar 2023 18:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjCaShP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbjCaShN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 14:37:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF90A1C1FD
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:37:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i11-20020a256d0b000000b0086349255277so22755511ybc.8
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680287829;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zMAftdNnYqJFW9DAl5ZWz3TXAOsGNXgF4f3dazPxjOI=;
        b=G0CozPdKfUsg9qvMRs6B+m0W+dsW2q/RRwYjaTC/e+WhfMU4EKldmQm0ARWYXIu03/
         F5mMw9MeLwqN/FSYxxnndCGmOIAXqYS20nVrhZry+WO7O/UPTAax8CyrGlfKSb6BvGJX
         g5Csppp32FW5vO40KyK2UbqrmrEjXgb7OGtuSaNOtqvuJeajrWwZNKDfxGXSa+vp0moM
         oa82pgmo70e1CNJAFXML1RFb0OFcjYMpFvwt8MelIEeVY5ZfFCWDrxAYXTV4hEBBRMWP
         AICv9k5+x04xybkSAFXjfrQbacp+TAeTOrLGW/SfP9yhVIu5Tef3eMbxTGcR1OoumbAB
         lksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680287829;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMAftdNnYqJFW9DAl5ZWz3TXAOsGNXgF4f3dazPxjOI=;
        b=b0j4NBt+fLqEbZ6S65g4ZS3McHi5QwAbGE2V1rVnzhU9iOhbWjYR0rkpcvisLkYD0x
         tA08SRszmFtpfsYzp6xUOXaslJ8GLJkpuhKV5Qz3XeKpsQqiNX3fAH791oSBe8fZy5DJ
         C/ugB+WHdtNxX5jaXAeMY8ewdGZMLbDjBBVpMwTHCBLxFKgfz27n9jkxqgUHyHTG4Ltb
         4BMLgs4EXGS5bA0VgtoF0vm+rWxDMIoOvH/U5S/U7I/v2sbr98IR1iPFy5YrXHXlt06T
         b8UWYclUEV99f5SupZ6iLVoPeQP28/AkLqjEXheSXocpiQ9p8lRGcqP+IaGEgK6dxd/Q
         pcRQ==
X-Gm-Message-State: AAQBX9dQoEJqIW6+yswSBzEKKI4csvY1cCF+mc6D+PFc/oGopDxTWve3
        jrRbG+oAfisaWc6nHCYft2i34n/+ax94
X-Google-Smtp-Source: AKy350aXEao7COAFxzBLbuCqsyvt9cJ53BPnoQ7GTC8BuRrgqo8sOf4VNcnX/ZmfOo7C+aAR051ShxXVVZwr
X-Received: from yuanchu.svl.corp.google.com ([2620:15c:2d4:203:a16:7b48:234e:4e85])
 (user=yuanchu job=sendgmr) by 2002:a05:690c:727:b0:545:62c0:6226 with SMTP id
 bt7-20020a05690c072700b0054562c06226mr14173287ywb.6.1680287829055; Fri, 31
 Mar 2023 11:37:09 -0700 (PDT)
Date:   Fri, 31 Mar 2023 11:37:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331183703.3145788-1-yuanchu@google.com>
Subject: [PATCH v2 1/2] fio: add support for POSIX_FADV_NOREUSE
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

As of Linux kernel commit 17e810229cb3 ("mm: support
POSIX_FADV_NOREUSE"), POSIX_FADV_NOREUSE hints at the LRU algorithm to
ignore accesses to mapped files with this flag. Previously, it was a
no-op.

Add it in fio as an fadvise_hint option to test the new behavior.

Signed-off-by: Yuanchu Xie <yuanchu@google.com>
---
 fio.h       | 1 +
 ioengines.c | 2 ++
 options.c   | 4 ++++
 3 files changed, 7 insertions(+)

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
index e2316ee4..56759c53 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -565,6 +565,8 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 			flags = POSIX_FADV_RANDOM;
 		else if (td->o.fadvise_hint == F_ADV_SEQUENTIAL)
 			flags = POSIX_FADV_SEQUENTIAL;
+		else if (td->o.fadvise_hint == F_ADV_NOREUSE)
+			flags = POSIX_FADV_NOREUSE;
 		else {
 			log_err("fio: unknown fadvise type %d\n",
 							td->o.fadvise_hint);
diff --git a/options.c b/options.c
index 18857795..fe580ebb 100644
--- a/options.c
+++ b/options.c
@@ -2740,6 +2740,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = F_ADV_SEQUENTIAL,
 			    .help = "Advise using FADV_SEQUENTIAL",
 			  },
+			  { .ival = "noreuse",
+			    .oval = F_ADV_NOREUSE,
+			    .help = "Advise using FADV_NOREUSE",
+			  },
 		},
 		.help	= "Use fadvise() to advise the kernel on IO pattern",
 		.def	= "1",
-- 
2.40.0.348.gf938b09366-goog

