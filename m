Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCACC636D4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 16:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjBGQdU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 11:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjBGQdR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 11:33:17 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB103E621
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 08:33:15 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r6so5863459ioj.5
        for <fio@vger.kernel.org>; Tue, 07 Feb 2023 08:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oLABXqI+4qLxZc+OPYZbtFU5hbh6iaTE/cm2SFnut4s=;
        b=yz+YjaNayP4O0GNCMZtxnbboDbxqh5RBg31MlZ1IpeX5MExiipE8I9qWQD6Yr9unNO
         jSJY9625EPK1tm9oCuIvtA1gA5r5KvbjJi+oUXcGvGxF3+6CXvplG26dK1W3z17os/Hy
         xpEV55usojGEkPW4Tvl38MV2Lqkb5UBMDyQgQynTziDs/3nUGu7+gz0PXXAk1L1utfgQ
         IDwz8CxBg91Wtc/BhOaWaRXCteZAZWQMC+lvqusJ1k/AMehjWBMPsIUpwbA7ERXQfQb8
         pGBXCaF0m+yDrPYP/mJT61/DEKzFwByVtEmWkwBZaBZRdWlyKYWJMIZpTxkpNsrm4DUy
         Pr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLABXqI+4qLxZc+OPYZbtFU5hbh6iaTE/cm2SFnut4s=;
        b=OAE6/dJZJ/ZzjpzbLCrbYlPmKSKNDdJHlFfPNzCq6v1iiAaURviajNDweuUcpbeeIi
         r75FutUj7OIURsTJLjbvez65Vaj0M1e7ygD9ALC/fjGAj/RO+D+OzLQmfKq0T8mrpFTk
         2PP1SlfbTmFaawoQ9ZHEHAN0UJ/l0vUYxbcY4FF8ofOFdZwlii+4ePdvhSHlbzMYLBlU
         toswMj76dSBtj7emK0OBtgZUWzI8yRYCxLx+sDb7cilTMXJIty7JOnnL433sT8d0cUSA
         IlF7Bho0DKzDawDyP/XB60qGFx+knwQ+N4uP86d1bDKGlOll1AAbqPv5H9oz+hE6Sd5d
         U9fw==
X-Gm-Message-State: AO0yUKXU3gQPVYnbNedyAN0efxWwZ+PREK0pHvoqqv0JJxQRV8ocKGx/
        6QglsbmOIUixSUqelzYKvXj26A==
X-Google-Smtp-Source: AK7set+CRdDCGLsStBUB+2kUk7idAB0UOuv8Hqd97eJ15kuWIEYyd7FePSdt5vAdVPZZT2DSRN9X1w==
X-Received: by 2002:a6b:ed05:0:b0:716:8f6a:f480 with SMTP id n5-20020a6bed05000000b007168f6af480mr3195850iog.0.1675787594990;
        Tue, 07 Feb 2023 08:33:14 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v11-20020a05663812cb00b003b77432cc37sm3500931jas.106.2023.02.07.08.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 08:33:14 -0800 (PST)
Message-ID: <73b2a3f0-286c-20c9-443a-22fc5e2ab1ed@kernel.dk>
Date:   Tue, 7 Feb 2023 09:33:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
To:     Vincent Fu <vincentfu@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
 <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
 <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
 <CGME20230203152620epcas5p1b3d5eb73d4d0f3eeebc01f8a185eca29@epcas5p1.samsung.com>
 <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
 <20230206065251.GA19745@green5>
 <678ee3fe-5408-ca9c-f7f4-dc3134765b06@kernel.dk>
 <b3369a19-0eb6-d9f3-4fcb-23fe9c6a87cc@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b3369a19-0eb6-d9f3-4fcb-23fe9c6a87cc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/7/23 9:16?AM, Vincent Fu wrote:
> On 2/6/23 14:37, Jens Axboe wrote:
>> On 2/5/23 11:52?PM, Kanchan Joshi wrote:
>>> On Fri, Feb 03, 2023 at 10:26:15AM -0500, Vincent Fu wrote:
>>>> On 2/3/23 09:14, Jens Axboe wrote:
>>>>> On 2/3/23 7:08?AM, Vincent Fu wrote:
>>>>>> On 2/3/23 07:46, Jens Axboe wrote:
>>>>>>> On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>>>>>>
>>>>>>>> ?Use O_RDONLY flag when read is requested on char-type files.
>>>>>>>>
>>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> Before this patch: unexpected permission-denial for unprivileged-user.
>>>>>>>>
>>>>>>>> $ ls -l /dev/ng0n1
>>>>>>>> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>>>>>>>
>>>>>>>> $ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>>>>>>>> -size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>>>>>>>> t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>>>>>> 4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>>>>>>>> fio-3.33-71-g7d7a
>>>>>>>> Starting 1 process
>>>>>>>> fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>>>>>>>> error=Permission denied
>>>>>>>>
>>>>>>>> filesetup.c | 5 +----
>>>>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/filesetup.c b/filesetup.c
>>>>>>>> index 1d3cc5ad..d77b8ba4 100644
>>>>>>>> --- a/filesetup.c
>>>>>>>> +++ b/filesetup.c
>>>>>>>> @@ -768,10 +768,7 @@ open_again:
>>>>>>>>          else
>>>>>>>>              from_hash = file_lookup_open(f, flags);
>>>>>>>>      } else if (td_read(td)) {
>>>>>>>> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>>>>>>>> -            flags |= O_RDWR;
>>>>>>>> -        else
>>>>>>>> -            flags |= O_RDONLY;
>>>>>>>> +        flags |= O_RDONLY;
>>>>>>>
>>>>>>> This will break sg like interfaces, where a read is done by writing the command to the char device.
>>>>>>>
>>>>>>> ?
>>>>>>> Jens Axboe
>>>>>>>
>>>>>>
>>>>>> Kanchan, does it work if you run fio with the --readonly option?
>>>>>
>>>>> I think we should just make it work. Conceptually, the patch is obviously
>>>>> fine, it just happens to break some oddball cases like sg/bsg. But maybe
>>>>> we just add a fio ioengine flag for that, like FIO_RO_NEEDS_RW_OPEN or
>>>>> something, where the engine can tell us if it needs a writeable open
>>>>> even or a read-only workload.
>>>>>
>>>>> Then generic_file_open() can use O_RDONLY for td_read(), except if the
>>>>> engine has FIO_RO_NEEDS_RW_OPEN set.
>>>>>
>>>>
>>>> Kanchan, can you try the diff below? It's also available at https://protect2.fireeye.com/v1/url?k=37173803-566c928b-3716b34c-74fe4860018a-aac6167af74310c3&q=1&e=3e678cf7-7d3f-487a-8a94-a9f0b41ca778&u=https%3A%2F%2Fgithub.com%2Fvincentkfu%2Ffio%2Ftree%2Frwopen
>>>
>>> Tried, this works, thanks!
>>> The patch looks good. Seems this flag can be added to libzbc engine too.
>>> That also treats the the char-type open in the same way.
>>
>> Thanks for testing - I've added it for libzbc as well.
>>
> 
> The new flag only affects generic_file_open() but the libzbc ioengine
> has its own file open function. So the flag has no effect.

That's a good point, not sure how I missed that when I explicitly
checked sg for it last week...

> Moreover libzbc uses the SG_IO ioctl even for character devices. So
> the code in libzbc_open_dev() (copied from generic_file_open) that
> opens character devices with O_RDWR is actually unnecessary.
> 
> I've committed some patches to tidy things up.

Thanks!

-- 
Jens Axboe

