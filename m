Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0A4C433FE
	for <fio@archiver.kernel.org>; Tue, 22 Nov 2022 22:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiKVWZ5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiKVWZ4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Nov 2022 17:25:56 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C57818D
        for <fio@vger.kernel.org>; Tue, 22 Nov 2022 14:25:55 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id x18so11347782qki.4
        for <fio@vger.kernel.org>; Tue, 22 Nov 2022 14:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5b5V+sOWRLZyJHWnaug3lk2R4K6icYNmcMPqg0YktEU=;
        b=ViQ1WJ+NYMziQZvpHoh8kN/b4dmZ/xQXaZrGrq4ccEKC6UFUXdvYxj/iNaavhuBSfy
         o5kFJRo3/q9ZiO5bdOW+lE7wIR8HPzyIaHeTf72Ti25rCWFjAz+rOx3QIppMlK+tuHYt
         4OLZHSBA2VXrvPlDB2gk2W+Hhtme8Rmo4faC2Uy0b7Dge2xTML0L6NmWjqw5Y9AOr4h5
         pqzFTRaCNbJNOEBQbZ2jfJhUG2VqtsNQu7neI9Q1b8vtyHtVLb4InHkRsutzOXFAvSUL
         bxu92dna3D2du6RM8wBps+smyaWS1Q1Y99/xaCKXyoa1YYZSOivc/0ULA0HlCTt3UvJj
         h0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5b5V+sOWRLZyJHWnaug3lk2R4K6icYNmcMPqg0YktEU=;
        b=1zV1aMZg9WKMq+nT2BoAGq4Rwk+iUWA3/GG5b19lwJ9/tygWsR3c7L1Wj275+YIDrO
         7RHBi2VYIM4IWTpfaAFqB+2E5fRTv2GApgviP2RA2A2BUqmKvJmxhY4DJkSxHhOi4lUd
         5fTmUZtInw9B9hulacOlfkIVLFKtA5pVy3OB4FM3NFmgiH5D/LEsYXYsRWg3pEQltV3I
         thbi5VL1sFbZCkN+yHL6gpi0s9kqr3DJavF6Ky9bEp1Gnrr1//kx9V0eKGYfcFmJ5KRQ
         Jd4Y92uE/HwKpdM8r7wFZrJ0JgnEu7yM9emwjVbn4M0yQx8FoeoCC8nlCAIt6ThN/xSA
         2r9Q==
X-Gm-Message-State: ANoB5pmko7uW8nOOzlyGgsJ38HGx+giM1A1Pm+YqS01OL9j1JQIOPDaa
        eYLsSMlgjcU0i3tvyGPjEZ1hpWIYJnk=
X-Google-Smtp-Source: AA0mqf6/QH1VRw7OKjEzyDHOYmSEnfnDtM7x9+gI7UJwjlK40W+Zj9i4OXSUcGP33AU5erbhk/989w==
X-Received: by 2002:a37:7c6:0:b0:6ea:a9e4:6225 with SMTP id 189-20020a3707c6000000b006eaa9e46225mr22724510qkh.320.1669155954215;
        Tue, 22 Nov 2022 14:25:54 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ca9-20020a05622a1f0900b00398a7c860c2sm8969904qtb.4.2022.11.22.14.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 14:25:53 -0800 (PST)
Message-ID: <5fd79355-de14-88c6-d9e0-8aaf45f0960c@gmail.com>
Date:   Tue, 22 Nov 2022 17:25:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] engines:io_uring: slat and clat calculation with
 sqthread_poll
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <20221104111314.25535-1-ankit.kumar@samsung.com>
 <CGME20221104112441epcas5p211f3960a712ba954139173a9c3b343df@epcas5p2.samsung.com>
 <20221104111314.25535-2-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221104111314.25535-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/4/22 07:13, Ankit Kumar wrote:
> When sqthread_poll is specified for io_uring and io_uring_cmd I/O engines,
> fio doesn't report submission latency and the completion latency is too big.
> Latency data before:
> 
> fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
>      clat (msec): min=1120.1k, max=1120.1k, avg=1120092.65, stdev= 8.32
>       lat (usec): min=104, max=5312, avg=132.81, stdev=325.05
>      clat percentiles (msec):
>       |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
>       | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
>       | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
>       | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
>       | 99.99th=[17113]
>    lat (msec)   : >=2000=100.00%
> 
> As kernel polling thread handles the submission, there is no way to know when
> the actual submission happened. We can only rely on the commit hook and
> measure the issue time.
> Latency data after the change:
> 
> fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
>      slat (nsec): min=50, max=2230, avg=146.68, stdev=138.08
>      clat (usec): min=105, max=5151, avg=132.98, stdev=314.89
>       lat (usec): min=105, max=5153, avg=133.13, stdev=315.03
>      clat percentiles (usec):
>       |  1.00th=[  106],  5.00th=[  108], 10.00th=[  109], 20.00th=[  110],
>       | 30.00th=[  111], 40.00th=[  113], 50.00th=[  114], 60.00th=[  115],
>       | 70.00th=[  117], 80.00th=[  118], 90.00th=[  119], 95.00th=[  121],
>       | 99.00th=[  123], 99.50th=[  123], 99.90th=[ 5145], 99.95th=[ 5145],
>       | 99.99th=[ 5145]
>    lat (usec)   : 250=99.61%
>    lat (msec)   : 10=0.39%
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/io_uring.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 6906e0a4..0d18fd4a 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -637,12 +637,16 @@ static int fio_ioring_commit(struct thread_data *td)
>   	 */
>   	if (o->sqpoll_thread) {
>   		struct io_sq_ring *ring = &ld->sq_ring;
> +		unsigned start = *ld->sq_ring.head;
>   		unsigned flags;
>   
>   		flags = atomic_load_acquire(ring->flags);
>   		if (flags & IORING_SQ_NEED_WAKEUP)
>   			io_uring_enter(ld, ld->queued, 0,
>   					IORING_ENTER_SQ_WAKEUP);
> +		fio_ioring_queued(td, start, ld->queued);
> +		io_u_mark_submit(td, ld->queued);
> +
>   		ld->queued = 0;
>   		return 0;
>   	}

Ankit, I think the important point here is to make sure that the 
reported slat and clat values when sqthread_poll=1 can be meaningfully 
compared to corresponding values when sqthread_poll=0.

That means we need to record issue_time at corresponding points in the 
submission process but it's not obvious to me where to record issue_time 
when sqthread_poll=1.

I can think of two reasonable solutions when sqthread_poll is enabled:

1) suppress slat and clat when sqthread_poll=1 because we don't have a 
good place to record issue_time

2) record issue_time and the end of fio_ioring_queue() when 
IORING_SQ_NEED_WAKEUP is not set and in commit() as you have above when 
it is flagged

What do you think?

Jens, do you have an opinion here?

Vincent
