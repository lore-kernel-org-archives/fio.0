Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E108C04A6A
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjGULI6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjGULIT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A9F30FE
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE27619E3
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 11:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250EBC433C9;
        Fri, 21 Jul 2023 11:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937512;
        bh=mME5yAo2bvEegrhVCjRW/f3w6O4ZovutwBnefEPDEHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSTIXOAF3AStzc/8JlNTah4FQ2xML4j4sCS/i8KwBikLu4jy61YOTOyZtN1uWVr1q
         VxL1WRFdmPN8Y1+Z8CTgPLGY22vhfuApUEbJVc95t6uw89wSwuz3UR2b6Hjq7tudUa
         lOSHQOh5coyb1bLXNtoE8Kv/PV6qKdHGnClOUmqm8R3jboEX/3Ww2Y9C44PrpBhYD5
         dpB353i2ydHqCoHX6+2Rji35x6f5iIFKKX6trmJAaJZf4UhGPQhQ7xCT6PugRyOP55
         jVH5kJAn/k5t0+h5FEaozdDQgxpsyrsgCwEbphWQ5yr/LPtaOykkjZOMSeQpLIFgnv
         AP9s1Yk+bRl1g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 1/6] os-linux: Cleanup IO priority class and value macros
Date:   Fri, 21 Jul 2023 20:05:05 +0900
Message-ID: <20230721110510.44772-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721110510.44772-1-dlemoal@kernel.org>
References: <20230721110510.44772-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

In os/os-linux.h, define the ioprio() macro using the already defined
IOPRIO_MAX_PRIO macro instead of hard coding the maximum priority value
again. Also move the definitions of the ioprio_class() and ioprio()
macros before the ioprio_value() function and use ioprio_class() inside
ioprio_value_is_class_rt() instead of re-coding the iopriority class
extraction again in that function.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 os/os-linux.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/os/os-linux.h b/os/os-linux.h
index 2f9f7e79..72727ac3 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -131,6 +131,9 @@ enum {
 #define IOPRIO_MIN_PRIO_CLASS	0
 #define IOPRIO_MAX_PRIO_CLASS	3
 
+#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
+#define ioprio(ioprio)		((ioprio) & IOPRIO_MAX_PRIO)
+
 static inline int ioprio_value(int ioprio_class, int ioprio)
 {
 	/*
@@ -144,7 +147,7 @@ static inline int ioprio_value(int ioprio_class, int ioprio)
 
 static inline bool ioprio_value_is_class_rt(unsigned int priority)
 {
-	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
+	return ioprio_class(priority) == IOPRIO_CLASS_RT;
 }
 
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
@@ -153,9 +156,6 @@ static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 		       ioprio_value(ioprio_class, ioprio));
 }
 
-#define ioprio_class(ioprio)	((ioprio) >> IOPRIO_CLASS_SHIFT)
-#define ioprio(ioprio)		((ioprio) & 7)
-
 #ifndef CONFIG_HAVE_GETTID
 static inline int gettid(void)
 {
-- 
2.41.0

