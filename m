Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D306C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 21:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023B160F45
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 21:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhIHVfn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 17:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhIHVfk (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 17:35:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FBCC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 14:34:30 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z1so5176677ioh.7
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 14:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QoRv+jFj5p+ZsorMcLEpEKz8W4XdqrqybTlSOoeONq4=;
        b=eLrofeRXx36HYttVT1wcNl5Dof6AGWvzDGP0nY4+kLS5qPS9pNefjDfHWnfb8fkCb1
         I+pXI2DkWP6elaEBEap9GBm22UO90Sq0ePbV/hhQ/5akMO+oA1XXfYadZ9/Hp7P19jZm
         I2pMO0lrJMINu7GN528jmb9GG/deH3KGssbLFOlhzT4UQNHkYwhdJSdPotaOhCnc6v3F
         ny+LTADSkZ57kB57OHTq0iMP+Cwf/ktgfuUWryWPQRtF5h8aG5nX+sN+k7cg7pGjWzJT
         rZ64W+uWPidHtdML270MpnBPQgCEGZnEiJgReNj6n6qNeQcsayc1WnUZ7sIxWh7AC4Ik
         Kl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QoRv+jFj5p+ZsorMcLEpEKz8W4XdqrqybTlSOoeONq4=;
        b=UJnFTCy23aJbz1+/LJWAds6G/LhZ89+zjjJ8Xo3YxxfQQAaFo13H8dvYbGA9mRczQA
         XuqcmzyG+UigDTEVhQ9BCI9aVaEXrpYmQ6jQ8isRsYbiwnQ4jh3mNIHJ0ypA4m4BNdcN
         aVUlPnv6NA9uBvNcytP9oVPKJqqxwE21cZYsLvMaIg0us7ma/gqImAyU3U0c7EGdv4DX
         djHtye36xOxuQyjyOSq2dCQTTE94nC0qWm6mHLGN/ELFmc5nPw6U+FG/JUr8RyzVtcDU
         e8hT6lh+AvuteovoeUVCLZn+kHKfeH9TKQ+PGMwpqNSBa3Z/SMZfOWxT9nUFqYEIMCTY
         3UpQ==
X-Gm-Message-State: AOAM532D7+JgaTWYGul4g3eW4dRY53JNYPrxRB/gwCHgq88a1duLWuOf
        IdsttfFtIuoq1XuI9sNIjBZ0H3PEjG7W6Q==
X-Google-Smtp-Source: ABdhPJyr1dPZrAxBqGrEQn+UaOfJ02pv6IItegsNg5HWHzRSqTYWeRTA0tKjkGy0UPCaPPo6KDMJXQ==
X-Received: by 2002:a02:7355:: with SMTP id a21mr410759jae.53.1631136869285;
        Wed, 08 Sep 2021 14:34:29 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s12sm178031ilo.0.2021.09.08.14.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 14:34:28 -0700 (PDT)
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
 <4ce4addd-a7c7-f35f-ef3b-b0bf9966e224@kernel.dk>
 <47a5597f-4b7a-fcfc-b57d-2b46c86c0817@kit.edu>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5668f23f-49b3-1c37-1029-dabe996f7bd0@kernel.dk>
Date:   Wed, 8 Sep 2021 15:34:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <47a5597f-4b7a-fcfc-b57d-2b46c86c0817@kit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/21 3:24 PM, Hans-Peter Lehmann wrote:
>> What's the advertised peak random read performance of the devices you are using?
> 
> I use 2x Intel P4510 (2 TB) for the experiments (and a third SSD for
> the OS). The SSDs are advertised to have 640k IOPS (4k random reads).
> So when I get 1.6M IOPS using 2 threads, I already get a lot more than
> advertised. Still, I wonder why I cannot get that (or at least
> something like 1.3M IOPS) using a single core.

You probably could, if t/io_uring was improved to better handle multiple
files. But this is pure speculation, it's definitely more expensive to
drive two drives vs one for these kinds of tests. Just trying to manage
expectations :-)

That said, on my box, 1 drive vs 2, both are core limited:

sudo taskset -c 0  t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n1 /dev/nvme1n1
Added file /dev/nvme1n1 (submitter 0)
sq_ring ptr = 0x0x7f687f94d000
sqes ptr    = 0x0x7f687f94b000
cq_ring ptr = 0x0x7f687f949000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=2535
IOPS=3478176, IOS/call=32/31, inflight=(128)
IOPS=3491488, IOS/call=32/32, inflight=(128)
IOPS=3476224, IOS/call=32/32, inflight=(128)

and 2 drives, still using just one core:

Added file /dev/nvme1n1 (submitter 0)
Added file /dev/nvme3n1 (submitter 0)
[...]
IOPS=3203648, IOS/call=32/31, inflight=(27 64)
IOPS=3173856, IOS/call=32/31, inflight=(64 53)
IOPS=3233344, IOS/call=32/31, inflight=(60 64)

vs using 2 files, but it's really the same drive:

Added file /dev/nvme1n1 (submitter 0)
Added file /dev/nvme1n1 (submitter 0)
[...]
IOPS=3439776, IOS/call=32/31, inflight=(64 0)
IOPS=3444704, IOS/call=32/31, inflight=(51 64)
IOPS=3447776, IOS/call=32/31, inflight=(64 64)

That might change without polling, but it does show extra overhead for
polling 2 drives vs just one.

> Using 512b blocks should also be able to achieve a bit more than 1.0M
> IOPS.

Not necessarily, various controllers have different IOPS and bandwidth
limits. I don't have these particular drives myself, so cannot verify
unfortunately.

>> Sounds like IRQs are expensive on your box, it does vary quite a bit between systems.
> 
> That could definitely be the case, as the processor (EPYC 7702P) seems to have some Numa characteristics even when configuring it to be a single node. With NPS=1, I still get a difference of about 10K-50K IOPS when I use the cores that would belong to different Numa domains than the SSDs. In the measurements above, the interrupts and the benchmark are pinned to a core "near" the SSDs, though.
> 
>> Did you turn off iostats? If so, then there's a few things in the kernel config that can cause this. One is BLK_CGROUP_IOCOST, is that enabled?
> 
> Yes, I did turn off iostats for both drives but BLK_CGROUP_IOCOST is enabled.
> 
>> Might be more if you're still on that old kernel.
> 
> I'm on an old kernel but I am also comparing my results with results
> that you got on the same kernel back in 2019 (my target is ~1.6M like
> in [0], not something like the insane 2.5M you got recently [1]). I
> know that it's not a 100% fair comparison because of the different
> hardware but I still fear that there is some configuration option that
> I am missing.

No, you're running something from around that same time, not what I was
running. It'd be the difference between my custom kernel and a similarly
versioned distro kernel.

There's a bit of work to do to ensure that the standard options don't
add too much overhead, or at least that you can work-around it at
runtime.

>> Would be handy to have -g enabled for your perf record and report, since that would show us exactly who's calling the expensive bits.

> I did run it with -g (copied the commands from your previous email and
> just exchanged the pid). You also had the "--no-children" parameter in
> that command and I guess you were looking for the output without it.
> You can find the output from a simple "perf report -g" attached.

I really did want --no-children, the default is pretty useless imho...
But the callgraphs are a must!

-- 
Jens Axboe

