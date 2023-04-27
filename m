Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42314C77B61
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 09:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbjD0JZR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 05:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243157AbjD0JZQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 05:25:16 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3528810D
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 02:25:14 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2aa39ce5d26so72827511fa.1
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 02:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682587512; x=1685179512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewEi+zntYKpcyY4I0y6UWxecgYtd3o5u/l4HyUGYbKw=;
        b=G40xIZilxyLTvPWc7B5TWRd9kci6/n1BBiCEPkjBeZV/NQspp9BPJQ+C+px6ieW21t
         rAglQTdI9Bgt4shC+xpN7Yv2AAIQOEquSQo/T9Gchdy/M+74mOpyk/eRdyT1lJLPdWrw
         jjuVAgDSIFEb2/NpgFOw8+jw4kugvgZs2KIjzIKnpVXyWlGAr+roPFDUlF4c2thsLyFT
         OpqN+hph8xhQBeDDhFOwjLdSCM2bEkZqrBOYOp86ubHizcDhcm05AAsNx2pfkf5zH6GY
         gSRjng5c4jjbgFflbOqk9PAwLJaQp1LZ/gWonaFPAi2cluE+9aWspyiog+Tn+PeSrHz4
         BHVQ==
X-Gm-Message-State: AC+VfDz9GjeCpV7Hq8TF9O8euTMWBe8eSCbVknrOlFCO9EoElhWb38jn
        1BzFYJQkYZZZ5MxCJ0jKdV2PY0GtWsiDy2SW
X-Google-Smtp-Source: ACHHUZ4tNidRqLaO8TGZXtqD2Gz/QHrAfW5y85B2wftzbeZizq9VhrE2T8HuLWxBvRQTU9TDOeCXVg==
X-Received: by 2002:a2e:7e0c:0:b0:293:2c65:20c8 with SMTP id z12-20020a2e7e0c000000b002932c6520c8mr432551ljc.1.1682587512275;
        Thu, 27 Apr 2023 02:25:12 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id w21-20020a2e8215000000b002a9f1b23604sm2860637ljg.93.2023.04.27.02.25.11
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 02:25:12 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 549354EB; Thu, 27 Apr 2023 11:25:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1682587511; bh=QyHAuux6rxOzDaj/rEvSxWnmxq9RKL9+j+jGcZkM9AM=;
        h=From:To:Cc:Subject:Date:From;
        b=G4gifgVGVyc71W+d0RkU/8UNqPPf9rMJ30sznIezMk3IZXO8Zh/rlMiQ8Zir2jMOE
         tOp8NUQOhSJSs7TLZFUD4hQbLAH6QOMO0PGGH28RmIxY0GjdHwqdMF48a91Dwndsr9
         oLZrMoKdDn+961Sdz6drOuWYI7bg6IwIKUgJLfp0=
Received: from x1-carbon.wireless.wdc (unknown [87.116.37.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 611303C7;
        Thu, 27 Apr 2023 11:24:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1682587501; bh=QyHAuux6rxOzDaj/rEvSxWnmxq9RKL9+j+jGcZkM9AM=;
        h=From:To:Cc:Subject:Date:From;
        b=NTVpIfE7G5hoXZpqDXGVbXvJZLQsPhaFSYdjTLLKX6Ut60V6zdwrWhvvnOuzSPPLP
         NvPZUDw51Fd1iHxLRPE2h1jb7OGUa7J7z61qsAQ6EqhLqp4Aj2WfwrORPde4uKCaKX
         PgTma6LYs3Slz+DS4rFwb+DSb8quyXGrCD/ki0AA=
From:   Niklas Cassel <nks@flawful.org>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, dlemoal@kernel.org,
        "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] Revert "zbd: Report the zone capacity"
Date:   Thu, 27 Apr 2023 11:24:23 +0200
Message-Id: <20230427092423.605250-1-nks@flawful.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

This reverts commit 067c18eb3700373d029a9f2795d662453fc09cf4.

In the Linux zoned block devices API (blkzoned.h) (and in the NVMe Zoned
Namespace Command Set Specification), the zone capacity can be different
for each zone (unlike zone size, which has to be the same for all zones).

In order to not mislead the user to think that the zone capacity has to
be the same for all zones, remove the zone capacity for zone0 from the
per device print.

The zone capacity can be printed in prints that are related to a specific
zone, e.g. when encountering an error when performing I/O to a zone.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 zbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index f5fb923a..351b3971 100644
--- a/zbd.c
+++ b/zbd.c
@@ -804,8 +804,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB and capacity %"PRIu64" KB\n",
-	       f->file_name, nr_zones, zone_size / 1024, zones[0].capacity / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n",
+	       f->file_name, nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
-- 
2.40.0

