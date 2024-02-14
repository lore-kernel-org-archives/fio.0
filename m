Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A726127B7D
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707933114; cv=none; b=QA2OBSKKtRfTR8zZk39IwV7+fxr46ikr+nj2O9lKXutTeNWWeq40mH3TyMTAvE42OW/TuNETGmHshh3P9D/WfvOLgTao79vdt7rOyO0G7mtqy/fcaWMaiU1BXOI4GnKxhe09bi1ODwBLLCh5nzxIoZcuU+0QKqZ9tZGr0ve6uEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707933114; c=relaxed/simple;
	bh=4pOmgQ5+UWjOtZwC+Ua+gECXOYJJzV8/5iN0O1bhj9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPjjVEkaeyamTZ4XZrz4HDNawjmxfa4SidwwrurpZUbBRpxGM+n5QYwpL04Ul6LCG4kZSYPik9T7tlviQSNNVLOWF+iPoNnGQtiJtNU5w7GUhu/7Q19FvEB+JIb/MK3udQLIGMghPGgbSl+5O8ibfOqj3twDgLdrr/uEj66M3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXvCuZIN; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXvCuZIN"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-785d57056b0so1461885a.0
        for <fio@vger.kernel.org>; Wed, 14 Feb 2024 09:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707933111; x=1708537911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gqrFQRwtZ//OsXFF5FjOIVD2hIc3B1DPN8lzMZK6EKA=;
        b=lXvCuZINUCmmzfAgA2GJeD+Yp7Xds55v0xpb//EhGTiFwRAfuZu25SnNhhW0GI48H7
         RWjT3QEqHnWoaEx6sBYRVnBU0I6UAboAdkzbhmnXSaCuhYP61nvU2av4RsVXVy0Anu1C
         5iNwhj4ubmoYMjrjsDG03OisPGIL/J9VDqVkdppVm4h6A15ytKuykADmtT7ioI3UIVCk
         xazvXpd7TT7Ai1cQxnuNTrK0k+V65UZmfw9mGo0Dm68k+GwUN7uwwdJe0gpWztVI1W2L
         XFQEw8bDIy3ezdZ4Dg5s+b7lqaohBylZTM7gEcS+h8dOzFEf0kTfBico4lf+Smew6KDI
         zLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707933111; x=1708537911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqrFQRwtZ//OsXFF5FjOIVD2hIc3B1DPN8lzMZK6EKA=;
        b=Gm/EXQzbRDxt1MECiJL2I6eOO7I6EMHU7QThpiiCqp0eZa0SHNcyAhMX8lFOfMO5d4
         L6YgzMw6BndFtiuGahtOoyZO6c/t6iQtx/ObKUfA8QrlL2LFDLg1zxTfcbNt/xVgMj7l
         rxyDCngdrNdwgUdDOTAfdTo1cvV7dQd2Y057VF1Mac5iqBD+RDWmSYfvGZur1EGz96Uv
         u50EUYDFpvbkArgcOtKiQfFWK+NMM9H+ybtnUHJJYkACSMPF0mRYfvobPEJmBlkNU2G1
         32Cyb0Nwi4AIZzKvregKc9Pxn1clyjKg1IkJj1C2EcUaGTrdTJ2K3hLaONMaDm017rcr
         i8gw==
X-Gm-Message-State: AOJu0YwVrgt6sFcQjFZ0pTcC+C8PsAMqGNSNax4ZnBVPlhZC/Ad9CFHs
	KQ1hy9aQSHit63QwLWH3uEVVsixBDy41IjbDUCfgSu72w30JXMfZ
X-Google-Smtp-Source: AGHT+IGkUq2Mm88+jXZgWA+BZ4O6/6ivmRIGSoEBFM6tvWHEREROVxEvV4M+GfX540cmFnqpQ06jwQ==
X-Received: by 2002:a05:620a:e1e:b0:786:89d9:b165 with SMTP id y30-20020a05620a0e1e00b0078689d9b165mr3436362qkm.5.1707933111142;
        Wed, 14 Feb 2024 09:51:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVBU7ExWEJ5tzRssrD6ZXMhmgXWLgRGg+nHZyuy9MitpOnqayzGC9nxRm4ldIA9L8lAHpEmNiWLf2ITJXVNZluAK0+aYbbz/2gMQb99EOwAJf85y6nYZiQ/CBnlKjGK+RqNvMAGcZ+JZ/U=
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id xb10-20020a05620a5aca00b00785600f9d21sm3989241qkn.123.2024.02.14.09.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 09:51:50 -0800 (PST)
Message-ID: <86754e2a-8083-44ea-8f02-e5966628763c@gmail.com>
Date: Wed, 14 Feb 2024 12:51:50 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] trim: add support for multiple ranges
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org, joshi.k@samsung.com
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
 <CGME20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685@epcas5p4.samsung.com>
 <20240214120624.135416-2-ankit.kumar@samsung.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240214120624.135416-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 07:06, Ankit Kumar wrote:
> NVMe specification allow multiple ranges for the dataset management
> commands. Currently the block ioctl only allows a single range for
> trim, however multiple ranges can be specified using nvme character
> device.
> 
> Add an option num_range to send multiple range per trim request, which
> only works if the data direction is solely trim i.e. trim or randtrim.
> Add FIO_MULTI_RANGE_TRIM as the ioengine flag, to restrict the usage of
> this new option.
> For multi range trim request this modifies the way IO buffers are used.
> The buffer length will depend on number of trim ranges and the actual
> buffer will contains start and length of each range entry.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst        |  7 +++++
>   backend.c        | 20 ++++++++++--
>   cconv.c          |  2 ++
>   fio.1            |  6 ++++
>   fio.h            | 18 +++++++++++
>   init.c           | 13 ++++++++
>   io_u.c           | 81 ++++++++++++++++++++++++++++++++++++++----------
>   io_u.h           |  4 +++
>   ioengines.h      |  2 ++
>   options.c        | 11 +++++++
>   thread_options.h |  3 ++
>   11 files changed, 148 insertions(+), 19 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 5bc1713c..c798613b 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2534,6 +2534,13 @@ with the caveat that when used on the command line, they must come after the
>   	Specifies logical block application tag mask value, if namespace is
>   	formatted to use end to end protection information. Default: 0xffff.
>   
> +.. option:: num_range=int : [io_uring_cmd]
> +
> +	For trim command this will be the number of ranges to trim per I/O
> +	request. The number of logical blocks per range is determined by the
> +	:option:`bs` option which should be a multiple of logical block size.
> +	This cannot be used with read or write. Default: 1.
> +

I would add a note here and in fio.1 that log_offset is not able to log 
all the offsets for trim operations with num_range > 1


>   .. option:: cpuload=int : [cpuio]
>   
>   	Attempt to use the specified percentage of CPU cycles. This is a mandatory
> diff --git a/backend.c b/backend.c
> index 1fab467a..2f2221bf 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1333,7 +1333,7 @@ static int init_io_u(struct thread_data *td)
>   int init_io_u_buffers(struct thread_data *td)
>   {
>   	struct io_u *io_u;
> -	unsigned long long max_bs, min_write;
> +	unsigned long long max_bs, min_write, trim_bs = 0;
>   	int i, max_units;
>   	int data_xfer = 1;
>   	char *p;
> @@ -1344,7 +1344,18 @@ int init_io_u_buffers(struct thread_data *td)
>   	td->orig_buffer_size = (unsigned long long) max_bs
>   					* (unsigned long long) max_units;
>   
> -	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
> +	if (td_trim(td) && td->o.num_range > 1) {
> +		trim_bs = td->o.num_range * sizeof(struct trim_range);
> +		td->orig_buffer_size = trim_bs
> +					* (unsigned long long) max_units;
> +	}
> +
> +	/*
> +	 * For reads, writes, and multi-range trim operations we need a
> +	 * data buffer
> +	 */
> +	if (td_ioengine_flagged(td, FIO_NOIO) ||
> +	    !(td_read(td) || td_write(td) || (td_trim(td) && td->o.num_range > 1)))
>   		data_xfer = 0;
>   
>   	/*
> @@ -1396,7 +1407,10 @@ int init_io_u_buffers(struct thread_data *td)
>   				fill_verify_pattern(td, io_u->buf, max_bs, io_u, 0, 0);
>   			}
>   		}
> -		p += max_bs;
> +		if (td_trim(td) && td->o.num_range > 1)
> +			p += trim_bs;
> +		else
> +			p += max_bs;
>   	}
>   
>   	return 0;
> diff --git a/cconv.c b/cconv.c
> index c9298408..ead47248 100644
> --- a/cconv.c
> +++ b/cconv.c
> @@ -111,6 +111,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
>   	o->serialize_overlap = le32_to_cpu(top->serialize_overlap);
>   	o->size = le64_to_cpu(top->size);
>   	o->io_size = le64_to_cpu(top->io_size);
> +	o->num_range = le32_to_cpu(top->num_range);
>   	o->size_percent = le32_to_cpu(top->size_percent);
>   	o->io_size_percent = le32_to_cpu(top->io_size_percent);
>   	o->fill_device = le32_to_cpu(top->fill_device);
> @@ -609,6 +610,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
>   
>   	top->size = __cpu_to_le64(o->size);
>   	top->io_size = __cpu_to_le64(o->io_size);
> +	top->num_range = __cpu_to_le32(o->num_range);
>   	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
>   	top->start_delay = __cpu_to_le64(o->start_delay);
>   	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
> diff --git a/fio.1 b/fio.1
> index 7ec5c745..cfa49423 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2293,6 +2293,12 @@ end to end protection information. Default: 0x1234.
>   Specifies logical block application tag mask value, if namespace is formatted
>   to use end to end protection information. Default: 0xffff.
>   .TP
> +.BI (io_uring_cmd)num_range \fR=\fPint
> +For trim command this will be the number of ranges to trim per I/O request.
> +The number of logical blocks per range is determined by the \fBbs\fR option
> +which should be a multiple of logical block size. This cannot be used with
> +read or write. Default: 1.
> +.TP
>   .BI (cpuio)cpuload \fR=\fPint
>   Attempt to use the specified percentage of CPU cycles. This is a mandatory
>   option when using cpuio I/O engine.
> diff --git a/fio.h b/fio.h
> index 1322656f..5d558e7b 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -71,6 +71,16 @@
>   
>   struct fio_sem;
>   
> +#define MAX_TRIM_RANGE	256
> +
> +/*
> + * Range for trim command
> + */
> +struct trim_range {
> +	unsigned long long start;
> +	unsigned long long len;
> +};
> +
>   /*
>    * offset generator types
>    */
> @@ -609,6 +619,14 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
>   	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
>   }
>   
> +static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
> +{
> +	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
> +		return true;
> +	else
> +		return false;
> +}
> +
>   static inline bool should_fsync(struct thread_data *td)
>   {
>   	if (td->last_was_sync)
> diff --git a/init.c b/init.c
> index 105339fa..7a0b14a3 100644
> --- a/init.c
> +++ b/init.c
> @@ -618,6 +618,19 @@ static int fixup_options(struct thread_data *td)
>   		ret |= 1;
>   	}
>   
> +	if (td_trimwrite(td) && o->num_range > 1) {
> +		log_err("fio: trimwrite cannot be used with multiple"
> +			" ranges.\n");
> +		ret |= 1;
> +	}
> +
> +	if (td_trim(td) && o->num_range > 1 &&
> +	    !td_ioengine_flagged(td, FIO_MULTI_RANGE_TRIM)) {
> +		log_err("fio: can't use multiple ranges with IO engine %s\n",
> +			td->io_ops->name);
> +		ret |= 1;
> +	}
> +
>   #ifndef CONFIG_PSHARED
>   	if (!o->use_thread) {
>   		log_info("fio: this platform does not support process shared"
> diff --git a/io_u.c b/io_u.c
> index 13187882..50df518c 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -943,8 +943,11 @@ static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
>   static int fill_io_u(struct thread_data *td, struct io_u *io_u)
>   {
>   	bool is_random;
> -	uint64_t offset;
> +	uint64_t offset, buflen, i = 0;
>   	enum io_u_action ret;
> +	struct fio_file *f = io_u->file;
> +	struct trim_range *range;
> +	uint8_t *buf;
>   
>   	if (td_ioengine_flagged(td, FIO_NOIO))
>   		goto out;
> @@ -966,22 +969,68 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
>   	else if (td->o.zone_mode == ZONE_MODE_ZBD)
>   		setup_zbd_zone_mode(td, io_u);
>   
> -	/*
> -	 * No log, let the seq/rand engine retrieve the next buflen and
> -	 * position.
> -	 */
> -	if (get_next_offset(td, io_u, &is_random)) {
> -		dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
> -		return 1;
> -	}
> +	if (multi_range_trim(td, io_u)) {
> +		buf = io_u->buf;
> +		buflen = 0;
>   
> -	io_u->buflen = get_next_buflen(td, io_u, is_random);
> -	if (!io_u->buflen) {
> -		dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
> -		return 1;
> -	}
> +		while (i < td->o.num_range) {
> +			range = (struct trim_range *)buf;
> +			if (get_next_offset(td, io_u, &is_random)) {
> +				dprint(FD_IO, "io_u %p, failed getting offset\n",
> +				       io_u);
> +				break;
> +			}
> +
> +			io_u->buflen = get_next_buflen(td, io_u, is_random);
> +			if (!io_u->buflen) {
> +				dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
> +				break;
> +			}
> +
> +			if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
> +				dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
> +					io_u,
> +					(unsigned long long) io_u->offset, io_u->buflen,
> +					(unsigned long long) io_u->file->real_file_size);
> +				break;
> +			}
> +
> +			range->start = io_u->offset;
> +			range->len = io_u->buflen;

It would be helpful to include a debug message with the offset and 
length here dprint(FD_IO, "...") for troubleshooting and testing 
purposes since there is no other convenient way to see all the ranges.

Vincent
