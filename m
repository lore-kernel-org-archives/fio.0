Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75355C433FE
	for <fio@archiver.kernel.org>; Sat, 19 Nov 2022 01:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiKSBdY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 20:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiKSBcz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 20:32:55 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED5E1181F7
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 16:37:40 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id e15so4236872qts.1
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 16:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7zEGOiOfCA9H0v3dvse30711xA7WOMplxkcW8qBI6s=;
        b=Vo0N0hCwwVv03gPqjA8HEMIjARBtgD30Xg23NmQFOHs1w02vUTKVEloiF2fyo5t40o
         V64j4hVB3Rx57yWHhgMZZBSqoL8/viAX/QqlkuLAcIyliVj+NjjKrQ6A+okgsOSBOriQ
         NqUVETK7ksP9afQ48hYYaNDCRg6m9cgQ7AxgH/Xt0qILOVW38YA2xXORi/wqnt13h5ZC
         3mT80M8bk/xEC+l5XjT26+e26OnAmIgY0tUTQc/GZR/QW0WgeqyFuYDVbF9LxdYtjpFL
         kHkPg441RcVNjeIcaT8rMgoq0gR3J31YSFGdKwXZ7Ls3twVu6m5qXUch8vlUfgJ0PC6V
         sxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7zEGOiOfCA9H0v3dvse30711xA7WOMplxkcW8qBI6s=;
        b=0Iih22FQKN5tOb/+NXwH7K0AoA8cNxOKq/WYuTHMcKihXAbstczp9Ze6Vbl4l3miUL
         tng0UneQE5eCbaXEYoNMYH9+iawZp+ZgMWCMr8YIuWtsmJIa8kD/+vbUd+3RXTbDgRtK
         wIWNLxeW3nfWPjjuhdYV9tuVWYyHZms8F19ckbWkKDJkminv20Pp7Q/upaMBDLc3t4Ry
         X4wdigjhMprr5+4WQYL8OILeu0WEeEgBit4MkFdAXgXUXlY1WCTFMRBfBqW/fPTA5V8e
         Vh/G5EwYfcSeuaEwKvNhIa89kH/VNPDu7z2OIz3aSdNLbOPDcIW5R9R5U9ao6Ko8n9wz
         L/Fw==
X-Gm-Message-State: ANoB5pnbk07VsDVe9PW410duQY+bsdH7o86f2GfeZp0kLU5MNiGSP3wA
        h77lz2LGZIZiyl5/vQMdubza1g61UzdL9w==
X-Google-Smtp-Source: AA0mqf4VJ5xZQIhqVMvw/fcvEEk7YoR/89EGBqgsxD2oLprPgK3a7koynwkb39Ard46OmLS5ZSZyTg==
X-Received: by 2002:a05:622a:4010:b0:3a5:dee6:3f9 with SMTP id cf16-20020a05622a401000b003a5dee603f9mr8982956qtb.672.1668818259637;
        Fri, 18 Nov 2022 16:37:39 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a29d500b006ed30a8fb21sm3481550qkp.76.2022.11.18.16.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 16:37:38 -0800 (PST)
Message-ID: <be09cbfb-5cfc-acee-66c7-015d16971421@gmail.com>
Date:   Fri, 18 Nov 2022 19:37:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 0/6] Support large pattern buffers
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221118231601.85837-1-logang@deltatee.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221118231601.85837-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/18/22 18:15, Logan Gunthorpe wrote:
> Hello,
> 
> This is v3 of this patchset which includes changes for the feedback
> thus far.
> 
> When testing storage platforms that have integrated compression it is
> useful to use specifically compressible real world data. The existing
> buffer_compress_percentage option doesn't work well for testing the
> performance of the compression algorithm portion of the stack seeing it
> results in random data (which can slow down many compression algorithms)
> followed by trivially compressible data (which can often be compressed
> at a higher performance than real world data).
> 
> Instead of the crude compressibility approximation when using
> buffer_compress_percentage, it would be useful to specify specific test
> data for benchmarking purposes. Using real world data or well-known
> test data like the Calgary Corpus would help to make the benchmarks
> closer to real world applications.
> 
> The existing buffer_pattern option would almost work for this, except it
> is limited to a maximum length of 512B and will be repeated in the
> IO buffer and thus can't be used for any arbitrary compression
> size seeing repeated data is easily compressed.
> 
> This patch set proposes allowing much larger buffer patterns,
> that may be loaded from a file. The first patch provides the
> infrastructure for passing arbitrary sized buffers in the client/server
> protocol (which means the server version number must be bumped), the
> second patch adds a method for pre-calculating the buffer size
> in parse_and_fill_pattern(), the third patch supports properly
> reading large files and the final patch enables dynamic allocation of the
> buffers themselves.
> 
> The buffer_pattern will still be truncated to the block size of
> the IO and repeated for every IO, but this should still be acceptable
> for testing compression in storage which tends to operate on
> fixed size chunks anyway.
> 
> An arbitrary limit on the pattern buffer of 128MB is still enforced to
> avoid issues that would crop up with the maximum limit of the
> client/server commands (FIO_SERVER_MAX_CMD_MB). This should be more than
> enough seeing it isn't useful to specify a buffer greater than the block
> size and blocksizes that large are not very practical.
> 
> Thanks,
> 
> Logan
> 
> --
> 
> Changes since v2:
>    - Fix missing signed off by on patch
>    - Add a patch to properly support binary patterns on windows
>      per Vincent and the CI run of the new test
> 
> Changes since v1:
>    - Added comment on the patterns member of struct thread_options_pack,
>      per Vincent
>    - Added a test in the suite to test a 16KB buffer and verify pattern
> 
> --
> 
> Logan Gunthorpe (6):
>    cconv: Support pattern buffers of arbitrary size
>    lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
>    lib/pattern: Support short repeated read calls when loading from file
>    options: Support arbitrarily long pattern buffers
>    lib/pattern: Support binary pattern buffers on windows
>    test: add large pattern test
> 
>   cconv.c            |  86 +++++++++++++++++++++++++++-----------
>   client.c           |  17 +++++---
>   gclient.c          |  12 ++++--
>   lib/pattern.c      | 100 +++++++++++++++++++++++++++++++++++++--------
>   lib/pattern.h      |  21 +++++++---
>   options.c          |  10 ++---
>   server.c           |  23 +++++++----
>   server.h           |   2 +-
>   stat.h             |   1 -
>   t/jobs/t0027.fio   |  14 +++++++
>   t/run-fio-tests.py |  29 +++++++++++++
>   thread_options.h   |  15 ++++---
>   12 files changed, 257 insertions(+), 73 deletions(-)
>   create mode 100644 t/jobs/t0027.fio
> 
> 
> base-commit: 07c8fe21021681f86fbfd3c3d63b88a5ebd4e557
> --
> 2.30.2

Applied. Thanks.
