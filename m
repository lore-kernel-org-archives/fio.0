Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A28C433F5
	for <fio@archiver.kernel.org>; Wed, 22 Sep 2021 14:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443AD611C9
	for <fio@archiver.kernel.org>; Wed, 22 Sep 2021 14:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhIVOrV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhIVOrV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Sep 2021 10:47:21 -0400
Received: from scc-mailout-kit-01.scc.kit.edu (scc-mailout-kit-01.scc.kit.edu [IPv6:2a00:1398:9:f712::810d:e751])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1ECC061574
        for <fio@vger.kernel.org>; Wed, 22 Sep 2021 07:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kit.edu;
        s=20190212; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UEqiIoYOja1wrXDdR6NVJMVicEC+Xb4XKKgtxSrGlfY=; b=pJgkl7p6kd73Wu0AdpLNAH42+z
        y1eqgHS76XWyhodgHtT2EM+MEebBktgzN5GL2GTHahsMmw2xe24QL3zZFTsRflp7Xo82+3AcOi1Rj
        KnK1+LbmeUA/HEUWz3E+PiFQVb/Gn05sCO9mNSf444pknlocvpeuSpr0JDsZ07nJvZU8=;
Received: from [2a00:1398:9:f612:d1c2:400:a855:6a47] (helo=kit-msx-42.kit.edu)
        by scc-mailout-kit-01.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (envelope-from <hans-peter.lehmann@kit.edu>)
        id 1mT3VM-0006pa-Lz; Wed, 22 Sep 2021 16:45:48 +0200
Received: from [192.168.42.5] (46.223.201.100) by smtp.kit.edu (129.13.50.106)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.13; Wed, 22 Sep
 2021 16:45:48 +0200
Message-ID: <1a2ea0c7-0c76-01ac-4c25-cdcbc8ec83fa@kit.edu>
Date:   Wed, 22 Sep 2021 16:45:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: Question: t/io_uring performance
Content-Language: en-US-large
To:     Erwan Velu <e.velu@criteo.com>, Jens Axboe <axboe@kernel.dk>,
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
 <08a0ddec-45b3-bdcb-e428-e17ff55c5382@kernel.dk>
 <9b72cfc0-c4e7-3ece-1f66-21b66d45d565@criteo.com>
 <8e3e78f6-947f-1566-b666-736c9fb9e353@criteo.com>
 <796c8f29-323a-6fbc-09fc-5c739c81a221@criteo.com>
 <abf13615-4243-e102-5c1d-cb252c679b1a@criteo.com>
From:   Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>
In-Reply-To: <abf13615-4243-e102-5c1d-cb252c679b1a@criteo.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.223.201.100]
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Thank you for your help with reproducing the benchmarks, Jens and Erwan!

> feel free to comment & patch.

I just submitted a little PR :)

Hans-Peter
