Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C632DC3F6B0
	for <fio@archiver.kernel.org>; Wed, 24 Aug 2022 20:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiHXUKA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbiHXUJ6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2022 16:09:58 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E25BC1
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 13:09:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y187so14325150iof.0
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 13:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=zuF8B5LNmWJ0kepn31GAY7f93MfYDbsNITjkjNaAh+w=;
        b=XAfloGx0F4dcjPtWmyKv42PUTmoOAvjRrNY6dHmYhTgGZU98tbjB/H5Urqzcro4zOP
         BEXIHwCy7RYquEXg/b6LZ7q+Q40xoCwHxVcZRY2unq+Yha/Zo+1K1TIDDF0qG92PYgHC
         Z7Q64opQxZiEKu4vWcnynvb8hSZ4Vj8WYr70nfz2neOOwOAZBI7b6rW9Ec13FiSmoZxy
         +xQEmR3IHix5RQ4jXKY+L0PQhtBEXNp/Q91MukzEeuJifAB97/ID2vgiI9AKFRpayDLu
         oSKTJDozVrO7XdKqn+A9P6EFrzGmcpDMSpJ0qU7/9B50+7156lDxjzoezBY+QsdZhHUh
         h6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zuF8B5LNmWJ0kepn31GAY7f93MfYDbsNITjkjNaAh+w=;
        b=UwILqyo6cKM4xC2ryFy+zRsPx4HV1hfcRmp90DqDAYEVWqiDfP3Fou/QEj5DtjR+KY
         WqQZIpAp10ArrjmfJD3fwzrXqYD7K7gMJE6S4uWZp9anQKepEBcrrG6Bwv/3dCB0yuT0
         UNFH4hxfXkp8nNEuOTRuxvQliyOKufZBhBOpCUP4rhfxrQVZKU6OvEXQwcHS0jqaA3PC
         dFlPnNF6P12vIWuzKH0h05mWGj+3kQkajXgrJdBoVUOsruKz5g1o/GypPvaodRBOuJMP
         Kgd2hmJxWcRzDjqh8ckiwc5a6AlCpXZO72BGgA2Nq1BZoY3gvDmiVmw2IqsUfprf38Bw
         q5ng==
X-Gm-Message-State: ACgBeo1Ig2EPq4ldEw/JA3CzAv6QH4hEpbTZ9gbVXw+8Zw+wAAGgzCL5
        OTe1ZYrP2zHCaMgurFYGJTTWRA==
X-Google-Smtp-Source: AA6agR6F1Pn03mvTtVe92YHoZXcKFNMLxoToY82VSZSqFLZSpyT+ZJoAVrPPNeFGH0VPkn0gXXiTMw==
X-Received: by 2002:a05:6638:35a8:b0:34a:456:e416 with SMTP id v40-20020a05663835a800b0034a0456e416mr267386jal.229.1661371795799;
        Wed, 24 Aug 2022 13:09:55 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i3-20020a023b43000000b003434c28f7adsm191810jaf.15.2022.08.24.13.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 13:09:54 -0700 (PDT)
Message-ID: <b6ddee98-1bc0-4a5c-7446-3b0a0857a2a3@kernel.dk>
Date:   Wed, 24 Aug 2022 14:09:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 2/2] t/io_uring: add support for async-passthru
Content-Language: en-US
To:     Anuj Gupta <anuj20.g@samsung.com>, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org
References: <20220824093109.308791-1-anuj20.g@samsung.com>
 <CGME20220824094134epcas5p4b7cacb00484146b5d510ded15a80c712@epcas5p4.samsung.com>
 <20220824093109.308791-3-anuj20.g@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220824093109.308791-3-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/24/22 3:31 AM, Anuj Gupta wrote:
> @@ -457,12 +509,13 @@ static unsigned file_depth(struct submitter *s)
>  
>  static void init_io(struct submitter *s, unsigned index)
>  {
> -	struct io_uring_sqe *sqe = &s->sqes[index];
> +	struct io_uring_sqe *sqe = NULL;
>  	unsigned long offset;
>  	struct file *f;
>  	long r;
>  
>  	if (do_nop) {
> +		sqe = &s->sqes[index];
>  		sqe->opcode = IORING_OP_NOP;
>  		return;

I'd just leave the initial assignment rather than have two manual ones
for the same thing, and then just have the 'pt' path override it.

> @@ -490,6 +543,41 @@ static void init_io(struct submitter *s, unsigned index)
>  			f->cur_off = 0;
>  	}
>  
> +	if (pt) {
> +		struct nvme_uring_cmd *cmd;
> +		unsigned long long slba;
> +		unsigned long long nlb;
> +
> +		sqe = &s->sqes[index<<1];

		sqe = &s->sqes[index << 1];

please.

> +		if (register_files) {
> +			sqe->fd = f->fixed_fd;
> +			sqe->flags = IOSQE_FIXED_FILE;
> +		} else {
> +			sqe->fd = f->real_fd;
> +			sqe->flags = 0;
> +		}
> +		sqe->opcode = IORING_OP_URING_CMD;
> +		sqe->user_data = (unsigned long) f->fileno;
> +		if (stats)
> +			sqe->user_data |= ((unsigned long)s->clock_index << 32);
> +		sqe->cmd_op = NVME_URING_CMD_IO;
> +		slba = offset / lbs;
> +		nlb = bs/lbs - 1;

You have two expensive integer divisions here. Would make sense to turn
lbs into a shift instead, those are a lot cheaper to do. And then you
can put the expensive part in the setup part rather than have it in the
fast path.

Another thing to consider is to make the pt path separate rather than
need a bunch of 'if (pt) ... else ...' in here?

> @@ -587,11 +690,14 @@ static int reap_events_uring(struct submitter *s)
>  
>  			f = &s->files[fileno];
>  			f->pending_ios--;
> -			if (cqe->res != bs) {
> +			if (!pt && cqe->res != bs) {
>  				printf("io: unexpected ret=%d\n", cqe->res);
>  				if (polled && cqe->res == -EOPNOTSUPP)
>  					printf("Your filesystem/driver/kernel doesn't support polled IO\n");
>  				return -1;
> +			} else if (pt && cqe->res != 0) {
> +				printf("io: unexpected ret=%d\n", cqe->res);
> +				return -1;
>  			}
>  		}
>  		if (stats) {

These two would be examples of things that would be cleaner with a
separate path too.

> @@ -1306,11 +1428,12 @@ static void usage(char *argv, int status)
>  		" -a <bool> : Use legacy aio, default %d\n"
>  		" -S <bool> : Use sync IO (preadv2), default %d\n"
>  		" -X <bool> : Use registered ring %d\n"
> -		" -P <bool> : Automatically place on device home node %d\n",
> +		" -P <bool> : Automatically place on device home node %d\n"
> +		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
>  		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
>  		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
>  		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
> -		use_sync, register_ring, numa_placement);
> +		use_sync, register_ring, numa_placement, pt);
>  	exit(status);

Reminds me, should the nsid and lbs be in the submitter struct?

Thanks for doing this work!!

-- 
Jens Axboe
