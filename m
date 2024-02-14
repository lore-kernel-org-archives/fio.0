Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B149C5A0F8
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707921879; cv=none; b=UwpHzTx9937HdnUD0eWI1gNQsq22O46WNSOOQVWqUUQxLFAkDsuEbuewmuz4yDIdx2EMGlLyKhTN0iwFC7GxwDBUge/FfU02hX3mMBX28tV0uvVI6xVUIReFS8SoaplJeqWs8HoAnWCQjXNLZj1ijDwKT6gmtz8JbSeqqbpAD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707921879; c=relaxed/simple;
	bh=u/N7jXkwX+/YPiM5P4kvWCURhdo7v1R8ahj9J/rjT4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qllMfOE9UO6+VO2VSP7nyyJIsOfJvs33i0X+OfId1B2oqOMMOyJeMaYMaoz7aOMUQUhqj35rrCjR+RY/5OUVkZ8lq6eQFlEwpzxou9bjiDWylFXK3GDkrsUojbDF2K6eT370aQHY9nQtvjn/8l0r/8XGb4ZQdebuyermUNEs9k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gPzJY7uO; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gPzJY7uO"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36464eebedbso182065ab.0
        for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707921876; x=1708526676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVg4FFlOpSNhmuzeCMsVA53joc80Jp88JvcPymABhUc=;
        b=gPzJY7uOEfGr/C9swUZSgKwihK6UEcLBh9pV/3evSonobzgR/E1SKe84XdFM9iRvLn
         JFsGDZfoiEucfYbcr6xPZgndQ9Oau09SAsMcZViOxmWy2G9P5JVDD8vwhGGfDlT24pxf
         MtR9mbyYP2SmO1tuGEu3h7/6yB/aWI8dldYeQhnTcHzSpgSNjTqSGDxnEk3Zjc4Iu0z3
         N1uJf8riPw+o9OOyZaUJjKOzS0Ygh/n0JPceKWSxvN/KiS2/AVhGCwThP/GzmIxS+Fn2
         6mnd/nevK91pXih2qZtoJ89hXn98ztOgPRwJZGLXPb6sBfQLYFOqxOR3JW6jhdpQfR5h
         2ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707921876; x=1708526676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVg4FFlOpSNhmuzeCMsVA53joc80Jp88JvcPymABhUc=;
        b=dEydEzO2QeK7pP9VqgP3zwcLPpXUaBznSsHdhGV1O049LMuWDMmAg4nY+B6NW/vZoQ
         eEEFYNdb1kbHXsvT3kS1oOF4WTy6EQz0jwvCTz7OH71ddZGPY2EpbZ/ZtAYztXIA95Fn
         k/8z/M43JoJvoIr+zWLblRZUh87gz6LVHwfBVums4uejjJjuXsTSRKXsieJZqM+Svg2j
         nbhZ+qYXFmN4QWeEXI7Ru/wDgiFCjASjKUOXhARve/4vXwiwZvmaywfzdup6FZgns7He
         38K+LE3LrOL2NLeGxYkcd+5k9V/VjU2dxA+8atqf0qydN6I8p3zda9IiHjN7sfcgjLgl
         5Rnw==
X-Gm-Message-State: AOJu0Yz6tblv1uU6Zg0VAQwfNU8dnzlnSIILK1eGSRTAzXtjkJa2jvp7
	4raxLTIo1QkNVkzIexyXJ7W53No3vzOQ2YnvEojXXAoRGjb/7lRqRtq9y3RqUuAljALD7Wv4PH7
	F
X-Google-Smtp-Source: AGHT+IHTFhwpM1ZhGsRin7jodYGH1gTUodWMdt2kJ9NhMpmn3B1iY0Zra07HMxhwJev/hoG1cKLGmw==
X-Received: by 2002:a92:c26b:0:b0:363:c919:eee3 with SMTP id h11-20020a92c26b000000b00363c919eee3mr3544675ild.0.1707921876525;
        Wed, 14 Feb 2024 06:44:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvp2w4jGc15ITYIMbLqMmSd84guw2y6rRYJy9FZjBchuLJAcja3OM+xb3FCs4KRn2vAMTfPjIRrGIT4PprFXqtEZEmKNR2Xex1Tvd/9H26HN1jnBbYus3w
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t9-20020a92cc49000000b003642c859d28sm480617ilq.79.2024.02.14.06.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 06:44:36 -0800 (PST)
Message-ID: <76a9b278-f660-494d-9408-71c90e4b9bcd@kernel.dk>
Date: Wed, 14 Feb 2024 07:44:35 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] engines/nvme: pass offset and len instead of io_u
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
 <CGME20240214064926epcas5p29dcccdd0abe0e0ffb75c64835ec6a01a@epcas5p2.samsung.com>
 <20240214120624.135416-3-ankit.kumar@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240214120624.135416-3-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/24 5:06 AM, Ankit Kumar wrote:
> Remove io_u dependency while calculating start and number of lba.
> This is a prep patch for multi-range trim support where an io_u entry
> will contain multiple start offset and buffer len.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>  engines/nvme.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/engines/nvme.c b/engines/nvme.c
> index 75a5e0c1..e5f17fc7 100644
> --- a/engines/nvme.c
> +++ b/engines/nvme.c
> @@ -8,20 +8,20 @@
>  #include "../crc/crc-t10dif.h"
>  #include "../crc/crc64.h"
>  
> -static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
> +static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
>  {
>  	if (data->lba_ext)
> -		return io_u->offset / data->lba_ext;
> +		return offset / data->lba_ext;
>  	else
> -		return io_u->offset >> data->lba_shift;
> +		return offset >> data->lba_shift;
>  }

Same here on redundant else.

> -static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
> +static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
>  {
>  	if (data->lba_ext)
> -		return io_u->xfer_buflen / data->lba_ext - 1;
> +		return len / data->lba_ext - 1;
>  	else
> -		return (io_u->xfer_buflen >> data->lba_shift) - 1;
> +		return (len >> data->lba_shift) - 1;
>  }

Ditto. I know these exist before, but let's please clean them up while
at it.

Apart from that, this one looks fine.

-- 
Jens Axboe

