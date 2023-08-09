Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E7EC001B0
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 16:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjHIQfc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 12:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHIQfc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 12:35:32 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762211B2
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 09:35:31 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6bcac140aaaso5561212a34.2
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 09:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691598930; x=1692203730;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QkVLVC/37+YVKz6PGpnWDRE2U2Z1NPHS1fdHlES13F8=;
        b=ZERzTnegB/SYzmJdsj0HlVMXIaFNRy4XN13y6BnyYj6dvohPcPhq+vgbX0YS3HzSd7
         I7ZdRH77041P4Va+/w4lXNy5HgcPkezn+Zl4T0SRaRSz5T/l8Y7KlTICdC5wQTMLdgEE
         1wzTCnAkEWIUBzP+/KDKiaeq+oZmsqMBrKCBlXut4QiVyQ4ur0d5BYlWCt1FuYKKvuWO
         2HTJ3b0cEg3fcZQjdjgiWHsp5YX8jJmPnC3xTyh2dcSxDwJDP71dqWxbVCJQdSvRKwjL
         FU4LesbGlDP7JWwmg0ff3uR9SNqJsWY6tZU3qSGPCs+syODpgtPwCCT9exS8hzoCCu1h
         aMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691598930; x=1692203730;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkVLVC/37+YVKz6PGpnWDRE2U2Z1NPHS1fdHlES13F8=;
        b=FXbA7wi3UyAplzaR6wqDeTtlIsz3QO+sm6NLrAjnZb9OnyiUhSto6aXn8q3onQkGel
         LmoKupuyQpe9Byc4M9xzGGsxU/WX4rkiKNZuYpnAMJgSEtnL/h9Bij1JNysLYBBnDN+u
         wSpJk++kiroOV8MHmuGm/s1Fqj77pjMXBCZQOWafHCPZCO0GymIJMS5w2yxMpm4NnDMn
         7e0bJCxgQsmoBYfcPGJvDUGNHcTpz5+hbHeAP0L4+p5Ai+/tr+h0wuYs21F/8v1MtzT9
         CtlRCtjy4KKeHwSF9ViYmX6zcdmi25WFovvnO49PvNyTkqJjeaSz9HnM0CvTr/IrF0MP
         3TeA==
X-Gm-Message-State: AOJu0YwTyn4wS5TKi8zNW/R0iTdOBp3Sr7qE1+JVJvbx7qwEjhLb0wPR
        2IH4cCvUHA7yJJiumHiA1I0=
X-Google-Smtp-Source: AGHT+IE5nOMILzWWNO1esGNDJ1cPvUi1Eluurngdl/Hq5h2WiM0AgZpMDpFXFR5tRm0kBACwjijCUQ==
X-Received: by 2002:a05:6808:1717:b0:3a7:b15d:b58c with SMTP id bc23-20020a056808171700b003a7b15db58cmr3858124oib.34.1691598930413;
        Wed, 09 Aug 2023 09:35:30 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id l9-20020a0ce089000000b0063d09326fa4sm4583182qvk.31.2023.08.09.09.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:35:29 -0700 (PDT)
Message-ID: <c6fc2d3d-ff55-f5fa-474f-d88053659841@gmail.com>
Date:   Wed, 9 Aug 2023 12:35:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 10/10] engines:io_uring: generate and verify pi for 64b
 guard
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055425epcas5p48d90059042b45333d73d8b814b0a501c@epcas5p4.samsung.com>
 <20230809111314.76947-11-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-11-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> Generate and verify protection information for 64 bit guard format, for
> the nvme backend of io_uring_cmd ioengine. The support is there for
> both the cases where metadata is transferred in separate buffer, or
> transferred at the end of logical block creating an extended logical
> block.
> This support also takes into consideration when protection information
> resides in last or first 8 bytes of metadata.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/nvme.c | 159 +++++++++++++++++++++++++++++++++++++++++++++++++
>   engines/nvme.h |   7 +++
>   2 files changed, 166 insertions(+)
> 
> diff --git a/engines/nvme.c b/engines/nvme.c
> index 724950be..db0d70bf 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -6,6 +6,7 @@
>   
>   #include "nvme.h"
>   #include "../crc/crc-t10dif.h"
> +#include "../crc/crc64.h"
>   
>   static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
>   {
> @@ -175,6 +176,159 @@ next:
>   	return 0;
>   }
>   
> +static void fio_nvme_generate_pi_64b_guard(struct nvme_data *data,
> +					   struct io_u *io_u,
> +					   struct nvme_cmd_ext_io_opts *opts)
> +{
> +	struct nvme_pi_data *pi_data = io_u->engine_data;
> +	struct nvme_64b_guard_pif *pi;
> +	unsigned char *buf = io_u->xfer_buf;
> +	unsigned char *md_buf = io_u->mmap_data;
> +	uint64_t guard = 0;
> +	__u64 slba = get_slba(data, io_u);
> +	__u32 nlb = get_nlb(data, io_u) + 1;
> +	__u32 lba_num = 0;
> +
> +	if (data->pi_loc) {
> +		if (data->lba_ext)
> +			pi_data->interval = data->lba_ext - data->ms;
> +		else
> +			pi_data->interval = 0;
> +	} else {
> +		if (data->lba_ext)
> +			pi_data->interval = data->lba_ext - sizeof(struct nvme_64b_guard_pif);
> +		else
> +			pi_data->interval = data->ms - sizeof(struct nvme_64b_guard_pif);
> +	}
> +
> +	if (io_u->ddir != DDIR_WRITE)
> +		return;
> +
> +	while (lba_num < nlb) {
> +		if (data->lba_ext)
> +			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
> +		else
> +			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
> +			if (data->lba_ext) {
> +				guard = fio_crc64_rocksoft_generic(0, buf, pi_data->interval);
> +			} else {
> +				guard = fio_crc64_rocksoft_generic(0, buf, data->lba_size);
> +				guard = fio_crc64_rocksoft_generic(guard, md_buf,
> +								   pi_data->interval);
> +			}
> +			pi->guard = cpu_to_be64(guard);
> +		}
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
> +			pi->apptag = cpu_to_be16(pi_data->apptag);
> +
> +		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
> +			switch (data->pi_type) {
> +			case NVME_NS_DPS_PI_TYPE1:
> +			case NVME_NS_DPS_PI_TYPE2:
> +				put_unaligned_be48(slba + lba_num, pi->srtag);
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
> +static int fio_nvme_verify_pi_64b_guard(struct nvme_data *data,
> +					struct io_u *io_u)
> +{
> +	struct nvme_pi_data *pi_data = io_u->engine_data;
> +	struct nvme_64b_guard_pif *pi;
> +	struct fio_file *f = io_u->file;
> +	unsigned char *buf = io_u->xfer_buf;
> +	unsigned char *md_buf = io_u->mmap_data;
> +	__u64 slba = get_slba(data, io_u);
> +	__u64 ref, ref_exp, guard = 0;
> +	__u32 nlb = get_nlb(data, io_u) + 1;
> +	__u32 lba_num = 0;
> +
> +	while (lba_num < nlb) {
> +		if (data->lba_ext)
> +			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
> +		else
> +			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
> +
> +		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
> +			if (pi->apptag == NVME_PI_APP_DISABLE &&
> +			    fio_nvme_pi_ref_escape(pi->srtag))
> +				goto next;
> +		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
> +			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
> +			if (pi->apptag == NVME_PI_APP_DISABLE)
> +				goto next;
> +		}
> +
> +		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
> +			if (data->lba_ext) {
> +				guard = fio_crc64_rocksoft_generic(0, buf, pi_data->interval);
> +			} else {
> +				guard = fio_crc64_rocksoft_generic(0, buf, data->lba_size);
> +				guard = fio_crc64_rocksoft_generic(guard, md_buf,
> +								   pi_data->interval);
> +			}
> +			if (be64_to_cpu((uint64_t)pi->guard) != guard) {
> +				log_err("%s: Guard compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
> +					f->file_name, (unsigned long long)slba,
> +					guard, be64_to_cpu((uint64_t)pi->guard));
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

Same comment here as for the 16b guard patch: local variables for the 
arguments of the comparison.

> +		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
> +			switch (data->pi_type) {
> +			case NVME_NS_DPS_PI_TYPE1:
> +			case NVME_NS_DPS_PI_TYPE2:
> +				ref = get_unaligned_be48(pi->srtag);
> +				ref_exp = (slba + lba_num) & ((1ULL << 48) - 1);
> +				if (ref != ref_exp) {
> +					log_err("%s: REFTAG compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
> +						f->file_name, (unsigned long long)slba,
> +						ref_exp, ref);
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
>   void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   				  struct nvme_dsm_range *dsm)
>   {
> @@ -253,6 +407,8 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>   	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
>   		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
>   			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
> +		else if (data->guard_type == NVME_NVM_NS_64B_GUARD)
> +			fio_nvme_generate_pi_64b_guard(data, io_u, opts);
>   	}
>   
>   	switch (data->pi_type) {
> @@ -287,6 +443,9 @@ int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
>   	case NVME_NVM_NS_16B_GUARD:
>   		ret = fio_nvme_verify_pi_16b_guard(data, io_u);
>   		break;
> +	case NVME_NVM_NS_64B_GUARD:
> +		ret = fio_nvme_verify_pi_64b_guard(data, io_u);
> +		break;
>   	default:
>   		break;
>   	}
> diff --git a/engines/nvme.h b/engines/nvme.h
> index fb1f7760..792b35d8 100644
> --- a/engines/nvme.h
> +++ b/engines/nvme.h
> @@ -457,4 +457,11 @@ static inline __u64 get_unaligned_be48(__u8 *p)
>   		p[3] << 16 | p[4] << 8 | p[5];
>   }
>   
> +static inline bool fio_nvme_pi_ref_escape(__u8 *reftag)
> +{
> +	__u8 ref_esc[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> +
> +	return memcmp(reftag, ref_esc, sizeof(ref_esc)) == 0;
> +}
> +
>   #endif

