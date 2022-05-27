Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66636C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 18:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349982AbiE0SFj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 14:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiE0SFj (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 14:05:39 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D11EC334
        for <fio@vger.kernel.org>; Fri, 27 May 2022 11:05:37 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q203so5462636iod.0
        for <fio@vger.kernel.org>; Fri, 27 May 2022 11:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XGtaCLqnZv1WFiUrDUOBC7iLUphVyTJEHGC2o1+VDaU=;
        b=HLSZod5caW2mu87JKNJ5RxTPZJwnhq2cnSJyVY71FXQ/tqzjDibF8cBh08EyCiy8p1
         QdOSlZRvcEB3mPbCMtxAkvY25CfxOR65ykWwxoXWL0e8LFwZBH9pOduIoFLPfFpCjIZJ
         sc0DzHJgJ3PSbT2Vhj6v8X+VDdLqKEhS/A5eQJgHw71v6X1Kqm/GEoO4xUt949/Giuf+
         XlpJfPGOWbDWrJCzbz1gy31PFcWVJwi5PMhAGMalADmnDF566YYZhEccItQmmkTTcsl1
         Lznpgw6bwpoPgAJ+bMy6YOofG1YpUHdpLBs9tHo0Ujl0dkl7Ia6hX19eulyjhMJPb+s+
         VgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XGtaCLqnZv1WFiUrDUOBC7iLUphVyTJEHGC2o1+VDaU=;
        b=c1gWiSzmbX1lKVGO8n4ZOs+zt1zvwSwUmfMy4iKtC8nIAqEvZalmzJsBFoimfqhkQC
         BV8CvZQC0K1aq/eaaAr4d1JRKbA8z2a6dChIEp9aMpS1pOCIGN1UayYx9PRmwnJNPRRV
         PLf4S+N5/TSDelfm/VJGfR3pbfn9gU39WWLH7Wbb3IsmZxje1TYF36PTFFKNTm2DNLLK
         4t4i4TuKnMWxkBYgH3l088zV+g5rWigapE1jkBFj98sRaf4qvWERq2Cn9d0JifPegGDU
         nkGQfCK/u6Enbc89Wh1PAuErV+amt7lJwBeyYAywK03g1Kl+5yfK6c2gtioqwSMrfAdk
         SCXQ==
X-Gm-Message-State: AOAM5322Bt91o1YWVNhDfdJO4txqrrvDV/UV8ZYv9PucNjvZnVA6p2j4
        PZFUxBO6omwU5jRk4+qA+0xawQ==
X-Google-Smtp-Source: ABdhPJyAGEbesMuIliMMMW7UUxnT4HByjahTbQPS4fFlRQWjl3TItDiHtq2Saw2fnYtP8F7K7RNbcg==
X-Received: by 2002:a5d:9f42:0:b0:654:9a2b:cab1 with SMTP id u2-20020a5d9f42000000b006549a2bcab1mr19853503iot.89.1653674736722;
        Fri, 27 May 2022 11:05:36 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m6-20020a92cac6000000b002d1883dc283sm1405027ilq.78.2022.05.27.11.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 11:05:35 -0700 (PDT)
Message-ID: <9f503041-380a-2e62-cf0e-96f42fbf9147@kernel.dk>
Date:   Fri, 27 May 2022 12:05:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 8/8] examples: add 2 example job file for io_uring_cmd
 engine
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
 <CGME20220526145406epcas5p255f21b413d5dd504ff415bb38577200b@epcas5p2.samsung.com>
 <20220526144809.14877-9-ankit.kumar@samsung.com>
 <3f857eda853f4c4187482a6695e6a025@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3f857eda853f4c4187482a6695e6a025@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/27/22 11:30 AM, Vincent Fu wrote:
>> -----Original Message-----
>> From: Ankit Kumar [mailto:ankit.kumar@samsung.com]
>> Sent: Thursday, May 26, 2022 10:48 AM
>> To: axboe@kernel.dk
>> Cc: fio@vger.kernel.org; krish.reddy@samsung.com;
>> joshi.k@samsung.com; anuj20.g@samsung.com
>> Subject: [PATCH v2 8/8] examples: add 2 example job file for
>> io_uring_cmd engine
>>
>> From: Anuj Gupta <anuj20.g@samsung.com>
>>
>> examples/uring-cmd-ng.fio has usage for conventional nvme-ns char
>> device
>> examples/uring-cmd-zoned.fio has usage for ZNS nvme-ns char device
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> Co-authored-by: Ankit Kumar <ankit.kumar@samsung.com>
>> ---
> 
> A minor nit: consider putting ioengine=io_uring_cmd and cmd_type=nvme
> directly in the job file.

Seconded - mixed job files generally only make sense for some kind of
testing framework, the example job files should be runnable directly
without using any args of environment variables.

-- 
Jens Axboe

