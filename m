Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF92DC4332F
	for <fio@archiver.kernel.org>; Thu, 17 Nov 2022 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiKQWGd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbiKQWGL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Nov 2022 17:06:11 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF5D19285
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=A5lXXhB7dOmb3ANFv0vM1nT/jPrkFRvqzGX7wsoDULw=; b=JkupmGInha+wykWlFsRCIW998o
        WXbGLSrnfHyedApo6VK74qDu7sV2Ax101KdyeTymzZqJPgwyIBvHksD7m7hrYDCKDiKsoi8AOwjzn
        irlk+smblkuc7wmDfmzQVkE6pFiOr+7GHbMLoeNt4T1IlVp0aiWuZ16tP/5tBW5WFI8r1C1aP6IZD
        gxT5/nPrEO0TN5Cj2Pi8D5UWo22yCs5zx3mmr1t8sl/XIBwUnDoLXNYcr9wvgynPvSTWUREtoGbz8
        ftYZ5kPlflmX+F0WiNYG8ihOvEcujk5DZqxzoTIr65J07mUkBJ0/C+6r9ZdGef0TBh9FBv6qmcpaf
        BFsqm6Kg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-004pD9-If; Thu, 17 Nov 2022 15:05:29 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0h-000Ljf-Pz; Thu, 17 Nov 2022 15:05:27 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 17 Nov 2022 15:05:18 -0700
Message-Id: <20221117220523.83501-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v2 0/5] Support large pattern buffers
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,

This is v2 of this patchset which includes changes for the feedback
thus far.

When testing storage platforms that have integrated compression it is
useful to use specifically compressible real world data. The existing
buffer_compress_percentage option doesn't work well for testing the
performance of the compression algorithm portion of the stack seeing it
results in random data (which can slow down many compression algorithms)
followed by trivially compressible data (which can often be compressed
at a higher performance than real world data).

Instead of the crude compressibility approximation when using
buffer_compress_percentage, it would be useful to specify specific test
data for benchmarking purposes. Using real world data or well-known
test data like the Calgary Corpus would help to make the benchmarks
closer to real world applications.

The existing buffer_pattern option would almost work for this, except it
is limited to a maximum length of 512B and will be repeated in the
IO buffer and thus can't be used for any arbitrary compression
size seeing repeated data is easily compressed.

This patch set proposes allowing much larger buffer patterns,
that may be loaded from a file. The first patch provides the
infrastructure for passing arbitrary sized buffers in the client/server
protocol (which means the server version number must be bumped), the
second patch adds a method for pre-calculating the buffer size
in parse_and_fill_pattern(), the third patch supports properly
reading large files and the final patch enables dynamic allocation of the
buffers themselves.

The buffer_pattern will still be truncated to the block size of
the IO and repeated for every IO, but this should still be acceptable
for testing compression in storage which tends to operate on
fixed size chunks anyway.

An arbitrary limit on the pattern buffer of 128MB is still enforced to
avoid issues that would crop up with the maximum limit of the
client/server commands (FIO_SERVER_MAX_CMD_MB). This should be more than
enough seeing it isn't useful to specify a buffer greater than the block
size and blocksizes that large are not very practical.

Thanks,

Logan

--

Changes since v1:
  - Added comment on the patterns member of struct thread_options_pack,
    per Vincent
  - Added a test in the suite to test a 16KB buffer and verify pattern

--

Logan Gunthorpe (5):
  cconv: Support pattern buffers of arbitrary size
  lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
  lib/pattern: Support short repeated read calls when loading from file
  options: Support arbitrarily long pattern buffers
  test: add large pattern test

 cconv.c            | 86 ++++++++++++++++++++++++++++++-----------
 client.c           | 17 +++++---
 gclient.c          | 12 ++++--
 lib/pattern.c      | 96 ++++++++++++++++++++++++++++++++++++++--------
 lib/pattern.h      | 21 +++++++---
 options.c          | 10 ++---
 server.c           | 23 ++++++-----
 server.h           |  2 +-
 stat.h             |  1 -
 t/jobs/t0027.fio   | 14 +++++++
 t/run-fio-tests.py | 29 ++++++++++++++
 thread_options.h   | 15 +++++---
 12 files changed, 253 insertions(+), 73 deletions(-)
 create mode 100644 t/jobs/t0027.fio


base-commit: 07c8fe21021681f86fbfd3c3d63b88a5ebd4e557
--
2.30.2
