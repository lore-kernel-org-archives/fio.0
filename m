Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAF6C38A2D
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiJZTk2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiJZTk1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:40:27 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B173A16D
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=CfwGejSGoUZWSYHIr2wr/gOgYiYEj+dc/oP6LzXbz4k=; b=Uv0T0YHM7RLc4ofk5LtF0TVpez
        F+Qt/6L23cdvUL7GRS5n47h4hIyYwYkuBS7EeZo6T8oOBIhpykjglZl0PiE0RKZd28Br8dp1/EO/U
        CQzoDolU5UIIIUdtsBNbp+pP3suAr7+79RxD3Af3WRkUVwiYEYWAYWoeLRcHjjqPHiCXXdxpoM485
        /HPqshfBoWsFiTv9urZvFuA/zZe/hIIn6pXc0lEgXIY3IJHi7n0YVQ0722USGbingxJAVX4iDEn9h
        /28xDF7aTYeBlaeB+Oi3Wg1nxZ5Ix80CiBwQak0yLBPqnYHfmtX1go8gTkU33cDHy9d4Z8OrdM9OW
        WmExqKiQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmGG-000HiI-H5; Wed, 26 Oct 2022 13:40:25 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmGF-0008XV-TM; Wed, 26 Oct 2022 13:40:23 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 26 Oct 2022 13:40:15 -0600
Message-Id: <20221026194019.32776-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH 0/4] Support large pattern buffers
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,

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

Logan Gunthorpe (4):
  cconv: Support pattern buffers of arbitrary size
  lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
  lib/pattern: Support short repeated read calls when loading from file
  options: Support arbitrarily long pattern buffers

 cconv.c          | 86 +++++++++++++++++++++++++++++++------------
 client.c         | 17 ++++++---
 gclient.c        | 12 ++++--
 lib/pattern.c    | 96 ++++++++++++++++++++++++++++++++++++++++--------
 lib/pattern.h    | 21 ++++++++---
 options.c        | 10 ++---
 server.c         | 23 +++++++-----
 server.h         |  2 +-
 stat.h           |  1 -
 thread_options.h | 12 +++---
 10 files changed, 207 insertions(+), 73 deletions(-)


base-commit: c4704c081a54160621227b42238f6e439c28fba3
--
2.30.2
