Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B791AC636D4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 14:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjBCOQS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 09:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCOPw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 09:15:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86D01B313
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 06:14:54 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id n13so5322743plf.11
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 06:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZB8BGcwnv2Qtxt2eYO8HkkJ4ZDDMCOg+8nq57OfC9KI=;
        b=6c5I6gw33URevznzSu8h78oq1jpJ+Z4ejafQkHln6RqmW+a0RW6Z/nZf+gx8fNOg8c
         FTDs+CYuupmR9tRgMa/bVe5zKuTejp0jRrom5WhupFwLWoKiGyMR+Omt7NsYdSqlnSe4
         Nc4gi8kbOMMeau8ecsRgWr+LcPt5fmggL2sBUU5LaaP4INjdb09VT0HWGi1fYgHxoi34
         0lVlksTIow2rnP9OURMMryVCK+DaR7T9e6OzSJ7Bpa7ixZCOh9vItblCRuYEeAqcd1Yd
         ktzc4umrF3AmOfEBCJKnUIK8MYRBjrXUAUilILkV8TGeDy9rcdQxq00F1ziRkCf8YZzo
         7Xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB8BGcwnv2Qtxt2eYO8HkkJ4ZDDMCOg+8nq57OfC9KI=;
        b=wONwFi0JFMkgWleekjXuYd6krBTrYutrJQdK/XyLN3L6UU4BelfG0MG8OwT/xUKxeC
         zDCndpmxOA6NTR3I9M+Eyv/ELlBo/sMXwpC+TABdj/MCeW1P87EuHDcZcNwcSwuHpnXZ
         VvLeYx2IADYeuSRhkvCQAyIeLMNaurHIwR1SGpq193/u6MwGuzRy6fSLU5FGqHG4KXXV
         SdyBGq7Vmy4I/X1U6VQOTHkk743Qw/OtrXh9HFkjbehqUZEykTjMIWiSnc6eWde8jjkC
         VBuj6n9MEBDf1Q0bbsHmjo9niUPtSRJzdj2Sg8lIaQu+J3eLRyytCS0BW2m8KElC5+MV
         YO1g==
X-Gm-Message-State: AO0yUKUhwkgbr0sug4Y+mugAxTKM4Kma8VKN2+cAJ8C/RjixmN38n3Ck
        VeuEXqjJ0FhA6EZnnFqtqOt6q+rPNAvtE30l
X-Google-Smtp-Source: AK7set/+2HxaO4WbFaf96J/N7yI+mE/f+CI8IydZ51KulBWmOfcvYO+jlgcCXO0XmOh9iYnXqa7eyA==
X-Received: by 2002:a17:902:cecb:b0:196:86c2:ee89 with SMTP id d11-20020a170902cecb00b0019686c2ee89mr12069450plg.3.1675433694339;
        Fri, 03 Feb 2023 06:14:54 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902ead400b001960096d28asm1675275pld.27.2023.02.03.06.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 06:14:53 -0800 (PST)
Message-ID: <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
Date:   Fri, 3 Feb 2023 07:14:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
 <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/3/23 7:08?AM, Vincent Fu wrote:
> On 2/3/23 07:46, Jens Axboe wrote:
>> On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>
>>> ?Use O_RDONLY flag when read is requested on char-type files.
>>>
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> ---
>>>
>>> Before this patch: unexpected permission-denial for unprivileged-user.
>>>
>>> $ ls -l /dev/ng0n1
>>> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>>
>>> $ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>>> -size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>>> t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>> 4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>>> fio-3.33-71-g7d7a
>>> Starting 1 process
>>> fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>>> error=Permission denied
>>>
>>> filesetup.c | 5 +----
>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/filesetup.c b/filesetup.c
>>> index 1d3cc5ad..d77b8ba4 100644
>>> --- a/filesetup.c
>>> +++ b/filesetup.c
>>> @@ -768,10 +768,7 @@ open_again:
>>>         else
>>>             from_hash = file_lookup_open(f, flags);
>>>     } else if (td_read(td)) {
>>> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>>> -            flags |= O_RDWR;
>>> -        else
>>> -            flags |= O_RDONLY;
>>> +        flags |= O_RDONLY;
>>
>> This will break sg like interfaces, where a read is done by writing the command to the char device.
>>
>> ?
>> Jens Axboe
>>
> 
> Kanchan, does it work if you run fio with the --readonly option?

I think we should just make it work. Conceptually, the patch is obviously
fine, it just happens to break some oddball cases like sg/bsg. But maybe
we just add a fio ioengine flag for that, like FIO_RO_NEEDS_RW_OPEN or
something, where the engine can tell us if it needs a writeable open
even or a read-only workload.

Then generic_file_open() can use O_RDONLY for td_read(), except if the
engine has FIO_RO_NEEDS_RW_OPEN set.

-- 
Jens Axboe

