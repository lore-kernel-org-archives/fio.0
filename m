Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61977C67871
	for <fio@archiver.kernel.org>; Mon, 24 Oct 2022 20:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiJXUHU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 24 Oct 2022 16:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiJXUGf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Oct 2022 16:06:35 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08B0696FD
        for <fio@vger.kernel.org>; Mon, 24 Oct 2022 11:26:49 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id f22so6127054qto.3
        for <fio@vger.kernel.org>; Mon, 24 Oct 2022 11:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1hWdDZLFME3sg02o5CZdu8FCBe0UQ/dIjRQ+05STb64=;
        b=IhH7lxO5s/qJzMkktkkjlR6dTTJgt7na2wY5Op7IqHPzu/03qzCXNSr2A5F9EkhCU7
         itrJY3iAEsdIaJdyPMZRaZ6Vf+eN/GcyCcV5+DYzZhRN8gI+Nl5rd9O/CYGBTbwlAyDV
         qY7EAinctvDyYYoiG2SvsP+tvem/9KhfZU6pbdScRWqwHUgU6g65xbh5dbEOc9B44NTs
         20VB9SYViX5eYG6jSnmx3d9/FcFAyDeZ0f//VGH2JS8/9wzlLVeywZiTRH4GsMWv7bHm
         jWbbW250wIEvMv7dthcv9Wj9wYRHSsbkOqePyyW3zjhaKVhNrVH6QDWOnKyik6ffavq5
         xezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hWdDZLFME3sg02o5CZdu8FCBe0UQ/dIjRQ+05STb64=;
        b=Qz0cyuI/4TOOgxiTdIWTqD0mBinkfjGqXZFuJPIf2WRCXSxCjnbQ40KRgc1ZLE7Yhd
         86kSlgP6JKOMkPjokcKMxHjDG0rSs+mFrpp/j0XiDJ2qE5DXPMdT85E+irolKvEfe6mv
         yIOWHcXAcD28JdBhzhixh5HnbrbcL4xjlgaQO0IE9SixcwFgXGIxYmNxhncLTyyDblz6
         rx3eLXsk8S1f2CR8JwpYKpFiVECZMbhuOrtOG+SdmtyYOsraNiX6NFwBiQAH7dQkBorO
         fPYJ5rEMa7YzeznWvCMLwelxRj9bO6+hUXylVdIiQbIuaf9oI14W0aVem8yvoefIQzjD
         /x0g==
X-Gm-Message-State: ACrzQf17vQUmuIKpp8gVNfiaipbgahOSOEJZnqTKV2UabCotmpTYDSku
        62dGXIuq8iPAOwm+8QS7UuX3sL8h2YM=
X-Google-Smtp-Source: AMsMyM4M6uOjwzvMVvl/zO7xXy1jFc351u07IM5IwlHI6E9zwAAcL9zDjyfPic6xpE75RnHFF+DOYA==
X-Received: by 2002:ac8:6f09:0:b0:39c:d3ab:eb84 with SMTP id bs9-20020ac86f09000000b0039cd3abeb84mr28804317qtb.267.1666635979099;
        Mon, 24 Oct 2022 11:26:19 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bj7-20020a05620a190700b006bb87c4833asm367080qkb.109.2022.10.24.11.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 11:26:18 -0700 (PDT)
Message-ID: <1301e1a3-e793-7ad3-e0ad-bd3a141d1678@gmail.com>
Date:   Mon, 24 Oct 2022 14:26:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 0/4] fix experimental verify
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/20/22 02:38, Shin'ichiro Kawasaki wrote:
> Recently I noticed that verify workload with --experimental_verify option does
> not read back verify data. I confirmed it with simple job below:
> 
>    [job]
>    filename=t0025file
>    size=128k
>    readwrite=write
>    do_verify=1
>    verify=md5
>    experimental_verify=1
> 
> Fio reported as follows. No read for verify data.
> 
>    Run status group 0 (all jobs):
>       READ: bw=0B/s (0B/s), 0B/s-0B/s (0B/s-0B/s), io=0B (0B), run=1-1msec
>       WRITE: bw=41.7MiB/s (43.7MB/s), 41.7MiB/s-41.7MiB/s (43.7MB/s-43.7MB/s)...
> 
> The debug log trace with --debug=io,verify option showed no verify data read
> either. It indicates that experimental verify is not working as expected.
> 
> This series addresses two issues to make experimental verify work again. Also
> add two test cases to confirm the issue fixes.
> 
> Of note is that this series makes test case #54 of t/zbd/test-zbd-support fail.
> I'm preparing another series to address it as well as other verify issues
> related to zonemode=zbd.
> 
> Changes from v1:
> * Reflected comments on the list to patch 3 and 4
> 
> Shin'ichiro Kawasaki (4):
>    verify: fix bytes_done accounting of experimental verify
>    verify: fix numberio accounting of experimental verify
>    test: add test for verify read back of experimental verify
>    test: add test for experimental verify with loops and time_based
>      options
> 
>   backend.c          |  8 ++++++--
>   fio.h              |  2 ++
>   io_u.c             | 23 +++++++++++++++++------
>   libfio.c           |  1 +
>   rate-submit.c      |  2 ++
>   t/jobs/t0025.fio   |  8 ++++++++
>   t/jobs/t0026.fio   | 20 ++++++++++++++++++++
>   t/run-fio-tests.py | 31 +++++++++++++++++++++++++++++++
>   verify.c           |  2 --
>   9 files changed, 87 insertions(+), 10 deletions(-)
>   create mode 100644 t/jobs/t0025.fio
>   create mode 100644 t/jobs/t0026.fio
> 

Applied. Thanks.

Vincent
