Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6D1C433FE
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 16:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiJRQOr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 12:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiJRQOp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 12:14:45 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDD61006B
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 09:14:40 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id de14so9609038qvb.5
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 09:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A03UXBsRhUeiHGzJdN+YtboOUqzWAyIdDpGza5jdTEY=;
        b=hlDurg245+3Vzv1fBiihUJ9V9oq9ASDsmrcVUsFBOw51tCGWiWBmbDaSA3b0B2xHCQ
         4yT9ZNXW+EotPZX1oMCEQAJfjk7syXusHLcFHw0Um350YbtYDDa2hWsB7zLzkXO0gPwu
         kiVFINnEh0Tdu2PYiruz2zbhYADKPJMa0pI+HMREHurqb15ONlUSZ+oQeanJShHeZ3qo
         NO/nh2vdeChPT5rBh1ZQqJUVsO6TgGC9hcWzLzKoSH2sSpxIlfiRV5RtZxTFR0INvytq
         reM92nLpWEH+7McvdFIXxlsmXWgte8AvkeiVpV88sr0/OsgPjEIITiEnfq/QFVsm6x85
         xrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A03UXBsRhUeiHGzJdN+YtboOUqzWAyIdDpGza5jdTEY=;
        b=JCojKK/TiKFniBr0W9m42su0iMGkM6oLlG9B8aRiydEp9vkVl7Byvr+WBsqfAJ9Cvc
         c+UpFvCOItSD82QPq5JNczT0w2PHC0ieuEpPSKZxHMxhLGeR0A0zEwVTXKqkC1i18WY8
         8wrFK2Wb9hkrKe8WiaOI0Ew30iTBX2SL8aHWVmJ5T5bnDjjlr/+n2vMGCjWIblxmDVJH
         ao6FI6ldpr1Vmei9JPU3qcjk7OqizlV7rya3zugbabOCzoLG44ELxyNzUXc0PIrn6hkP
         kUebZRNEkvPcRhQnpfUrKgjNfIPvYSHN0oQWSYocCHXF/PgxDLrGgcylS73FzsDJR2vp
         LI0g==
X-Gm-Message-State: ACrzQf0HqkDQTBs3gijtoh1v7T/Mnye31tjcErE+4fJB4Cy0XrgCq2kn
        MTmgTyc2uk+f30uqqHVtigc=
X-Google-Smtp-Source: AMsMyM7NzulGpuMPO0XUWDvetMm7vzgMcBubWyRgkiBGCMAgi17t72dNKHAS0henQTV7lWJAFiWY2w==
X-Received: by 2002:a05:6214:c86:b0:4b4:4e78:c0b with SMTP id r6-20020a0562140c8600b004b44e780c0bmr2986561qvr.126.1666109679695;
        Tue, 18 Oct 2022 09:14:39 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id o14-20020a05620a2a0e00b006cbc00db595sm2785296qkp.23.2022.10.18.09.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 09:14:39 -0700 (PDT)
Message-ID: <e1d0b1fa-b36a-1269-7d3d-4998d2b62177@gmail.com>
Date:   Tue, 18 Oct 2022 12:14:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] fix experimental verify
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/18/22 00:17, Shin'ichiro Kawasaki wrote:
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

Hello Shin'ichiro,

I applied your patches to a branch on GitHub:

https://github.com/vincentkfu/fio/commits/exp-verify

All of the automated Linux and macOS tests pass but on Windows I see 
failures with t0026:

https://ci.appveyor.com/project/vincentkfu/fio/builds/45105941

Would you take a look?

Vincent
