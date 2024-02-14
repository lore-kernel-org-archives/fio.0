Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9B15B666
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707921835; cv=none; b=fCwmtaC1jAAZW92B7Cgid/IP1apQtWmTsU8X5qgdz7QDtKyhGrmx/jyKQKaR1x7WwSxta7BPgatMcK0eXymBuVlHxE5xYJNo2jLULx5wl54R34h7N+6al7ceFbzCHrw/o2vOrEj5+aOPbEFrIpE3DAoTO0qrpnnLswNKIZcOC2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707921835; c=relaxed/simple;
	bh=UCl8iFVcQgAl4TT8JreJgu+gG26Mz5veORnbYZz95T4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uD5TYT8r2XRdDmZIAf1NgqeXPgZ+UuXxtKOOvUWERbzfZg8n4cTfI7ajYSsji+7WB79wF8ggkhMys6pgbvln8YPuinymdAeSoQJ+PaRW078ixlAgVDHt6/LkKZr2dBJFeBLVg2HizeV+3gAkhyXU5Nu1+nAL69IMSAkjFlyOva4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=etW1+a1J; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="etW1+a1J"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so57410739f.0
        for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707921831; x=1708526631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DTTzkSKnjdkUbq+fxZGNQhH+iNq35Utw5g0Mi9WNeDY=;
        b=etW1+a1J6Fxf2r41YltddTelKX9JYyt0gT8ChQn+/nuznZzTRAwXk5lShCdjZTFixQ
         71P2+pfCsFWfaJRgEkiFNXz9nfm2dTK1wOPVN/HWKLZe2lzWut/NtGwTDUX9GzmvYShR
         yEIoKgH5OiIsXFA/txVGMGzvD3Ho4ltUwm/pprZI5lWGkmBR9vmiJH/F5tLW3GQ0gHi3
         cb41fHUdGWREoKYJ3IfHd1NRtQYEzT1cyrUiIJUdzpxwvxwX4Y5YvekT6LzWxjjHkQ5I
         IYEUmbL/SJ7WxLL6ULTHycwiF1mdsnZa6i0ZL9UmInHUcrxCrA5WT9ZZWylTk+rziaoW
         lJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707921831; x=1708526631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DTTzkSKnjdkUbq+fxZGNQhH+iNq35Utw5g0Mi9WNeDY=;
        b=lkk/6FUb7ZmTzxOLUNMCCLOZkhYNrIByOLQfMgAumwsOqDs41IxWXbaZ1zc5vbTU+L
         NHiM0b1zL3FISFCHO1XohZbsNEMlwXuTHuDfJtHtBpODs68Oco4H616jH7p3tI/oTBr/
         D+zuV0RbrARetoZ6J3FRPUmeG6Ay8QaLPuMwBUvG81yYF5JbPvX/EUmCxHDwHVR2D9lZ
         wJTbqC1/TBcGQow0iXCvF2Ko2bHxIzwNT0JsmfTnL4kD/1V/uhzhyF3KJFETBDU1yE1T
         SL7WedO2QQeLuw90c9OWBj83pbrz4OfZGWq/kGOAgFA0hC6VcvvsEyLTJHcF/3iKcIFe
         C0mA==
X-Gm-Message-State: AOJu0YxyC9rdi7yDT6Oa0haG/QPmXJ99f5NfkaekIeh9MdGf/7TyI3Nw
	N+0Hei34N49HvK4sSvGfV6cJs7rj+4va28V3XjC3yLf4Kxa7M9rdSPWJ/26BHQE=
X-Google-Smtp-Source: AGHT+IGCcY1B5TiZCI6U7V1XnhmCNmHbCY1mt/9b+uPPA0VXFX2WMHnpl+EU2yVmOTRPTey4RW9sWw==
X-Received: by 2002:a92:c544:0:b0:363:e55d:77e8 with SMTP id a4-20020a92c544000000b00363e55d77e8mr3119600ilj.3.1707921831073;
        Wed, 14 Feb 2024 06:43:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVUjuMjdqbOnzfJTpbZTCEQMxH2wZiifyQIdNJbbRgub6v7mzcVapKdpEsOz9ADay70tEDIBhnkXsAwipr8ayKJocHB+lXVVeI7zs27DEijILFXH7Q60TBX
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t9-20020a92cc49000000b003642c859d28sm480617ilq.79.2024.02.14.06.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 06:43:50 -0800 (PST)
Message-ID: <47983128-751a-42b0-86be-cf112adc3c32@kernel.dk>
Date: Wed, 14 Feb 2024 07:43:49 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] trim: add support for multiple ranges
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
 <CGME20240214064925epcas5p4167aa60ecee87f3a15bb2a57a4409685@epcas5p4.samsung.com>
 <20240214120624.135416-2-ankit.kumar@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240214120624.135416-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/24 5:06 AM, Ankit Kumar wrote:
> @@ -609,6 +619,14 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
>  	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
>  }
>  
> +static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
> +{
> +	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
> +		return true;
> +	else
> +		return false;
> +}
> +

Nit: unnecessary else, just get rid of it.

> @@ -966,22 +969,68 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
>  	else if (td->o.zone_mode == ZONE_MODE_ZBD)
>  		setup_zbd_zone_mode(td, io_u);
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
> +			buflen += io_u->buflen;
> +			f->last_start[io_u->ddir] = io_u->offset;
> +			f->last_pos[io_u->ddir] = io_u->offset + range->len;
> +
> +			buf += sizeof(struct trim_range);
> +			i++;
>  
> +			if (td_random(td) && file_randommap(td, io_u->file))
> +				mark_random_map(td, io_u, io_u->offset, io_u->buflen);
> +		}
> +		if (buflen) {
> +			io_u->buflen = buflen;
> +			io_u->number_trim = i;
> +		} else {
> +			return 1;
> +		}
> +	} else {
> +		/*
> +		 * No log, let the seq/rand engine retrieve the next buflen and
> +		 * position.
> +		 */
> +		if (get_next_offset(td, io_u, &is_random)) {
> +			dprint(FD_IO, "io_u %p, failed getting offset\n", io_u);
> +			return 1;
> +		}
> +
> +		io_u->buflen = get_next_buflen(td, io_u, is_random);
> +		if (!io_u->buflen) {
> +			dprint(FD_IO, "io_u %p, failed getting buflen\n", io_u);
> +			return 1;
> +		}
> +	}

This is a huge block and a bit of a mess because of it - since this is
highly unlikely for anything but special workloads, please move it into
a function so we can hopefully get it out-of-line in the hot path.

Also looks like you forgot to bump the server version?

-- 
Jens Axboe

