Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F21C6FD1D
	for <fio@archiver.kernel.org>; Thu, 30 Mar 2023 21:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjC3V2B (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Mar 2023 17:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjC3V2A (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Mar 2023 17:28:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E794C179
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 14:28:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so20157291ybl.19
        for <fio@vger.kernel.org>; Thu, 30 Mar 2023 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680211679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h0vL0OPMdPPeT4R5mVlNLbO51OYqmlftJRRVqL7/120=;
        b=PxRO1jMs997fdaBAijUoxsIL5zQ1A+EJ2bbo1DFVbLrvaBCCT7sjLHWy5qU1mELiAn
         MBtquIQsrZWFyjlPtXRA6eeJimrD5KX87LhST6ZXuerF8U9O8nue9LGPurSTyXnq9nRn
         TioKjMxmhkbbtFrkWwMRrMXdHfjR23EnEuTEH/70YwhAjQS+a18G6M+tpuyOF92IH9eS
         WfBiiEC3OZ5UWBSEkFQ2AgtYB/MqHZS69CAAQ1Ksru3bc6f7kZle6TRIDPfj+YlS4sj6
         SFliq35/upOSeloMxmozqAeNQPUbvdbdQp6LLe3ydGEruYB14KakMbYE37fb2Csmond/
         aa0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680211679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0vL0OPMdPPeT4R5mVlNLbO51OYqmlftJRRVqL7/120=;
        b=XCP9MTxP/bkB265tD6Buli+ZalKkx11CzcjXHZmi2z017V0SK9ifMlN6ovDn2XCfhw
         p65gP9PS0TnkCEZW72r8jfEtXJG8mCrJTa9K9e2JblkoamwpVvZ6sjZ1Wt3NRpVn34EX
         hoEO0XkbyQBUvVw+jHsZkPC7+Nv538dRsIq82UsJRJtdl0tk9V5SGTB/vnDQF0IhCum2
         aXPReZf3StP8zNOEitHlTUzLrOJmCKAYGaquo0VmKgJMJypYoFTXw8fmcbq2tuWp4qdU
         H7SqbtbheyZJXu3/4YAl0olw7OUNI+VsKqXAXxXFc7CcLn7IZ9Z7KOtolyqn04nlhpae
         qr1Q==
X-Gm-Message-State: AAQBX9esf+nEa0/leRlxtIuL+u6Ms03fVxihcmt41UYPPpKrljK4HnfD
        mlIy85iX6QY2LkfYqtL1ZWrox6W+n+rI
X-Google-Smtp-Source: AKy350ba9+r4jyB7YngiC0ouJLTLNkLO3AQbv4ilDFD44g7OYSvBm/d9LvvTjlhtXtFOrTA1bm8lSPzYKfQq
X-Received: from yuanchu.svl.corp.google.com ([2620:15c:2d4:203:38bc:7140:ab63:2a52])
 (user=yuanchu job=sendgmr) by 2002:a81:b647:0:b0:545:5e70:3237 with SMTP id
 h7-20020a81b647000000b005455e703237mr11990232ywk.2.1680211679379; Thu, 30 Mar
 2023 14:27:59 -0700 (PDT)
Date:   Thu, 30 Mar 2023 14:27:05 -0700
In-Reply-To: <20230330212705.2992931-1-yuanchu@google.com>
Mime-Version: 1.0
References: <20230330212705.2992931-1-yuanchu@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230330212705.2992931-2-yuanchu@google.com>
Subject: [PATCH 2/2] docs: add noreuse fadvise_hint option
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
 fio.1 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fio.1 b/fio.1
index e2db3a3f..4fa033f3 100644
--- a/fio.1
+++ b/fio.1
@@ -1098,6 +1098,9 @@ Advise using FADV_SEQUENTIAL.
 .TP
 .B random
 Advise using FADV_RANDOM.
+.TP
+.B noreuse
+Advise using FADV_NOREUSE.
 .RE
 .RE
 .TP
-- 
2.40.0.348.gf938b09366-goog

