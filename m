Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051B545955
	for <fio@vger.kernel.org>; Sat, 27 Jan 2024 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706372631; cv=none; b=I/BCNbVDYxCWydqBKPJT8er1Ho9TgFCwnblySu/os83gQAF8MqX7s7+tPeURwCsbl4eNXqBxPzb8HEtPDFcQoBQdO+tG8qTenJ+cvcfPvYZAgFSixfAKKmVh7FTM5Xvji5oZBrYtZsDIh0ojPXKG2m+/cnXKi93RAkpTJVEXnA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706372631; c=relaxed/simple;
	bh=Fm9sHD6bfWEZoCcj2qDmTH1DNtHPUCiS86gODXt3MNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+HtusvvbUiR3a0jeywK2EOwDa0Zp51UOcnSS2/C/jk6uNM7y9Ctt6TXUFRFLHLS2OZnAPTKcLuj+aC/spgSf4vrwQPcTdaOCS7byTtcp+ssMq7SPSsg+RDb6cwdUOp7+I39MkI2xoo6xKHDsDrx8CtzCAl11Q1C9v6TFtziOMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNEhKAOL; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNEhKAOL"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-68c444f9272so968166d6.3
        for <fio@vger.kernel.org>; Sat, 27 Jan 2024 08:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706372629; x=1706977429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wD74raayxWDMgSNbJgqh/84Us+Z8wGOkDPotZhsguRY=;
        b=lNEhKAOLZOeEhYYPH42FExC6K3yblxddKHbznUSoqyZDPGQ/+nCQesym5YNf9fyruk
         C//BJHwRP3EfDqUduVfHq/nvm63ehMz9mmrfJH3f3XMKpmcDCxsCv3IGunFWq0PW3nXU
         dtpOM0cP60zdrcSbRTSP4giqXB5UDByZMZUOdphz/QBrT4bFNQoEaswWjJ6VKQJ2VU2h
         MQEBkE1q/X02t8ObNRKjx0K0V4FsV3mz47iyvVnqoE0mF5DoEP4rkSr4cEH9sQP13Q+U
         qSirpeek8KJj6uuamE54SuG1dM3UDMefsDjGYx6U1HiiQInpDmrHOP0x4m0tnPHWaOD/
         vQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706372629; x=1706977429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wD74raayxWDMgSNbJgqh/84Us+Z8wGOkDPotZhsguRY=;
        b=M0AKF/qYJgh9sOCHyCiGlt8shkeuFos8S6IsQ7r5LIHg4m1IgrZM9LFvs2hKcPcnzE
         hrTN1ja3BaCCGnyEjDG60bb4t+JJTc83OX99WfZQh0FE0EWxGHmDCfuS+puQ9abjOZfp
         wOqET7Yqntwt4JuyyCMmO1et+DK8wHNKfrzceI9kfiZfiOY8JOWG3z527Zm/8WghAgdR
         yGDk5OzMVP5LREY8eDgYty8a2xO62bb49YMpuxm5LLPZU8Do4h20n7EXNt6K64AGlcU2
         BMOa+AXXu4nxW2FdUunPodmn9T07CS+pqmykOwYl3xOrSSfEBldHnhOOaOWL8diLMW1d
         su1g==
X-Gm-Message-State: AOJu0YwxFq22UjbVspdKbMYopUmkzdQpCPRhvetAeQy0RIe3PkXKetdg
	L7bBv6wi6aR3oET5Dm3E5/Vuat0KDm3bKXaH9sZMlJOPTTWwnzQl
X-Google-Smtp-Source: AGHT+IHa1xwgWXc8msNUC2SDmUOySnJsTFf7+6eX39D3kpR3giI08l1blSTah3FpiQEC9qL6OW425Q==
X-Received: by 2002:a05:6214:21e9:b0:67f:acb3:3149 with SMTP id p9-20020a05621421e900b0067facb33149mr2138630qvj.112.1706372628551;
        Sat, 27 Jan 2024 08:23:48 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ld27-20020a056214419b00b006869e0eed00sm1560981qvb.26.2024.01.27.08.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jan 2024 08:23:47 -0800 (PST)
Message-ID: <8e957a62-7681-49a1-b8b7-aca47f261c37@gmail.com>
Date: Sat, 27 Jan 2024 11:23:46 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] examples: cmdprio_bssplit: s,IO,I/O,
Content-Language: en-US
To: Niklas Cassel <cassel@kernel.org>, axboe@kernel.dk
Cc: fio@vger.kernel.org, dlemoal@kernel.org
References: <20240126181353.4151771-1-cassel@kernel.org>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240126181353.4151771-1-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/24 13:13, Niklas Cassel wrote:
> Replace IO with I/O.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>   examples/cmdprio-bssplit.fio | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
> index f3b2fac0..05f0d0b2 100644
> --- a/examples/cmdprio-bssplit.fio
> +++ b/examples/cmdprio-bssplit.fio
> @@ -12,9 +12,9 @@ iodepth=16
>   ; use the same prio class and prio level defined by the cmdprio_class
>   ; and cmdprio options.
>   [cmdprio]
> -; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
>   ; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
> -; All other IOs are executed without a priority set.
> +; All other I/Os are executed without a priority set.
>   bssplit=64k/40:1024k/60,1024k/100
>   cmdprio_bssplit=64k/100:1024k/0,1024k/0
>   cmdprio_class=1
> @@ -23,20 +23,20 @@ cmdprio=0
>   ; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
>   ; use a different prio class and prio level (appended to each entry).
>   [cmdprio-adv]
> -; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
>   ; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
>   ; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
> -; All other IOs are executed without a priority set.
> +; All other I/Os are executed without a priority set.
>   stonewall
>   bssplit=64k/40:1024k/60,1024k/100
>   cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
>   
>   ; Identical to the previous example, but with a default priority defined.
>   [cmdprio-adv-def]
> -; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
>   ; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
>   ; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
> -; All other IOs are executed with prio class 2 and prio level 7.
> +; All other I/Os are executed with prio class 2 and prio level 7.
>   stonewall
>   prioclass=2
>   prio=7

Applied. Thanks.

Vincent
