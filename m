Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B897C001B0
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 01:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjGTBbS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTBbS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 21:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C982106
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 18:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F0A6187A
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 01:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8216C433C8;
        Thu, 20 Jul 2023 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689816676;
        bh=6MHFzglwDf0RneDZzFPLmDoTbL4SE1VIB2x4xOLGfXY=;
        h=From:To:Cc:Subject:Date:From;
        b=RQB9ZUClQNnUpsuXHMBVY5dnhwB+29T21C+jGBVq5bvKdoJ8GB/ShkaAswk9NBo8n
         fkUOXSWFgdGldIlCsyTBUkpQLqtnV9q3zoEnLYa+CI+vRYCHk3/8ZvG8OeqnP6Qx+O
         l2csIeKKvTkfNlZ7RzuadIKsz8LxmNqdQgYAfg0nXQbNUHTavSCtBh2QW6kVE0voqk
         GERUjp/cCo/SAg0kMDtPyM2ur5CXRp38lXI3QVzqPmCBdDWeLjoLEjXPT5U6h5BgzL
         5LNotXC1fVIpcPBOgFQI5nvpIHV3p3L84fnVqHA6AJVa9yKW7oLygZjD5D51b/joJO
         0wm/OK1Va8J7g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 0/5] Add support for I/O priority hints
Date:   Thu, 20 Jul 2023 10:31:09 +0900
Message-ID: <20230720013114.28158-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Linux kernel 6.5 will add support for I/O priority hints, which can be
used (for now) to specify a command duration limit for block devices
supporting this feature.

This patch series extends fio I/O priority options and adds new options
to allow users to specify I/O priority hints.

Changes from v1:
 - Added patch 1
 - Addressed Niklas comments

Damien Le Moal (5):
  os-linux: Cleanup IO priority class and value macros
  os-linux: add initial support for IO priority hints
  options: add priohint option
  cmdprio: Add support for per I/O priority hint
  stats: Add hint information to per priority level stats

 HOWTO.rst          | 32 ++++++++++++++++++++++++++++----
 backend.c          |  9 ++++++---
 cconv.c            |  2 ++
 engines/cmdprio.c  |  9 ++++++---
 engines/cmdprio.h  |  1 +
 engines/io_uring.c | 25 +++++++++++++++++++++++--
 engines/libaio.c   | 21 +++++++++++++++++++++
 fio.1              | 30 +++++++++++++++++++++++++++---
 options.c          | 31 ++++++++++++++++++++++++++++---
 os/os-dragonfly.h  |  4 ++--
 os/os-linux.h      | 27 +++++++++++++++++++--------
 os/os.h            |  7 +++++--
 server.h           |  2 +-
 stat.c             | 10 +++++++---
 thread_options.h   |  3 ++-
 15 files changed, 178 insertions(+), 35 deletions(-)

-- 
2.41.0

