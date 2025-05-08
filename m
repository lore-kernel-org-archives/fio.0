Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57A728688F
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746724714; cv=none; b=I3DmTGG26NcZKRTT43HomANO8Ush75TA6GCxZrGUUoF0zSfW1vw2DAtPgP7ULJ1EDe6cb5JgHM/NqAB2MvfKMtikh20AqxuGQ22uCF9CuUBrN2BC35nDtWWyQ41S8UWRqSZj/OQ7midzQliTVsP1kSLSOadslyt0WAhzmFZTgQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746724714; c=relaxed/simple;
	bh=9sXTonDVLPdUYTiDXweR13PEBnnq8czT3pT3SDWu+10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ow3B+GyL2z11EKHQo5PnfWGB2jFqe9OcUpFxf7BK4PdOXTGKg9Zt7GJqItoqW9a65l2RyHdKmSUokv/9ItRNJI+7mVqp218tbzfFy9AXNqxPaelVojUEgP/0eyrV36i+1MIQS9AffWAf5Nvyvj1iQyQ5BbpoyFzZTaVJ34JyPRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=18akfjly; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="18akfjly"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85db3475637so79032039f.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746724710; x=1747329510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/1p/05enpiX3szgbSh+MNUTd/BbHaitcbdq1+ttBJLw=;
        b=18akfjlyNRtkNw/kuubyFkoZbfL0Kr+aobF+jEqIl6D75uchmc/MVk2Q7qifbtNk7N
         5hi6XFCFmA2AkwMuGkg/9TuJyTIOqckOxyeUdruVL16CnZGU+EHT5h6t6bC6WPCa/nzQ
         277v9mNjVLQMzr3NqQMlM6bXwX2ZV6qeaQ6A8GXXjbnOEU40TACM4O2Uc1sGK/Ya61l/
         Yi8edEhSjv4p9lLpzwjvmy4UKulFn7hqdVptAkGRF2gmceTRLEcaYp9IXWR2ZkJ8jNiU
         1ZCAZFI198vzD0t5zmVWHNiZNRqxHQxm+Td380B9/WnJdD0EdFarU+eOwFfq7S2Ae6WQ
         T2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746724710; x=1747329510;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1p/05enpiX3szgbSh+MNUTd/BbHaitcbdq1+ttBJLw=;
        b=WOGWX6nszA5xZ8wSspjE601gVso6kVSzt3Pn7HmMKdg9iC/LGbbl/HgT/Jl0+CpC3B
         WEurT3HWOx9K8ygneg8XqGKiigVt0fJoFSB3kqWVAb0kPjxS4mxE1iQjzZJxVWNYJpGe
         uchfksJ5cuLhlCBOjSOf80QN+c90xJz5tIcvUS2imL+YFzciYxIqJVUnk/kGRNPBxKFI
         hCpbo7j+nbPLjukNgkgNJEQy0wL9AWjm5ndbxp8JmkLrYbFMsp8cZPNQTYQdwvUS9NU4
         P+CJvRhafdZr/3kNGz5kT89bQJCKnTPw6lzlUFB/YHUwthNzJQg464Ur5tKaYNtytVGs
         Ki4g==
X-Forwarded-Encrypted: i=1; AJvYcCVN7qKJKgvoxqE9irhs7DFD4gK2xADEG2SCxfUFVgK27sfIvAiWs1qyzrymcQK69oJbOAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn7Kyb40EnVQZBzeVy48WRZC3n5vxY4qVLjGwn9QUnZNjrdOGX
	f+Vw6XPhmNwrD/41tqlm7zrxSLrb7qq+5QhsmETqe8/YTtjGd3bIM7YTJy8AsMk=
X-Gm-Gg: ASbGncs+6SDD4psEX1JUw97ic3ErYTfyqc2agUUgvIUKbVz+Gh5ZMZDqOzd61jc6XlX
	1UbbjG+oa9Zy6Zv8V7xSHiiqFPCmNegv6Gky3r3s8eX35lZqA5I630G58Hl68WDIAXioGsZhMN5
	9nyWGi8qrdfOMZ0Eaovcz0me+PePzBTaOqGlvALUT60173G82qmE51PocBYMJKjsiBmUY7KjhSo
	p+xkzP2shIPAbKkHUHAGtCW6cda3/Q+iwfxqPqKztVA0fFIA11eU2/5YSzRaOx7SS94gouPWabR
	p9FplRO2b5HaDANP7+FxoxdA2iESP2STXALzRVLMSMs7QSA=
X-Google-Smtp-Source: AGHT+IG0a++FTKEO/kzObUW++Z19gNCuwYrABp1nFW/1+w1iwFNPdZPDduVX6/Yq8v1vHEMd0H/K2w==
X-Received: by 2002:a05:6602:2594:b0:85b:5c9a:a9ce with SMTP id ca18e2360f4ac-867550aa561mr486819939f.6.1746724709687;
        Thu, 08 May 2025 10:18:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa226594besm46229173.124.2025.05.08.10.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 10:18:29 -0700 (PDT)
Message-ID: <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
Date: Thu, 8 May 2025 11:18:28 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <20250508171444.2113-1-vincent.fu@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250508171444.2113-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 11:14 AM, Vincent Fu wrote:
> The pread and pwrite functions for Windows posix emulation never actually seek
> to the requested offset. Fix this so that the psync ioengine works correctly on
> Windows.
> 
> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
> ---
>  os/windows/posix.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/os/windows/posix.c b/os/windows/posix.c
> index e3abf383..3e48c3ff 100644
> --- a/os/windows/posix.c
> +++ b/os/windows/posix.c
> @@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
>  		off_t offset)
>  {
>  	int64_t pos = _telli64(fildes);
> -	ssize_t len = _write(fildes, buf, nbyte);
> +	ssize_t len;
>  
> +	_lseeki64(fildes, offset, SEEK_SET);
> +	len = _write(fildes, buf, nbyte);
>  	_lseeki64(fildes, pos, SEEK_SET);
> +
>  	return len;
>  }
>  
>  ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
>  {
>  	int64_t pos = _telli64(fildes);
> -	ssize_t len = read(fildes, buf, nbyte);
> +	ssize_t len;
>  
> +	_lseeki64(fildes, offset, SEEK_SET);
> +	len = read(fildes, buf, nbyte);
>  	_lseeki64(fildes, pos, SEEK_SET);
> +
>  	return len;
>  }

lol, how broken is that... Does windows have any offset read/write
variants, or is lseek required?

-- 
Jens Axboe

