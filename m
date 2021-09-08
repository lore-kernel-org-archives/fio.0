Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE67C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964716113E
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhIHMm6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbhIHMm6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 08:42:58 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F5C061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 05:41:50 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id x5so2150026ill.3
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 05:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gep16M9m5bviyLafc3rcn08JrMDZEZp0IBwEFzuWC+M=;
        b=u6x/U1v5Zs2/PnY2zvl5k6GlhbCtSDnsORVqcZIcrroZtjreCqAuo9yDzlIESn7g0R
         Dn2J84C94QAmBDHuQiV7OBnXy8PaRVuTCEECwrGvJqG4dZthAnP3YBKL3DDe72YrTUya
         d9KAnl16oiaBYxX1d1clpv8ppzgSr1cA1sWfCc1Yce7/ojTyWV0rJOkgsnh3NgFaZck7
         MG6IzolFOfo8GZmppylIR7fQDclAgc6YA/Xy+5Rx33XPvCaeAYSG3G9YN1hHvF1jbqLS
         lyegK0e2KQiX9NpxKIoFon+IhWWSxUBmdqiD7K1Zdj0KOLwdE6rOoDNA9s69dbf388TA
         0aoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gep16M9m5bviyLafc3rcn08JrMDZEZp0IBwEFzuWC+M=;
        b=c2Jzpgoj3NwnUifQWHNTU09X18DroT2rzV3ao6b2Hka02cyc/rPKqCBs73gnqSNpt1
         TBnYswVNcFLyIvZm2Akxim3BLG9C6srDfr7Ubzd26HJBR16OJCo+ZtPQJMNAIWFDsElf
         srvIy4oeTnYRx30m4e6Mgy3KEtwy6dt46xJuqkEi39+I6NpvuGU651ZSz6bw4evZT5n3
         XHVc03c0TI7BthptpjWLC3m3dy9IBz7Art4UK8jeL0+8M1uodWLQppTlTeZ7QWRGufLh
         VT9wIWTaJc0acXxkNe/CkwZu1pUkQnCnREZoMHcxa2jOVtDM24acSy0xfgaMgsMBCuME
         v47A==
X-Gm-Message-State: AOAM5314f1k7TEpm4pC9yrA0SgRmt7TUJBkgay6kgL+tzLfiyzj2EiqZ
        CXXnWUnXGSlCR75kLZ8gDnGhRA==
X-Google-Smtp-Source: ABdhPJx4mRGIMssuTHcjKgmj+y6oBHcgeXL9WIfU9WnFEbmnM8+p6JTEiQEz5VF8LPKV8UeNbtiNeQ==
X-Received: by 2002:a92:c0d2:: with SMTP id t18mr2801935ilf.80.1631104909652;
        Wed, 08 Sep 2021 05:41:49 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u15sm1024340ilk.53.2021.09.08.05.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:41:49 -0700 (PDT)
Subject: Re: Question: t/io_uring performance
From:   Jens Axboe <axboe@kernel.dk>
To:     Sitsofe Wheeler <sitsofe@gmail.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
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
Message-ID: <8d6acc34-5078-c023-fcc8-cb34b63e5112@kernel.dk>
Date:   Wed, 8 Sep 2021 06:41:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bfddf649-aaf4-b01f-f26b-513fb4e236b2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/21 6:22 AM, Jens Axboe wrote:
> On 9/8/21 5:53 AM, Sitsofe Wheeler wrote:
>> (CC'ing Jens directly in case he missed the previous messages)
>>
>> On Mon, 6 Sept 2021 at 15:28, Hans-Peter Lehmann
>> <hans-peter.lehmann@kit.edu> wrote:
>>>
>>> Hi Jens,
>>>
>>> not sure if you have read the emails in this thread - now trying to address you directly. Both Erwan and me are unable to reproduce your single-threaded IOPS measurements - we don't even get close to your numbers. The bottle-neck seems to be the CPU, not the SSDs. Did you use some special configuration for your benchmarks?
>>>
>>> Best regards
>>> Hans-Peter
>>>
>>> (I have also reproduced the behavior with an Intel processor now - the single-threaded throughput is also capped at around 580k IOPS, even though the SSDs can handle more than that when using multiple threads)
> 
> Thanks for CC'ing me, I don't always see the messages otherwise. 580K is
> very low, but without having access to the system and being able to run
> some basic profiling, hard for me to say what you're running into. I may
> miss some details in the below, so please do ask followups if things are
> missing/unclear.
> 
> 1) I'm using a 3970X with a desktop board + box for my peak testing,
>    specs on that can be found online.
> 
> 2) Yes I do run a custom configuration on my kernel, I do kernel
>    development after all :-). I'm attaching the one I'm using. This
>    hasn't changed in a long time. I do turn off various things that I
>    don't need and some of them do impact performance.
> 
> 3) The options I run t/io_uring with have been posted multiple times,
>    it's this one:
> 
>    taskset -c 0  t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 /dev/nvme3n1
> 
>    which is QD=128, 32/32 submit/complete batching, polled IO,
>    registered files and buffers. Note that you'll need to configure NVMe
>    to properly use polling. I use 32 poll queues, number isn't really
>    that important for single core testing, as long as there's enough to
>    have a poll queue local to CPU being tested on. You'll see this in
>    dmesg:
> 
>    nvme nvme3: 64/0/32 default/read/poll queues
> 
> 4) Make sure your nvme device is using 'none' as the IO scheduler. I
>    think this is a no-brainer, but mentioning it just in case.
> 
> 5) I turn off iostats and merging for the device. iostats is the most
>    important, depending on the platform getting accurate time stamps can
>    be expensive:
> 
>    echo 0 > /sys/block/nvme3n1/queue/iostats
>    echo 2 > /sys/block/nvme3n1/queue/nomerges
> 
> 6) I do no special CPU frequency tuning. It's running stock settings,
>    and the system is not overclocked or anything like that.
> 
> I think that's about it. The above gets me 3.5M+ per core using polled
> IO and the current kernel, and around 2.3M per core if using IRQ driven
> IO. Note that the current kernel is important here, we've improved
> things a lot over the last year.
> 
> That said, 580K is crazy low, and I bet there's something basic that's
> preventing it running faster. Is this a gen2 optane? One thing that
> might be useful is to run my t/io_uring from above, it'll tell you what
> the IO thread pid is:
> 
> [...]
> submitter=2900332
> [...]
> 
> and then run
> 
> # perf record -g -p 2900332 -- sleep 3
> 
> and afterwards do:
> 
> # perf report -g --no-children > output
> 
> and gzip the output and attach it here. With performance that low,
> should be pretty trivial to figure out what is going on here.

Followup - the below is specific to my peak-per-core testing, for
running much lower IOPS most of it isn't going to be required. For
example, polled IO is not going to be that useful at ~500K iops.

For the original poster, and I think this was already asked, but please
run the perf as indicated and also do a run with two threads:

taskset -c 0,1 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B1 -n2 /dev/nvmeXn1 /dev/nvmeYn1

just to see what happens. t/io_uring doesn't work very well with
driving polled IO for multiple devices, it's just a simple little
IO generator, nothing advanced.

I picked CPU0 and 1 here, but depending on the number of queues on your
device, you might be more limited and you should pick something that
causes a nice spread on your setup. /sys/kernel/debug/block/<dev> will
have information on how queues are spread out.

Again, not really something that should be needed at these kinds of
rates, unless the device is severly queue starved and you have a lot of
cores in your system. Regardless, strictly affinitizing the workload
helps with variance between runs and is always a good idea.

-- 
Jens Axboe

