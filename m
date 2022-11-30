Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BB7C433FE
	for <fio@archiver.kernel.org>; Wed, 30 Nov 2022 19:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiK3TKx (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK3TKw (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Nov 2022 14:10:52 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3441354465
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 11:10:51 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id x18so13041186qki.4
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 11:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9A2LzNw01W+ONGN2kabS/JVJiEEC327OcyGq2mSdMs=;
        b=jyueGJdFLTQuK0W8icsdeELWLW7l2XSEFLmE7Roup0GzS5mJYEq13q6BK6vc8RjqJH
         QkrrQ3XoN8IjshZhKt84GV98dzOzsngf7PGJUgzTmQBCpgOTty5PnuymZP3vm+DNcHFx
         U+MbksJMmgEUQQO55MWHurzGKR3DjuLNuIvwpNC2VhUF9PQicDvVv5hL6l5kgc/qfzLG
         5YB2PeQZjnbmOAXE67a+3tJYGBr8s8rWmPIZjffiYdOuflmDZevVoNPLB9ZTCx6uAw76
         iYeyeHjItSpt/7tbfxCklaeOCiVoMacJesMoyQZGXwd0PSS4iffTxPEi7l5c9N15slCj
         J31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9A2LzNw01W+ONGN2kabS/JVJiEEC327OcyGq2mSdMs=;
        b=ET/g/YJddD1YTl6Iv4XY1t+g+lp+sfRXeZI/4PWNTVSxq+ljCTdnjnVn8V/5KqrQCl
         86AFBs/Mop/2NgMjVVMlNYH9jNum7Tx5L6ipgKSGPmjSYohL/blj8y1dxxN/JYDSpXY5
         4ypMN2rN5Uphos2Lcxh6eBf9Ji7ZkY8O8rttu1VTWIYnqSxLvf2r9kN+gnShveHzp4RZ
         Vp6RufUn/FPs/xMnGB4XB302Q+jmp0cL+0Nx4jJh/XZRWLWCeo3l3GgRWEa9uP/LAwx+
         pNjRh68RwfWzL/iaF5Y0zTmu2pI0H95r28y7vEFG8OoGTKjCQAbWNhKDtwoPaFUaF4uU
         sOwg==
X-Gm-Message-State: ANoB5pkuBklj7hZerWx1mo9NE/OCdy33kzkUQds6nUFiCTIk5GIfG75g
        e6dqqtPvV9AIQVEiAWvBilY=
X-Google-Smtp-Source: AA0mqf64VWKZcNVbRdcaT8+T541IsWLLEtFKqY35I+3fOsQpbemEJuM1x9aufwHw0vhuMPgkIb5q9w==
X-Received: by 2002:a05:620a:2186:b0:6fa:1e56:9b1 with SMTP id g6-20020a05620a218600b006fa1e5609b1mr56555527qka.637.1669835450042;
        Wed, 30 Nov 2022 11:10:50 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id w17-20020a05620a425100b006eef13ef4c8sm1755689qko.94.2022.11.30.11.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 11:10:49 -0800 (PST)
Message-ID: <a927ca77-acc8-874f-f846-268d7a9ac1b9@gmail.com>
Date:   Wed, 30 Nov 2022 14:10:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] io_u: fix offset generation for mix of random and
 sequential workload
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org
References: <20221118051454.31288-1-ankit.kumar@samsung.com>
 <CGME20221118052633epcas5p2c19a4398ff6a9d592eadb7b93f7e5d1e@epcas5p2.samsung.com>
 <20221118051454.31288-2-ankit.kumar@samsung.com>
 <1d29e8c8-ce79-0608-d979-d50bfbc9e112@gmail.com>
 <20221130105053.GA20432@test-zns>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221130105053.GA20432@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/30/22 05:50, Ankit Kumar wrote:
> On Mon, Nov 28, 2022 at 04:57:28PM -0500, Vincent Fu wrote:
>> On 11/18/22 00:14, Ankit Kumar wrote:
>>> Sometimes while running a mix of sequential and random I/O's the
>>> generated sequential offset is outside the I/O region. This usually
>>> happens if the previous I/O is the last block in the region and
>>> thus results in this sequential I/O's offset to be just outside the
>>> region.
>>> With this fix, fio generates a random offset within the I/O region.
>>>
>>> This fixes #1486
>>>
>>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>>> ---
>>>    io_u.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_u.c b/io_u.c
>>> index 8035f4b7..e49b1b29 100644
>>> --- a/io_u.c
>>> +++ b/io_u.c
>>> @@ -432,8 +432,11 @@ static int get_next_block(struct thread_data *td,
>> struct io_u *io_u,
>>>    				*is_random = false;
>>>    				io_u_set(td, io_u, IO_U_F_BUSY_OK);
>>>    				ret = get_next_seq_offset(td, f, ddir, &offset);
>>> -				if (ret)
>>> +				if (ret || offset >= f->io_size) {
>>>    					ret = get_next_rand_block(td, f, ddir, &b);
>>> +					offset = -1ULL;
>>> +					*is_random = true;
>>> +				}
>>>    			}
>>>    		} else {
>>>    			*is_random = false;
>>
>> This patch causes a regression with a workload such as:
>>
>> fio --name=test --bs=4k --filesize=32k --nrfiles=10 --number_ios=10
>> --file_service_type=sequential --percentage_random=50 --rw=randread
>> --randrepeat=0 --ioengine=null --debug=io
>>
>> Only the first file will be accessed when this patch is applied. Bad offsets
>> are needed in order to trigger the move to the next file.
>>
>> Here is a related issue: https://protect2.fireeye.com/v1/url?k=9f1fdb0c-fe94ce3a-9f1e5043-74fe485fffe0-0f0dbb3b9fc8b673&q=1&e=c35fdef7-d5f7-487d-b2e8-9f36779622fe&u=https%3A%2F%2Fgithub.com%2Faxboe%2Ffio%2Fissues%2F1372
>>
>> Perhaps the right thing to do is to limit the offset >= f->io_size check to
>> cases where nrfiles = 1 as in the patch for issue 1372.
>>
>> Also, it seems to me that if we are intending to generate a sequential
>> offset for this case and succeed in doing so, we should just wrap around to
>> the beginning of the file instead of choosing a new random offset.
>>
>> In general we have an overwhelming set of ways to generate offsets and
>> little automated testing for offset generation. In the long run we should
>> develop a set of tests for offset generation that exercise the different
>> options. This will help us detect issues and give us confidence that future
>> code changes won't introduce regressions.
>>
>> Vincent
>>
> Ok thanks for pointing out, adding the nrfiles == 1 check should suffice.
> 
> I thought about changing the current sequential offset generation logic but
> its used for a lot of things as you pointed out. Modifying it may create
> further regression.
> 
> One such case is with zone block devices when zone capacity is less than
> zone size. Currently if we don't limit size by specifying io_size or
> number_ios or runtime, fio will exit early without transferring size bytes
> of data as it generates a bad offset i.e. offset outside the I/O region.
> This is because of holes or gaps between a zone end and start of next zone.
> All the test cases in t/zbd/test-zbd-support takes account of that.
> 
> There is another case with gaps ex: with workload such as "rw=read:4K"
> where fio will exit early without transferring size bytes of data. I am
> not sure whether this is the correct behavior.
> This will only happen if file size is bigger than f->offset + f->io_size
> i.e. we never reach the end of file, else it will wrap around.
> 
> I think to handle all these cases and percentage_random workload, for
> multiple files is going to be tricky.
> 
> One solution I can think of is to just update the documentation for "size" by
> mentioning that runtime can also get reduced if there are holes or gaps
> while doing sequential I/O's, or if we have mixture of sequential or random
> workload which can generate an out of I/O region offset.
> 
> Ankit
> 

Ok. It seems like what is happening in 
https://github.com/axboe/fio/issues/1486 is that fio is doing sequential 
I/O, reaches the end of the device, and then decides that the job is 
completed. This is arguably correct behavior. I agree that the right 
approach is to improve the documentation because changing the code to 
catch this special case may be risky. I think the io_size work around 
you provided in the ticket is a reasonable resolution.

Vincent

