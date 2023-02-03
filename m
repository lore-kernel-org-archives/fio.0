Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCB9C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 14:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjBCOLT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 09:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjBCOKt (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 09:10:49 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8DDA9D63
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 06:08:44 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id g8so5456641qtq.13
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 06:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XnIK+DT9M3emGQe+g8rVAMa5dcfdXFrs1tXiXLOIGC4=;
        b=fFoiI66ADn+Jram5hrWz2rux8Trf1fA/pI5VXjGoehABYCoBwKO7qNU/+RSduZdB4Q
         zcT1AOhWerUEhgQV58y9yrEZnOrZmxd1yjoALKhO3VRlP+c8jgEdPCcLz4a8FDedIBtH
         j8QrvMhxCAQ2WARYyLOdA8wqeY5KEEeaOG1v5aw+1Q1GN+MPiJ/GuFYOu6Me/qbFfUMa
         wERqTt6gL701JpnnmbBtf4JqLk2fCYz/wz1XOzvUtU1qZax75UQy206LFzttDs2AGta+
         +3CTy/HAU6+QWdXSml2bt0EaslEncEoXumplrIpE5ZWv3ZPliHofrWMLDNiAiUPlrAWF
         GMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XnIK+DT9M3emGQe+g8rVAMa5dcfdXFrs1tXiXLOIGC4=;
        b=wah2zIjf8iiZ/NpOLVVZOPKOY3QOcgGRSJkbAYcNL/baCpOvNioyRMmX/bElYorzhC
         FmFZ6mz9SFImEa9ccjvmkHwdUtIVhcSPosIGv8ypY0Q1QS5Rmv2k+95M75mdW+slqNUZ
         WC4eq1FusNRXLrhJ0VRCXiQ08eyveruArCWi8XAiF3hi+0/8SbB3AhfYckymyxWIFXjQ
         MT29qqfe/r3qOWt7il244fzwj04xJ2Ar99xbRCGJIYkof8CB+FiWpAyMvCshO+njB63T
         +GArZyKcrFcdUagBy5g5kSQEDD2W65/4Ja4leu/1i2Ey7nwHUHEvRcytkeDILrBMYDac
         chiA==
X-Gm-Message-State: AO0yUKVgDkrc/JLOqlWqYeemn9vx7d5Z6pYYdki4Vf5ijx9Zz6YYAnEV
        IfOwDt8lYLYK1IwzigZ4QC4=
X-Google-Smtp-Source: AK7set91kMmtOYhU8+VwtlmV82HdIxWtYRqSsW5LsEBetCMq3f1tGs33iLNMogP1jIbJQaEs5weBKg==
X-Received: by 2002:a05:622a:120e:b0:3b8:6075:5d16 with SMTP id y14-20020a05622a120e00b003b860755d16mr20240925qtx.56.1675433323113;
        Fri, 03 Feb 2023 06:08:43 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id e18-20020ac86712000000b003b9a505627bsm1575808qtp.79.2023.02.03.06.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 06:08:42 -0800 (PST)
Message-ID: <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
Date:   Fri, 3 Feb 2023 09:08:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/3/23 07:46, Jens Axboe wrote:
> On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>
>> ﻿Use O_RDONLY flag when read is requested on char-type files.
>>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> ---
>>
>> Before this patch: unexpected permission-denial for unprivileged-user.
>>
>> $ ls -l /dev/ng0n1
>> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>
>> $ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>> -size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>> t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>> 4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>> fio-3.33-71-g7d7a
>> Starting 1 process
>> fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>> error=Permission denied
>>
>> filesetup.c | 5 +----
>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/filesetup.c b/filesetup.c
>> index 1d3cc5ad..d77b8ba4 100644
>> --- a/filesetup.c
>> +++ b/filesetup.c
>> @@ -768,10 +768,7 @@ open_again:
>>         else
>>             from_hash = file_lookup_open(f, flags);
>>     } else if (td_read(td)) {
>> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>> -            flags |= O_RDWR;
>> -        else
>> -            flags |= O_RDONLY;
>> +        flags |= O_RDONLY;
> 
> This will break sg like interfaces, where a read is done by writing the command to the char device.
> 
> —
> Jens Axboe
> 

Kanchan, does it work if you run fio with the --readonly option?

Vincent
