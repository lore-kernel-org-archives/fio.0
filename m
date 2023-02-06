Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8003CC636D3
	for <fio@archiver.kernel.org>; Mon,  6 Feb 2023 19:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBFTh6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Feb 2023 14:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBFTh5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2023 14:37:57 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934E1286D
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 11:37:54 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id s10so783553iln.6
        for <fio@vger.kernel.org>; Mon, 06 Feb 2023 11:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gaGXqdBWLVhhvz1zNE1I2dvyh0WBGt4zprAvxG1gB+8=;
        b=zvApf0MsoUtrzJpUYT6fla1A61vhvwqet+nHp9eqWCiYXJzEqbp5vg4Bs5smtNm7mR
         2bhgXkNOKYfaKzBsClleiQjogJuSVAto+9/EErJe7upvYClF7ZIKz7xLcUai8flXYl4W
         OjkLS4SFd6B+AlFKMHnmwQrbY3hb1sw3sPVfrYIMm5Rk59NeFen487YzZWx4NJrWreOd
         mdkDSBOS71f4wKf8V8xWHTMUvkVCkbpJSRcLsNm6rPbP0Nt8oTMC+tkdisyE0/MMygzT
         UkqtG1ZB5Sftc9bu3YP0LoW1aM8o/HiJAk30m2oyqjCY7vs7xPX1qNOfUcYnTlTI+2nP
         nwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gaGXqdBWLVhhvz1zNE1I2dvyh0WBGt4zprAvxG1gB+8=;
        b=6n256HaMKMsYiOl0ldVaFEveKIejBgySXuiR+gROXi0GTYj9sLeNnIaBDxxycbUgp6
         OVKyEaVCwVJz1zEusW+ifb04wsvA4RE9DguHiV8nv8xpfiE2+QzJYsCkSakJ9BhJMQ6T
         YWbOqUbIICRYOIlyH+UezcajnM6g8/Tuz3V9ek7AB/LUi6/2q+znt2QvRBcRzeR0HESi
         iwyYJuBy1+jb9kYgdRYtcTQngKNR+x49etYX9K8AGBnClzEoIboklVoYB0NJrXFWk6Kc
         ozab0UtxAXJgdDLCNPATf9eKNf33zB/zDy1tch7EOD5xwgyQ9xyTL4UNcgBrZS6MgpbH
         QfAw==
X-Gm-Message-State: AO0yUKWE4773iW4h39kox6ijBAjqxS9ig+3IfbZOT28JcrSwCHUc3bGg
        SDBbx+1UtWuJmHogs0128Iv6kQ==
X-Google-Smtp-Source: AK7set9ktRzDmFQ5ZIAizMrJeD+hLNLCHoEJUqnPABQEN21FPCVlQzF3WZ6SGMvuB8lJ/qKZrQzPuQ==
X-Received: by 2002:a05:6e02:1b88:b0:313:c5a4:9888 with SMTP id h8-20020a056e021b8800b00313c5a49888mr372113ili.0.1675712274145;
        Mon, 06 Feb 2023 11:37:54 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m43-20020a026a6b000000b003a058610fc8sm3775379jaf.82.2023.02.06.11.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 11:37:53 -0800 (PST)
Message-ID: <678ee3fe-5408-ca9c-f7f4-dc3134765b06@kernel.dk>
Date:   Mon, 6 Feb 2023 12:37:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
 <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
 <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
 <CGME20230203152620epcas5p1b3d5eb73d4d0f3eeebc01f8a185eca29@epcas5p1.samsung.com>
 <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
 <20230206065251.GA19745@green5>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230206065251.GA19745@green5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/5/23 11:52?PM, Kanchan Joshi wrote:
> On Fri, Feb 03, 2023 at 10:26:15AM -0500, Vincent Fu wrote:
>> On 2/3/23 09:14, Jens Axboe wrote:
>>> On 2/3/23 7:08?AM, Vincent Fu wrote:
>>>> On 2/3/23 07:46, Jens Axboe wrote:
>>>>> On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>>>>
>>>>>> ?Use O_RDONLY flag when read is requested on char-type files.
>>>>>>
>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>> ---
>>>>>>
>>>>>> Before this patch: unexpected permission-denial for unprivileged-user.
>>>>>>
>>>>>> $ ls -l /dev/ng0n1
>>>>>> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>>>>>
>>>>>> $ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>>>>>> -size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>>>>>> t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>>>> 4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>>>>>> fio-3.33-71-g7d7a
>>>>>> Starting 1 process
>>>>>> fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>>>>>> error=Permission denied
>>>>>>
>>>>>> filesetup.c | 5 +----
>>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/filesetup.c b/filesetup.c
>>>>>> index 1d3cc5ad..d77b8ba4 100644
>>>>>> --- a/filesetup.c
>>>>>> +++ b/filesetup.c
>>>>>> @@ -768,10 +768,7 @@ open_again:
>>>>>>         else
>>>>>>             from_hash = file_lookup_open(f, flags);
>>>>>>     } else if (td_read(td)) {
>>>>>> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>>>>>> -            flags |= O_RDWR;
>>>>>> -        else
>>>>>> -            flags |= O_RDONLY;
>>>>>> +        flags |= O_RDONLY;
>>>>>
>>>>> This will break sg like interfaces, where a read is done by writing the command to the char device.
>>>>>
>>>>> ?
>>>>> Jens Axboe
>>>>>
>>>>
>>>> Kanchan, does it work if you run fio with the --readonly option?
>>>
>>> I think we should just make it work. Conceptually, the patch is obviously
>>> fine, it just happens to break some oddball cases like sg/bsg. But maybe
>>> we just add a fio ioengine flag for that, like FIO_RO_NEEDS_RW_OPEN or
>>> something, where the engine can tell us if it needs a writeable open
>>> even or a read-only workload.
>>>
>>> Then generic_file_open() can use O_RDONLY for td_read(), except if the
>>> engine has FIO_RO_NEEDS_RW_OPEN set.
>>>
>>
>> Kanchan, can you try the diff below? It's also available at https://protect2.fireeye.com/v1/url?k=37173803-566c928b-3716b34c-74fe4860018a-aac6167af74310c3&q=1&e=3e678cf7-7d3f-487a-8a94-a9f0b41ca778&u=https%3A%2F%2Fgithub.com%2Fvincentkfu%2Ffio%2Ftree%2Frwopen
> 
> Tried, this works, thanks!
> The patch looks good. Seems this flag can be added to libzbc engine too.
> That also treats the the char-type open in the same way.

Thanks for testing - I've added it for libzbc as well.

-- 
Jens Axboe

