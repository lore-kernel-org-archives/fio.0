Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF42634E9
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706191923; cv=none; b=lGqs0L3SsSPknq79Z4hzjJAkydSyuG19UqevMdPm7LmPC87AbXlSoT5JqYAOxOoro2G/SQlzdYblTVf4a9IitMCger0vNRc8f6zrrCZs3bXP6bvf6Ed+j8qc7OkBrk6R8YsBp0FqOvx+9n5Gr4vj444Zbp+ro/0P4DJSTXpF7ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706191923; c=relaxed/simple;
	bh=O+HYx/qJspLm5l9JlolfvlO4NjtUCkkX2Bky7dWnlyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+TpaCHxv+yz2wSPYtFjbrA8gR50TPxHerEDREiyt4bwmDnp6CU0c2sYFS3DyZNeiH4rTcQbwj4YLNxR8+nO9fvqFBaoJrparW25qU7cRm5RL6/n/bb+r7AQ85WQh4mQkhuWMg5tWC+/ZJrtWK52ApEdBhQhZu0A+IhpybpFAEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1edUS2L; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1edUS2L"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6851dd6b3c3so33553696d6.0
        for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706191921; x=1706796721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Su6p5nKmZJ2ZG26R9BBvckg/a6kTxDv0TZ/GaOrlCRw=;
        b=L1edUS2LSkrP0cYXCmMdwXmNSHRrCG06ZQptgJUCar01sqEGf89ejgNh4YP/pYOvCD
         m7Ug2xytQB7tGdxAKQFIV3l1PyukSNLpr2Ge1r7PieA95rT4HD2gyMomOyUovwoIwrx1
         ee1Cg90CFONbRpPg5XlcQcnpxVoNJWduZeCZH/ELZSkUFR/8c4pRicphWRf2TMWhLOuo
         lQMcV+egKlBHDK3cnPBZIoWMivG7z7gvwZ78Nngv7LMHr7l27rNTOILDiJNFA83Uli7N
         +yg5d9xxzUFWoq0OFWOwUfucrpzP0CV2cu4hmCssFJpmOXXrClN4g84F4QGHj85H0vwJ
         DVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706191921; x=1706796721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Su6p5nKmZJ2ZG26R9BBvckg/a6kTxDv0TZ/GaOrlCRw=;
        b=qmgZCWsNNFqEObLGW+6JU+PHK/998iyF04natPuqPhuya7HGCTOn08nw0MV7A/e4tW
         290/VTXXERu6yv1NvmDA09mKfsM0UYbRHH1KX/DgciujZhgIGEDq1L3lMt5yTrgzH6PB
         B8+mjcoQ5gN65qSk8WOIjrQiecIrbMRGc/snRQpvqG2H5uArQDcxBRB5Sao+daO+7V6l
         JMZhCVJIUNoQR0Q2WwaHNr6fnmypIzDAkBRgcR8Y+o5jCZBvPKOD8nGT5d2MOmVn7imS
         DVkk+NrJ7XLYxT0fH2cTi1Tq7pqPu7YrJ3FEwMxNrc8DRttue4xLbGyU3OZQXy5L5jBW
         d2tw==
X-Gm-Message-State: AOJu0Yw9jXMSawaJnyMwl2Ec6qSulbZZ8ZqbWV3GuxlccZja4ot3Jnvb
	jeUd7XpSd7nm6M2E3KJBvNW/sOSIBWmxEKUUe9G/idEGq6mIJB0T
X-Google-Smtp-Source: AGHT+IHUF+34Cd4D8unI5GoKBAZPQWhmHQsRvQH3SsEz1oX8wtv9T5qjKto+AEa32OKOpJCNAHdOJA==
X-Received: by 2002:a05:6214:e6f:b0:680:c838:5cd8 with SMTP id jz15-20020a0562140e6f00b00680c8385cd8mr1177390qvb.7.1706191920981;
        Thu, 25 Jan 2024 06:12:00 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id or9-20020a056214468900b00686a4f9312bsm2445636qvb.50.2024.01.25.06.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 06:12:00 -0800 (PST)
Message-ID: <2830529c-c441-4047-8bf5-02698d3fbb05@gmail.com>
Date: Thu, 25 Jan 2024 09:11:59 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] log both average and max values over the window
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org
References: <CGME20240125054350epcas5p3b4116e69a99e57421c5c22989e5cfb7a@epcas5p3.samsung.com>
 <20240125110124.55137-1-ankit.kumar@samsung.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240125110124.55137-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/25/24 06:01, Ankit Kumar wrote:
> This series adds an alias log_window_value to option log_max_value which
> now report average, max or both the values. The log_window_value option
> type has been changed from boolean to string but retains backward
> compatibility by allowing =0 and =1 values to specify avg and max values
> respectively.
> There is no change to existing log formats while reporting only average
> or max values.
> 
> The fio documentation has been updated specifying the new log format
> when both values are reported.
> 
> Changes since v2:
>   - Fix man page as suggested by Vincent.
> 
> Changes since v1:
>   - Use posval for strings instead of magic numbers as suggested by
>     Jens.
>   - Change option name to log_window_value and add alias to log_max_value
>     as suggested by Vincent.
> 
> Ankit Kumar (2):
>    stat: log out both average and max over the window
>    docs: update fio man page for log_window_value
> 
>   HOWTO.rst | 45 +++++++++++++++++++++++++--------
>   client.c  |  6 +++--
>   fio.1     | 47 +++++++++++++++++++++++++++--------
>   iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
>   iolog.h   | 21 +++++++++++++---
>   options.c | 34 +++++++++++++++++++++----
>   server.c  |  6 +++--
>   stat.c    | 32 ++++++++++++++----------
>   8 files changed, 200 insertions(+), 65 deletions(-)
> 

Applied. Thanks.
