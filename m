Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC767C433F5
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 14:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63A260F14
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 14:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhIFO1a (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbhIFO1a (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Sep 2021 10:27:30 -0400
Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e752])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC8C061575
        for <fio@vger.kernel.org>; Mon,  6 Sep 2021 07:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kit.edu;
        s=20190212; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version
        :Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I/UATi1NUTNm90Wufths0cL7QBCa5i50KbYBAfszRBc=; b=kVd2oE+2vL4WfrvW4GbvmN7vTa
        VCp56oSwYaakfjJvuo3kqWGMJ7gQOt4D/eFBtpy4+nhBpGNbd0yUs/YU1r13L8+2UaAjHRt5LBaT7
        kafoyOWib1ihS2rJwo7S4T37MLf/WjHgM77lQdzvJUXgf69zFldDD4eIGejAT8UUxT4k=;
Received: from [2a00:1398:9:f612:f16c:129a:2c38:447d] (helo=kit-msx-50.kit.edu)
        by scc-mailout-kit-02.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (envelope-from <hans-peter.lehmann@kit.edu>)
        id 1mNFZm-0003ri-Og; Mon, 06 Sep 2021 16:26:23 +0200
Received: from [192.168.42.5] (46.223.201.100) by smtp.kit.edu (129.13.50.106)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Mon, 6 Sep 2021
 16:26:22 +0200
Subject: Re: Question: t/io_uring performance
To:     Erwan Velu <e.velu@criteo.com>,
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
From:   Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
Message-ID: <77b67cc0-30c1-70a8-438b-f1bcf1fdb295@kit.edu>
Date:   Mon, 6 Sep 2021 16:26:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.223.201.100]
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Jens,

not sure if you have read the emails in this thread - now trying to address you directly. Both Erwan and me are unable to reproduce your single-threaded IOPS measurements - we don't even get close to your numbers. The bottle-neck seems to be the CPU, not the SSDs. Did you use some special configuration for your benchmarks?

Best regards
Hans-Peter

(I have also reproduced the behavior with an Intel processor now - the single-threaded throughput is also capped at around 580k IOPS, even though the SSDs can handle more than that when using multiple threads)
