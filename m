Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5685BC433F5
	for <fio@archiver.kernel.org>; Wed, 11 May 2022 19:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243957AbiEKTTQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 May 2022 15:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiEKTTM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 May 2022 15:19:12 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81805AA40
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:19:10 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l15so2105632ilh.3
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0CtJiekOsOz/eTE0FK5YVN26sd6FNqOwmO8EiP6fXs4=;
        b=5od46JpIDMzHHin8bpZCrAi8QtBqMOprb/tNQ8ycOE+BKjK4z3EWUUiB8IzCVuqzP/
         s8WPQ2gGycUAxj5EiAFlcVLU//Haq98P6T37LV/AlBmF3CL7YzKGgmM5ZQIKRqgkz1bx
         kcF1ApI3RQBc6GsaX1TY7hAi4RnnTBJpv+cFaKxSAR1WvpLqCEbmLxnW+pFu3URvG1xh
         dglOcYWg9SAo0mvHYrfrp9f3XnLZ67ddQ6Im0iQAwSDAKKQYUWfa9lepvD3oLLp5xJsc
         6hXC5JJoWZ/QFbZNuZJxsSYjSCmqclIEcnVW0+/8gfPZ4MG8t4koEucuCduQoFmAI530
         38Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0CtJiekOsOz/eTE0FK5YVN26sd6FNqOwmO8EiP6fXs4=;
        b=gwYzlwTKzu/YV7LRFsIaBMg83g0bUaQvJWbZSIvshitiogJq8NQqXaIDQmAnsxmvrZ
         k9u9Wcbi3UOK/D9evR8JShxtKKIyjrfwVud59bgRAtkrShYljBPOADECotIabptGK7B0
         NelT0XPAUeopdzE4xd0EkTK8RbOZE8TJOed6PH0EE/9EXs3i7VaCmEZZ5QBjqKpMo4pK
         qEszIQUxyFJGqzHVBd0e1jDHVvlam6QFPuH64Kjxho3Zf88/NjBd/k6PNCumpXFUjsG1
         zHRohoX6y0nfbYzE4c1oDFECnnoDNoDxN1P1o8a3N4kUgzvmvrhTcfkQ9aFvv8FUwqzy
         DQFQ==
X-Gm-Message-State: AOAM533l/cqZhOH03jjOiEDOrztTpEEw9W4aGn/wuWwYyhJurvV/Vgdy
        D1+CneYnMNJo8IIV93zw5y7sUA==
X-Google-Smtp-Source: ABdhPJyYOv7t8rz8FLSikYhJy4HkzQde1xb/CpLi3Raniof/Nwb2erczSQFLC4MVAgDtT2Tu4QmZ+A==
X-Received: by 2002:a05:6e02:2190:b0:2cf:8529:e291 with SMTP id j16-20020a056e02219000b002cf8529e291mr12149293ila.22.1652296750299;
        Wed, 11 May 2022 12:19:10 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d8e0d000000b0065a47e16f34sm806268iod.6.2022.05.11.12.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 12:19:09 -0700 (PDT)
Message-ID: <698673c0-0fc4-671c-15da-0fb7a053da41@kernel.dk>
Date:   Wed, 11 May 2022 13:19:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/3] fio: add xnvme engine
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com>
 <20220511163019.5608-1-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220511163019.5608-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/11/22 10:30 AM, Ankit Kumar wrote:
> This patch introduces a new xnvme fio engine.
> 
> xNVMe provides an API for synchronous and asynchronous I/O.
> A library backs the API, libxnvme, which provides implementations for API users to
> run their I/O application on Linux, FreeBSD, macOS, and Windows without changing the application code.
> 
> Implementations of sync. interfaces include:
> * psync (preadv/pwritev)
> * Linux NVMe driver-ioctl
> * FreeBSD NVMe driver-ioctl
> 
> Implementations of async. interfaces include:
> * io_uring
> * io_uring_cmd (experimental)
> * libaio
> * POSIX aio

Is the plan also to cleanup the passthrough support for the io_uring engine
and submit that? I'd personally find that a lot more useful than this xnvme
engine. I don't mind including it if you guys are using it and find it
useful for testing xnvme on various platforms, but it's not something
I'd personally use.

-- 
Jens Axboe

