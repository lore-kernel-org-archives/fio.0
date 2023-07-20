Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C234C001E0
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 01:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjGTBbT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTBbS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 21:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDCB2102
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 18:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C894617CF
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 01:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73306C433C7;
        Thu, 20 Jul 2023 01:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689816677;
        bh=ppc70Rla8ntlkg+WgvBaaL6FZajdy9L75108HeO150s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZYU7fVTzLrZYzD4dWv8qOP3WAxX0kX831GMohlOIZfkjcmW1ko1tNO6A5KX5zgqV
         Xktbz2YsnWbsF8iJWP3LfEDhj2reMOlyW2ZqI0iRXeYOp1cTwQuLBiliTTXtpANmc/
         0tHo4tr9DrEdo4ToUoimpIfE21jTw6FtQbV6PYaRj4kQnLqwEeOofe0UpoZtnqk6La
         dMVKyT0UorJxhuhPbO+x0KHcOaQID2UVrBgTQK64OpZ31cQ1XLFM0pnm5MCe15JPOf
         MicCY0mMxCZDzaxKu4yAtSgi4lXXMALqmYPUvFvvev/L6Qs0UwQJLn8fIHuNIezI8Y
         WUbePaQrYnMiw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 1/5] os-linux: Cleanup IO priority class and value macros
Date:   Thu, 20 Jul 2023 10:31:10 +0900
Message-ID: <20230720013114.28158-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720013114.28158-1-dlemoal@kernel.org>
References: <20230720013114.28158-1-dlemoal@kernel.org>
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

