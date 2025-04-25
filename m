Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB62CCC1
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 04:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745554462; cv=none; b=eit+PUjieH1+Bsg4EHIc65ECO3XllfFiuwpvLNmK50G1ikeHu3Kc/EPWH6mi0e6TlkNlZqQLQSQNaBaqyPQ30rRdZIkhzILTsq8vjcP5eymKZ2GPmeRD2YoahN9Gh1avw/wZNy+hnEGQ8WkHYWirov4lKgvKBEHf17Gfd619lgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745554462; c=relaxed/simple;
	bh=lw83O5y5elv+9q87tcJAECL/Np1l4CVApidaCt6QSzQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YDgpv4knTKZUmQls85oYOtFgqcmv2qP4c6308gm8sETcBIZG+A1abOc8kHP87Y7GMs2eDaJZvWtuM6P/dT/yirlvqGyBoJ/R2TPtfMzlKmSiWHDf6Olyv7rE+c3yEiFHasUHou+gs2B0MxzZ/S5AIpnnKG6TWJGmFhbFEEOnBfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJ4UFFT0; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ4UFFT0"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c75d727c3aso29019485a.0
        for <fio@vger.kernel.org>; Thu, 24 Apr 2025 21:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745554459; x=1746159259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g8KKjgABwLApzjy4K/YLW+yM2Biq9pqx/ybJJ+sAxpw=;
        b=IJ4UFFT0Lqx9xeRI8VaQZ5E3epDKbRaRCbF1JCqFl/bzqXQ/6KxspmA/8Y5DuSw2IS
         m1RLIloReHLHlGGiS02AY1bS+QNd0ApasySF61Gki2sQ5PJnpME8PdPPdqyLqeM972ir
         02JBP0vZ5jHLt0bGR0hmkUwk0u80s0lDMVJjzVQKh+GBx8hwnKNEup2cI6+icUdxGArN
         QNobQ2JHpnfj6gRewwPA+VRQL2cDCJRW+d5W3jq87T06Z2Vy5TP+DQp0iCFyejrWTCyZ
         Qr0AlWIri5j/lW3zW/xYMvlU9U4k5kGtgRHM4w/hnDmjMr0lgwGEHWhgRipXZuFKMwHw
         cQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745554459; x=1746159259;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8KKjgABwLApzjy4K/YLW+yM2Biq9pqx/ybJJ+sAxpw=;
        b=knhBd71ieBsMEYcYezMZ8SpPKSFxXRBBmpiukIQEesE/HPO/I08SH1OwZqjmnmRfI0
         Pk7XxQ9Sdz5wLyqUHcb/Lfu99FcUGAk1tsnjuGgKjR2rvRP2VsFvA74FSAZtmilXN/k7
         vEvAU7QSRBfHkRWTacu1vORhZ8BdueLCkyv6ZOrygTURGMbdcGT7g/auAvpLtpyZco3s
         0R/AO7kTSW4tktE8b7o3saYSnE8SIhxmSNf3yWUtVXpodgOUqyDdWl2+WSoYUid/Ad5S
         7CwxufYcK7EbHMduUz3NjKsblheW7eLtNYnvT6jWMfCUGenM1v+5+yW5yJ9MeltpSB/r
         cxjg==
X-Forwarded-Encrypted: i=1; AJvYcCUsuUn3jMmwfxLHYnmYTBku/p5OSKUI4vb0vO6Ny9WZYVC5O4uvNBJd6nW+4uVSqHQqrPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyxpVXd+6uGSHWnX3y8x+VEQf496fpYxoKeS5d77t4QYXE58ag
	XPgK3YXtBXuXx9UyMFFdlSK7KwGnlBIW7iEAgO6Jjyv8ytGdVbl+
X-Gm-Gg: ASbGncugKei+42vn9k6nbSZZC16rBSxyme0EqfTZ+pHeQChhsQD8UJOYm88Hxy06aoH
	qXYzSERrm+m4gomCsowtzhqgYbh2+cJhS/p/9SWOnLsiJ4lCpltLVjdjz3GNox2l2UKiymeQdfV
	9urOXciWoXzVk1n+VRmSXLOBjkUEmAeNFbt1roLc1lk7AKyElzUstd2vnpBXioJenBf/UWEYVZK
	sl6Jy+Q07cRcOS97Coti61Ce+dAD4U2Ib0EDkj1IXeAMYOjDl3cuBdyNRqZPOFjKhUNxWi8jJmq
	htggWfWfvY5547dXS+9l4dF10WX81ooU66AtmbTe2cCZjMzpa18aO6L4kjueglzlkWl89cniElc
	x/5JaQ7eLooCtT3ft
X-Google-Smtp-Source: AGHT+IEN4INlUVBJA2nGpmCttIFqfT1YE4zvBuIjB7WoHogopLA0FhVbZspsNnP3LNmmJiIsekpf8w==
X-Received: by 2002:a05:620a:bcb:b0:7c3:d752:f256 with SMTP id af79cd13be357-7c96073cb1amr50948185a.7.1745554459341;
        Thu, 24 Apr 2025 21:14:19 -0700 (PDT)
Received: from [192.168.1.201] (pool-108-48-176-137.washdc.fios.verizon.net. [108.48.176.137])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c0a73c6dsm17896206d6.84.2025.04.24.21.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 21:14:18 -0700 (PDT)
Message-ID: <53104556-47af-48f4-9cd7-64add2bdb173@gmail.com>
Date: Fri, 25 Apr 2025 00:14:17 -0400
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
From: Sean Anderson <seanga2@gmail.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org"
 <fio@vger.kernel.org>, Damien Le Moal <dlemoal@kernel.org>
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
 <ptncklg56axp5463pdaadt5a3xxepeu4vnnl3qqtg3k2elpsmj@lcl7boaxswn5>
 <ce3a5fb5-ed48-b751-4de7-cf72aae5df49@gmail.com>
In-Reply-To: <ce3a5fb5-ed48-b751-4de7-cf72aae5df49@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 10:01, Sean Anderson wrote:
> On 4/24/25 02:13, Shinichiro Kawasaki wrote:
>> On Apr 23, 2025 / 13:11, Sean Anderson wrote:
>>> Hi,
>>>
>>> I'm getting an "active zones exceeded" error when running fio with
>>> --rw=randwrite mode:
>>>
>>> # fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev
>>> flushes: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
>>
>> Hi,
>>
>> The block size is 4k. And according to the blkzone report, it looks like the gap
>> between the zone size and zone capacity is 512b. So, I guess the fio can not
>> fill the gap by 4k writes. It looks likely this unalignment between the gap and
>> the block size left unwritten small remainders in many zones, then many zones
>> are kept open and the device exceeded the max active zone limit. Based on this
>> guess, I suggest to try with 512 byte block size to align it with the gap.
> 
> Same issue. And fio seems to be capable of working with the gap in --rw=write mode.
> 
>>> fio-3.39
>>
>> Recently, I contributed a fix which handles the case many small remainders are
>> left by random write workload to zoned block devices [1]. The fix was upstreamed
>> after the fio version 3.39. I also suggest to try out the latest fio code with
>> 4k blocksize.
>>
>> [1] https://github.com/axboe/fio/commit/e2e29bf6f8300186d267fa46a7b266d14d174575
> 
> Yeah, I saw that, but it didn't appear to be related to this issue. I will try it
> out tonight.

Same issue. I will look into this more this weekend.

--Sean

