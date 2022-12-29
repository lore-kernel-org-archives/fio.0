Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBACC3DA7A
	for <fio@archiver.kernel.org>; Thu, 29 Dec 2022 21:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiL2VM5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiL2VM4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Dec 2022 16:12:56 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1DC12745
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 13:12:51 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h26so15910573qtu.2
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 13:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Re8sd6G6daFTIqQjNe+RNtbU/WWr4MFwetbvybbZOA8=;
        b=Bw4fPadQ1xDIds42Beivk7D7v2K/G5Kw6UzNL4jzRjuwJ0qPA/bOFgaB5HR/3V3wkX
         vFIpr9L5AsxYiPMOKvunkZ+jJdGgyziZp7gIsOCydJ0RwRUexh0ngV0oR1JB7i9sJAwS
         QDmCq3CeVc+WcicCIUpWc4BK9/ITmC9qD/J79AYXB5JWpN9mSZKEud3QwAQp5KfyPOVN
         evu7BpzjjGDiVa7TXf6hWdPTMsHHo63vxjSVQoCviIGg7miQjDM42PYUWKPq2NHzgqUE
         s3yKpNF3Eiafy3YNLB4na2AMy7CKnUGt01EHKb3KJBEdVblkmlVK4E0SJ4FRzuieW4m+
         ooZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Re8sd6G6daFTIqQjNe+RNtbU/WWr4MFwetbvybbZOA8=;
        b=Dpog9unvChQgnWnV8iQfwu3TFMnW0J+h2yxAHxjXCiQMq02Z69x9uRSLgREdMJErco
         KuKCyELcgDYArLFbIxTsXCP4fQbbzdmUMNNvW0OaGC77LIKGWMXdTkyY2LfQDZrw+Qz8
         m6iIy948MP573lcfKX0lDItVTbYt4wrswRSTGhqcDX7y7mZcafkgAWVAE0TC5tK0iRsi
         S9HxQFO1uedSD5xcLNBXyqVC4Ovt7Yaw0mReR9ULQ6O0wLjMIRSOOjme6OvdUQwiSBsd
         lRq3D4CKZHroXKY4Df/czKhvERYW0oWgC4n14DIC6XtI5T/mxVlZBVKJ9bNpCNIFos8H
         tB+g==
X-Gm-Message-State: AFqh2kpnGsIwgh1Ufm/HCuy1UZPYzLMK+9B0/PgKpzonWK/HUcjqVuFG
        TNm5lye7ioEYFxBRBBGWPx0CnArP3wg=
X-Google-Smtp-Source: AMrXdXtJSaOONevk3w6dBZbmlrVOetMo6Sa9NmVYPbkSEf2peO1f9DMKS+D3ruGiHvUD3mpTH2DR7w==
X-Received: by 2002:ac8:4b76:0:b0:3a8:18fb:d2b8 with SMTP id g22-20020ac84b76000000b003a818fbd2b8mr37177701qts.12.1672348370252;
        Thu, 29 Dec 2022 13:12:50 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id i7-20020a05622a08c700b00343057845f7sm12202392qte.20.2022.12.29.13.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 13:12:49 -0800 (PST)
Message-ID: <078ce8d4-2080-ff5f-6b58-f157c3b21181@gmail.com>
Date:   Thu, 29 Dec 2022 16:12:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: fio question
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        M Kelly <mckelly2833@gmail.com>
References: <CAD5ox-FDUjeZRe9_h_2NtCOCSx2szCVnemO50GwGHa0R_PvqeA@mail.gmail.com>
 <c30865ee-71cc-150d-5952-14eb61d40b07@gmail.com>
 <CAD5ox-GcbKpGmJoCqcx0NM=y_ioDnokygqVu41WFy7z-A8i5Fg@mail.gmail.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAD5ox-GcbKpGmJoCqcx0NM=y_ioDnokygqVu41WFy7z-A8i5Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/29/22 13:16, M Kelly wrote:
> Hi,
> 
> Thank you for your reply and that info, I really appreciate it.
> One last question, if you have time -
> 
> I incorrectly thought the cmdline options:
> 
>      --numjobs=8 --filename=1:2:3:4:5:6:7:8 --size=X (or perhaps --filesize=X)
> 
> would have each of the 8 threads doing i/o independently and concurrently.
> 
> Q: Is there a way to use a single command-line to get X threads doing
> i/o in parallel to separate files that it is similar to my 8 separate
> cmdlines ?
> 
> thx again, and wishing you a happy 2023
> -mark
> 

Oh, I missed that in your original message. numjobs=8 will create 8 
independent jobs that read from the 8 files in a round robin fashion. I 
would still expect performance to differ from 8 jobs reading from 
separate files.

> On Thu, Dec 29, 2022 at 9:28 AM Vincent Fu <vincentfu@gmail.com> wrote:
>>
>> On 12/27/22 18:50, M Kelly wrote:
>>> Hi,
>>>
>>> Thank you for fio.
>>> Apologies if this is the wrong place to ask.
>>>
>>> I am running fio on a laptop with an nvme ssd and have a question
>>> about differences between results.
>>>
>>> test.1 - test.8 are each 900 Mb files of random data created beforehand
>>>
>>> run 1 -
>>>
>>> echo 3 | sudo tee /proc/sys/vm/drop_caches
>>>
>>> fio --name=fiotest
>>> --filename=test.1:test.2:test.3:test.4:test.5:test.6:test.7:test.8
>>> -gtod_reduce=1 --size=900M --rw=randread --bs=8K --direct=0
>>> --numjobs=8 --invalidate=0 --ioengine=psync
>>>
>>> results:
>>>
>>>      iops        : min= 6794, max=86407, avg=26989.80, stdev=33609.35, samples=5
>>>      iops        : min= 6786, max=84998, avg=26818.40, stdev=32972.35, samples=5
>>>      iops        : min= 6816, max=83273, avg=26422.20, stdev=32200.02, samples=5
>>>      iops        : min= 6838, max=88227, avg=27462.20, stdev=34405.56, samples=5
>>>      iops        : min= 6868, max=85788, avg=26870.00, stdev=33332.10, samples=5
>>>      iops        : min= 6818, max=84768, avg=26719.60, stdev=32880.23, samples=5
>>>      iops        : min= 6810, max=86326, avg=27005.60, stdev=33581.89, samples=5
>>>      iops        : min= 6856, max=81411, avg=26165.00, stdev=31345.85, samples=5
>>>      READ: bw=2644MiB/s (2773MB/s), 331MiB/s-332MiB/s (347MB/s-348MB/s),
>>> io=7200MiB (7550MB), run=2709-2723msec
>>>
>>> run 2 -
>>>
>>> echo 3 | sudo tee /proc/sys/vm/drop_caches
>>>
>>> fio --name=fiotest1 --filename=test.1 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest2 --filename=test.2 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest3 --filename=test.3 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest4 --filename=test.4 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest5 --filename=test.5 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest6 --filename=test.6 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest7 --filename=test.7 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> fio --name=fiotest8 --filename=test.8 -gtod_reduce=1 --size=900M
>>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
>>> --ioengine=psync &
>>> wait
>>>
>>> results (from each) -
>>>
>>>     iops        : min= 5836, max= 6790, avg=6481.37, stdev=140.90, samples=35
>>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
>>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17777-17777msec
>>>     iops        : min= 5924, max= 6784, avg=6476.54, stdev=126.85, samples=35
>>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
>>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17785-17785msec
>>>     iops        : min= 5878, max= 6766, avg=6475.23, stdev=138.57, samples=35
>>>     READ: bw=50.6MiB/s (53.0MB/s), 50.6MiB/s-50.6MiB/s
>>> (53.0MB/s-53.0MB/s), io=900MiB (944MB), run=17792-17792msec
>>>     iops        : min= 5866, max= 6788, avg=6478.74, stdev=139.18, samples=35
>>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
>>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17782-17782msec
>>>     iops        : min= 5890, max= 6782, avg=6477.91, stdev=135.21, samples=35
>>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
>>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17783-17783msec
>>>     iops        : min= 5838, max= 6790, avg=6450.11, stdev=137.17, samples=35
>>>     READ: bw=50.3MiB/s (52.7MB/s), 50.3MiB/s-50.3MiB/s
>>> (52.7MB/s-52.7MB/s), io=900MiB (944MB), run=17892-17892msec
>>>     iops        : min= 5922, max= 6750, avg=6454.06, stdev=125.76, samples=35
>>>     READ: bw=50.3MiB/s (52.8MB/s), 50.3MiB/s-50.3MiB/s
>>> (52.8MB/s-52.8MB/s), io=900MiB (944MB), run=17880-17880msec
>>>     iops        : min= 5916, max= 6724, avg=6465.94, stdev=127.54, samples=35
>>>     READ: bw=50.5MiB/s (52.0MB/s), 50.5MiB/s-50.5MiB/s
>>> (52.0MB/s-52.0MB/s), io=900MiB (944MB), run=17816-17816msec
>>>
>>> Question: if I am really doing 900 MiB of random reads from 8 separate
>>> files in both tests, and the page-cache was empty before each test,
>>> does this difference in performance make sense or am I reading the
>>> results incorrectly ?
>>>
>>> thank you for any info/ advice, suggestions,
>>> -mark
>>
>>
>> Your first test directs fio to create a single job that reads from the
>> files in a round robin fashion.
>>
>> The second test has eight independent jobs reading separately from the
>> eight files as fast as they can.
>>
>> It's not a surprise that the results are different.
>>
>> Vincent

