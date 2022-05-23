Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570BDC433EF
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbiEWQoz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiEWQoz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:44:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE7D69733
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:44:53 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n10so14560424pjh.5
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BLCwRKcbogo5ckQEc6KqHDFBgp1NhYLWHDNRxLOZsls=;
        b=zpTFazIsZ1sP9ICck82/q9T18lVZYDh7e/PYIKWzv0YTS4W27nbg+PF+oOCmY4Kb/B
         Kbxes/lrWa0xE+9EOwI3R8Lu5JGtHioXK0W7eNUZXKy154h7gRy4LpMiawrrkSfHeVpU
         4vZv5os8a/NxU7eKdjZoMwucm2nZEc4IPYyiHYcnAmOyIjUSXJVW5NE3aoZAFcABSWgY
         rUCz7IAFuIMRl9ZM/eW7Ulg4VV+sLOEf0PIxiNIBK1i5hoR0mX4M7ojXuaU5cpv/zM1o
         /EQQZRofFKnDAgWAZPkstI+wXBZ2oURB8W9/SdwKT7ATMUKBYirIjoGSpqts3gQVgkdL
         AnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BLCwRKcbogo5ckQEc6KqHDFBgp1NhYLWHDNRxLOZsls=;
        b=SxIzAjjl170xayazq6T4GIUkPlkbGIHZc6ZCQK2YqxWNUpUcQIhf11Uk2LrvW95/a/
         gg5Qkl+9/5eN6ErUu9JaH3jnZ7CUlHTWvdPNm41mqW+TNmD7gValdtnG9TufN7Zp40lc
         sKtGGVA/2/hpokh35RWTHtsCn0JO8ckIBKXHxd0up6knR8zSOm6fdM83FHCJyseamUIX
         +YM7Gh5E4Y8gim6knAGBkiUm7vbblBo8lKpwQYLdk8jK3laRfYquAC8TE60Ue74FXdTO
         jxqfypAaGqY3CzFfsU9TWfi1tNhxAAdiWxM7AEbjstl6NHKly6T4Dmosj3n2vmzXPo9L
         /q9A==
X-Gm-Message-State: AOAM533sr74csqu9e2rUXu3PKVLERvrm8UbzLnUhzBO3m+l1IciuNhfX
        p5Odt52Vu+tHKbKYUeOTgZR2WQ==
X-Google-Smtp-Source: ABdhPJygnPGKMejWW2Yh13a6QcvtnHYJSUfxCIgbkmtV2V25JHqCeIiHZAobxvL3YSVGIzPgrW5jUw==
X-Received: by 2002:a17:902:edd1:b0:158:8318:b51e with SMTP id q17-20020a170902edd100b001588318b51emr23956065plk.89.1653324292742;
        Mon, 23 May 2022 09:44:52 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c13-20020a170903234d00b0015f0dcd1579sm3810785plh.9.2022.05.23.09.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 09:44:52 -0700 (PDT)
Message-ID: <be576bfa-49e8-aa05-5163-6133e9137695@kernel.dk>
Date:   Mon, 23 May 2022 10:44:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 3/7] engines/io_uring: add new I/O engine for uring
 passthrough support
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
 <CGME20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07@epcas5p4.samsung.com>
 <20220523131039.17697-4-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220523131039.17697-4-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/23/22 7:10 AM, Ankit Kumar wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add a new I/O engine (io_uring_cmd) for sending uring passthrough
> commands. The new I/O engine will be built only if its support is
> present in the kernel. It will also use most of the existing
> helpers from the I/O engine io_uring. The I/O preparation,
> completion, file open, file close and post init paths are going to
> differ and hence io_uring_cmd will have its own helper for them.
> 
> Add a new io_uring_cmd engine specific flag to support nvme
> passthrough commands. Filename name for this specific option
> must specify nvme-ns generic character device (dev/ngXnY).
> This provides io_uring_cmd I/O engine a bandwidth to support
> various passthrough commands in future.
> 
> The engine_pos and engine_data fields in struct fio_file are
> separated now. This will help I/O engine io_uring_cmd to store
> specific data as well as keep track of register files.
> 
> The supported io_uring_cmd options are:
>  * registerfiles
>  * sqthread_poll
>  * sqthread_poll_cpu
>  * cmd_type

This looks way better than the earlier versions.

> co-authored-By: Anuj Gupta <anuj20.g@samsung.com>
> co-authored-By: Ankit Kumar <ankit.kumar@samsung.com>

Since the patch is attributed to Anuj as the author, that co-authored-by
should be a Signed-off-by from Anuf.

> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 1e15647e..75248624 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -25,6 +25,17 @@
>  #include "../os/linux/io_uring.h"
>  #include "cmdprio.h"
>  
> +#ifdef CONFIG_LIBNVME
> +#include <sys/stat.h>
> +#include <nvme/ioctl.h>
> +#endif
> +
> +#ifdef CONFIG_URING_CMD
> +enum uring_cmd_type {
> +	FIO_URING_CMD_NVME = 1,
> +};
> +#endif

Can you briefly describe why we need the libnvme dependency? What does
libnvme get us here? Would it be too cumbersome to do it without
libnvme?

In general, fio tries to not rely on external libraries unless there's a
strong reason to do so.

> @@ -270,6 +289,23 @@ static struct fio_option options[] = {
>  		.category = FIO_OPT_C_ENGINE,
>  		.group	= FIO_OPT_G_IOURING,
>  	},
> +#ifdef CONFIG_URING_CMD
> +	{
> +		.name	= "cmd_type",
> +		.lname	= "Uring cmd type",
> +		.type	= FIO_OPT_STR,
> +		.off1	= offsetof(struct ioring_options, cmd_type),
> +		.help	= "Specify uring-cmd type",
> +		.posval = {
> +			  { .ival = "nvme",
> +			    .oval = FIO_URING_CMD_NVME,
> +			    .help = "Issue nvme-uring-cmd",
> +			  },
> +		},
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_IOURING,
> +	},
> +#endif
>  	{
>  		.name	= NULL,
>  	},

Options should always be visible regardless of availability, they should
just error if not available at runtime.

> @@ -373,6 +409,61 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_URING_CMD
> +static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
> +{
> +	struct ioring_data *ld = td->io_ops_data;
> +	struct ioring_options *o = td->eo;
> +	struct fio_file *f = io_u->file;
> +	struct io_uring_sqe *sqe;
> +
> +	/* nvme_uring_cmd case */
> +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> +#ifdef CONFIG_LIBNVME
> +		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
> +		struct nvme_uring_cmd *cmd;
> +		unsigned long long slba;
> +		unsigned long long nlb;
> +
> +		sqe = &ld->sqes[(io_u->index) << 1];
> +
> +		if (o->registerfiles) {
> +			sqe->fd = f->engine_pos;
> +			sqe->flags = IOSQE_FIXED_FILE;
> +		} else {
> +			sqe->fd = f->fd;
> +		}
> +		sqe->opcode = IORING_OP_URING_CMD;
> +		sqe->user_data = (unsigned long) io_u;
> +		sqe->cmd_op = NVME_URING_CMD_IO;
> +
> +		slba = io_u->offset / data->lba_size;
> +		nlb = (io_u->xfer_buflen / data->lba_size) - 1;
> +
> +		cmd = (struct nvme_uring_cmd *)sqe->cmd;
> +		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> +
> +		/* cdw10 and cdw11 represent starting lba */
> +		cmd->cdw10 = slba & 0xffffffff;
> +		cmd->cdw11 = slba >> 32;
> +		/* cdw12 represent number of lba's for read/write */
> +		cmd->cdw12 = nlb;
> +		cmd->addr = (__u64)io_u->xfer_buf;
> +		cmd->data_len = io_u->xfer_buflen;
> +		cmd->nsid = data->nsid;
> +
> +		if (io_u->ddir == DDIR_READ)
> +			cmd->opcode = nvme_cmd_read;
> +		if (io_u->ddir == DDIR_WRITE)
> +			cmd->opcode = nvme_cmd_write;
> +
> +		return 0;
> +#endif
> +	}
> +	return -EINVAL;
> +}
> +#endif

The nested ifdefs don't do much here for readability. Would be cleaner
as:

#ifdef CONFIG_URING_CMD
static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
{
#ifndef CONFIG_LIBNVME
	return -EINVAL;
#else
	struct ioring_data *ld = td->io_ops_data;
	struct ioring_options *o = td->eo;
	struct fio_file *f = io_u->file;
	struct io_uring_sqe *sqe;

	/* nvme_uring_cmd case */
	if (o->cmd_type != FIO_URING_CMD_NVME)
		return -EINVAL;

	...
#endif /* CONFIG_LIBNVME */
}
#endif /* CONFIG_URING_CMD */

> +#ifdef CONFIG_URING_CMD
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
> +	if (o->hipri && o->cmd_type == FIO_URING_CMD_NVME) {
> +		log_err("fio: nvme_uring_cmd doesn't support hipri\n");
> +		return ENOTSUP;
> +	}
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
> +
> +	ld->ring_fd = ret;
> +
> +	fio_ioring_probe(td);
> +
> +	if (o->fixedbufs) {
> +		log_err("fio: io_uring_cmd doesn't support fixedbufs\n");
> +		return ENOTSUP;
> +	}
> +	return fio_ioring_mmap(ld, &p);

This is a limitation of the current implementation, which means that
once the kernel does support that, your fio still won't work until you
update it.

In other words, this should just fail at runtime if someone attempts to
use it.

In general, cleanup all the ifdef mess, it's all over the place. It
makes it really hard to maintain, way too easy to make a change that
works on your setup and breaks if you don't have eg libnvme. Rather than
do it in the middle of functions, have stubs that just return an error
if the right options aren't available. That makes the actual functional
functions easier to read too, rather than having ifdefs sprinkled
everywhere.

-- 
Jens Axboe

