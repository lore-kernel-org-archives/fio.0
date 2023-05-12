Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72160C77B75
	for <fio@archiver.kernel.org>; Fri, 12 May 2023 16:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjELQrz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 May 2023 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjELQry (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2023 12:47:54 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEE0A25F
        for <fio@vger.kernel.org>; Fri, 12 May 2023 09:47:45 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-61b5b4df8baso80360236d6.1
        for <fio@vger.kernel.org>; Fri, 12 May 2023 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683910065; x=1686502065;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u7iX3FaEN2aa8K0p0PP7De0p/CHx+4IgcKcb4/eJr94=;
        b=gGEvmHDZlE6LMLkgIAsQ1SCB0ZdMX+ntAt/cluc2qGwhzIqW5pFxqzZZRH627LOcs3
         hGcNtQgHRmti7+6ZYhUOU+R96xqFfNSR03VMS0RyfIb6k8EzKmybGPwTt2enCNG9Qz2G
         esT4+u25Sxpy+d+Zb/fFzb3E7oSppjlnXS+Ass4XPJzUYOiYOyzh2ZAdqNNO+ARFyQGM
         Yd32vIqV4HHhd3loZJeMkW9g7c9g4qthOqHG11PzSkPz6JBSXEozkOCTEbnto5GSGGYU
         RocCG08R5dqnDXsboua0QcTKi/oE/tmB+kIV4PTGVqtGw41reeGW+BgffuUxQFmvVTPs
         Cx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683910065; x=1686502065;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7iX3FaEN2aa8K0p0PP7De0p/CHx+4IgcKcb4/eJr94=;
        b=gd2ZZ/JRs9lt6zL3vQcyGQHwq0aTZha/RZcQek7BS9O0aXLlQq/SSCdHjVqi4AE4gV
         k+2D5ww2FTG0q5vjrbdDbmjOsixMcT+wv11jsr7ksEfaSwKnsapRswOVCcXdWC75rSIY
         fIB1/0TH0uihtIYk/coFjkPOvxkJLluRhXLQLwtJg1aHGs4pRl8DpRniGpGYQABX5kcD
         rlMUmpXh6Y1x0hsTxmalm8eAz13zIko+9FcflYsgJdmg21hHg9xzArV0iKvtQIO+JjFw
         8Wba93Kn0nFXblf1WaEdPec51h6a3dTbhXj5+m+aKwgnf0B8jiZg0FWGHWQ5+9K6CO66
         Xc9w==
X-Gm-Message-State: AC+VfDxmD35FRRoMmVOar5xGlTPaR8Dxb5uHtpucGDnb80Q2syhJ4Mac
        8H0M4hjS809FNyPnNItcInbm8hDxWN8=
X-Google-Smtp-Source: ACHHUZ5Yf2XEDxrv3xm5yvXj7r3e6k0DpXd38agnYmwuhBGe2ygk9cWpAoKxzRb0yCYO+2wBgng3gg==
X-Received: by 2002:a05:6214:624:b0:621:463e:f337 with SMTP id a4-20020a056214062400b00621463ef337mr18780549qvx.9.1683910064754;
        Fri, 12 May 2023 09:47:44 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id q10-20020ac8410a000000b003b835e7e283sm3226210qtl.44.2023.05.12.09.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 09:47:43 -0700 (PDT)
Message-ID: <a91da230-b6ad-8177-37e1-0b7d3b8aead3@gmail.com>
Date:   Fri, 12 May 2023 12:47:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] engines/io_uring: io_uring_cmd engine cleanup and
 fixes
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, joshi.k@samsung.com
References: <20230508160118.25334-1-ankit.kumar@samsung.com>
 <CGME20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73@epcas5p1.samsung.com>
 <20230508160118.25334-2-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230508160118.25334-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/8/23 12:01, Ankit Kumar wrote:
> - The io_uring_cmd ioengine assumes that logical block size is power of 2.
> In case of extended LBA where metadata is transferred as part of LBA
> this is not correct. Use division operation for that. The existing
> calculation for power of 2 LBA remains the same.
> 
> - The current implementation doesn't support protection info and
> metadata transferred as separate buffer, return error for these
> scenarios.
> 
> - Add checks to verify that block sizes are multiple of LBA size.
> - Add support for 64 LBA formats as per the latest NVM command set
> specification.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>

Ankit, overall this looks fine.

Consider splitting this patch into two separate ones:

1) add support for extended LBA sizes
2) add support for more than 16 LBA formats

 From what I can tell the two changes are conceptually distinct, so it 
makes sense to have two separate patches.

I have 4 specific comments below.

> ---
>   engines/io_uring.c | 31 +++++++++++++++++++++----
>   engines/nvme.c     | 57 +++++++++++++++++++++++++++++++++++++---------
>   engines/nvme.h     |  3 ++-
>   3 files changed, 75 insertions(+), 16 deletions(-)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index f5ffe9f4..32ddba19 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1177,22 +1177,41 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
>   	if (o->cmd_type == FIO_URING_CMD_NVME) {
>   		struct nvme_data *data = NULL;
>   		unsigned int nsid, lba_size = 0;
> +		__u32 ms = 0;
>   		__u64 nlba = 0;
>   		int ret;
>   
>   		/* Store the namespace-id and lba size. */
>   		data = FILE_ENG_DATA(f);
>   		if (data == NULL) {
> -			ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
> +			ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
>   			if (ret)
>   				return ret;
>   
>   			data = calloc(1, sizeof(struct nvme_data));
>   			data->nsid = nsid;
> -			data->lba_shift = ilog2(lba_size);
> +			if (ms)
> +				data->lba_ext = lba_size + ms;
> +			else
> +				data->lba_shift = ilog2(lba_size);
>   
>   			FILE_SET_ENG_DATA(f, data);
>   		}
> +
> +		data = FILE_ENG_DATA(f);

The line above is not needed since data gets a value from calloc if it 
was intially null.

> +		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
> +
> +		for_each_rw_ddir(ddir) {
> +			if (td->o.min_bs[ddir] % lba_size != 0 ||
> +				td->o.max_bs[ddir] % lba_size != 0) {

The != 0 is not needed in the two lines above.

> +				if (data->lba_ext)
> +					log_err("bs must be a multiple of "
> +						"(LBA data size + Metadata size)\n");
> +				else
> +					log_err("bs must be a multiple of LBA data size\n");
> +				return 1;
> +			}
> +                }
>   	}
>   	if (!ld || !o->registerfiles)
>   		return generic_open_file(td, f);
> @@ -1243,16 +1262,20 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
>   	if (o->cmd_type == FIO_URING_CMD_NVME) {
>   		struct nvme_data *data = NULL;
>   		unsigned int nsid, lba_size = 0;
> +		__u32 ms = 0;
>   		__u64 nlba = 0;
>   		int ret;
>   
> -		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
> +		ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
>   		if (ret)
>   			return ret;
>   
>   		data = calloc(1, sizeof(struct nvme_data));
>   		data->nsid = nsid;
> -		data->lba_shift = ilog2(lba_size);
> +		if (ms)
> +			data->lba_ext = lba_size + ms;
> +		else
> +			data->lba_shift = ilog2(lba_size);
>   
>   		f->real_file_size = lba_size * nlba;
>   		fio_file_set_size_known(f);
> diff --git a/engines/nvme.c b/engines/nvme.c
> index fd2161f3..b99eae9c 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -21,8 +21,13 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   	else
>   		return -ENOTSUP;
>   
> -	slba = io_u->offset >> data->lba_shift;
> -	nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
> +	if (data->lba_ext) {
> +		slba = io_u->offset / data->lba_ext;
> +		nlb = (io_u->xfer_buflen / data->lba_ext) - 1;
> +	} else {
> +		slba = io_u->offset >> data->lba_shift;
> +		nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
> +	}
>   
>   	/* cdw10 and cdw11 represent starting lba */
>   	cmd->cdw10 = slba & 0xffffffff;
> @@ -65,8 +70,13 @@ int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
>   	struct nvme_dsm_range dsm;
>   	int ret;
>   
> -	dsm.nlb = (len >> data->lba_shift);
> -	dsm.slba = (offset >> data->lba_shift);
> +	if (data->lba_ext) {
> +		dsm.nlb = len / data->lba_ext;
> +		dsm.slba = offset / data->lba_ext;
> +	} else {
> +		dsm.nlb = len >> data->lba_shift;
> +		dsm.slba = offset >> data->lba_shift;
> +	}
>   
>   	ret = nvme_trim(f->fd, data->nsid, 1, sizeof(struct nvme_dsm_range),
>   			&dsm);
> @@ -94,11 +104,12 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
>   }
>   
>   int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
> -		      __u64 *nlba)
> +		      __u32 *ms, __u64 *nlba)
>   {
>   	struct nvme_id_ns ns;
>   	int namespace_id;
>   	int fd, err;
> +	__u32 format_idx;
>   
>   	if (f->filetype != FIO_TYPE_CHAR) {
>   		log_err("ioengine io_uring_cmd only works with nvme ns "
> @@ -113,9 +124,8 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
>   	namespace_id = ioctl(fd, NVME_IOCTL_ID);
>   	if (namespace_id < 0) {
>   		err = -errno;
> -		log_err("failed to fetch namespace-id");
> -		close(fd);
> -		return err;
> +		log_err("%s: failed to fetch namespace-id\n", f->file_name);
> +		goto out;
>   	}
>   
>   	/*
> @@ -125,17 +135,42 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
>   	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
>   				NVME_CSI_NVM, &ns);
>   	if (err) {
> -		log_err("failed to fetch identify namespace\n");
> +		log_err("%s: failed to fetch identify namespace\n",
> +			f->file_name);
>   		close(fd);
>   		return err;
>   	}
>   
>   	*nsid = namespace_id;
> -	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
> +
> +	if (ns.nlbaf < 16)
> +		format_idx = ns.flbas & 0xf;
> +	else
> +		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
> +

Consider quoting the NVMe standard's description of flbas in the commit 
message to make it easier for anyone looking at this commit in the 
future to verify that the code above is doing the right thing.

> +	*lba_sz = 1 << ns.lbaf[format_idx].ds;
> +

For consistency the definition of struct nvme_id_ns should be updated to 
be struct nvme_lbaf lbaf[64].

> +	/* Only extended LBA can be supported */
> +	*ms = le16_to_cpu(ns.lbaf[format_idx].ms);
> +	if (*ms && !((ns.flbas >> 4) & 0x1)) {
> +		log_err("%s: only extended logical block can be supported\n",
> +			f->file_name);
> +		err = -ENOTSUP;
> +		goto out;
> +	}
> +
> +	/* Check for end to end data protection support */
> +	if (ns.dps & 0x3) {
> +		log_err("%s: end to end data protection not supported\n",
> +			f->file_name);
> +		err = -ENOTSUP;
> +		goto out;
> +	}
>   	*nlba = ns.nsze;
>   
> +out:
>   	close(fd);
> -	return 0;
> +	return err;
>   }
>   
>   int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
> diff --git a/engines/nvme.h b/engines/nvme.h
> index 408594d5..f1d84d68 100644
> --- a/engines/nvme.h
> +++ b/engines/nvme.h
> @@ -88,6 +88,7 @@ enum nvme_zns_zs {
>   struct nvme_data {
>   	__u32 nsid;
>   	__u32 lba_shift;
> +	__u32 lba_ext;
>   };
>   
>   struct nvme_lbaf {
> @@ -223,7 +224,7 @@ int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
>   			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
>   
>   int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
> -		      __u64 *nlba);
> +		      __u32 *ms, __u64 *nlba);
>   
>   int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   			    struct iovec *iov);

