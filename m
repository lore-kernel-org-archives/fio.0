Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBB9C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 16:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0BB560EB7
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 16:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhIHQOC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347298AbhIHQOB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 12:14:01 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F6C061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 09:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kit.edu;
        s=20190212; h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:To:From:
        References:Subject:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6hfVDJ+tVbfRfjL14LhJwclDsGOVDSEss6/DM6DQcK4=; b=B6NYBGwIKU4FEZeFtN/CeBwgOy
        rt2mdG7extk9AkkHo02cIs5blejBLoUs3mFdXhDXLGi/asXy9DNi87u0DiHB2ZmhrDVV2v2YSb3+/
        GYEygvRZdLQR9D0luCf5ebSKBuPgXLKZJ4gj/GqiYedpnUjAmcxR96F2IUEekMEpPPII=;
X-SCC-RSpam-Status: Action: no action
 Symbol: ARC_NA(0.00)
 Symbol: TO_DN_EQ_ADDR_SOME(0.00)
 Symbol: HAS_XOIP(0.00)
 Symbol: FROM_HAS_DN(0.00)
 Symbol: TO_MATCH_ENVRCPT_ALL(0.00)
 Symbol: MIME_GOOD(-0.10)
 Symbol: HAS_ATTACHMENT(0.00)
 Symbol: RCPT_COUNT_TWO(0.00)
 Symbol: NEURAL_HAM(-0.00)
 Symbol: FROM_EQ_ENVFROM(0.00)
 Symbol: MIME_TRACE(0.00)
 Symbol: RCVD_TLS_LAST(0.00)
 Symbol: RCVD_COUNT_TWO(0.00)
 Symbol: MID_RHS_MATCH_FROM(0.00)
 Symbol: BAYES_HAM(-3.00)
 Message-ID: 1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu hits=-3.1
Received: from [2a00:1398:9:f612:a904:3ac7:70b1:bec0] (helo=kit-msx-44.kit.edu)
        by scc-mailout-kit-02.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (envelope-from <hans-peter.lehmann@kit.edu>)
        id 1mO0Bu-0003Cn-KO; Wed, 08 Sep 2021 18:12:51 +0200
Received: from [192.168.42.5] (46.223.201.100) by smtp.kit.edu (129.13.50.106)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Wed, 8 Sep 2021
 18:12:50 +0200
Subject: Re: Question: t/io_uring performance
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
From:   Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
To:     <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Message-ID: <1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu>
Date:   Wed, 8 Sep 2021 18:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8d6acc34-5078-c023-fcc8-cb34b63e5112@kernel.dk>
Content-Type: multipart/mixed;
        boundary="------------96EE85D44EDAF5E416B608BA"
Content-Language: en-US-large
X-Originating-IP: [46.223.201.100]
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--------------96EE85D44EDAF5E416B608BA
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jens,

thank you for your reply. Given that you have read the thread after the first reply, I think some of the questions of your first email are no longer relevant. I still answered them at the bottom for completeness, but I will answer the more interesting ones first.

> I turn off iostats and merging for the device.



Doing this helped quite a bit. The 512b reads went from 715K to 800K. The 4096b reads went from 570K to 630K.

> Note that you'll need to configure NVMe
  to properly use polling. I use 32 poll queues, number isn't really
  that important for single core testing, as long as there's enough to
  have a poll queue local to CPU being tested on.

My SSD was configured to use 128/0/0 default/read/poll queues. I added "nvme.poll_queues=32" to GRUB and rebooted, which changed it to 96/0/32. I now get 1.0M IOPS (512b blocks) and 790K IOPS (4096b blocks) using a single core. Thank you very much, this probably was the main bottleneck. Launching the benchmark two times with 512b blocks, I get 1.4M IOPS total.

Starting single-threaded t/io_uring with two SSDs still achieves "only" 1.0M IOPS, independently of the block size. In your benchmarks from 2019 [0] when Linux 5.4 (which I am using) was current, you achieved 1.6M IOPS (4096b blocks) using a single core. I get the full 1.6M IOPS for saturating both SSDs (4096b blocks) only when running t/io_uring with two threads. This makes me think that there is still another configuration option that I am missing. Most time is spent in the kernel.

# time taskset -c 48 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 /dev/nvme0n1 /dev/nvme1n1
i 8, argc 10
Added file /dev/nvme0n1 (submitter 0)
Added file /dev/nvme1n1 (submitter 0)
sq_ring ptr = 0x0x7f78fb740000
sqes ptr    = 0x0x7f78fb73e000
cq_ring ptr = 0x0x7f78fb73c000
polled=1, fixedbufs=1, register_files=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=2336
IOPS=1014252, IOS/call=31/31, inflight=102 (38, 64)
IOPS=1017984, IOS/call=31/31, inflight=123 (64, 59)
IOPS=1018220, IOS/call=31/31, inflight=102 (38, 64)
[...]
real    0m7.898s
user    0m0.144s
sys     0m7.661s

I attached a perf output to the email. It was generated using the same parameters as above (getting 1.0M IOPS).

Thank you very much for your help. I am looking forward to hearing from you again to be able fully reproduce your measurements soon.
Hans-Peter


=== Answers to (I think) no longer relevant questions ===

> The options I run t/io_uring with have been posted multiple times, it's this one

This is the same configuration that I also ran (I did not explicitly specify the parameters that are the same as the default).

> Make sure your nvme device is using 'none' as the IO scheduler.

The scheduler is set to 'none'.

> Is this a gen2 optane?

It is not an optane disk but I also do not expect to get insanely high numbers like in your recent benchmarks. Just more close to the old benchmarks but using two SSDs.


=== References ===

[0]: https://twitter.com/axboe/status/1174777844313911296

--------------96EE85D44EDAF5E416B608BA
Content-Type: application/gzip; name="perf-output.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="perf-output.gz"

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
--------------96EE85D44EDAF5E416B608BA--
