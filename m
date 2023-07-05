Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB48EB64DA
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 22:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjGEWNH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjGEWNG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 18:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2F7171E
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 15:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A25C56173D
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 22:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7037FC433C9;
        Wed,  5 Jul 2023 22:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688595185;
        bh=WoRJxTpZVjRwJHPiTcdTZOqDQoBfCAzLJz5AawRBnlg=;
        h=From:To:Cc:Subject:Date:From;
        b=QBk9s1f737YFWodTxPAEyqoaWIwsDUkos9IhJ9OZqJLBqbbcfiBXWCC+d+rNPj/dD
         ddr9L+b58U9lR0ZcGInPTscAFs0EmBkfR/xyCrcE7zohuwa30rYRZ3po9u9Eg2ZOos
         mFA32R9bk3aWiGtmVwyaX8oE63r05lGou/bc2HVphx9mbyHqljwcDxUMBXhYo+nluM
         Vb+7Lqhnfn0bQFHTFrVZY2eWnFC0rK+YC/7NPTkjninemT1cs65WEvHNcHnDlqq++/
         9VhjIiUQPCwlqSkirZSvkCDN9otOopCh4ZqAY4Q6K1aDZFpqgR6iVGpc0n7wph+c6P
         7bBzrWuw+h+qQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 0/4] Add support for IO priority hints
Date:   Thu,  6 Jul 2023 07:12:58 +0900
Message-ID: <20230705221302.430678-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Linux kernel 6.5 will add support for IO priority hints, which can be
used for now to specify a command duration limit for block devices
supporting this feature.

This patch series extends fio IO priority options and adds new options
to allow users to specify IO priority hints.

Damien Le Moal (4):
  os-linux: add initial support for IO priority hints
  options: add priohint option
  cmdprio: Add support for per I/O priority hint
  stats: Add hint information to per priority level stats

 HOWTO.rst          | 31 +++++++++++++++++++++++++++----
 backend.c          |  9 ++++++---
 cconv.c            |  2 ++
 engines/cmdprio.c  |  9 ++++++---
 engines/cmdprio.h  |  1 +
 engines/io_uring.c | 25 +++++++++++++++++++++++--
 engines/libaio.c   | 21 +++++++++++++++++++++
 fio.1              | 28 +++++++++++++++++++++++++---
 options.c          | 31 ++++++++++++++++++++++++++++---
 os/os-dragonfly.h  |  4 ++--
 os/os-linux.h      | 21 +++++++++++++++++----
 os/os.h            |  7 +++++--
 stat.c             | 10 +++++++---
 thread_options.h   |  3 ++-
 14 files changed, 172 insertions(+), 30 deletions(-)

-- 
2.41.0

