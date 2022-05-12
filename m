Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFA2C433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 16:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356115AbiELQoV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 12:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356630AbiELQoU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 12:44:20 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C5D2685EA
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:44:14 -0700 (PDT)
Received: from integral2.. (unknown [180.242.99.67])
        by gnuweeb.org (Postfix) with ESMTPSA id 45BC37F628;
        Thu, 12 May 2022 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1652373854;
        bh=/DpMa6UBJRmco2wHRVP9d6IrPNuhCb2KIiYQZ/1NqwA=;
        h=From:To:Cc:Subject:Date:From;
        b=P7Ht+aiUKnHT7o/sPIHq/0llagh4442pnlDUfrK76RAtcq65Mt2tq/WZPoRekDDSA
         eiZj84pbyySp7VWyMJZIK/7lSofDLyFrwEp6Od08XTs564UFC3YM9i5fwK2cpkC52X
         T+SYeTtnD19KVLvJ/ryMpAPdcZkG2GJ5g758VcrsU6n8jcIqbeJYxbqO6u1hs+hysR
         O0wRladzcN1DwWBAjIqAtUkxHZA2/RrJlYBc1Z40+kWI9JP34Ln6kiItrRQ+G44GzC
         fBHJsRTWN6e9pnsoaCW6ZJs290CMsjrp+z87ong/7jiHRXMZM+n0J6FA+fPfQZUMI0
         8CzrQLzHTWEqA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 0/3] Cleanups and Fixes
Date:   Thu, 12 May 2022 23:43:30 +0700
Message-Id: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Jens,

This is the v4 series of small fio cleanups and fixes. I dropped
the patches about ENOMEM handling this time. The most noticable
change is patch #3 (fix clang warning). The rest is just small
optimization and indentation clean up.

v4:
  - Append Reviewed-by tags from Niklas Cassel.
  - Rebase the series.

Link v3: https://lore.kernel.org/fio/20220428203954.222165-1-ammarfaizi2@gnuweeb.org/

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
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


base-commit: d338e8760f3f442b3e4498598854130e55745eb9
-- 
Ammar Faizi

