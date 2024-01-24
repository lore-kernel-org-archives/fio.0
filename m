Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D5E60DD4
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 12:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706097735; cv=none; b=e2oby4CoK3fkD6FjJV4hbsYO/KIMz84MZcBZoSllpYyihwm70z3uDFYrSpepDb18c0QodTwpmq6WShMLU9T4FyOUSe+DvfCskkb9+gQmosHcY2XVQpwhlasvvkebmqdUmSBgUMl23dNpbwRQfqaNK2Arn4l/7vlhYv8zuknnTaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706097735; c=relaxed/simple;
	bh=nlhvyP8I7hBg0K+kY7HJW4Tu0iJl1NVNwmxBFw/Wlcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cOcmM6edBvfJo9TPoJErpCauSC0+XfF1jWr4VTnMxoQH03fNpEpWksm3ErFC1ShWDIQ8x/DP2Ila1V++Ys2pzslH2W/X+w1B8ZivkUbjYwu2oEljUHWRz4NApoOZy2z3U+ckSw3lkfhzxlHoBk95XJalIOhkMzFqYwu0cPNDytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=atGYM6mh; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atGYM6mh"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6806914dba7so37565986d6.2
        for <fio@vger.kernel.org>; Wed, 24 Jan 2024 04:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706097732; x=1706702532; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IprVjZlJKkIf19tOBskiizVg/40jNuh4EDzzTmcm374=;
        b=atGYM6mhDEVSYlFWJXMlWqyCii2p9e3ne4geCh3EGA7a544yBuoEhJ3XZgf0MYRX8K
         LqUEuEhkO5Ip30Cg4pruI89buNCHfhELq9VVsORN/dZ9ddk4bisSEfTEdbPG+MAaUNUE
         umkqf+RD3aCjw4+EXz/PAiPUsqr2Abj3nGtwXMKTHbcYx7sl3qTXooNumI8kDss5BJXo
         qXWBrGDIoZFVPOT9Byc+GQgjMl8RUkzwq4a7fRj61aZUxD77wOmYz9l4y1sYRjoMC2uZ
         vbKKRnd+/qI7J6lYV1U/Mt8TIAkrIPxvWAwg1NTeNLX1mzlGs5xssPOU3+JvPc0yKDMI
         PGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706097732; x=1706702532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IprVjZlJKkIf19tOBskiizVg/40jNuh4EDzzTmcm374=;
        b=Z5JdgtakS/XO6ufv1LFc0auX5/izvt9kfTtgdCd1rVOxBAXV5y/5cRHVz8OyY6sjAY
         XGrOEe0JAWzhTIfXjZv69neDmnI0b/4+jhjoHwMABsPOUnD/Ot/KBRqIV5jgLN1pDzOw
         8vQu6Pt2rf1QlwlxoUHT7DfPey9ljERohbRSalsfpz3op532SPCOBpnMI2wXKZYy+cy5
         K0yiNw8LSQN08xMLUE9N0jAwrkoQVOTaGKU2lQNfdjcqjFXu++j82NiS4BxyDjoykPKp
         1+59+TIPmRTP+ryY2KmaBOHUjJzfW4ScXf0HIsNY2PCzsYX2uthTQ1ASEEAgnbjpEOTP
         gTVw==
X-Gm-Message-State: AOJu0Yz8YktXCsCAiT7yuggcbZR36xxqVH0O9pAOyby5eGRNtf/YSOSV
	HJV+B/AI5cccTgMNL5VlNpPcnkprvdrPJ7r6vPk2Q/kt5R6WThfH
X-Google-Smtp-Source: AGHT+IFYRYKrweGggKX9icZchOMsm0ydp7kGeak1hPkoBZ0SiFgBrlEgjLSq9NzrOQMqLT64jE06Og==
X-Received: by 2002:ad4:5ecf:0:b0:681:8f1b:b6b2 with SMTP id jm15-20020ad45ecf000000b006818f1bb6b2mr2770623qvb.102.1706097732347;
        Wed, 24 Jan 2024 04:02:12 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id mu14-20020a056214328e00b0068589e61426sm4281855qvb.87.2024.01.24.04.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 04:02:11 -0800 (PST)
Message-ID: <629184d7-7dba-436f-8f09-ad4b917e04ce@gmail.com>
Date: Wed, 24 Jan 2024 07:02:11 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] docs: update fio man page for log_window_value
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org
References: <20240124113413.52550-1-ankit.kumar@samsung.com>
 <CGME20240124061716epcas5p3c60fd0138f74a40bd020f1f31a298a07@epcas5p3.samsung.com>
 <20240124113413.52550-3-ankit.kumar@samsung.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240124113413.52550-3-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/24/24 06:34, Ankit Kumar wrote:
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst | 45 +++++++++++++++++++++++++++++++++++----------
>   fio.1     | 52 ++++++++++++++++++++++++++++++++++++++++------------
>   2 files changed, 75 insertions(+), 22 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index d0ba8021..f83a8b53 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -4067,7 +4067,7 @@ Measurements and reporting
>   	I/O that completes. When writing to the disk log, that can quickly grow to a
>   	very large size. Setting this option makes fio average the each log entry
>   	over the specified period of time, reducing the resolution of the log.  See
> -	:option:`log_max_value` as well. Defaults to 0, logging all entries.
> +	:option:`log_window_value` as well. Defaults to 0, logging all entries.
>   	Also see `Log File Formats`_.
>   
>   .. option:: log_hist_msec=int
> @@ -4088,11 +4088,28 @@ Measurements and reporting
>   	histogram logs contain 1216 latency bins. See :option:`write_hist_log`
>   	and `Log File Formats`_.
>   
> -.. option:: log_max_value=bool
> +.. option:: log_window_value=int, log_max_value=int
>   
> -	If :option:`log_avg_msec` is set, fio logs the average over that window. If
> -	you instead want to log the maximum value, set this option to 1. Defaults to
> -	0, meaning that averaged values are logged.
> +	If :option:`log_avg_msec` is set, fio by default logs the average over that
> +	window. This option determines whether fio logs the average, maximum or
> +	both the values over the window. This only affects the latency logging,
> +	as both average and maximum values for iops or bw log will be same.
> +	Accepted values are:
> +
> +		**avg**
> +			Log average value over the window. The default.
> +
> +		**max**
> +			Log maximum value in the window.
> +
> +		**both**
> +			Log both average and maximum value over the window.
> +
> +		**0**
> +			Backward-compatible alias for **avg**.
> +
> +		**1**
> +			Backward-compatible alias for **max**.
>   
>   .. option:: log_offset=bool
>   
> @@ -5061,11 +5078,19 @@ toggled with :option:`log_offset`.
>   by the ioengine specific :option:`cmdprio_percentage`.
>   
>   Fio defaults to logging every individual I/O but when windowed logging is set
> -through :option:`log_avg_msec`, either the average (by default) or the maximum
> -(:option:`log_max_value` is set) *value* seen over the specified period of time
> -is recorded. Each *data direction* seen within the window period will aggregate
> -its values in a separate row. Further, when using windowed logging the *block
> -size* and *offset* entries will always contain 0.
> +through :option:`log_lat_msec`, either the average (by default), the maximum

`log_lat_msec` should be `log_avg_msec`


