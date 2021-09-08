Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DB0C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 16:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6628D61139
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 16:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbhIHQVn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245273AbhIHQVm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 12:21:42 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8156BC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 09:20:34 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y18so4041396ioc.1
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BYJg2XrXoqSD0BVCRXKwe4pt4sho5ituTS0VFCsvRm4=;
        b=o3OoV4nwKFb5yDfquhrq4EaaSUtTNxqU/+bkrLt1mmWJc8VVWgxN1Xu6EZNivNyBcT
         X3cyH1mxijTw78XQ90W1OKZ9KF1ewbiA0Qjajz9Myt3HcsSBgU1ihVHX7CX3Juh9qyWe
         uriqJDlrVTU5DZ73yWAzqwEa8F2l66yIB9tZ0EoJ8cBKI7aWOtQUL12EnzH+gwlqMr7u
         sZhuUzq8SpQjFUeXCpePTT4QGDPYbqf79tktK2xtBcejOG0zpd1T1z6BdN97VNKtR4iQ
         FZ3bBJVA55dnWTn2pklZsq7RbVmghL8H+txWDsLSFjsrtXsn1FyTGv+Xk8xkE/UITQxi
         UjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BYJg2XrXoqSD0BVCRXKwe4pt4sho5ituTS0VFCsvRm4=;
        b=kjva/drCc7hGrCfjLrgGC4FB7QcGgIZOXOL7ufcGvQkHlLhCPwz/XaDiDcBzSjEVZP
         ApMBew9QUQopNs3wYWb3ajeUA5wd2Oi86DDX4l75wJ6rv8rxiDFIHcaTtUfM2lse9MXA
         gO2JZOeP3Ez/de8h8fhteW4gJL1GWJaqS1dYBQ8mkKVZIB8quvzS5eMWQ0EZkQUsYCYb
         P1SpqjTf03RKETC69FOteQ1YM21mJTc1V1EGxnnS/gUMso8c6SeFp0S/cwvPzZD0CRHx
         FFb0i/i1XTqiXZNIFcv6NojEBCUbpyrDU29g37EwKiR50t55q4VNGs3rxkHwK1alloDr
         4YlA==
X-Gm-Message-State: AOAM532Ycq472fOUH8bT7ih9lct0nQAGjyOe7IjvB4sB9dWPnjwCcEHx
        424fmAg7J2R4buBQVyD4TWFHHUwVRk621w==
X-Google-Smtp-Source: ABdhPJzdRA7gLtAiabcug9ewLZOQx/0AUMgPIkRelGMx42+BkAe2++z9be3uXsASa3laq8LLKGrX0w==
X-Received: by 2002:a05:6602:117:: with SMTP id s23mr606433iot.124.1631118033464;
        Wed, 08 Sep 2021 09:20:33 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k21sm1295231ioh.38.2021.09.08.09.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 09:20:32 -0700 (PDT)
Subject: Re: Question: t/io_uring performance
To:     Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
 <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
 <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
 <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
 <CALjAwxgM65_vfrBkvGksoyO6vgR1dx4aPtGJSqRhm-gieHKgyA@mail.gmail.com>
 <bfddf649-aaf4-b01f-f26b-513fb4e236b2@kernel.dk>
 <8d6acc34-5078-c023-fcc8-cb34b63e5112@kernel.dk>
 <1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4ce4addd-a7c7-f35f-ef3b-b0bf9966e224@kernel.dk>
Date:   Wed, 8 Sep 2021 10:20:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/21 10:12 AM, Hans-Peter Lehmann wrote:
> Hi Jens,
> 
> thank you for your reply. Given that you have read the thread after the first reply, I think some of the questions of your first email are no longer relevant. I still answered them at the bottom for completeness, but I will answer the more interesting ones first.
> 
>> I turn off iostats and merging for the device.
> 
> 
> 
> Doing this helped quite a bit. The 512b reads went from 715K to 800K. The 4096b reads went from 570K to 630K.
> 
>> Note that you'll need to configure NVMe
>   to properly use polling. I use 32 poll queues, number isn't really
>   that important for single core testing, as long as there's enough to
>   have a poll queue local to CPU being tested on.
> 
> My SSD was configured to use 128/0/0 default/read/poll queues. I added
> "nvme.poll_queues=32" to GRUB and rebooted, which changed it to
> 96/0/32. I now get 1.0M IOPS (512b blocks) and 790K IOPS (4096b
> blocks) using a single core. Thank you very much, this probably was
> the main bottleneck. Launching the benchmark two times with 512b
> blocks, I get 1.4M IOPS total.

Sounds like IRQs are expensive on your box, it does vary quite a bit
between systems.

What's the advertised peak random read performance of the devices you
are using?

> Starting single-threaded t/io_uring with two SSDs still achieves "only" 1.0M IOPS, independently of the block size. In your benchmarks from 2019 [0] when Linux 5.4 (which I am using) was current, you achieved 1.6M IOPS (4096b blocks) using a single core. I get the full 1.6M IOPS for saturating both SSDs (4096b blocks) only when running t/io_uring with two threads. This makes me think that there is still another configuration option that I am missing. Most time is spent in the kernel.
> 
> # time taskset -c 48 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 /dev/nvme0n1 /dev/nvme1n1
> i 8, argc 10
> Added file /dev/nvme0n1 (submitter 0)
> Added file /dev/nvme1n1 (submitter 0)
> sq_ring ptr = 0x0x7f78fb740000
> sqes ptr    = 0x0x7f78fb73e000
> cq_ring ptr = 0x0x7f78fb73c000
> polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
> submitter=2336
> IOPS=1014252, IOS/call=31/31, inflight=102 (38, 64)
> IOPS=1017984, IOS/call=31/31, inflight=123 (64, 59)
> IOPS=1018220, IOS/call=31/31, inflight=102 (38, 64)
> [...]
> real    0m7.898s
> user    0m0.144s
> sys     0m7.661s
> 
> I attached a perf output to the email. It was generated using the same parameters as above (getting 1.0M IOPS).

Looking at the perf trace, it looks pretty apparent:

     7.54%  io_uring  [kernel.kallsyms]  [k] read_tsc                           

which means you're spending ~8% of the time of the worload just reading
time stamps. As is often the case once you get near core limits,
realistically that'll cut more than 8% of your perf. Did you turn off
iostats? If so, then there's a few things in the kernel config that can
cause this. One is BLK_CGROUP_IOCOST, is that enabled? Might be more if
you're still on that old kernel.

Would be handy to have -g enabled for your perf record and report, since
that would show us exactly who's calling the expensive bits. The next
one is memset(), which also looks suspect. But may be related to:

https://git.kernel.dk/cgit/linux-block/commit/block/bio.c?id=da521626ac620d8719d674a48b8ec3620eefd42a

-- 
Jens Axboe

