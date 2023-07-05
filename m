Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0DDEB64DD
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 17:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGERFP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjGERFO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 13:05:14 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D73171D
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 10:05:13 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-682a5465e9eso262915b3a.1
        for <fio@vger.kernel.org>; Wed, 05 Jul 2023 10:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688576713; x=1691168713;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tjsDJXc7hLCWga0mIBPcl/63w0JmvK7rooxhPByn+zE=;
        b=t6dX3lrRlL9986gcDP16wODJr/tYPDqkK0LbS4uDUyHGieYH5ol1kQwUroSp0WIw0U
         keOCgskul9SIb6VG+BxEUwfLxW/NH+Z4IQjGh2u7tmD5CN2fV2DVkufrB4QSpdavsITX
         DRYoZIg5EbGhuq3awoKXP+VWe9jwQ/8KKJl0XRFWnXVSzgD1OENPiN67hHqsvUzgSNB/
         /uPf54iGzusxR/ah44kneKop9lNmYKSxLYaHIxBq2Q4MXBVAo/qO0Oq/Q7vZrWg5pBnW
         6lTBp6wt82B2Z0Xmo1U/LedBfIqblDRiUHk3xknXpZf38bG8a4IUmaP8aGNfa5fpbz4B
         uxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688576713; x=1691168713;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjsDJXc7hLCWga0mIBPcl/63w0JmvK7rooxhPByn+zE=;
        b=gwkpPQ74amHlBbox54twXz9dojiacUj4LAIFUQkH8nXUiB/izX7dvtoc+wva7ZAjbw
         9AGMvlP+VXWtrP9wh7NGNdul/B8cut5dd00JMJ8pjidO8x3gi3DS2Jvh03C/vKJoqAfU
         bOiRlixm9cGA098kbHb0DFnxdXhnEXIX+UWwwzlr7K4tSlnIQibabYlm8AjCrc0HIXR+
         3RvO9vJWORuQwC570xV06zFILlqI57cF2aznOgwU2i7G3nhHO7ZtzuklPz2SK5X9bo8r
         9PAGfOcQPlIo4dLYrJqYlFGc4r6KYEUvUFkBCcGe1F7mehO/k+N4aBnhG5PX+IEjYg2C
         cM1Q==
X-Gm-Message-State: AC+VfDxbzwkMEMAPkm2ZkUneLuR448zaWr6HuK/y8VnUubyDE1RF9k4p
        Hr6mZKPl5h5M3YMs/zYAnQThXCe6k41IBQNmyyE=
X-Google-Smtp-Source: ACHHUZ6G3LhgKZaXHoKktDsTxBDF1r8CtqEfmtFNMcG0L97zYki9LRLpYYvjDH34e6ue8u7TP83wEA==
X-Received: by 2002:a05:6a21:9989:b0:12c:bbd3:a0dd with SMTP id ve9-20020a056a21998900b0012cbbd3a0ddmr23954066pzb.0.1688576712920;
        Wed, 05 Jul 2023 10:05:12 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i1-20020aa787c1000000b00682b15d509csm1923109pfo.194.2023.07.05.10.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 10:05:12 -0700 (PDT)
Message-ID: <ec7824a9-8d71-e1a8-eb87-23d9b5e9e235@kernel.dk>
Date:   Wed, 5 Jul 2023 11:05:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Fio on Block size 128M
Content-Language: en-US
To:     Nick dan <nickdan2999@gmail.com>, fio@vger.kernel.org
References: <CAE6FHhHS5f5cs8SzfTfkaLRy=A7QS_q3QX2Tb3g3XDTaSXbE6Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAE6FHhHS5f5cs8SzfTfkaLRy=A7QS_q3QX2Tb3g3XDTaSXbE6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/4/23 11:25?PM, Nick dan wrote:
> Hi
> 
> I have a NVMe disk, SATA SSD and SATA HDD.
> I have mkfs.ext4 on all the disks. And mounted the file system on /mnt.
> I want the block size to be set as 128MB and file size 10GB
> 
> What is the correct way to benchmark ? As it is taking a lot of time
> and the values of Throughput are not correct. What should be taken
> into consideration? Can you send the fio  command?

What are you trying to do, specifically? A block size of 128MB should of
course work, but it's somewhat nonsensical as no applications would do
that, and on the device side, it'd be chopped into much smaller pieces
anyway. That means one fio read or write of 128MB would turn into
potentially many hundreds of device requests.

For any fio question or bug report, please include what you are seeing
and what you would expect. Just saying "it's taking a lot of time and
throughput is not correct" is not super useful, be more detailed and
specific. And as also stated in the REPORTING-BUGS file, include what
version you are running, the job file being used, etc. That would make
for a complete bug report.

-- 
Jens Axboe

