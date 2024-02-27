Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BB34E1D5
	for <fio@vger.kernel.org>; Tue, 27 Feb 2024 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055489; cv=none; b=VDjgxw5pqRYCP5wbE/wlj3M+j/53ElYBJFu0792Uiut8pXogFX373DNwIqrcTuo42GPhXVi27Gbjf9LLc0n3k3dwpeRZ00RnT13BEA3QkhKptwhnNAYfWUIw/EEON3CiSlw8P57RRSIDxwre7QjmVUiG0b/cOHnB1PAnd5iQhEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055489; c=relaxed/simple;
	bh=RINXMfPbjHfNMfGzoL24yJCnTkTAlIfz52ZU4rdjdUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xm/rC9psxp2CYfKF0G9yjnI+87MYyC/UiTrQNi4XR2tE7B0ue5hUzIm+QMYxVE10xuep9zLnN5r1/lJBmcYtY1QnDoId4iD2+Q/3hzA3i8oZm/IT1vH6Ru0kkRoLXxEg1iwvi4kUwjHkyjJD/j1tSbrvh4xYxh38RCeCCc6dblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ed/k7mT9; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ed/k7mT9"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c19aaedfdaso1546863b6e.2
        for <fio@vger.kernel.org>; Tue, 27 Feb 2024 09:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709055487; x=1709660287; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wWjGDkfrI5FNUvB/ONHCaFK/pAEqYRZsGxdeitkE7rs=;
        b=ed/k7mT9rQBdUQUO3U33NDKzGKz824Xpi71AD+WtvYAUx4qwlrP4J3xp7ZLIOIuqdM
         Uaa9hyOnqLrROi/6o8PeFMj3phTSqaQq2F+GcS9SuIdHSukE+qwUJ+TBEs5Njj1lknBZ
         dPHzUsaEDDvPqfR2VqQH3Hvn4zXN6rvdtkt9mukHu1bkJ3J8luh1yyAqh3raxAhjMaSU
         /NKBZaO0t5Ot6lgch1LQJb7DNNcygiRmHsqYfvl3EJ2+so+67zb1CGlqM8xrw5D1fZVX
         g1u3qafWHpHAhMIxEbfzI9PIGMN2kgpZwf/tHtkacYKbSLq1kqeNr647kzrgrM0i8bR4
         XvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709055487; x=1709660287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wWjGDkfrI5FNUvB/ONHCaFK/pAEqYRZsGxdeitkE7rs=;
        b=aPeBcWIarCMXLzerIVaGSZpR6r8mBAxUvCfZU7MV2ElVTZCe7w/U6OqIb5IIgt7V+e
         4r3lnIU1a9Qol4y9TbAnTL9rhJ6xPiFwIqonlU5S51C0qBQg2xnnhkmQhA5JgFeS60na
         O9qdBqtmkMZEwkZKFw/ruzMtDxDXDKDorIG278gx9p3OWd1j/XaaoV6uZJ57xYhDuaN6
         d2gjFp0Dds58hlwP7h25lYQFEwAcOYScoaO6ceiuOWcyMMSw8luGwAaNFRGmDt+CBLTa
         hxzsUnI8+feONc380LrOENrU3lVv1oHmcw/iuYzFN5tmeVrxJDJ3W/nSCHxvLeJoxKVJ
         O+YA==
X-Forwarded-Encrypted: i=1; AJvYcCVGvOvPPsDWjcgAPm8ZAbgfMUBD0mkfCbaN8uJByupSEd/CQ1YZmafMi720UdfmtKt8+3R8RH6ACJxSU+edVV7pzaNC
X-Gm-Message-State: AOJu0Yx1j7UT6Ts40n275lDfNpES9hmZvwDmXLBTXHE0bPpl4WHUZPvc
	RiHELaxWR/7iOH1Ey5mb5cDQ224Koe2r2NplhSKxoDnpuNkv35ZA8S6MSTTO
X-Google-Smtp-Source: AGHT+IGlNExDRxKSreqWPLvnQyd0SLMb8zs5/Qzh7GEb+XDIMYZikFk94hu11lnUOIVQ8QovYyeJyQ==
X-Received: by 2002:a05:6808:e8c:b0:3bf:d127:b510 with SMTP id k12-20020a0568080e8c00b003bfd127b510mr3227852oil.15.1709055486756;
        Tue, 27 Feb 2024 09:38:06 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id s14-20020ac85ece000000b0042c6c5bc47fsm3772345qtx.83.2024.02.27.09.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 09:38:06 -0800 (PST)
Message-ID: <eec27771-3934-42a2-becf-c45501a84e0d@gmail.com>
Date: Tue, 27 Feb 2024 12:38:05 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] gettime: fix cpuclock-test on AMD platforms
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <20240227155856.5012-1-vincent.fu@samsung.com>
 <dd061da8-a3e0-4824-a650-8db42300af99@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <dd061da8-a3e0-4824-a650-8db42300af99@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 11:34, Jens Axboe wrote:
> On 2/27/24 8:26 AM, Vincent Fu wrote:
>> Starting with gcc 11 __sync_synchronize() compiles to
>>
>> lock or QWORD PTR [rsp], 0
>>
>> on x86_64 platforms. Previously it compiled to an mfence instruction.
>>
>> See line 47 of https://godbolt.org/z/xfE18K7b4 for an example.
>>
>> On Intel platforms this change does not affect the result of fio's CPU
>> clock test. But on AMD platforms, this change causes fio's CPU clock
>> test to fail and fio to fall back to clock_gettime() instead of using
>> the CPU clock for timing.
>>
>> This patch has fio explicitly use an mfence instruction instead of
>> __sync_synchornize() in the CPU clock test code on x86_64 platforms in
>> order to allow the CPU clock test to pass on AMD platforms.
> 
> Looks good:
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 
Applied. Thanks.
