Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C14C433FE
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5734C61139
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349271AbhIHMee (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351825AbhIHMeZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 08:34:25 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6972BC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 05:33:17 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h29so2128278ila.2
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 05:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kFaQzWGVDXrLST3mb6G8BuYUOhQ7QnXNzm6foyeP7qw=;
        b=CzxkoFisWVE2j1xHBRnDJpE38TmlLKXj1eVVoD9oBP2OJ/F7TGrb/579w00CiWN9Ng
         0DgZ3drBTbzm7VNId+izDOdRCxgJCCiX0fcteK9Vh+ZqUSZxrwHxGLmnmYeJippZDobL
         rejraawIaiyKzEwGiZ14gulmejybJcFV1iMSOLQQV3rv/jD/SMe4OUpX3Gcdp+xiekf8
         YEoveofSGX/WmR2TTFD9qcLO5F1wa/h+9CtgVSLnDvgoqGicvh0YNzmDOLxQSw09vL+6
         jVS3rWcPkAsvpjr4Zl/hOauLlgmY992iR/SdrhiqXvI8hTvMt8tPKOms8+fOHNPCBNMH
         +Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kFaQzWGVDXrLST3mb6G8BuYUOhQ7QnXNzm6foyeP7qw=;
        b=ItVIv1NH0a4eQ00r+vV40nI5viBortgW8JZQHax82fUNaX1sEb/dkxBaxCTRu+/hQU
         UvJcwXT8Pi0584KvHdl4+0cjwvpWbZs73abtDvNiy39o2//RlHjHEpCvXMgV0fHJalHS
         61eRImHILkAZYoRG+VZXEw2g+JQ19HoljGNg0nztCZJM4cyd3zXheZhgrxfXHeCU6haE
         xTrNwssO/qsRt23T0UuFSyB/GJSN54OuVQqXVXIz52o9kd/H/C9DR1o+SuNne7eQfEbH
         sqz8Rl1p/BtefnprkXM3BW8arc3nfVTOBlA5WroVbVc0hwmz1FzYpgIOBEzzHeLS6LRe
         uwCQ==
X-Gm-Message-State: AOAM53122Tb4bxQX08J/2g1B+fCG7qqZrwCVEXlHROgeF3rG4Xw/s/gV
        Pwzm43d3lYvb9S9JzE5EXnNb+yIg4pn0pQ==
X-Google-Smtp-Source: ABdhPJxjVzkMXHMC33uzQeGZyWv0c+UhvEdF1Sg7aiwzLYiVtLFNxpKZWe/bbWIy7St89nsGOj4aag==
X-Received: by 2002:a92:ae0e:: with SMTP id s14mr2787024ilh.197.1631104396615;
        Wed, 08 Sep 2021 05:33:16 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e15sm1095626ilu.29.2021.09.08.05.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:33:16 -0700 (PDT)
Subject: Re: Question: t/io_uring performance
To:     Erwan Velu <e.velu@criteo.com>,
        Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>,
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08a0ddec-45b3-bdcb-e428-e17ff55c5382@kernel.dk>
Date:   Wed, 8 Sep 2021 06:33:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/1/21 8:17 AM, Erwan Velu wrote:
> 
> Le 01/09/2021 à 16:05, Erwan Velu a écrit :
>>
>> [...]
>> These numbers are perfect.
>>
>> I rebuild fio on a 5.4 kernel on a high-end nvme which is 1M iops read 
>> capable and got stuck at the same number as you aka 580K iops.
>>
>> So, I'd agree with you something is curious here.
>>
> Same on a 5.10.35.
> 
> Jens, did we missed something here ?

Read through the actual thread. It seriously sounds like the system is
hitting bandwidth limits, which is very odd. 580K is not very much. Just
curious, does it change anything if you use 512b blocks instead?

-- 
Jens Axboe

