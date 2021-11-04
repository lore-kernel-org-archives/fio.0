Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB52C433F5
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B142B61108
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhKDHZ1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhKDHZ1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 03:25:27 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E53C061714
        for <fio@vger.kernel.org>; Thu,  4 Nov 2021 00:22:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p16so10189092lfa.2
        for <fio@vger.kernel.org>; Thu, 04 Nov 2021 00:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QMz4ecKSTKXw1biQlBl1eOvmNy7mLjIe0R8MzR0fwLM=;
        b=FI5xkduP7YxMvTlG65D0AYNKkZ0N+Ch7KL1WWsnRv+7NlFrqHnLIPz+T9xvEbKA9Uw
         z1z29n/oesN0kWUtyRe5js2lzB8gt3JFlDix/PbNtxLrz+ynf4emBVOhyWjMo7F4O/6f
         r0ixa+o6Oo9H+myLo6G8FjM7oPEzoGFDeQuPQEuoG7ixjFWYKAREQjjydfG2xnWz362K
         Ft1mo2chSQnMzvA++cy17dMvhHzK+6DgKld32EnW9LQbT5m9wpK3YN/cz5l9edCgD8Sx
         UkRcv1lIqU+OtWvoKfJmYTI4lMbtinHPLXCg1LiyxuAiM4iERutO72CnH/stASiIlVT1
         Gzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=QMz4ecKSTKXw1biQlBl1eOvmNy7mLjIe0R8MzR0fwLM=;
        b=ebSUNt+qG8/ywB8+eCoKPLHM9PCBnIQf2vEuW6xfWIOWNJpAiVy7o4veq53n2EOfD6
         s3CZbKZFOo5cBM0DZj+UE/ut4PZOGAGwC7nsg8xuSOvJvTddon+sE6kKb8c8unkSCz6E
         vHXeG2ygLbjmkx2OkULAB89auq8OdLIMX0E2b+ZxXdfOGVxRBQbJvanDY0lNRVO/qxBF
         l7ZotfmRkYEu/uG8MWqSJHIepJyB7Ur8ERedCx4xZPzm2p+aa8VrZmAJ5GRimd8LG+e6
         V2tslwVu2oEfPZH2sRQc++suXiIy32o94kyZRtu5haqUjUpGUNqgRJ6R0R/SpLFQKhs8
         wdIw==
X-Gm-Message-State: AOAM533Dx3xO9pr62jPSM540CtiT32P+lqpATcghbhhRzbI0zAeKovrR
        IXU4YICCc9Nv/tkldUdLzxig8NjEtkbkkw==
X-Google-Smtp-Source: ABdhPJwQV/L8wHYc9yY67fSARSwS6ey0mqwKehAB31eyld9iGNB07nC+qm2XPqTX0Fanp47Bym+yQA==
X-Received: by 2002:a05:6512:31d1:: with SMTP id j17mr46428277lfe.11.1636010567335;
        Thu, 04 Nov 2021 00:22:47 -0700 (PDT)
Received: from localhost.localdomain (dyh1cxc773fwnls7mh3kt-4.rev.dnainternet.fi. [2001:14bb:1aa:298b:7bb9:24b4:bf6a:35d1])
        by smtp.gmail.com with ESMTPSA id s7sm391317lji.67.2021.11.04.00.22.46
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 00:22:46 -0700 (PDT)
Sender: =?UTF-8?Q?Ville_Skytt=C3=A4?= <vskytta@gmail.com>
From:   "=?UTF-8?q?Ville=20Skytt=C3=A4?=" <ville.skytta@iki.fi>
X-Google-Original-From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@upcloud.com>
To:     fio@vger.kernel.org
Subject: [PATCH] genfio: fix temporary file handling
Date:   Thu,  4 Nov 2021 09:22:45 +0200
Message-Id: <20211104072245.717980-1-ville.skytta@upcloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As a side effect, the template temp file is no longer left behind, as
a unique filename is used for it on each run.

Use the same method of figuring out the temp dir as in
check_status_file().

Signed-off-by: Ville Skyttä <ville.skytta@upcloud.com>
---
 tools/genfio | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/genfio b/tools/genfio
index 8518bbcc..fc7e6e46 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -22,7 +22,8 @@
 BLK_SIZE=
 BLOCK_SIZE=4k
 SEQ=-1
-TEMPLATE=/tmp/template.fio
+TEMPLATE=$(mktemp "${TMPDIR:-${TEMP:-/tmp}}/template.fio.XXXXXX") || exit $?
+trap 'rm -f "$TEMPLATE"' EXIT
 OUTFILE=
 DISKS=
 PRINTABLE_DISKS=
-- 
2.25.1

