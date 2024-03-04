Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB178B77
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 19:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579832; cv=none; b=iM+UrPoR6SlVdDETumSwRlHwkTDA8w6HwufYvLAKw8zMbhpkPIM/oMSUXp15+KPTdjn70e5huHvhferZTVjjUBygi0x3tkylBoUo+zq4hzca0CuqCchCG29O2hFyHwkbj5uH+JP+lZzsM7krWAvi5ZKRZdk6iY9GPZFqWAxp8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579832; c=relaxed/simple;
	bh=yNiisA3g5Ws0rv1e9gWlp8KL4pe+1+9l61ywNAfuwWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F7W/FTxS5ZDSYSxYEdDQJIamPLWD3jgWDrnK7nHcq/6Sz06kikEoRS3mCeO/mlN7Y5r6Fqk0AJizSU0+YZDMz5L09wewKjxE5zOuKJXtpgoH/c+CfqNkuClHOQM+TX4jcfIxWpCedIKPuMPVjcqBfSo4HDQKm4951pIOCtaxa20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SVoKSzr0; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SVoKSzr0"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-21f70f72fb5so3623907fac.1
        for <fio@vger.kernel.org>; Mon, 04 Mar 2024 11:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709579830; x=1710184630; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/1aqttCFnboPRP8cnKptXjE5NcDuoTfFGBLX4putQI=;
        b=SVoKSzr0lvDi/nscbQUg2GmxMs7k9h57U3weXAq0LsXYf7rSAPPMJZCLPWSphYiwUK
         DPLesr6nlDsTFUlG2Bjyjx1D8NNB7YCT1zrmG464xUpZQySi+5fT5xAS8q6FuxAdjVte
         WFCUILIH/rOlZwQF5kHc812K/GyK9smz6FktOdvMhvISf9WIfAzTiQWn8i06pvPjUFGg
         tQp3+0KKV50Z/voqY7sxloxys5iASrxGb5WOw3p0PLPPvnAyGwme5tARNzKHOtDmwA0/
         RrgkVg9+nfPHj5A6+PwWTnYogr5bfExmCyknhz8ERGsugXGxYhjwxznpQbhaz6wO71aC
         WYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579830; x=1710184630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/1aqttCFnboPRP8cnKptXjE5NcDuoTfFGBLX4putQI=;
        b=XQhiPi1yrhbwIjfRrkjb/ucAsvYI/1h+sn8GSM8HcwedRn+GiAXiedsXakOX8QkRDq
         WfMYZQEsO6nqq3gJov3aLRWkO9zucVP6a4GIHvW+Fevd0fiawx5IogO03RI2fulhhek6
         t4+CXCGTOLLJjFuQBVsA/bGfFyn7Ieo6+5nMiRYiwKQSDRLn5FIiV0JnxVUDld+xzT/f
         +8F/4weKsCDlMayCI3UoMzEbNREJNY0C7DOyue0VX/areJkizNl564PiCnEPG9hOtIiU
         0ZvvlSm9svwSc988eLsqR0qyu85i+Tk5CQjBjoniaQ9qbxAtCKJioA26cBjHCg3StVr8
         8zhQ==
X-Gm-Message-State: AOJu0YxMXul33gUYNFuQ+wq3YkG3LXVdMJMlCgzlJTotwNXz85cxGH4q
	DqURlhbjJADgMnZgu6S7kbasrP5Bn8kEtOU2MHOnc2/XpKWYgSfG
X-Google-Smtp-Source: AGHT+IFY9sxMjn1wxE3rhckQ8p2PSpNPfGZ7u1vxkBs1wMJNkllMUWPu0k87X2Mmo6On/7CW2Ilfnw==
X-Received: by 2002:a05:6871:588:b0:220:dc43:f9f2 with SMTP id u8-20020a056871058800b00220dc43f9f2mr8620647oan.38.1709579830208;
        Mon, 04 Mar 2024 11:17:10 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k5-20020a05620a07e500b007882915ca34sm1168517qkk.40.2024.03.04.11.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 11:17:09 -0800 (PST)
Message-ID: <f517659f-0b86-4eb0-aaba-666010976666@gmail.com>
Date: Mon, 4 Mar 2024 14:17:09 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] t/jobs: Further clarify regression test 8
Content-Language: en-US
To: Avri Altman <avri.altman@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org
References: <20240304071851.982-1-avri.altman@wdc.com>
 <20240304071851.982-4-avri.altman@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240304071851.982-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 02:18, Avri Altman wrote:
> Add some more details explaining the expected result
> 
> Signe -off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   t/jobs/t0008-ae2fafc8.fio | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/t/jobs/t0008-ae2fafc8.fio b/t/jobs/t0008-ae2fafc8.fio
> index 4b364850..f4e8a06e 100644
> --- a/t/jobs/t0008-ae2fafc8.fio
> +++ b/t/jobs/t0008-ae2fafc8.fio
> @@ -1,4 +1,5 @@
> -# Expected result: fio writes 16MB, reads 16+16MB
> +# Expected result: fio writes 16MB, reads 16MB+16Kb of metadata:
> +# 16mb writes of 4K blocks are 4k IOs, each creates a 4 bytes of crc data = 16K
>   # Buggy result: fio writes 16MB, reads ~21MB
>   [global]
>   bs=4k

The explanation added here is not right. For details see

https://github.com/axboe/fio/blob/5ae4f4220a48dddddc84c8b839ef9d8a1ed4edb1/t/run-fio-tests.py#L107
