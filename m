Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52327C433EF
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 13:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280A860FC2
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 13:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhKJNaI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Nov 2021 08:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKJNaI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Nov 2021 08:30:08 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AE3C061764
        for <fio@vger.kernel.org>; Wed, 10 Nov 2021 05:27:20 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id i12so2435968ila.12
        for <fio@vger.kernel.org>; Wed, 10 Nov 2021 05:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yp857SIHDT3hMHVh53YlYWu1UNIwovct7Sd8BfxyY9k=;
        b=iVnE/gyD673geJnwIkHqQn0+bskDCCU3RRdWS+a1Uq9UFypANSkdbfcp1psFWpkTxm
         4UpK76jRxqA9QrARGGbeVKQ1LWmHeufDs2yKqBGtE0KzQravCH/wSjKLdT2801aJzDRZ
         KJLDVAjHld5xFXss9NMQeRK/AojLNBjL9UxSBj4Sp8mFH2EAY6Ar+vI6FDpYtfxeEeim
         bGhq9Fq26yA7iYpeUy6/Qj8C+jeIwHq1u89Lo23k5rG6tnvuYOmVeVpMxGwjP7OQTiHv
         N0t4Y6D/4V8hZzampBptTpzkqzxDbPySWGL/W+OH3GZibQCbhKaVClA0XR9Hh4nWsTQs
         u1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yp857SIHDT3hMHVh53YlYWu1UNIwovct7Sd8BfxyY9k=;
        b=UfHJxRQ928mzuitRdEkjAI8lNaLyt9vKRWsEf3AG8q1mLs13AAM3HDADJz9E6TYaV2
         NzovRs0BkwRlyWD+6NPSd9ZFt/5RzX/ONXdkOxpxEJ/q1f6D+BAC9sP9R9ufpuc3aVf/
         V1d6nEU5liTY4OK4s6b+snzLJV7jIGic10O6Hzj4TgFTdnPgMVsC7EC8i5yHkln1ubFm
         h1RMvoocbITm9BKVXNBZmDqAj22NoWsA5nWCtP4EMSONz5kopVyD9lYs8cs/mOI+ya81
         iuJMOWVrd/dwFpI95KDgWb7aoAksJHqiwmwcRBuwrz1BkFqysGpFXRYp8Z6zuQ2+j/TD
         epHw==
X-Gm-Message-State: AOAM532zJi998Zz8U8WxfemQcg9nGYAN92SvW+fPiw2E7giFWDijD054
        gWEUzMkr4/itykPi8RzZMCi+/EMIcZpMCdQ9
X-Google-Smtp-Source: ABdhPJzYGw+VIlZ5zczvhL52AE65MBfmwYsa9qIeMdCLEvLicT5jw1dIP+Z8m2XYb5u5hLVJ/f3j5A==
X-Received: by 2002:a05:6e02:1b0f:: with SMTP id i15mr11177758ilv.191.1636550840183;
        Wed, 10 Nov 2021 05:27:20 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u12sm12969031ilm.1.2021.11.10.05.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 05:27:19 -0800 (PST)
Subject: Re: [PATCH] stat: create a init_thread_stat_min_vals() helper
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211108131143.80158-1-Niklas.Cassel@wdc.com>
 <163637789309.316137.11821147634914478848.b4-ty@kernel.dk>
 <YYuUUigHbn9gSSJD@x1-carbon>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <01d1c798-c7e0-cfa9-521a-8ae42cf80ec1@kernel.dk>
Date:   Wed, 10 Nov 2021 06:27:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YYuUUigHbn9gSSJD@x1-carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/10/21 2:43 AM, Niklas Cassel wrote:
> On Mon, Nov 08, 2021 at 06:24:53AM -0700, Jens Axboe wrote:
>> On Mon, 8 Nov 2021 13:12:09 +0000, Niklas Cassel wrote:
>>> From: Niklas Cassel <niklas.cassel@wdc.com>
>>>
>>> Create a init_thread_stat_min_vals() helper so that we can remove
>>> duplicated code.
>>>
>>>
>>
>> Applied, thanks!
>>
>> [1/1] stat: create a init_thread_stat_min_vals() helper
>>       commit: 6619fc32c413c4ff3a24c819037fb9227af3f876
>>
> 
> Hello Jens,
> 
> I still don't see it either in kernel.dk or github.
> I'm guessing that you forgot to push.

Indeed, pushed out now.

-- 
Jens Axboe

