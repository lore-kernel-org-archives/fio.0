Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DD6C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 11:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED6060EE3
	for <fio@archiver.kernel.org>; Fri, 10 Sep 2021 11:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhIJL0R (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Sep 2021 07:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhIJL0R (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Sep 2021 07:26:17 -0400
Received: from scc-mailout-kit-01.scc.kit.edu (scc-mailout-kit-01.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e751])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5313EC061574
        for <fio@vger.kernel.org>; Fri, 10 Sep 2021 04:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kit.edu;
        s=20190212; h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:To:
        References:Subject:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JA/tcr3EsAX+MnMab5f10QvhDIlR7bTjJwiF5lB63vQ=; b=26NulDgfY5UWg3p9gjies3ank0
        CwvvGG7Soo9bjkYxvhJD2IfROiPvCgAXAJJvEMglQwofiC3HdoLzftWLi4dCXFHRJs3sJ7jFp8Oxb
        fGCkMOG6jUPPiqqhFdPTkMfoKW+o95DGucc1HcL8nUKdHQBlKn/wogBqcp3Ujxpc8018=;
Received: from [2a00:1398:9:f612:7dff:d82:2b55:971a] (helo=kit-msx-45.kit.edu)
        by scc-mailout-kit-01.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (envelope-from <hans-peter.lehmann@kit.edu>)
        id 1mOeeV-0001Sr-HI; Fri, 10 Sep 2021 13:25:04 +0200
Received: from [IPv6:2a00:1398:9:fb03:c58a:b1d5:6e49:8264]
 (2a00:1398:9:fb03:c58a:b1d5:6e49:8264) by smtp.kit.edu
 (2a00:1398:9:f612::106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Fri, 10 Sep
 2021 13:25:03 +0200
From:   Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
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
 <1cf066bb-aa71-1403-c80c-454ea87a9502@kit.edu>
 <4ce4addd-a7c7-f35f-ef3b-b0bf9966e224@kernel.dk>
 <47a5597f-4b7a-fcfc-b57d-2b46c86c0817@kit.edu>
 <5668f23f-49b3-1c37-1029-dabe996f7bd0@kernel.dk>
To:     <axboe@kernel.dk>, <fio@vger.kernel.org>
Message-ID: <812cac88-dd29-852f-2370-4121376ac64e@kit.edu>
Date:   Fri, 10 Sep 2021 13:25:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5668f23f-49b3-1c37-1029-dabe996f7bd0@kernel.dk>
Content-Type: multipart/mixed;
        boundary="------------5C9BF356D072133CA196964B"
Content-Language: en-US
X-Originating-IP: [2a00:1398:9:fb03:c58a:b1d5:6e49:8264]
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--------------5C9BF356D072133CA196964B
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

> it's definitely more expensive to drive two drives vs one for these kinds of tests. [...] it does show extra overhead for polling 2 drives vs just one.

Oh, right. Sorry. Thanks a lot for the interesting measurements. Also, I somehow missed that you already are at 3.5M IOPS. Crazy.

> No, you're running something from around that same time, not what I was running

I upgraded the Kernel to 5.10.32 (that's the most recent one provided by Canonical for Ubuntu 20.04) and tried again. I'm still stuck at 1.0M IOPS.

> I really did want --no-children, the default is pretty useless imho... But the callgraphs are a must!

I think I now managed to export what you expected (somehow "-g" was not enough and I needed to do "-g graph", even though that should actually be the default). You can find the perf output attached. It was recorded on Kernel 5.10.32.

Hans-Peter

--------------5C9BF356D072133CA196964B
Content-Type: application/gzip; name="output.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="output.gz"

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
--------------5C9BF356D072133CA196964B--
