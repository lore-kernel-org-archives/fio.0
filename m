Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D96C433F5
	for <fio@archiver.kernel.org>; Thu, 28 Apr 2022 20:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiD1Unb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiD1Una (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 16:43:30 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7932DF4D
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 13:40:13 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id CDC577E39D;
        Thu, 28 Apr 2022 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651178412;
        bh=cEqMopcX935KX6Vuzu/QJdW9puBQhPF5sIduRNzLNAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=I+w0MnTgE2c6t7Gjk1WQzzzmYRbXUj5B9IWRmI0Ue7XT0PHTiCB1wdzdP6i0IFF+8
         iQKeYX6BrCnkWFDN6Rrm70zFu6ebowdNY5hDd0/JqiriEpmKd0N9v4ABDFFgAyjhdo
         EvtFbDy/MNIvFrzMWLj9rf60Sy6oUCM1s2UJ2+gloQR9/3R7ii8nRU0RPFzc6wtXQM
         3rWH25zXG4i2cNBauNxhHov1jEtcqbRvXj1NWbDlA1bKsmOzQjE9aS7e/H1JTuCXny
         Zx9S7U/lm7Ps/LFG3VCdSD7DMpbeAxK0zqu5YP/71AllMKJxOcjqZHJSO6A1n+Dw5p
         JWyscuBAKEcqg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v3 0/3] Small fio cleanups and fixes
Date:   Fri, 29 Apr 2022 03:39:51 +0700
Message-Id: <20220428203954.222165-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This is the v3 series of small fio cleanups and fixes. I dropped
the patches about ENOMEM handling this time. I will resend those
in a different series later because I think we have many places
to fix them, so I will dedicate more time to it.

There are 3 patches in this series:

1. Trivial indentation fix.
2. Small optimization for the JSON code.
3. Fix `-Wimplicit-fallthrough` warning when compiling with clang-15.

Please review, thanks!

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (3):
  backend: Fix indentation
  json: Change `if (!strlen(str))` to `if (!str[0])`
  Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`

 Makefile  | 6 +++++-
 backend.c | 2 +-
 json.c    | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)


base-commit: 5f2d43188c2d65674aaba6280e2a87107e5d7099
-- 
Ammar Faizi

