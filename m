Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A941C6D
	for <fio@vger.kernel.org>; Wed,  4 Sep 2024 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725475641; cv=none; b=eTXcR6W3GvsY/eZTgTm4qo/4T+0EC67cq58oa2FuStbUi7hcR3z7Zb65c3uK5PkRb5pwEFEcg/vIL8yhL9HcbkGr32QZ9+vjn1H8bdEz3xMmmMeRMkitSfqGMh6DuGMhY6hlLsX09cRUfDeUnVsj3BiTKO25IoNm64wcfHbPWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725475641; c=relaxed/simple;
	bh=tqXFiWS2UqjBbbO0BLextK/6PIVAkMs9bDCs8BOh0sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdBc5WKIsYS7ufSMnT8Bxn+dX6T8uIjZWSsX90cRy++kJczQ4RxahrWV6aOI4sH+E7YY+HtYKuxSoOmgTU7iaVadmFkovMjoCLsH+AretNJNrCQFXRt2JCg1GGDGfnlKJ7iITI2FZrvvY3nFIRp5G14C8oMd9SzdgdsNYSEutPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEEMoCkQ; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEEMoCkQ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6bf9ddfc2dcso31697676d6.1
        for <fio@vger.kernel.org>; Wed, 04 Sep 2024 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725475639; x=1726080439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXUmOABFQr6ZFZNcgu3P+uGU2pdxIN9Nq6xjsW81/PE=;
        b=nEEMoCkQXFRJQZgVOVU1yI63sRHXbXeoVUzcOg0zSufI5RNZv4xfjGIlBfH9oFqIu7
         ph3J5cWKBTG3ZwdQVQVerkl53sRgPvKI2KZpVR7C9t/pt1FZkQ/7tzFpOzNc2foqiyM3
         p/7h8ZYOtCN4PnztsKDimWR80DMGSQgkEYrfHCOLDp5OOhSE9lqp8nailvVkxtEcbh0I
         syeb0xk4RIigm6w7cf832Po/7U9qlbehBYRAVU44lgjmnU1wEFEUwAwBi+neEaAT9k5O
         np7E62EuTaWc+V44w8srsIeGL6EbfNQjNWRiC+ShbqNLOYPfoqo3iQkRcGE/nBhra0cc
         SPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725475639; x=1726080439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXUmOABFQr6ZFZNcgu3P+uGU2pdxIN9Nq6xjsW81/PE=;
        b=U56b0/na4Tdl/VWHbmSIj4MjMfS2BcTWhNbUUptDaMQdl7WXSceL9sCFXdn9x4ApdU
         24NxbYDgb7euVLJ8nP2KAvBzo5o2KQk2FocRM7zp9oMk+C3q4eTM82auaSZ5zcNfaEpC
         q8iaDMtXQgkB+DihJ2wLnZ7EkugY4QBFXry/8xD/k8tjIgIyla8WNEIn0jnLz77+XvcH
         Q8CQWOkT5QrEdMxYCq76hqjGacEJ6cA5hvL/ihJtV9VVrSDQGwC8GDajEJUL/p+MnjRN
         QNqFKsk+slc5qWWzGm+z2x1AdBcJiDF6dS6RC6Dt9ce9R13rnLkQbPIuieFD5FSvkeK+
         qZWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUWtXurywDwqDIds+fGvcDIEwIyViMXwz48MquGhUueO8/3iqQrBo8wZ64uhcYdvZ2XyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy20VOU8I0Nvxesq7r2sH++e5wyn9WaJu6nGTAL4kiLWLqjbYve
	0HwI+7UpKL0yhmmhq1L0e5YSAEWftdZMyaoi8leWPiLFvzA+RXYU
X-Google-Smtp-Source: AGHT+IFNDRm29zeOLdwf9rLdPfuSOrBYkinW6bzHVs90B91Lqo/VdAgvmqfx15u+nOd3JeTqDmngYA==
X-Received: by 2002:a05:6214:338a:b0:6b5:eba0:d0ab with SMTP id 6a1803df08f44-6c355684df7mr140871306d6.15.1725475638776;
        Wed, 04 Sep 2024 11:47:18 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c520315369sm750406d6.96.2024.09.04.11.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 11:47:17 -0700 (PDT)
Message-ID: <a3c610ae-c191-4b9f-b2a8-ed797caf4240@gmail.com>
Date: Wed, 4 Sep 2024 14:47:17 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] introduce the log_issue_time option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Nick Neumann <nick@pcpartpicker.com>, Damien Le Moal <dlemoal@kernel.org>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/24 04:58, Shin'ichiro Kawasaki wrote:
> When write_lat_log option is set, fio outputs the 'clat' completion
> latency log file. This clat log can be used to analyze IO latency. This
> file can also be considered as an IO trace file as each IO entry can
> fully describe an IO when the --log_offset and --log_prio options are
> also used. However, using the clat log file as an IO trace is inaccurate
> because the time field of each entry uses millisecond units, which is
> too coarse for fast IOs (e.g. when using SSDs). Also, the time field
> value is recorded not at command completion, but at log sample
> recording. The time field value is slightly different from the IO
> completion time.
> 
> This series proposes the new option 'log_issue_time' to address the
> inaccuracy problem. When this option is set, fio adds another field to
> the log file entries to log an IO issuing time in nanoseconds.
> 
> The first four patches in the series clean up the current code as
> preparation. The 5th patch introduces the 'log_issue_time' option. The
> following two patches document the new option. The last two patches add
> two test cases to check the log file format.
> 
> Changes from v1:
> * 1st: Described add_*lat_sample() arguments in the commit message
> * 5th: Incremented FIO_SERVER_VER and fixed typos
> * 8th,9th: Added test requirements and extended job runtime/log_avg_msec
> 
> Shin'ichiro Kawasaki (9):
>    stat: reduce arguments of add_*lat_sample() functions
>    stat: reduce arguments of add_log_sample()
>    iolog: refactor flush_samples()
>    iolog: drop struct io_sample_offset
>    introduce the log_issue_time option
>    doc: fix the descriptions of the log_prio option
>    doc: describe the log_issue_time option
>    t/jobs/t0033: add test for the log file format
>    t/jobs/t0034: add test for the log_issue_time option
> 
>   HOWTO.rst                |  40 ++++++++--
>   cconv.c                  |   2 +
>   client.c                 |  36 +++++----
>   engines/fileoperations.c |   6 +-
>   fio.1                    |  26 +++++--
>   init.c                   |  12 +++
>   io_u.c                   |  14 +---
>   iolog.c                  | 154 ++++++++++++++++++++------------------
>   iolog.h                  |  47 +++++++++---
>   options.c                |  10 +++
>   server.c                 |  10 ++-
>   server.h                 |   3 +-
>   stat.c                   | 155 ++++++++++++++++++++++++---------------
>   stat.h                   |  13 ++--
>   t/jobs/t0033.fio         |  28 +++++++
>   t/jobs/t0034.fio         |  27 +++++++
>   t/run-fio-tests.py       |  66 +++++++++++++++++
>   thread_options.h         |   2 +
>   18 files changed, 458 insertions(+), 193 deletions(-)
>   create mode 100644 t/jobs/t0033.fio
>   create mode 100644 t/jobs/t0034.fio
> 

Applied. Thanks.

Vincent
