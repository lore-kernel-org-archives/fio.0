Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E242C04A6A
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 15:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbjHIPiM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjHIPht (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 11:37:49 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5BB3A97
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 08:37:11 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-447823dd96fso2026955137.1
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 08:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691595431; x=1692200231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zxqdEAEen2I2gRCgvWsRTw0260V4Uj5LN2o4MBPsGsA=;
        b=ZEoWf3yFn4+WvR2PwdClUvJpZACCZmAKato+EhoP8gqF7ADOQUrzDvtygcvUwJhf8F
         gqO03jyLlSkxLfUViUvShFnlTV8G1Svfks6jn28qhSoDBAFvvmL0faYMBGDrfUaO6fQG
         dtUygscm9LgSIzzdHsa1WhHAqd/nPjEzVKBOsDJ6uwyBaoHlEW66mco5xeMIqnGkLDVY
         AzdqDKMrVpxMegzfozc1BtX84o1M9wblrBYELECbUFOpAvf0/BWL6oxlsQ6Zv/cvviW+
         CTITS/FiM9wb680aFYIYbzzg2NNVG2sNE4fLgJ6hIHZD9Fg4YU9v3oT0PN3SAha11Jre
         muyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595431; x=1692200231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zxqdEAEen2I2gRCgvWsRTw0260V4Uj5LN2o4MBPsGsA=;
        b=ilqYofoKA41bx742MeyR57n9a6842nceKY8SsHgrQleSFI8Wb9TSq9Uo6Y8sCE3bdP
         2bg0SUl7W5oSush4UKjgXJNHkjJ8OOmNke3f4I//GNkzMRapkKUsUAkSfKPPno370kRp
         vaNvWMc50DnTX/4Wfltw2hXNFJEIOUdDXJHlAzVi28u8gRtYZj8Yh+h7N+MutRQckCfJ
         fcgHQ+o9tla+96sGH0pQMmpPK3Aie7oV6CS54eWSnQe6rsVkQMWRlO9rji992PzYTOGn
         kdYGZPXh/NhAVsV0qPFOy5Me82Va3ALbyfuIq6dCMrJh3EGmygCvrIXiw23XhEywO4k7
         OlQQ==
X-Gm-Message-State: AOJu0Yy8erMk5+FUjU0D2YtmysxbOfVwTM+na1sZ9ZrBH5RCBZnrbfGc
        Cvx6v1PjooFPZx2VhAisJ4CJa557WHBGrg==
X-Google-Smtp-Source: AGHT+IH9wVlQ0xxi3xE0BdKS/AfXE1+PV2g75VHqBdbgMfGBnjJYS1RvgWs1nan0cnKFVJfHNqlgnA==
X-Received: by 2002:a67:db0e:0:b0:446:ea06:b543 with SMTP id z14-20020a67db0e000000b00446ea06b543mr1926530vsj.11.1691595430675;
        Wed, 09 Aug 2023 08:37:10 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id p28-20020a05620a113c00b0076cb1eff83csm4066794qkk.5.2023.08.09.08.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:37:10 -0700 (PDT)
Message-ID: <bf2c8d4c-a288-003f-9a9e-5cbeb3432557@gmail.com>
Date:   Wed, 9 Aug 2023 11:37:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 03/10] engines:io_uring: enable support for separate
 metadata buffer
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055416epcas5p1bd18cd6413c64f10780e9c0ccdc92706@epcas5p1.samsung.com>
 <20230809111314.76947-4-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-4-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> This patch enables support for separate metadata buffer.
> As we are unaware of metadata size during buffer allocation, we provide
> an option md_per_io_size. This can be used to specify metadata size for
> single IO.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst          |  4 ++++
>   engines/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>   engines/nvme.c     | 16 ++++++--------
>   fio.1              |  3 +++
>   4 files changed, 65 insertions(+), 10 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index ac8314f3..6e0677f2 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2487,6 +2487,10 @@ with the caveat that when used on the command line, they must come after the
>           want fio to use placement identifier only at indices 0, 2 and 5 specify
>           ``fdp_pli=0,2,5``.
>   
> +.. option:: md_per_io_size=int : [io_uring_cmd]
> +
> +	Size in bytes for separate metadata buffer per IO. Default: 0.
> +
>   .. option:: cpuload=int : [cpuio]
>   
>   	Attempt to use the specified percentage of CPU cycles. This is a mandatory
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 2b707927..0dfd5f17 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -59,6 +59,7 @@ struct ioring_data {
>   	int ring_fd;
>   
>   	struct io_u **io_u_index;
> +	char *md_buf;
>   
>   	int *fds;
>   
> @@ -95,6 +96,7 @@ struct ioring_options {
>   	unsigned int uncached;
>   	unsigned int nowait;
>   	unsigned int force_async;
> +	unsigned int md_per_io_size;
>   	enum uring_cmd_type cmd_type;
>   };
>   
> @@ -217,6 +219,16 @@ static struct fio_option options[] = {
>   		.group	= FIO_OPT_G_IOURING,
>   	},
>   	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
> +	{
> +		.name	= "md_per_io_size",
> +		.lname	= "Separate Metadata Buffer Size per I/O",
> +		.type	= FIO_OPT_INT,
> +		.off1	= offsetof(struct ioring_options, md_per_io_size),
> +		.def	= "0",
> +		.help	= "Size of separate metadata buffer per I/O (Default: 0)",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_IOURING,
> +	},
>   	{
>   		.name	= NULL,
>   	},
> @@ -631,6 +643,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
>   
>   		fio_cmdprio_cleanup(&ld->cmdprio);
>   		free(ld->io_u_index);
> +		free(ld->md_buf);
>   		free(ld->iovecs);
>   		free(ld->fds);
>   		free(ld->dsm);
> @@ -1016,6 +1029,7 @@ static int fio_ioring_init(struct thread_data *td)
>   {
>   	struct ioring_options *o = td->eo;
>   	struct ioring_data *ld;
> +	unsigned long long md_size;
>   	int ret;
>   
>   	/* sqthread submission requires registered files */
> @@ -1036,6 +1050,28 @@ static int fio_ioring_init(struct thread_data *td)
>   
>   	/* io_u index */
>   	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
> +
> +	/*
> +	 * metadata buffer for nvme command.
> +	 * We are only supporting iomem=malloc / mem=malloc as of now.
> +	 */
> +	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
> +	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
> +		md_size = (unsigned long long) o->md_per_io_size
> +				* (unsigned long long) td->o.iodepth;
> +		md_size += page_mask + td->o.mem_align;
> +		if (td->o.mem_align && td->o.mem_align > page_size)
> +			md_size += td->o.mem_align - page_size;
> +		if (td->o.mem_type == MEM_MALLOC) {
> +			ld->md_buf = malloc(md_size);
> +			if (!ld->md_buf)
> +				return 1;
> +		} else {
> +			log_err("fio: bad mem type: %d\n", td->o.mem_type);

It would be more user friendly if the error message said something like, 
"Only iomem=malloc is supported."

> +			return 1;
> +		}
> +	}
> +
>   	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
>   
>   	td->io_ops_data = ld;
> @@ -1062,8 +1098,17 @@ static int fio_ioring_init(struct thread_data *td)
>   static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
>   {
>   	struct ioring_data *ld = td->io_ops_data;
> +	struct ioring_options *o = td->eo;
> +	char *p;
>   
>   	ld->io_u_index[io_u->index] = io_u;
> +
> +	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
> +		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
> +		p += o->md_per_io_size * io_u->index;
> +		io_u->mmap_data = p;
> +	}
> +
>   	return 0;
>   }
>   
> @@ -1116,6 +1161,13 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
>   				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
>   				return 1;
>   			}
> +			if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
> +			    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) *
> +						  data->ms))) {
> +				log_err("md per io size should be sufficient for metadata payload\n");

It would be more user friendly if fio's error message included the 
md_per_io_size needed to run the job.

> +				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
> +				return 1;
> +			}
>                   }
>   	}
>   	if (!ld || !o->registerfiles)
> diff --git a/engines/nvme.c b/engines/nvme.c
> index 7e891eed..65725e3c 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -79,6 +79,10 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
>   		cmd->data_len = io_u->xfer_buflen;
>   	}
> +	if (data->lba_shift && data->ms) {
> +		cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
> +		cmd->metadata_len = (nlb + 1) * data->ms;
> +	}
>   	cmd->nsid = data->nsid;
>   	return 0;
>   }
> @@ -149,21 +153,13 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
>   		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
>   
>   	data->lba_size = 1 << ns.lbaf[format_idx].ds;
> +	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
>   
>   	/*
> -	 * Only extended LBA can be supported.
>   	 * Bit 4 for flbas indicates if metadata is transferred at the end of
>   	 * logical block creating an extended LBA.
>   	 */
> -	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
> -	if (data->ms && !((ns.flbas >> 4) & 0x1)) {
> -		log_err("%s: only extended logical block can be supported\n",
> -			f->file_name);
> -		err = -ENOTSUP;
> -		goto out;
> -	}
> -
> -	if (data->ms)
> +	if (data->ms && ((ns.flbas >> 4) & 0x1))
>   		data->lba_ext = data->lba_size + data->ms;
>   	else
>   		data->lba_shift = ilog2(data->lba_size);
> diff --git a/fio.1 b/fio.1
> index f62617e7..6b49a747 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2247,6 +2247,9 @@ By default, the job will cycle through all available Placement IDs, so use this
>   to isolate these identifiers to specific jobs. If you want fio to use placement
>   identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
>   .TP
> +.BI (io_uring_cmd)md_per_io_size \fR=\fPint
> +Size in bytes for separate metadata buffer per IO. Default: 0.
> +.TP
>   .BI (cpuio)cpuload \fR=\fPint
>   Attempt to use the specified percentage of CPU cycles. This is a mandatory
>   option when using cpuio I/O engine.

