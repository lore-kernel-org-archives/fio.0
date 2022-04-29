Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7261EC433EF
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 00:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiD2Aui (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 28 Apr 2022 20:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiD2Aui (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Apr 2022 20:50:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AB8888D2
        for <fio@vger.kernel.org>; Thu, 28 Apr 2022 17:47:20 -0700 (PDT)
Received: from integral2.. (unknown [180.246.147.8])
        by gnuweeb.org (Postfix) with ESMTPSA id A68937E7A8;
        Fri, 29 Apr 2022 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651193239;
        bh=D9ymXP+b2MKbzMk+C4kMMtz21w7XuQDUz64qNbq9Vas=;
        h=From:To:Cc:Subject:Date:From;
        b=XL+l04nKlJV9EbmviGtahq5F3YqyXDpYMojkBsvLqGw9Hz3DAVbPGUsw1Yx0O3uLq
         7poU0nnGdPefbHVo9KDV7O1VVu9s5lKR+8zRi9lykSBNW9KUDfIrkHCPpGzY2rLcw4
         hAU3SNiJVWirsO5iLOYwMPM06BWq17AVWGPfg/wfyG4zrc1uM7kcxhC8cS4gsNz3vQ
         ZmOGiboNPSY9qwVqk10OFE8bHN/fDJsKiDO7AQj4ul5day4bAjhtB6e5xBwg+flUwk
         4KnF8TUgxgi1nOL3YUEw3mrLTb0By2I0Z2FQwGS8Fd2MRtU2St62U41gqntudWKfVu
         U6Zzu0EfYo8dA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH v1 0/8] fio error handling fixes
Date:   Fri, 29 Apr 2022 07:46:57 +0700
Message-Id: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This series contains patches that were dropped from my previous thread:

  https://lore.kernel.org/fio/20220428203954.222165-1-ammarfaizi2@gnuweeb.org

Plus, I have more patches in this series. This series contains error
handling fixes, mostly about ENOMEM. There are 8 patches in this
series. All of them are ENOMEM handling stuff except that patch #4 has
extra fixes and a bit of refactoring.

Please review, thanks!

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (8):
  cgroup: Add ENOMEM handling on a `malloc()` call
  stat: Add ENOMEM handling on `malloc()` / `calloc()` calls
  engines/net: Add ENOMEM handling on a `malloc()` call
  blktrace: Fix broken error handling in `merge_blktrace_iologs()`
  blktrace: Add ENOMEM handling when allocating @ipo
  blktrace: Add ENOMEM handling in `trace_add_open_close_event()` and its callers
  client: Add ENOMEM handling on `realloc()` calls
  client: Add ENOMEM handling on `malloc()`, `calloc()` and `strdup()` calls

 blktrace.c    | 116 +++++++++++++++++++++++++++++++-------------
 cgroup.c      |   4 ++
 client.c      | 131 +++++++++++++++++++++++++++++++++++++++++---------
 engines/net.c |   9 ++--
 stat.c        |  40 +++++++++++----
 5 files changed, 231 insertions(+), 69 deletions(-)


base-commit: 5f2d43188c2d65674aaba6280e2a87107e5d7099
-- 
Ammar Faizi

