Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C47C433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 12:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiE0Mkm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 08:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352342AbiE0Mjv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 08:39:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43F4A3DF
        for <fio@vger.kernel.org>; Fri, 27 May 2022 05:24:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 202so4248112pfu.0
        for <fio@vger.kernel.org>; Fri, 27 May 2022 05:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5J/WJdTxN8YdazQiFT+uyF4YaOfETSV56YcJ5/JwyXQ=;
        b=Uw+S+pfSSR4TJO1nl6IH2rMcFbpC0H85T9i+KfQHsd5liL0RzNBCzk/b2KC06bLAdG
         VAKamGsdsSlKS9KHgAUxjOjgvQcBIvNa6YNSGHFluaVczHblnt9J90nb9BbKpV9njJmq
         ci1hR5KG4XxccYDQEzL3npMHLPF1W09ZSgRfxfXGfkWGRCd4qUWteb85vWPtkFs7DcGz
         xKgWKhIJ0hyzHA8K8H3LfI4t6GuNZMoCw/mOSlo/V02huTI7R/IRFmc6FesJnOAI1PPB
         Q5kO71wL6K7BmDT3GIVBomu+AFeePPbBy4zXYLekyYpB5hmAhJilBgC/mOmp51z/AN9A
         1N/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5J/WJdTxN8YdazQiFT+uyF4YaOfETSV56YcJ5/JwyXQ=;
        b=FFpr0PCdK/PN74slbx1t0E0uhcO7xSJqNaQy5RS6SGuc/GTJ25KD4ibiIkeOHZPq62
         oVts/ZndOlYhyJm+LUx7h4P7OZs0mt16IDS2z4FDvbONdcBA8Hm08XLLwD0NvDT5jghk
         pF/tcNibJLG5ccc4tdVp8J2wpm5VlZ3BTj6EETD3dkH1ifiH4vaOknTK6ybejDNnTOwN
         m28DrRsMAiafMDdRX/eXfRYPoVWO1XxxtUzHwcLv4BFgCVA4EE+h7dVHizunU93dToTr
         cSWtygV4A0ime0PhUbv6DoEOzOkq8t9UgXRmKQYC0c6RVtiE8+bhzU/nW6bZILWe7VAT
         JVmA==
X-Gm-Message-State: AOAM531KV1WGb50RwRnnDhudV+h56/qB+mElc3Usja7Lt5hFVn4mRcnu
        RYqR2Jdit2/DRybhLAzJiP7MNQ==
X-Google-Smtp-Source: ABdhPJy2nt9BVXelUu8026wD5/wZaYKT/mK4heg3iAkqhpPxofrqOdkO2a4VqVqjxv95cpayDL9ubA==
X-Received: by 2002:a63:2026:0:b0:3fa:cefb:e408 with SMTP id g38-20020a632026000000b003facefbe408mr12659555pgg.57.1653654283067;
        Fri, 27 May 2022 05:24:43 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v21-20020a170902e8d500b00163506d51e7sm3518554plg.125.2022.05.27.05.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 05:24:42 -0700 (PDT)
Message-ID: <2ac8deb0-6de9-7f85-9b90-cfb53dac8561@kernel.dk>
Date:   Fri, 27 May 2022 06:24:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, anuj20.g@samsung.com
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
 <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
 <20220526144809.14877-4-ankit.kumar@samsung.com>
 <20220527072947.GA16232@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527072947.GA16232@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/27/22 1:29 AM, Kanchan Joshi wrote:
> On Thu, May 26, 2022 at 08:18:04PM +0530, Ankit Kumar wrote:
> 
>> +void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>> +                 struct iovec *iov)
>> +{
>> +    struct nvme_data *data = FILE_ENG_DATA(io_u->file);
>> +    __u64 slba;
>> +    __u32 nlb;
>> +
>> +    slba = io_u->offset / data->lba_size;
>> +    nlb = (io_u->xfer_buflen / data->lba_size) - 1;
>> +
>> +    memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> 
> Is this better or setting remaining fields (which are not populated
> down) to zero.

Since lba_size is a power of 2, it would be a lot more efficient to take
this division by non-constant out of the fast path and init a shift
value:

data->lba_shift = log2(data->lba_size);

and change these to:

slba = io_u->offset >> data->lba_shift;

and ditto for nlb.

>> +    /* cdw10 and cdw11 represent starting lba */
>> +    cmd->cdw10 = slba & 0xffffffff;
>> +    cmd->cdw11 = slba >> 32;
>> +    /* cdw12 represent number of lba's for read/write */
>> +    cmd->cdw12 = nlb;
>> +    if (iov) {
>> +        iov->iov_base = io_u->xfer_buf;
>> +        iov->iov_len = io_u->xfer_buflen;
>> +        cmd->addr = (__u64)(uintptr_t)iov;
>> +        cmd->data_len = 1;
> 
> Is this correct? Do we always get 1 vector to deal with.

Yes

-- 
Jens Axboe

