Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86BFC433F5
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 23:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiDFXvl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 19:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbiDFXvk (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 19:51:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661594666F
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 16:49:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id s2so3932335pfh.6
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 16:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Jq1v/OzS7ZWRoSjS1Nan4Xzxu2cWMqUrwFWgtHiJj7A=;
        b=rloe4fmr0q3+Rf/UJQ6LlYx3Y7YRJ5U9RLhKJsk5VBobM33KG6aLCd+WBO0XEnIMUb
         eev8kUXbESr7DmrsNewW7rJZwgg2fVYdhuZfMO/Qf0SYRvgcWVDhvq12UbOL66nz8OzI
         vtEznC3pCHvJFeMQUY3x/ZaLybituuDyMmsAfF8DAfKr44Wj27T+Luerhh3fYUfcLhT8
         VaqGhKg9zGjMHtLlJSDFZLmRaKpp17R8bL1EnhCjqpM7/ch0FvArnQh7NK/dnNu5aMEj
         ihlaRPZE5y85xuagHDRKS4VrkBIJphIApoD4+roHOAM87/+3JS2MFTwObRmTGB/gwal7
         yZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jq1v/OzS7ZWRoSjS1Nan4Xzxu2cWMqUrwFWgtHiJj7A=;
        b=NuhNAMiRnKODjTlo3TbPiOjdxuRbvEnWk3Nu0Mk7dBB68TrDoWZOs2cZgj3z/f2KhV
         WSdGCgxilNZb6mDWPey2FuE6Oa5qNfk0xn/gL2HJCXZOj48ktoAzhQ/MmpxBVFpdtaGu
         Atr6SyZd3weAsZ/gsQIYUSyk+5GXBqnXbjZt/P44WwhDc95tdKYWsyCnSk/2593ZyeYk
         BBQvhD83Vgoj2qKgmWjwdUayuHHBOOQsUs7+lZ5iWySvFh8w8EzxATUmZLRJ5Mf5zilC
         9uOVKCXMV7oRyslhMzpSGHoGilocju3/xpWdUwI8kskVy1WZ6AdlCwWBApJ9MqzKVc7I
         nTWw==
X-Gm-Message-State: AOAM5302AN5v0e+DEjtUrtVKPCJcTFSqrt/apFEXyBqQ4ZiRAwaTb/JV
        61L4yM8XbYnXJa4uDw8gabjBRoqHlUaEsQ==
X-Google-Smtp-Source: ABdhPJz+X7ePLefyl2d9+Ixaxh4bSNfcuDvW7szhAXcnqocwxSmb8A57YJtV1GoGdZ2AA3Dp+ztANQ==
X-Received: by 2002:a63:b14:0:b0:399:26d9:98d8 with SMTP id 20-20020a630b14000000b0039926d998d8mr9249300pgl.263.1649288980527;
        Wed, 06 Apr 2022 16:49:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm19616317pfe.186.2022.04.06.16.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:49:40 -0700 (PDT)
Message-ID: <0ad758ef-5213-3fd6-0a69-0c6640f3882d@kernel.dk>
Date:   Wed, 6 Apr 2022 17:49:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Logging and its significant impacts on performance
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVToftFmBMWRNRfp_N2k-+wicyfAOfS8vSy+x77LDjj0-uw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADqNVToftFmBMWRNRfp_N2k-+wicyfAOfS8vSy+x77LDjj0-uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/10/22 12:47 PM, Nick Neumann wrote:
> I had switched to doing per_unit (every sample) logging recently in
> order to work around some issues I was hitting with using
> --log_avg_msec.
> 
> After looking at my results, I could see a significant decrease in
> maximum and average bandwidth during runs. So I started playing with
> disabling other aspects of logging and was really surprised by the
> effect, running a 60 second random write test after an nvme format and
> 10 minutes of idle. I repeated the experiment many times to make sure
> it wasn't just noise.
> 
> With a 970 Evo 1TB, I saw the following results:
> --log_avg_msec=100, all latency/latency percentile options disabled:
> max bandwidth 1.04GB/s, avg for run 0.99GB/s
> --log_avg_msec=100, all latency/latency percentile options enabled:
> max bandwidth 1.00GB/s, avg for run 0.94GB/s
> no log_avg_msec, all latency/latency percentile options enabled:
> max bandwidth 0.95GB/s, avg for run 0.91GB/s
> 
> Between the best and worst performance is on the order of 100MB/s of
> bandwidth. Is this surprising at all, or expected with fio?

It's certainly not unexpected. The higher the granularity of logging,
the higher the cost. This is particularly evident if you're using
smaller block sizes, and hence higher IOPS.

-- 
Jens Axboe

