Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC918F5A
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709383335; cv=none; b=E5nBbXYMfEBAilk//6VifSNqAzXE4SsZ1CqaCfyb9qREChCNe1XOZmOMEcLlHMqdyL06aZ7RNclA+8VPG9fbx27MH+LL/mok7cUgBZGL19X/mNhw/QD+UQTFdOFRqMvsgZWn05qRzF95uPgXMlUlfdXfmuzTvE2CGzoiaIPEYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709383335; c=relaxed/simple;
	bh=BaLeMx27tssdUOQHsJIcf9DMulc4kOMYMr/crAd89eE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GO2bpRnTJdzK94EgG8CU+BHm+AaatcB62VBzTfrHMRx5hkhxgJ2sVII74QPw0SuOrDF39K+cr9VeRGjyfZgPxOVuxTPQaoNJmzN7k5Ofo8U6sFPABsi5aEVbYA2A5yzoVcmW4nlMS+sou29I+FmFOURkMqvhyhpQwqnBO+JOOss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkZ9WLCv; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkZ9WLCv"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-787a2a14d9cso205650185a.2
        for <fio@vger.kernel.org>; Sat, 02 Mar 2024 04:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709383333; x=1709988133; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=92iuRE29pzvwYu0BgH/wQETglEPni9Ff6pnhDvtphnw=;
        b=XkZ9WLCvQaJyVOrwl3PEssom4hbuRhiaDqCFhcOF3gUXV6N38CH8Vkzk0+IsN20php
         mEJ4Gr21VQUkQAgAFLQlwS2cG9xR4eswVO6u+74wjXU9YqOGw0Qv9C0OaeHsDETwL/fJ
         ihGRANTQYxNUUIFrTeocQ0qMWos05Q1oAIsma42PupfDlbcFmPxzKyVaObgHUN34sJsV
         p1jEhq/d6bDPkdScpGEE37LI4Zq0JGhpihVyy42Z06hATPM0ctS011GkCb00HGuqjVIe
         8bbiQTynrtQWb5QbYepy/OxGbWcH8US90RB/izxyoFIcwGyDkxIXJ6PO2fmBj22MsFBd
         FwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709383333; x=1709988133;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92iuRE29pzvwYu0BgH/wQETglEPni9Ff6pnhDvtphnw=;
        b=hfInj7Pa2e94SIMHAebwMh76cEXL7oK4tFPwk6l4SoWcYMu6caTviCTYmoQdqjL9JM
         7gMjkqiHrp+bxOD0Z5LExmM0NoErGPclQI34EdiWGrreSQN58thl4uKNCUB8Hps9NMSq
         +GGCJcoR/Q1xtHs29Q/p0PTLpiyI/C9s1hWGKAGhCgmCatLcP8b5cZN4LkZl6OF1QfeC
         lWEYybX7n2YJj0Yn239cpbWnAgmxwt7v+bzl9JL8ksUYytHqNNOzp9zRsvK1k/5i+nUS
         I4lS0/XcowGH1bzXJXiCgEv70tPQPN/njMS6nZzYPUX4bJHkVylWm2MJ3KaHq2u5McfV
         Jdow==
X-Gm-Message-State: AOJu0Ywx6rZrbjwMU42y9OQenOHyWItXmEt/rjm5rsWXsg6gILPeQy92
	3zCexE5nWEX69SvYHqsKqw0u9HKEPmGtq16SLs//PTeRKBVOTRpi
X-Google-Smtp-Source: AGHT+IFSOFUTT/pjwnpzPzEYuhiBLwrq3iDGkLizHM04rWU0Bo2D1ACp1ie3CQmpsSbGgY8ggK5dcQ==
X-Received: by 2002:a05:620a:3193:b0:787:be95:a1c6 with SMTP id bi19-20020a05620a319300b00787be95a1c6mr5144782qkb.22.1709383333032;
        Sat, 02 Mar 2024 04:42:13 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g28-20020a05620a13dc00b00787d6814c10sm2525755qkl.13.2024.03.02.04.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Mar 2024 04:42:12 -0800 (PST)
Message-ID: <d3f51807-8793-4e90-a0f6-28d7e114d910@gmail.com>
Date: Sat, 2 Mar 2024 07:42:11 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] t/jobs: Fix a typo in jobs 23 & 24
Content-Language: en-US
To: Avri Altman <avri.altman@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org
References: <20240302083613.602-1-avri.altman@wdc.com>
 <20240302083613.602-6-avri.altman@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240302083613.602-6-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/24 03:36, Avri Altman wrote:
> s/bsrange/bssplit
> 
> Fixes: commit c37183f8a161 (test: test job for randtrimwrite)
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   t/jobs/t0023.fio | 4 ++--
>   t/jobs/t0024.fio | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/t/jobs/t0023.fio b/t/jobs/t0023.fio
> index 4f0bef89..b051fef2 100644
> --- a/t/jobs/t0023.fio
> +++ b/t/jobs/t0023.fio
> @@ -33,7 +33,7 @@ bsrange=512-4k
>   # 			block sizes match
>   # Buggy result: 	something else
>   [bssplit]
> -bsrange=512/25:1k:25:2k:25:4k/25
> +bssplit=512/25:1k/:2k/:/4k

Thanks for catching this issue.

The end of the line above should be 4k/ instead of /4k

https://github.com/fiotestbot/fio/actions/runs/8121755928

>   
>   # Expected result: 	trim issued to random offset followed by write to same offset
>   # 			block sizes match
> @@ -59,5 +59,5 @@ norandommap=1
>   # 			block sizes match
>   # Buggy result: 	something else
>   [bssplit_no_rm]
> -bsrange=512/25:1k:25:2k:25:4k/25
> +bssplit=512/25:1k/:2k/:4k/
>   norandommap=1
> diff --git a/t/jobs/t0024.fio b/t/jobs/t0024.fio
> index 393a2b70..2b3dc94c 100644
> --- a/t/jobs/t0024.fio
> +++ b/t/jobs/t0024.fio
> @@ -33,4 +33,4 @@ bsrange=512-4k
>   # 			block sizes match
>   # Buggy result: 	something else
>   [bssplit]
> -bsrange=512/25:1k:25:2k:25:4k/25
> +bssplit=512/25:1k/:2k/:4k/

