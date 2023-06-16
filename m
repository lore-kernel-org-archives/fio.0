Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AA2EB64D7
	for <fio@archiver.kernel.org>; Fri, 16 Jun 2023 21:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjFPVOk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 16 Jun 2023 17:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjFPVOj (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Jun 2023 17:14:39 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B495E1FFF
        for <fio@vger.kernel.org>; Fri, 16 Jun 2023 14:14:37 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-630038f13daso3998766d6.3
        for <fio@vger.kernel.org>; Fri, 16 Jun 2023 14:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686950077; x=1689542077;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8cGawVeK8rFeIY/W1w/zUQfijYJE369ihqwSajVZCg=;
        b=SMATV+OnUeFFh37JASGWzOE9BaS2g8BpTouxdBp1PVrxUguIIMl5RbSajeGwn/ov4Z
         WATktSgZVW+OyC9sK/z9InHtw9TpzumNktM2jiU5PAgjCk1ZI8/Xe2LknKpTycMCN7ge
         6LfATfqfhDglnByWke+MgOjQHXYYhmI4n53zJOKSKFOx5COH5L8fSXgcDNv1nRQyQhg5
         iysAUnMsfKcmvCJtXYvsdX3xWyPs5Uxpuin5ulMs1K/OZxS+nhqqkRzGgs3Saus8gUB8
         s5Fo4vvB9G2aWXwGF6HmX0URPt0pxWIjZYEIMPrMF5AM0LFc1Scb5S6c938ORbUVSPsK
         JnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686950077; x=1689542077;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8cGawVeK8rFeIY/W1w/zUQfijYJE369ihqwSajVZCg=;
        b=k1ykjD/XMa7S6AlEMpVU6gs5Tn5jVx7nD41w/Co4mR0fc2FR1SmEu/wlHrEZ8zJYUt
         Z1oc0g6EDxkyyscHnyN45+NMurzhmVm91vRZBExgN3z2hn/+5/vkQICRiPyz6B/otDix
         T5zTxhEKhgRb2QIkuy50HX7LCjOhYhhAhjfwQH0yipQ70MaLXvAzjVB3h9vBWK6p4LL9
         owiAG4c639Q1UJ/IiVjU6HtFLs7MhSQXX4sK5408/1VSRx7fbWTRcEuFY3C325i2tW6m
         nw+kM1AoYct/7bG/bCrpRYuou0VY1OKPNWU+8PkgA3PNk8pa25jv79EqAVr9E99D7nuR
         MpNQ==
X-Gm-Message-State: AC+VfDxTgtWtV1dn8G1+G803cEO5rbPFQew/tt6W7RSU38puknl/jZTy
        qBlKrpORKqm1NXFyE43YFYrEaV2hegQ=
X-Google-Smtp-Source: ACHHUZ7yhGDRp4Gk/WQOkClt6ICRB64nKwyctWQ/anZqNBY0MA0lBhqcpFyaAESl0XPJNvcyQO+Rug==
X-Received: by 2002:a05:6214:21ec:b0:623:4ca9:5b25 with SMTP id p12-20020a05621421ec00b006234ca95b25mr3619443qvj.31.1686950076666;
        Fri, 16 Jun 2023 14:14:36 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k10-20020a05620a138a00b00762062998fesm2980484qki.48.2023.06.16.14.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 14:14:36 -0700 (PDT)
Message-ID: <6332d1e4-9758-8545-623f-20ad5808f67f@gmail.com>
Date:   Fri, 16 Jun 2023 17:14:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: Fio sequential I/O request generation
Content-Language: en-US
To:     Peter Veentjer <alarmnummer@gmail.com>, fio@vger.kernel.org
References: <CAGuAWdAyy2yaM4mJ-CprFgg1JEOriom5Dv_xE8jH1qURdce9xA@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAGuAWdAyy2yaM4mJ-CprFgg1JEOriom5Dv_xE8jH1qURdce9xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/17/23 22:39, Peter Veentjer wrote:
> Hi,
> 
> I'm working on io_uring integration for Java and using Fio to get a
> performance baseline. The problem is that Fio is slower than my
> benchmark and hence I do not have a proper baseline.
> 
> Part of my problem is that I don't understand how sequential I/O
> generating works when the io_depth is larger than 1 (I'm testing with
> 64).
> 
> In the first version, I was iterating over the blocks in the file and
> sequentially issuing the requests, and keeping the required number of
> requests in flight. The problem is that this will lead to many
> concurrent and consecutive blocks being scheduled and the Linux I/O
> scheduler will merge many. iostat Confirmed that a huge percentage of
> requests were merged.
> 
> Using iostat I have verified that Fio is not suffering from merged
> read-request or write-requests, so I guess Fio is not using the above
> approach.
> 
> Some other approaches I have tried.
> 
> 1) Split the file into smaller sections and let each stride access a
> portion of the file. E.g. io_level = 64 and a 64 MB file, each stride
> gets a 1MB section of the file.
> 
> 2) Each stride goes over the whole file but starts from a different
> position. With 64 io_level, there are 64 different start offsets.
> 
> The performance I'm getting is still significantly higher than what
> Fio measures so I'm sure that I'm doing something wrong (no apples vs
> apples comparison). But the numbers my benchmark measures are
> consistent with what iostat is reporting: the bandwidth and IOPS do
> match.
> 
> I have included the Fio configuration for completeness:
> 
> fio --name=sometest --numjobs=1 --filesize=4M --time_based
> --runtime=60s --ramp_time=2s --ioengine=io_uring  --direct=1
> --verify=0 --bs=4k --iodepth=64 --rw=read --group_reporting=1
> --cpus_allowed=1
> 
> I'm testing with Direct I/O and using a single thread that is pinned
> to core 1 which does sequential reads and I want to keep 64 requests
> in flight.
> 
> If someone could shine a light on how Fio generates requests for
> sequential reads/writes.
> 
> Regards,
> 
> Peter.

Try running with --debug=io. That will give you more insight into what 
fio is doing.

Vincent
