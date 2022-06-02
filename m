Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1772C433EF
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 04:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiFBEUN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiFBEUA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jun 2022 00:20:00 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6561E00E
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 21:19:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s24so4789147wrb.10
        for <fio@vger.kernel.org>; Wed, 01 Jun 2022 21:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zEccmrue/DbEmKgMrNdtXkRvChZ5TOlTl6MxsEfB998=;
        b=vLcxULozsQzr84Y1nh08GLYOa3pu951lR7IG9MDtedAINgy2/LLlyJ+RcSJBx1oiHZ
         aHS1fcvUVybdXUF6IbXNwCwL7CXKunT6CrHo/4SNMavL+fDXIybDhT8Wnckp+js1PVfI
         578XzBKE3ATJIGRthXuPtNttZHpiozv1B4ZYObKSrjiVWcn3/2Yd2bAOq/Lq5w9d6Gty
         Yu/ridyd/ZDcT6mxRKgNWoLG7JUdUGVtOsZxHbvewbN52yrx2FkBetJJ8zGtsqYSKCdh
         aRpOPjWCxhexbuyPjL/UrCuEYhUIOdYLPjolgtRU6F7hsGH2dDp/kJ/kbVMs9znoWB7s
         wHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zEccmrue/DbEmKgMrNdtXkRvChZ5TOlTl6MxsEfB998=;
        b=3yXJ+u2A0bv3qOGjD52ObafBFozXfSkR5uXDyTTBoBfOKbq7stICvL/3/N7KFTsDE3
         Fq8ZsTYiSKAxkMOTJ4mM12+39j16r3DDvQvtO3bQdgjhAZ3kBXhGT7mjXh8T4o6fdNui
         C+ORS9CzkafZTgfjwpFQtfVOBXKah+KSOLTg5ERNZI5zO3kGOGBLWh3M7p7ccMGAi0Yg
         Vr27ojgh+CDS6SqxKBYexxq2WCcN4N5+qB8bRot3h7q1e+nDC/1bg1Xerd7yKJXnY14m
         gH3o0r/RajizMPZ3nFqC9LFBXk/djEFgi6EC9vV3NwiOpeClPvLhqKqbAoLb95yfnz1M
         6kFA==
X-Gm-Message-State: AOAM532j/gQkBvPe8ffxQXpShSgioyvMszZPrxyPFSpwP0Yqr5DL+f5H
        1ZtGCcVLd8K3mLo+pvPW+djUXRY7o8jopi3Z
X-Google-Smtp-Source: ABdhPJziau+v6KxcNZELGHRPvs5S68oESXSVDSGTRC+0+g0YsCKYak1X9qDlXyAzFBTcd0HQZZH0cA==
X-Received: by 2002:a05:6000:1606:b0:210:2b15:66fa with SMTP id u6-20020a056000160600b002102b1566famr1889007wrb.568.1654143597049;
        Wed, 01 Jun 2022 21:19:57 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id t12-20020a5d49cc000000b00210352bf36fsm2925982wrs.33.2022.06.01.21.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 21:19:56 -0700 (PDT)
Message-ID: <e5abe6c3-ae66-dae2-8039-b7ec6bb9f054@kernel.dk>
Date:   Wed, 1 Jun 2022 22:19:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 5/9] engines/io_uring: add new I/O engine for uring
 passthrough support
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
 <CGME20220531133746epcas5p36ec535b219f3e2008b14d2adc59e30f2@epcas5p3.samsung.com>
 <20220531133155.17493-6-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220531133155.17493-6-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/31/22 7:31 AM, Ankit Kumar wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add a new I/O engine (io_uring_cmd) for sending uring passthrough
> commands. It will also use most of the existing helpers from the
> I/O engine io_uring. The I/O preparation, completion, file open,
> file close and post init paths are going to differ and hence
> io_uring_cmd will have its own helper for them.
> 
> Add a new io_uring_cmd engine specific option to support nvme
> passthrough commands. Filename name for this specific option
> must specify nvme-ns generic character device (dev/ngXnY).
> This provides io_uring_cmd I/O engine a bandwidth to support
> various passthrough commands in future.
> 
> The engine_pos and engine_data fields in struct fio_file are
> separated now. This will help I/O engine io_uring_cmd to store
> specific data as well as keep track of register files.
> 
> Added a new option cmd_type. This specifies the type of uring
> command to submit. Currently it only supports nvme uring command

A few minor nits which we don't need to respin this for, unless other
changes end up being required. In general this to me looks like it's
ready to go, people please holler if they agree / disagree so we can get
this finished up.

> +static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
> +{
> +	struct ioring_data *ld = td->io_ops_data;
> +	struct ioring_options *o = td->eo;
> +	struct fio_file *f = io_u->file;
> +	struct io_uring_sqe *sqe;
> +	int ret;
> +
> +	/* nvme_uring_cmd case */
> +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> +		struct nvme_uring_cmd *cmd;

This should just be:

	if (o->cmd_type != FIO_URING_CMD_NVME)
		return -EINVAL;

	... other case ...

to prevent unnecessary nesting.


> @@ -728,6 +829,61 @@ retry:
>  	return fio_ioring_mmap(ld, &p);
>  }
>  
> +static int fio_ioring_cmd_queue_init(struct thread_data *td)
> +{
> +	struct ioring_data *ld = td->io_ops_data;
> +	struct ioring_options *o = td->eo;
> +	int depth = td->o.iodepth;
> +	struct io_uring_params p;
> +	int ret;
> +
> +	memset(&p, 0, sizeof(p));
> +
> +	if (o->hipri)
> +		p.flags |= IORING_SETUP_IOPOLL;
> +	if (o->sqpoll_thread) {
> +		p.flags |= IORING_SETUP_SQPOLL;
> +		if (o->sqpoll_set) {
> +			p.flags |= IORING_SETUP_SQ_AFF;
> +			p.sq_thread_cpu = o->sqpoll_cpu;
> +		}
> +	}
> +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> +		p.flags |= IORING_SETUP_SQE128;
> +		p.flags |= IORING_SETUP_CQE32;
> +	}
> +
> +	/*
> +	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
> +	 * than that.
> +	 */
> +	p.flags |= IORING_SETUP_CQSIZE;
> +	p.cq_entries = depth;
> +
> +retry:
> +	ret = syscall(__NR_io_uring_setup, depth, &p);
> +	if (ret < 0) {
> +		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
> +			p.flags &= ~IORING_SETUP_CQSIZE;
> +			goto retry;
> +		}
> +		return ret;
> +	}

This retry doesn't really have any reason for existing anymore, as we
know we have SETUP_CQSIZE if we have SQE128/CQE32. Hence I think it
should just go away, and we should probably have a nice warning print of
some sort if we get EINVAL as it means the kernel is too old to support
SQE128/CQE32 and hence passthrough in general.

That prevents people from emailing me that it doesn't work just because
their kernel is too old.

Apart from that, this looks good to me.

-- 
Jens Axboe

