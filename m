Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EF42701B8
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 05:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745473991; cv=none; b=OONx6zKmItrNsBjs51Q8aAYS++2wjc1Ocn393ZiizY4RY8kpR5r0cAxohJ7rPM/GhiqOBHqJM6yxbIzcTRQlGAtBUvSrKgVgF8qtmbkuA/Xx+i7fhwm5+o3e6hZikXHwsLIbgjAc1NA44agfcE0Y88mPsyY3myR1UNVk1ER+o10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745473991; c=relaxed/simple;
	bh=b9eCWQ2IBFUf8AtFm+1eRI8bzMO1q6NJBLaKHYuJu5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N2kuPnWgEI6xnxsrYp/swVCS/buxkvM0Il44tN1g8N4OgP0Gwwd8XHr3HGqzn7YTOmTKAA1ITsOKldfKZtMBXrE2/UlaYYGamIWE4FwC9K7MxxHSd5Txnzi3ljRpAQyQTSs2R00oOhmtuUpEXOiwG/0XEW0lsg5gn4fGtNM7WdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ot0dfTMk; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ot0dfTMk"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c5a3334fddso8690185a.1
        for <fio@vger.kernel.org>; Wed, 23 Apr 2025 22:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745473989; x=1746078789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0cv8g1PCUaPqImc/JlzzWZZ+RPyd2tz+l0C3Rhkks0=;
        b=Ot0dfTMkkh0qpuBE+lFAOpdOLPRz7mCJjMMcVkPUjNFkCmbWt8Pg+/6z++amjDnW5u
         aSv2L+zt8jnB5WRpcZhEI0zf76L0ESvLmaWpYB1LCZ4N1a1O1vWf4TdjcSxofF2T5dSW
         h9mO764LpRRXlKnTdqxw0ypKnEaQ+3vMxfg9W9g5R3Kl+NkDYRD4B57XkIJwcFnqX81n
         Hfbp6nCOanPqTnqMHiS/O/0AxjpKxAsIjFv1fHEcMyedlH0lv3rzsr1RYLsNplGC1UdU
         mGutZ4WEQdK4bvM+h5gpICy/xRSS3a5zsI+axiWpM0YuQ38Yo0hcmFJSPUhwHF+nf7+6
         Iuog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745473989; x=1746078789;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n0cv8g1PCUaPqImc/JlzzWZZ+RPyd2tz+l0C3Rhkks0=;
        b=F6CHJwI0WPSRuffuobQWjks1xBcjYzXM6mr+9Hme2nXNT7abyjeKrRGnffkTdnNYI/
         FvaQ5RopC1u+sJdWOMjSe3ZDXhpnKgs6hCAuI6LPRA8SXS3JWo7Br6FMIVRSZRiSCdON
         k/X6AfAEVCKdDRImmmKhfL9iNHZuk9fjhwdjBQV72US5g/xOJ7k6hjaAeuyu19AwpaNZ
         TBnyVz5OPgn5nmRSjP/amOvFbmbnNbzoP9vULJUFBzMFu+nawPDocQlf+cTXlS3IyCj9
         Q2KRrpcEdck3YcE0XfPCw9FJElA39/qb6433cJz+mXrYXdf75YKVsqHK+jnNCcqxb2zQ
         7bLA==
X-Forwarded-Encrypted: i=1; AJvYcCXi/Jj9ol4mq38E4QKbnGvFJlzxHSX/ooKUVEEFSSdV58avbINizz3msddpR71SEQMUlDc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd3Bgc1oh2F2dTdZb6AlZQqD/NhvR5jjg0qFBMexNgMXXf1s6I
	SZBnzDgJzzwkO3CAil+jRbzABNI7r8+F7/y8l02utIASbaM717pX
X-Gm-Gg: ASbGncstY9iFT3ESVK+kFVibZAKPRa2BxtpIdNZIeV3BG8sO8muXluBTSwPWPkjtRG7
	jz9dK4CQpVEEDOvlIMm+tfIOSefyD9FRUWBKsaXni3k+NxiOqKqKcumNKVWBhkXW6ppb+BTAkua
	6r6bRw0kWTzS+vn1wlvsFAfeRvtC3RRLoEGEBrqlUAoRxtkHYmdfquJ5HNwazbmOqvrz69cikwg
	iny8WC5cEyqxjp3zWbsYlvW23d99fQcxgG+/YKpDmGeqnGi/Xmh4ZsEEdSWntjbsDjFlLRB/LSq
	YD5iAkcvgJIXP37RQyHmHy7a/h1UZiI1oKMFXonPMob2R+1gL4I7N6lVEN7t2ote2BF+BEqsbUg
	IoVD13WjwoiLKs/sI
X-Google-Smtp-Source: AGHT+IHO1q5zsjE23iMtgdrmoO8iue5UeuLPsMZMkcoha99XonL/NYFj4bIXxbvRfnSrjLd7HD42QQ==
X-Received: by 2002:a05:622a:1486:b0:474:efa8:3607 with SMTP id d75a77b69052e-47eb2893a8amr7002021cf.1.1745473988994;
        Wed, 23 Apr 2025 22:53:08 -0700 (PDT)
Received: from [192.168.1.201] (pool-108-48-176-137.washdc.fios.verizon.net. [108.48.176.137])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47e9f7a820esm7569761cf.41.2025.04.23.22.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 22:53:08 -0700 (PDT)
Message-ID: <c08e28c3-8528-bb90-3e77-95f10cf1ca27@gmail.com>
Date: Thu, 24 Apr 2025 01:53:07 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [BUG] active zones exceeded error with max_open_zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
 <2a232db8-280a-4a76-aade-916499fd524d@kernel.org>
 <949cb711-b20b-6bb5-6663-e12ca7d71cf2@gmail.com>
 <9483165f-c834-4272-9949-59e93659551b@kernel.org>
From: Sean Anderson <seanga2@gmail.com>
In-Reply-To: <9483165f-c834-4272-9949-59e93659551b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 01:40, Damien Le Moal wrote:
> On 4/24/25 14:27, Sean Anderson wrote:
>> On 4/23/25 23:10, Damien Le Moal wrote:
>>> On 4/24/25 02:11, Sean Anderson wrote:
>>>> Hi,
>>>>
>>>> I'm getting an "active zones exceeded" error when running fio with
>>>> --rw=randwrite mode:
>>>>
>>>> # fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev
>>>
>>> --max_open_zones=1978 is an extremely large value that likely exceeds the drive
>>> capabilities, which is what fio is telling you.
>>> What are your drive maximum open and active zones limits ?
>>>
>>> cat /sys/block/my_zone_dev/queue/max_open_zones
>>> cat /sys/block/my_zone_dev/queue/max_active_zones
>>
>> This is correct for the drive.
> 
> I am sure it is. My point is that you cannot use --max_open_zone fio option with
> a value larger than what these sysfs attribute values are.

as I said

# cat /sys/block/my_zone_dev/queue/max_open_zones
1978
# cat /sys/block/my_zone_dev/queue/max_active_zones
1978

>>> fio will use the min_not_zero of these 2 values as the maximum number of zones
>>> that can be written simultaneously. Especially if your drive has an active zone
>>> limit, you *cannot* write to more zones than that limit at the same time.
>>> fio will default to max_open_zones=min_not_zero(drive max open, drive max
>>> active) and for a random write workload, it will:
>>> - pick zones randomly up to max_open_zones
>>> - direct write IOs to a randomly chosen zone in the current set of open zones
>>> and when an open zone becomes full, randomly pick another zone to replace it.
>>
>> Well the issue is that it appears to just pick random zones, not random open zones.
> 
> The drive may be completely empty, all zones empty, so no open zones to chose
> from. So fio picks a random zone and adds it to the set of open zones it tracks.
> It will repeat that until the set of open zones reaches the limit, at which
> point, fio has no choice but to keep writting these open zones until they are full.
> 
> If the drive already has open zone in the fio workload range, these zones will
> be added to the set of open zones on fio start.

But it's not doing this.

>>> For your workload, if you want to measure the maximum "random" write performance
>>> of your disk, simply do NOT specify --max_open_zones=. fio will pick the best
>>> possible number for you.
>>
>> Same issue.
> 
> Are you specifying an offset+size range ? If yes, how many zones are open in
> that range and outside of it ?

The full command line and output is in my original email. I ran `blkzone reset`
before this. If I don't do a reset first it fails almost immediately.

> What drive is it ? Looking at the blkzone report you sent, the zones look
> ridiculously small (32 sectors...)... Is this a null_blk device ?

Something I'm working on. I'm not done testing yet (which is why I was messing around
with fio). You can probably guess what it is based on the geometry.

I'm actually thinking of creating a device mapper driver (layer?) to combine the zones
because a lot of other layers expect larger zones. E.g. btrfs expects 4M zones. Not
sure whether it should go under linear or not.

But tbh this is a bit strange to me. Ideally filesystems should take advantage of smaller
zones because they more closely approximate conventional zones. And if they need to store
larger structures they should just store them in multiple zones.

> If that is the case, try creating the drive with larger zones. You may be
> hitting a bug with such tiny zones. Since such drive do not exist in the field,
> we never really tested such extreme configuration.

The hardware I am targeting naturally has small zones, so I am interested in finding/fixing
these sorts of bugs.

--Sean
