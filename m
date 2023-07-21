Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2581EB64DD
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjGULI4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjGULIT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9F26B5
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7A060B9B
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 11:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C57C433CA;
        Fri, 21 Jul 2023 11:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937511;
        bh=9u05mR41aeOube9/m8pAw8kqoFvGGTuXscBX8xJYcjs=;
        h=From:To:Cc:Subject:Date:From;
        b=iB93fjyjRPVj8PdDWlXKTK5kn00rYun/iYuI4N0qMptaxnNPd3XtF3mn1i5WAIvyY
         35XWGFXyZbqBJl+wBfrZ7X2lrWC1PVPN6ZcKc+NS/wQVL6TKORUh9Xvgq3qSXfJo5j
         vMzYv9poaAmLlX/e9A5SQCri/7uAnKSKWTu2aOpnQ6QNIyUB9h1aY0RU11Q/JEaKAX
         jo3iJ9HdjwKcZ3QsMCuF+HNtUcjVL63xPs/gXZShqcsD6+t9wXNbvP79I1FaORnfdG
         XpXedSGAWqQyHNf+6BPSuDxgzfgqymWA8uo6CyJW3w/4lLXmrv5OwBFBrXnRpcnmOF
         4EilTjU/f2Agw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 0/6] Add support for I/O priority hints
Date:   Fri, 21 Jul 2023 20:05:04 +0900
Message-ID: <20230721110510.44772-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Linux kernel 6.5 adds support for I/O priority hints, which can be
used (for now) to specify command duration limits for block devices
supporting this feature.

This patch series extends fio I/O priority options and adds new options
to allow users to specify I/O priority hints.

Changes from v2:
 - Added patch 2 to generically define the cmdprio_xxx options. This
   dwisimplifies tidies up patch 5.
 - Added Niklas review tag to patch 1

Changes from v1:
 - Added patch 1
 - Addressed Niklas comments

Damien Le Moal (6):
  os-linux: Cleanup IO priority class and value macros
  cmdprio: Introduce generic option definitions
  os-linux: add initial support for IO priority hints
  options: add priohint option
  cmdprio: Add support for per I/O priority hint
  stats: Add hint information to per priority level stats

 HOWTO.rst          |  37 ++++++++++++++--
 backend.c          |   9 ++--
 cconv.c            |   2 +
 engines/cmdprio.c  |   9 ++--
 engines/cmdprio.h  | 106 +++++++++++++++++++++++++++++++++++++++++++++
 engines/io_uring.c |  86 ++----------------------------------
 engines/libaio.c   |  82 +----------------------------------
 fio.1              |  33 ++++++++++++--
 options.c          |  31 +++++++++++--
 os/os-dragonfly.h  |   4 +-
 os/os-linux.h      |  27 ++++++++----
 os/os.h            |   7 ++-
 server.h           |   2 +-
 stat.c             |  10 +++--
 thread_options.h   |   3 +-
 15 files changed, 251 insertions(+), 197 deletions(-)

-- 
2.41.0

