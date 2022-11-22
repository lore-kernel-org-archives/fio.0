Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00682C4332F
	for <fio@archiver.kernel.org>; Tue, 22 Nov 2022 22:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiKVW4e (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiKVW4L (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Nov 2022 17:56:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38342BE10
        for <fio@vger.kernel.org>; Tue, 22 Nov 2022 14:56:10 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y10so13864977plp.3
        for <fio@vger.kernel.org>; Tue, 22 Nov 2022 14:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXhtFJbZMJaBdzHj/HgTJhfhYKm9BCvKMJQ7Tvnv+Ys=;
        b=loFt7SfKaS/JAZiKL2F4Uv74WIAVB29ZyLo2vZilx5y8gZqrbuycroCuKXfu2hSFYO
         bAIPEJPgjr0CzmwEobtfCjy1C5BwFw/kaY8F7OPU8D4nPpfJXNu9AZ0/CLOpie9/BZ7V
         IzGoVnv/TbrFJgp6S2o04JQP40Xq7oePTPyRHNgdm0aY4/+HtkhU0ou8K1HpIaVZJ2fg
         rx+2CexR4NnVdR58z3Bvgg6vWcqd61wm7pBrNc3yo45+tVD0H3FWomKFn0P57+BwP/7c
         YUD+oNUQtE6jDFue3h2rR1Ws9Ct028gg/J2iDza7+f4wgquLRZa/Vl/bOdztJIWLZ5O+
         lXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXhtFJbZMJaBdzHj/HgTJhfhYKm9BCvKMJQ7Tvnv+Ys=;
        b=wS5AduPCkgI44FDlBENqjRcsidkTUBW0RweumD7+chTK0otj/ZyCmcHijvQylWwXFa
         jePPTsSlzEWjH4X+hEOyic+Rhsfs2YM55oSAZ4d/C92gtTiU1/UNpwbpg6lHHR4L/Vnc
         IIl6/B77PJQhNfnQrneaKgvxAnk0NVZtJ5HR42ES/vnw/MH9vo2ibCsWJPBwB1tRpgJp
         HzBXalhOv8tGQnSaY/goapuOKdA1/o7o7qnf2bX54KREdEN0dr5OQhkRDtB7RwEkjO1i
         dztBka10Z97S6HVoo7/3SLnUFXtNP1TnVtX7e1ytRnKXGMEKAMrrQZp5Dd9tMaJ8/vow
         GNmg==
X-Gm-Message-State: ANoB5pl7Ws5i+YY5CNGlUJzZ4nnxVNXJsdbp+eUPyFEosc9IYE4MfPLI
        jWyeFJI32P3CY7Rjoxu1nKK2Xw==
X-Google-Smtp-Source: AA0mqf7pUtsdQv8Ocnetv7pkin4oaCVjwhErRsfbQBEfRgvBupMHIkOsLWW6r6N1HND+qwQFhevRnQ==
X-Received: by 2002:a17:90b:3444:b0:213:519d:fe51 with SMTP id lj4-20020a17090b344400b00213519dfe51mr33599443pjb.239.1669157769568;
        Tue, 22 Nov 2022 14:56:09 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902a38100b001886ff82680sm12440560pla.127.2022.11.22.14.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 14:56:08 -0800 (PST)
Message-ID: <9566efbe-4441-7376-df41-1023b5febc8c@kernel.dk>
Date:   Tue, 22 Nov 2022 15:56:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] engines:io_uring: slat and clat calculation with
 sqthread_poll
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org
References: <20221104111314.25535-1-ankit.kumar@samsung.com>
 <CGME20221104112441epcas5p211f3960a712ba954139173a9c3b343df@epcas5p2.samsung.com>
 <20221104111314.25535-2-ankit.kumar@samsung.com>
 <5fd79355-de14-88c6-d9e0-8aaf45f0960c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5fd79355-de14-88c6-d9e0-8aaf45f0960c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/22/22 3:25?PM, Vincent Fu wrote:
> On 11/4/22 07:13, Ankit Kumar wrote:
>> When sqthread_poll is specified for io_uring and io_uring_cmd I/O engines,
>> fio doesn't report submission latency and the completion latency is too big.
>> Latency data before:
>>
>> fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
>> ???? clat (msec): min=1120.1k, max=1120.1k, avg=1120092.65, stdev= 8.32
>> ????? lat (usec): min=104, max=5312, avg=132.81, stdev=325.05
>> ???? clat percentiles (msec):
>> ????? |? 1.00th=[17113],? 5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
>> ????? | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
>> ????? | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
>> ????? | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
>> ????? | 99.99th=[17113]
>> ?? lat (msec)?? : >=2000=100.00%
>>
>> As kernel polling thread handles the submission, there is no way to know when
>> the actual submission happened. We can only rely on the commit hook and
>> measure the issue time.
>> Latency data after the change:
>>
>> fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
>> ???? slat (nsec): min=50, max=2230, avg=146.68, stdev=138.08
>> ???? clat (usec): min=105, max=5151, avg=132.98, stdev=314.89
>> ????? lat (usec): min=105, max=5153, avg=133.13, stdev=315.03
>> ???? clat percentiles (usec):
>> ????? |? 1.00th=[? 106],? 5.00th=[? 108], 10.00th=[? 109], 20.00th=[? 110],
>> ????? | 30.00th=[? 111], 40.00th=[? 113], 50.00th=[? 114], 60.00th=[? 115],
>> ????? | 70.00th=[? 117], 80.00th=[? 118], 90.00th=[? 119], 95.00th=[? 121],
>> ????? | 99.00th=[? 123], 99.50th=[? 123], 99.90th=[ 5145], 99.95th=[ 5145],
>> ????? | 99.99th=[ 5145]
>> ?? lat (usec)?? : 250=99.61%
>> ?? lat (msec)?? : 10=0.39%
>>
>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>> ---
>> ? engines/io_uring.c | 4 ++++
>> ? 1 file changed, 4 insertions(+)
>>
>> diff --git a/engines/io_uring.c b/engines/io_uring.c
>> index 6906e0a4..0d18fd4a 100644
>> --- a/engines/io_uring.c
>> +++ b/engines/io_uring.c
>> @@ -637,12 +637,16 @@ static int fio_ioring_commit(struct thread_data *td)
>> ?????? */
>> ????? if (o->sqpoll_thread) {
>> ????????? struct io_sq_ring *ring = &ld->sq_ring;
>> +??????? unsigned start = *ld->sq_ring.head;
>> ????????? unsigned flags;
>> ? ????????? flags = atomic_load_acquire(ring->flags);
>> ????????? if (flags & IORING_SQ_NEED_WAKEUP)
>> ????????????? io_uring_enter(ld, ld->queued, 0,
>> ????????????????????? IORING_ENTER_SQ_WAKEUP);
>> +??????? fio_ioring_queued(td, start, ld->queued);
>> +??????? io_u_mark_submit(td, ld->queued);
>> +
>> ????????? ld->queued = 0;
>> ????????? return 0;
>> ????? }
> 
> Ankit, I think the important point here is to make sure that the
> reported slat and clat values when sqthread_poll=1 can be meaningfully
> compared to corresponding values when sqthread_poll=0.
> 
> That means we need to record issue_time at corresponding points in the
> submission process but it's not obvious to me where to record
> issue_time when sqthread_poll=1.
> 
> I can think of two reasonable solutions when sqthread_poll is enabled:
> 
> 1) suppress slat and clat when sqthread_poll=1 because we don't have a
> good place to record issue_time
> 
> 2) record issue_time and the end of fio_ioring_queue() when
> IORING_SQ_NEED_WAKEUP is not set and in commit() as you have above
> when it is flagged
> 
> What do you think?
> 
> Jens, do you have an opinion here?

Submission latency for SQPOLL is really just the time it takes to fill
in the SQ ring entries, and any syscall if IORING_SQ_NEED_WAKEUP is set.
For normal fio use, that flag will never be set and we'll basically just
fill in SQEs. I'm not convinced logging that time separate makes sense,
so perhaps the sanest to suppress SLAT if SQPOLL is set? CLAT definitely
does make sense, as it's the time from doing the submit call (whether
wakeup is set or not) and until we reap the completion.

-- 
Jens Axboe
