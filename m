Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BE8C4332F
	for <fio@archiver.kernel.org>; Tue, 15 Nov 2022 20:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiKOU5f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbiKOU50 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Nov 2022 15:57:26 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A00201B1
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 12:57:24 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o8so10609347qvw.5
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 12:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1WSxhoV6TPdRf7uLKxiQT8xNIfhyt7YlsWGkLbJ/tow=;
        b=cDk45Rx002KMdwVLbu14BrH443V7xsrDLzTuUke0efPOnCtSt+ULKj/K9yqQuoNOid
         TiMdZeilpeUIX5ouZCvAhORJozImcgRwm346cuKTftuo6h99VgJyC5df60vK0EKbqhiK
         thLzbCWBScqJRQn+Yxcv8rQYVJKtGnf6P1xd8HYuTQs++5H5cjX3BnQksHw2LtqoErfK
         cw0qO16YpgU/Zv/azO6CqRtLsATm+YUiREtob3/4r9mgo0i2KE8L1PaWOafF0ZEPHehZ
         bMoU3327Kn6aV0b+cl9I8OEYBauyS7qZBtFHCJhoOU0ZAmM7eM0Hm4yEWDlEmH8RXTgL
         3zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WSxhoV6TPdRf7uLKxiQT8xNIfhyt7YlsWGkLbJ/tow=;
        b=B2vq8ufgDMdufWb8T+VuweF43dDLmd0RFMcozy8oTualnscilTHFxM0X/OhajVOoBt
         VIz39VFQ6VORUcofzxorp4MuK1C+ptarn6cTTedXafivFbjgzFFLJAmqX3DuPsShtCIx
         Eka7y4f3WYY4VQIMPfGRckMsptEGKZGZaMc6n2bQ5TPV0rilvjAKgPzY/qqGxfkQgqkj
         ZdxNbip/8Uqg3cg73XdmWPwuX5VVKVEyp/wGdVX80J1kCjbBW+DdV2QbRiUE9PCCY5z3
         EzAiKGhLsByB26Uai6YWy9w+0yX4/3zkaUxr02GN02Nq7f5tzIdO7GtH//vEffaLj/Hw
         aj8g==
X-Gm-Message-State: ANoB5pn26OPF4GL0RlgvkErzIgCpEVlV/NYCFj4KYSuq+XZjNzRihirM
        AQCn8yb0z5P6kQLtM6nUYm0=
X-Google-Smtp-Source: AA0mqf50Ammr/ogEZAWYIYoXiTr5472hzH4PXMzUzWUk1GU09HjouK2RgvcAIxUeoAHO4K4wH7K7tA==
X-Received: by 2002:a05:6214:3c9a:b0:4bb:5931:f949 with SMTP id ok26-20020a0562143c9a00b004bb5931f949mr18689783qvb.66.1668545843690;
        Tue, 15 Nov 2022 12:57:23 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id x13-20020a05620a258d00b006bb82221013sm8925170qko.0.2022.11.15.12.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 12:57:22 -0800 (PST)
Message-ID: <b7f2106f-9427-25df-9aa3-ff9dd6958996@gmail.com>
Date:   Tue, 15 Nov 2022 15:57:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/4] Support large pattern buffers
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>
References: <20221026194019.32776-1-logang@deltatee.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221026194019.32776-1-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/26/22 15:40, Logan Gunthorpe wrote:
> Hello,
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
> Logan Gunthorpe (4):
>    cconv: Support pattern buffers of arbitrary size
>    lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
>    lib/pattern: Support short repeated read calls when loading from file
>    options: Support arbitrarily long pattern buffers
> 
>   cconv.c          | 86 +++++++++++++++++++++++++++++++------------
>   client.c         | 17 ++++++---
>   gclient.c        | 12 ++++--
>   lib/pattern.c    | 96 ++++++++++++++++++++++++++++++++++++++++--------
>   lib/pattern.h    | 21 ++++++++---
>   options.c        | 10 ++---
>   server.c         | 23 +++++++-----
>   server.h         |  2 +-
>   stat.h           |  1 -
>   thread_options.h | 12 +++---
>   10 files changed, 207 insertions(+), 73 deletions(-)
> 
> 
> base-commit: c4704c081a54160621227b42238f6e439c28fba3
> --
> 2.30.2

I've looked through the patches, done some testing and see no problems 
apart from the small changes already mentioned.

It would be nice to have an addition to our test suite that covers this 
functionality.

Vincent
