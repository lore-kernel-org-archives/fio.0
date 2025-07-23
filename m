Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BADD20F079
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753291419; cv=none; b=r1EXcdMunmlJZCJRZqdVBYeP9Sg4ZaFfHJ3g/RU1zR5R/zJXt4cUVG5xM9/cOhu150lGGY5JQrpQLxAIufndmKykvLqCaW990QbK/JOvvRnto+H+RorT9lAtOk/uOdzoOvnQyrSh7UCtSCInmpSlQmIC71KnA03On999tXCiCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753291419; c=relaxed/simple;
	bh=8x1HfKLg9WhxKjXTfE6dP35KYtqcrCPDPwsFM1Y4u9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SK/y4pxSYLuMUv7TOzB/ChCvKCEwxuDItGuISnt5sPfDdCQJI4UoQ1EbcX+Ajj7v/avEu9kmWjp/m6PiDkTPhtAqOmKNC2NcKREaBWNLceo+6YQLuuFf/iLCf1ARvQGEZZ3MaQxZl5n4b6SND8jNSuQeSRogPP89NE5qHyhDk8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oSFODI7F; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oSFODI7F"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3de1875bf9dso413325ab.2
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753291415; x=1753896215; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hoM8c9p2obruyw7x1OUD08ugGvmv/O4B+QovOsBBmSU=;
        b=oSFODI7FBrDwPJ4v5ekuNSMA5f+xPrH1f6/mNdno2Zj4E8lglfXAvTVEYXXCQizbot
         X/cwWGJBajsqL5iPGnXSps3JuCuq3iPQR33gSbsEUp6Z24TeMsUGBlMVywOo+xGnItuA
         QdLmJfHbnD+9sZOu7zTGVO2CZ6K5nGGV9fy967LdJ5wrDWda1oZcSMbE23FoyfcgHhJK
         2vWtPySO6VYeGSd4nub0oxIZ/hL2q9i2mT6oDqaejkUl53uScBFw5XbmdxWWoJEE9Biz
         0paif5oWezGcOGnqP1lisKckg7jyI5ZYk3t3+3FrjpLmsQJ77KNExnICkwWrRW2HAZpb
         loIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753291415; x=1753896215;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hoM8c9p2obruyw7x1OUD08ugGvmv/O4B+QovOsBBmSU=;
        b=cYqjOpFkZwNV45mZkdNgbgbX3GIGsVpmFw1Ggk1xN0ccSvAsQmbqfwcl+UltELQflc
         mEK9TnEDMM7tVloLnQq9IrssUQx1ToR0wc1EvS5Tz4w9MMnO7eZfnxUTCVdTqQg9WvVu
         ztELMHl8/9KK+FlgLhOmB56JtNLfO6xenCcKdUTyzoDCEXZ5W4P3vfDf4YNID/1hzLl/
         5k+x8OZLFc19AYBXZz+VEQPZTxd/aVT8psAodoz33V3WkLvOgBGJeKb6VwB6vRq9Zu2E
         xEx4WG4A87RyVkJvAZT/bBmq4dpdYcKbn8miKSzN88B9iV+yZNwLh/+HsXq5chGMfJmR
         Yizg==
X-Forwarded-Encrypted: i=1; AJvYcCVpz7to5gQMtj8zu1OjOZKrY4xNnLD1dN1knDAlxclRRxRo4kbW9i+7DZWxUGFHz9E+698=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYIugKHznnS3Pq+zQPeW9mR3zgCjxyBmO/EBfRey9yBMWu6hX7
	KqDKzfLBfLkyMZvS5IuDb1RkluoCtpTTb5YbKspH7B8bEI+BHS3pM3E5zoBmMsLMjtY=
X-Gm-Gg: ASbGncufUasIcua8A2767taAf9oFTNv52gZQhH4dlM0jTvQd4BL9fJ1SZ6qkIrjJSV2
	0QxtYDO68Hqx0WHwjDwFlYf+iWdwq1toeqOM2K38x8iLg6q1ae4pvPEIhSXcL0rHI+YuAk4uaDo
	+nLhCQjHMCHIjQjJHKbHAVFucdG4/4MzmlOsjDLAlQ+v2sN24b0MkXMviCeHShBuz2Aa4K8wH/u
	e497LO0VXmBUh5aIRojip96jyrqn8Oo/z7/MzDknqZMkhVjI1Q9s6KuFDDSwpcC9h+/+3Fe2da6
	mgA/XkKfsJwohJlG0R6JQFXlvhz7god8xooxsPgnKcq4ykjqKDu/AHaX/Fq03yjvgq0iYN4bK9l
	J7LLuQfSVm7yXzuFE/Q==
X-Google-Smtp-Source: AGHT+IFaAebrThKaqXa5aepggrfLDUiT3Sd/sXxrPzceOyrDa6VRUwvTwgvoQ0NxxY1W8XE3UA4hVw==
X-Received: by 2002:a92:cd8d:0:b0:3df:460a:ec3c with SMTP id e9e14a558f8ab-3e3355d0264mr72965695ab.22.1753291414008;
        Wed, 23 Jul 2025 10:23:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca6183asm3129519173.130.2025.07.23.10.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 10:23:33 -0700 (PDT)
Message-ID: <15cb4581-7067-40fa-9a1b-8883c9993d2c@kernel.dk>
Date: Wed, 23 Jul 2025 11:23:32 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] engines/io_uring: support r/w with metadata
To: Vincent Fu <vincentfu@gmail.com>, anuj1072538@gmail.com,
 hch@infradead.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
 <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/25 11:04 AM, Vincent Fu wrote:
> @@ -436,6 +502,27 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
>  				sqe->len = 1;
>  			}
>  		}
> +		if (o->md_per_io_size) {
> +			struct io_uring_attr_pi *pi_attr = io_u->pi_attr;
> +			struct nvme_data *data = FILE_ENG_DATA(io_u->file);
> +
> +			sqe->attr_type_mask = IORING_RW_ATTR_FLAG_PI;
> +			sqe->attr_ptr = (__u64)(uintptr_t)pi_attr;
> +			pi_attr->addr = (__u64)(uintptr_t)io_u->mmap_data;
> +			pi_attr->len = o->md_per_io_size;
> +			pi_attr->app_tag = o->apptag;
> +			pi_attr->flags = 0;
> +			if (strstr(o->pi_chk, "GUARD") != NULL)
> +				pi_attr->flags |= IO_INTEGRITY_CHK_GUARD;
> +			if (strstr(o->pi_chk, "REFTAG") != NULL) {
> +				__u64 slba = get_slba(data, io_u->offset);
> +
> +				pi_attr->flags |= IO_INTEGRITY_CHK_REFTAG;
> +				pi_attr->seed = (__u32)slba;
> +			}
> +			if (strstr(o->pi_chk, "APPTAG") != NULL)
> +				pi_attr->flags |= IO_INTEGRITY_CHK_APPTAG;
> +		}

I'd move these out-of-line whenever possible. It both improves
readability, but also conveys that this isn't necessarily the normal/hot
path.

> @@ -590,6 +678,19 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
>  			io_u->error = -cqe->res;
>  		else
>  			io_u->resid = io_u->xfer_buflen - cqe->res;
> +		return io_u;
> +	}
> +
> +	if (o->md_per_io_size) {
> +		struct nvme_data *data;
> +		int ret;
> +
> +		data = FILE_ENG_DATA(io_u->file);
> +		if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
> +			ret = fio_nvme_pi_verify(data, io_u);
> +			if (ret)
> +				io_u->error = ret;
> +		}
>  	}

Ditto

> +	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
> +		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
> +		struct nvme_cmd_ext_io_opts ext_opts = {0};
> +
> +		if (data->pi_type) {
> +			if (o->pi_act)
> +				ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
> +
> +			ext_opts.io_flags |= o->prchk;
> +			ext_opts.apptag = o->apptag;
> +			ext_opts.apptag_mask = o->apptag_mask;
> +		}
> +		fio_nvme_generate_guard(io_u, &ext_opts);
> +	}

Ehh a strcmp() in the hot path?! First of all, that's a big no-no.
Secondly, if this really was required, you'd add something to put that
strcmp() in the slow path and flag it. Lastly, thankfully this should be
much better as:

	if (td->io_ops == &ioengine_uring ...)

instead.

> @@ -1347,12 +1464,20 @@ static int fio_ioring_init(struct thread_data *td)
>  	/* io_u index */
>  	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
>  
> +	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
> +		if (o->apptag_mask != 0xffff) {
> +			log_err("fio: io_uring with metadata requires an apptag_mask of 0xffff\n");
> +			return 1;
> +		}
> +	}

Same, though this is at least slow path. But people copy-paste wonky
code like that all the time...

>  	 * metadata buffer for nvme command.
>  	 * We are only supporting iomem=malloc / mem=malloc as of now.
>  	 */
> -	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
> -	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
> +	if ((!strcmp(td->io_ops->name, "io_uring_cmd") &&
> +	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) ||
> +	    (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size)) {
>  		md_size = (unsigned long long) o->md_per_io_size
>  				* (unsigned long long) td->o.iodepth;
>  		md_size += page_mask + td->o.mem_align;

And I'm starting to see where this is coming from. If you are so
inclined, please do a cleanup patch first getting rid of these strcmp()
calls.

>  static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
>  {
>  	struct ioring_data *ld = td->io_ops_data;
>  	struct ioring_options *o = td->eo;
>  
> +	if (o->md_per_io_size) {
> +		struct nvme_data *data = NULL;
> +		__u64 nlba = 0;
> +		int ret;
> +
> +		data = FILE_ENG_DATA(f);
> +		if (data == NULL) {
> +			data = calloc(1, sizeof(struct nvme_data));
> +			ret = fio_get_pi_info(f, &nlba, o->pi_act, data);
> +			if (ret) {
> +				free(data);
> +				return ret;
> +			}
> +
> +			FILE_SET_ENG_DATA(f, data);
> +		}
> +	}

Out of line please...

> diff --git a/engines/nvme.c b/engines/nvme.c
> index 37a31e2f..4b3d3860 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -8,22 +8,6 @@
>  #include "../crc/crc-t10dif.h"
>  #include "../crc/crc64.h"
>  
> -static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
> -{
> -	if (data->lba_ext)
> -		return offset / data->lba_ext;
> -
> -	return offset >> data->lba_shift;
> -}
> -
> -static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
> -{
> -	if (data->lba_ext)
> -		return len / data->lba_ext - 1;
> -
> -	return (len >> data->lba_shift) - 1;
> -}
> -

Various bits like this, please do a prep patch first moving things
around.

-- 
Jens Axboe
