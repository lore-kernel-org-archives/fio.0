Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E987C433EF
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 22:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1022061B51
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 22:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhKQWW0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 Nov 2021 17:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbhKQWWY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Nov 2021 17:22:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4045C061570
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 14:19:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r132so3479895pgr.9
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 14:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFTlo7G3ixVhX7veOgeCjAnFukP6MnNv2fMLWYHdCtw=;
        b=b+nNmGma5wo+7dmFva7Y/QyzwwMXzig50CVNf9Cxt4AitdUXKczdXpp7LMyMa0BSOa
         DtiQfwOBxzKt0BWqYEjKc0/YVHL+oDoUS7yWr71+2Av2bhW1gObUZxzUovpdr0ro/jNz
         r9I+iqXmKnIHusn999qFzAkWZeKH6ZKkY9roU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFTlo7G3ixVhX7veOgeCjAnFukP6MnNv2fMLWYHdCtw=;
        b=L8Wbq8fUDqbwmj8KnEMnsyKEPL/5fn+3PiVFemGWYBNbyH7xCpuatcko8AOi/Uhczq
         JIR93G2ilSof4DdOWzMPK3Zhsneko8+wroY/TkFApceMpSJjX60jEpuXtau1NmKu5U0q
         +QCSk/VPhTKgTLOwvYeQ9/MxMzvtFGrUlmqxvKSS0JOOEBGGgLoR6pEEdKJGBYxQBv4h
         8BIS/vVCffvnLQXtHq8pn/sTJUtRYiATRCLarNQuO3Es5ehIAciOLoxIzLCctlkm9Z/h
         qyeCBtIDpLVPX1jEV7vG2Hk7l6D4NC1lWgzNUa5/gesHuAFWQnSrJPSQWug+VEpNb05I
         09YA==
X-Gm-Message-State: AOAM532gO1NB94X+T99M8Yk9t1Rx5jCoK0ePeXDQ3DGHa/PkpcmIO0Mv
        /YEuMTZfrXinuRowxAGMVrfLsLOkw4/USQ==
X-Google-Smtp-Source: ABdhPJyNQSx4GQ6MfctNqoYcPoO5iQgZUVBxWk1OrvmMWFiaBrLSfD6iF5EYKAyzs/4Dbbr0zYuw5g==
X-Received: by 2002:a05:6a00:1a16:b0:49f:ed6d:c48e with SMTP id g22-20020a056a001a1600b0049fed6dc48emr10186386pfv.14.1637187565183;
        Wed, 17 Nov 2021 14:19:25 -0800 (PST)
Received: from localhost ([2620:15c:202:201:327f:7baa:380e:33a3])
        by smtp.gmail.com with UTF8SMTPSA id l12sm589674pfu.100.2021.11.17.14.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:19:24 -0800 (PST)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     axboe@kernel.dk, niklas.cassel@wdc.com
Cc:     fio@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] Makefile: Fix android compilation
Date:   Wed, 17 Nov 2021 14:19:18 -0800
Message-Id: <20211117221918.3050439-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Inclue cmdprio for Android as well.
Without the patch, make for Android fails at link time:

engines/io_uring.c:824: error: undefined reference to 'fio_cmdprio_init'
engines/io_uring.c:456: error: undefined reference to 'fio_cmdprio_set_ioprio'
...

Fixes e27b9ff0e ("cmdprio: move cmdprio function definitions to a new cmdprio.c file")

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index e9028dce..04c1e0a7 100644
--- a/Makefile
+++ b/Makefile
@@ -236,6 +236,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c profiles/tiobench.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+  cmdprio_SRCS = engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE += oslib/linux-blkzoned.c
 endif
-- 
2.34.0.rc1.387.gb447b232ab-goog

