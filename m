Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F030FC77B7C
	for <fio@archiver.kernel.org>; Fri, 12 May 2023 18:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbjELSda (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 May 2023 14:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238565AbjELSd2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2023 14:33:28 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A14E719
        for <fio@vger.kernel.org>; Fri, 12 May 2023 11:32:57 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-76c6ba5fafaso20107739f.1
        for <fio@vger.kernel.org>; Fri, 12 May 2023 11:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683916369; x=1686508369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q+gNdXMlp4+hyhV77BiQItFnY4/TUihTnyB4wD/Swy0=;
        b=L6suWHCzI+64kfgEEGGvsLmIZJ+XNU3oKLiBNI/g5TH9eMZQ9HgQApw471/jFJJleM
         VK+UOujxrFUMGYQEzHE1EmGph5eGpxKzkZ6GzLJjR8y6JCf1M1MXT8ujIeHanKrNgBT7
         fCaLtV7LRyGM0ZfluDgfOhuRsg2T0nQRLg2BmNostzY2RW2dPJucMlc+QId8bhnSQkFH
         +bFztCdw2gg9ZBHx7awMBnBSs2I+O1T7mpGw8oy49m7Jsn7bz5PblMGSj4qD/uvIIKPi
         8NLmFt8OCM2rYfxzytsR9VE3m3pyEM4hGO/LUDKjV6DUc1+L3/fZWVNw+lPxxQiZjs+/
         M4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683916369; x=1686508369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+gNdXMlp4+hyhV77BiQItFnY4/TUihTnyB4wD/Swy0=;
        b=MhjYmQlMyYxo6Mr/3oECXTRjk5mbqXYOVADRx8uS/L0PytBGwzba8nNdH84y7NlAdP
         JgQZXvgXzOwvlOuD2vC3BHEOPdwNbZy9UAQAuExJTOu4Da7HYAR3gRADhQelJmf1fNIY
         nCrCHCaW8g8NXkMK8zX+PQ7jNngCDB6eb8tXU/jZVxDQyYABL6UswQ/0fCEss596Yj4z
         qDMqLc8HRD+ROrt6mwgb7hZdeiBZQsAG0FGKjXmkvfxtkj0plqtcIJ8skdCxU7QWOMFA
         CdOATcdKvkdXxcxf49UtT9wax5uTy0IADDIx9xr187HuUvmYSgVGD4d2vA0HWJjsvClB
         ML+A==
X-Gm-Message-State: AC+VfDyHtCiK/Nxu6NxT9g6Qv57udqx+oIU/uYj/YxgeV4Y1bV7fU8b7
        MN0MJFahIUIvxCcAc8adRV9xdg==
X-Google-Smtp-Source: ACHHUZ5+GwfAd2WboTf7Bl9Qcmq+0f9kYO5+viTMEy/vOZGTLngtxZky2660iY7tPY0Us2WEmidglA==
X-Received: by 2002:a6b:8d8c:0:b0:76c:77b9:b82e with SMTP id p134-20020a6b8d8c000000b0076c77b9b82emr3728722iod.0.1683916369172;
        Fri, 12 May 2023 11:32:49 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t10-20020a056638348a00b0040faf78330asm5342402jal.28.2023.05.12.11.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 11:32:48 -0700 (PDT)
Message-ID: <5dfd99af-bd44-4d55-fbbe-1b0a68ee9b15@kernel.dk>
Date:   Fri, 12 May 2023 12:32:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] engines/io_uring: io_uring_cmd engine cleanup and
 fixes
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, joshi.k@samsung.com
References: <20230508160118.25334-1-ankit.kumar@samsung.com>
 <CGME20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73@epcas5p1.samsung.com>
 <20230508160118.25334-2-ankit.kumar@samsung.com>
 <a91da230-b6ad-8177-37e1-0b7d3b8aead3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a91da230-b6ad-8177-37e1-0b7d3b8aead3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/12/23 10:47?AM, Vincent Fu wrote:
> On 5/8/23 12:01, Ankit Kumar wrote:
>> - The io_uring_cmd ioengine assumes that logical block size is power of 2.
>> In case of extended LBA where metadata is transferred as part of LBA
>> this is not correct. Use division operation for that. The existing
>> calculation for power of 2 LBA remains the same.
>>
>> - The current implementation doesn't support protection info and
>> metadata transferred as separate buffer, return error for these
>> scenarios.
>>
>> - Add checks to verify that block sizes are multiple of LBA size.
>> - Add support for 64 LBA formats as per the latest NVM command set
>> specification.
>>
>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> 
> Ankit, overall this looks fine.
> 
> Consider splitting this patch into two separate ones:
> 
> 1) add support for extended LBA sizes
> 2) add support for more than 16 LBA formats

Exactly, that was going to be my comment too. If you need to make
paragraphs on what changes are being made, that's a clear sign that they
should be separate changes.

-- 
Jens Axboe

