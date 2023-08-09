Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89F0C04A94
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 16:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjHIQeG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 12:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHIQeF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 12:34:05 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27201982
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 09:34:04 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-76c93abeb83so5622385a.0
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 09:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691598844; x=1692203644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yKZuPgFU+o5TddUeM1HCvxLe/p5XgQhrqB9YkwMjIPc=;
        b=rl/SPVz5SPaIJq9789BKQpDzBhpOL/oNDxR2gadGnTULBH66uthsnR2QIZCA4pfjaP
         TMNv3jC5PwPhPrcezhabLuK5iSPs/mwkYJMluISmOUlYvTcmDOcPhG8sQfuk8UWqJd/E
         z75If/gofCf48mbR0zyMiP9oWDTCViykfApASBTipgl7rU6FQ9P/7am2Mia1w+o8hEAt
         TX+LAr3cplxnu7H+9e0g6WC9G+M6F2HN2V7eU3sDD/iwVGJbKOfoL7FFbNNDr78xnbdu
         yqwgw3otRMkwdPMADa+XgAuw9bulOBpRZcvsCZajIuiwEYseG61lT1S/zi6wecsMScoP
         e4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691598844; x=1692203644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKZuPgFU+o5TddUeM1HCvxLe/p5XgQhrqB9YkwMjIPc=;
        b=l00jfmCIN0LCsKxEsv/zn6hzh+yBLtUR4PK42wAiu3AagKENZmHitVCGpr0NjNPXhs
         RsB8Uqb1snIaaT4xttx/xixYWYsw3q+YsuXaP8phTrjyIH2a4/MSwXvw8MA1nhtpbg9p
         fjZiNbrzaNmJsBztkMjh/0O1iZIxPVy69OpJdWXU9WE7aSHr4jey8m46bYMFQXCDOhjD
         1nE0v9/bDkKrOoM4AkC+Mx1oC810L+Utn6t7TYKj87TbGdB7d4GqRh1FumZ7iJ/af8Xv
         aq+oYNb0Xwj7V8Jgb3uqUAZEkM2SqAbAo4HUNzZhbtpehKeuTyhYQjtggp1KX4igM7+y
         2T5w==
X-Gm-Message-State: AOJu0Yy7GJhhtyjjb6H1Xtk0DyCyBRToTfwtPCMoGY6bW0TxILsBNeZM
        BsOiqdG1nIyZPn39dIIhy8ahSRvuggirIw==
X-Google-Smtp-Source: AGHT+IET6nuqZgmw8xLQV05GkLxJ2T7eq7SCrn8xdkYE2IKF/Wh9guGo5FXRsle9QJJcs6ivObrcsg==
X-Received: by 2002:a05:620a:a0d:b0:76c:54bc:a8f7 with SMTP id i13-20020a05620a0a0d00b0076c54bca8f7mr3359032qka.68.1691598843575;
        Wed, 09 Aug 2023 09:34:03 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g16-20020ae9e110000000b0076cb0ed2d7asm4090339qkm.24.2023.08.09.09.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:34:03 -0700 (PDT)
Message-ID: <89def663-1e1b-8716-59ad-547cab805fca@gmail.com>
Date:   Wed, 9 Aug 2023 12:34:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 07/10] engines:io_uring: generate and verify pi for 16b
 guard
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055421epcas5p4ff594788202cc188c5fbed3f19763e0c@epcas5p4.samsung.com>
 <20230809111314.76947-8-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-8-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> Generate and verify protection information for 16 bit guard format, for
> the nvme backend of io_uring_cmd ioengine. The support is there for
> both the cases where metadata is transferred in separate buffer, or
> transferred at the end of logical block creating an extended logical
> block.
> This support also takes into consideration when protection information
> resides in last or first 8 bytes of metadata.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/io_uring.c |  34 +++++++++
>   engines/nvme.c     | 173 +++++++++++++++++++++++++++++++++++++++++++++
>   engines/nvme.h     |  12 ++++
>   3 files changed, 219 insertions(+)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 93b864f0..e773e4af 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -456,7 +456,9 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
>   	struct ioring_options *o = td->eo;
>   	struct io_uring_cqe *cqe;
>   	struct io_u *io_u;
> +	struct nvme_data *data;
>   	unsigned index;
> +	int ret;
>   
>   	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
>   	if (o->cmd_type == FIO_URING_CMD_NVME)
> @@ -470,6 +472,15 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
>   	else
>   		io_u->error = 0;
>   
> +	if (o->cmd_type == FIO_URING_CMD_NVME) {
> +		data = FILE_ENG_DATA(io_u->file);
> +		if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
> +			ret = fio_nvme_pi_verify(data, io_u);
> +			if (ret)
> +				io_u->error = ret;
> +		}
> +	}
> +
>   	return io_u;
>   }
>   
> @@ -1190,6 +1201,7 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
>   {
>   	struct ioring_data *ld = td->io_ops_data;
>   	struct ioring_options *o = td->eo;
> +	struct nvme_pi_data *pi_data;
>   	char *p;
>   
>   	ld->io_u_index[io_u->index] = io_u;
> @@ -1198,11 +1210,32 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
>   		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
>   		p += o->md_per_io_size * io_u->index;
>   		io_u->mmap_data = p;
> +
> +		if (!o->pi_act) {
> +			pi_data = calloc(1, sizeof(*pi_data));
> +			pi_data->io_flags |= o->prchk;
> +			pi_data->apptag_mask = o->apptag_mask;
> +			pi_data->apptag = o->apptag;
> +			io_u->engine_data = pi_data;
> +		}
>   	}
>   
>   	return 0;
>   }
>   
> +static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
> +{
> +	struct ioring_options *o = td->eo;
> +	struct nvme_pi *pi;
> +
> +	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
> +	    (o->cmd_type == FIO_URING_CMD_NVME)) {
> +		pi = io_u->engine_data;
> +		free(pi);
> +		io_u->engine_data = NULL;
> +	}
> +}
> +
>   static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
>   {
>   	struct ioring_data *ld = td->io_ops_data;
> @@ -1408,6 +1441,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
>   	.init			= fio_ioring_init,
>   	.post_init		= fio_ioring_cmd_post_init,
>   	.io_u_init		= fio_ioring_io_u_init,
> +	.io_u_free		= fio_ioring_io_u_free,
>   	.prep			= fio_ioring_cmd_prep,
>   	.queue			= fio_ioring_queue,
>   	.commit			= fio_ioring_commit,
> diff --git a/engines/nvme.c b/engines/nvme.c
> index 8793d742..e89faee5 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include "nvme.h"
> +#include "../crc/crc-t10dif.h"
>   
>   static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
>   {
> @@ -21,6 +22,158 @@ static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
>   		return (io_u->xfer_buflen >> data->lba_shift) - 1;
>   }
>   
> +static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
> +					   struct io_u *io_u,
> +					   struct nvme_cmd_ext_io_opts *opts)
> +{
> +	struct nvme_pi_data *pi_data = io_u->engine_data;
> +	struct nvme_16b_guard_pif *pi;
> +	unsigned char *buf = io_u->xfer_buf;
> +	unsigned char *md_buf = io_u->mmap_data;
> +	__u64 slba = get_slba(data, io_u);
> +	__u32 nlb = get_nlb(data, io_u) + 1;
> +	__u32 lba_num = 0;
> +	__u16 guard = 0;
> +
> +	if (data->pi_loc) {
> +		if (data->lba_ext)
> +			pi_data->interval = data->lba_ext - data->ms;
> +		else
> +			pi_data->interval = 0;
> +	} else {
> +		if (data->lba_ext)
> +			pi_data->interval = data->lba_ext - sizeof(struct nvme_16b_guard_pif);
> +		else
> +			pi_data->interval = data->ms - sizeof(struct nvme_16b_guard_pif);
> +	}
> +
> +	if (io_u->ddir != DDIR_WRITE)
> +		return;
> +
> +	while (lba_num < nlb) {
> +		if (data->lba_ext)
> +			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
> +		else
> +			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
> +			if (data->lba_ext) {
> +				guard = fio_crc_t10dif_generic(0, buf, pi_data->interval);
> +			} else {
> +				guard = fio_crc_t10dif_generic(0, buf, data->lba_size);
> +				guard = fio_crc_t10dif_generic(guard, md_buf, pi_data->interval);
> +			}
> +			pi->guard = cpu_to_be16(guard);
> +		}
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
> +			pi->apptag = cpu_to_be16(pi_data->apptag);
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
> +			switch (data->pi_type) {
> +			case NVME_NS_DPS_PI_TYPE1:
> +			case NVME_NS_DPS_PI_TYPE2:
> +				pi->srtag = cpu_to_be32((__u32)slba + lba_num);
> +				break;
> +			case NVME_NS_DPS_PI_TYPE3:
> +				break;
> +			}
> +		}
> +		if (data->lba_ext) {
> +			buf += data->lba_ext;
> +		} else {
> +			buf += data->lba_size;
> +			md_buf += data->ms;
> +		}
> +		lba_num++;
> +	}
> +}
> +
> +static int fio_nvme_verify_pi_16b_guard(struct nvme_data *data,
> +					struct io_u *io_u)
> +{
> +	struct nvme_pi_data *pi_data = io_u->engine_data;
> +	struct nvme_16b_guard_pif *pi;
> +	struct fio_file *f = io_u->file;
> +	unsigned char *buf = io_u->xfer_buf;
> +	unsigned char *md_buf = io_u->mmap_data;
> +	__u64 slba = get_slba(data, io_u);
> +	__u32 nlb = get_nlb(data, io_u) + 1;
> +	__u32 lba_num = 0;
> +	__u16 guard = 0;
> +
> +	while (lba_num < nlb) {
> +		if (data->lba_ext)
> +			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
> +		else
> +			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
> +
> +		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
> +			if (pi->apptag == NVME_PI_APP_DISABLE &&
> +			    pi->srtag == NVME_PI_REF_DISABLE)
> +				goto next;
> +		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
> +			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
> +			if (pi->apptag == NVME_PI_APP_DISABLE)
> +				goto next;
> +		}
> +
> +		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
> +			if (data->lba_ext) {
> +				guard = fio_crc_t10dif_generic(0, buf, pi_data->interval);
> +			} else {
> +				guard = fio_crc_t10dif_generic(0, buf, data->lba_size);
> +				guard = fio_crc_t10dif_generic(guard, md_buf, pi_data->interval);
> +			}
> +			if (be16_to_cpu(pi->guard) != guard) {
> +				log_err("%s: Guard compare error: LBA: %llu Expected=%x, Actual=%x\n",
> +					f->file_name, (unsigned long long)slba,
> +					guard, be16_to_cpu(pi->guard));
> +				return -EIO;
> +			}
> +		}
> +
> +		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_APP) {
> +			if ((be16_to_cpu(pi->apptag) & pi_data->apptag_mask) !=
> +			    (pi_data->apptag & pi_data->apptag_mask)) {
> +				log_err("%s: APPTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
> +					f->file_name, (unsigned long long)slba,
> +					(pi_data->apptag & pi_data->apptag_mask),
> +					be16_to_cpu(pi->apptag) & pi_data->apptag_mask);
> +				return -EIO;
> +			}
> +		}
> +

I think the above would be easier for humans to read if there were local 
variables for (be16_to_cpu(pi->apptag) & pi_data->apptag_mask) and 
(pi_data->apptag & pi_data->apptag_mask). Defining local variables would 
also simplify the error message.

> +		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
> +			switch (data->pi_type) {
> +			case NVME_NS_DPS_PI_TYPE1:
> +			case NVME_NS_DPS_PI_TYPE2:
> +				if (be32_to_cpu(pi->srtag) !=
> +				    ((__u32)slba + lba_num)) {
> +					log_err("%s: REFTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
> +						f->file_name, (unsigned long long)slba,
> +						(__u32)slba + lba_num,
> +						be32_to_cpu(pi->srtag));
> +					return -EIO;
> +				}
> +				break;
> +			case NVME_NS_DPS_PI_TYPE3:
> +				break;
> +			}
> +		}
> +next:
> +		if (data->lba_ext) {
> +			buf += data->lba_ext;
> +		} else {
> +			buf += data->lba_size;
> +			md_buf += data->ms;
> +		}
> +		lba_num++;
> +	}
> +
> +	return 0;
> +}
> +
>   void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   				  struct nvme_dsm_range *dsm)
>   {
> @@ -96,6 +249,11 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   	slba = get_slba(data, io_u);
>   	cmd->cdw12 |= opts->io_flags;
>   
> +	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
> +		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
> +			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
> +	}
> +
>   	switch (data->pi_type) {
>   	case NVME_NS_DPS_PI_TYPE1:
>   	case NVME_NS_DPS_PI_TYPE2:
> @@ -120,6 +278,21 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   	}
>   }
>   
> +int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
> +{
> +	int ret = 0;
> +
> +	switch (data->guard_type) {
> +	case NVME_NVM_NS_16B_GUARD:
> +		ret = fio_nvme_verify_pi_16b_guard(data, io_u);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>   static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
>   			 enum nvme_csi csi, void *data)
>   {
> diff --git a/engines/nvme.h b/engines/nvme.h
> index f3598352..a1102dfe 100644
> --- a/engines/nvme.h
> +++ b/engines/nvme.h
> @@ -44,6 +44,9 @@ struct nvme_uring_cmd {
>   #define NVME_IDENTIFY_CSI_SHIFT 24
>   #define NVME_NQN_LENGTH	256
>   
> +#define NVME_PI_APP_DISABLE 0xFFFF
> +#define NVME_PI_REF_DISABLE 0xFFFFFFFF
> +
>   #define NVME_ZNS_ZRA_REPORT_ZONES 0
>   #define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
>   #define NVME_ZNS_ZSA_RESET 0x4
> @@ -131,6 +134,13 @@ enum nvme_io_control_flags {
>   	NVME_IO_PRINFO_PRACT		= 1U << 29,
>   };
>   
> +struct nvme_pi_data {
> +	__u32 interval;
> +	__u32 io_flags;
> +	__u16 apptag;
> +	__u16 apptag_mask;
> +};
> +
>   struct nvme_lbaf {
>   	__le16			ms;
>   	__u8			ds;
> @@ -415,6 +425,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   		      struct nvme_cmd_ext_io_opts *opts);
>   
> +int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
> +
>   int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
>   			     enum zbd_zoned_model *model);
>   

