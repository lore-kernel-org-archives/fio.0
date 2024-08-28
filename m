Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439AF13D896
	for <fio@vger.kernel.org>; Wed, 28 Aug 2024 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864800; cv=none; b=fjinZhMDtSM4vHH5vYPi5LTYYUcB5hZgFPNmE4mqMnX9A9adDQMmDaWnhLmlALYLarziXdbOZ7E/3oX2ry2JQ/ZPwOw3Q9PQkJgKrwuGQ4iV8v+hQKrDzH3Wv/l2KzITwJA8YvJEaeBiWBC5fqeS75tIwWwSykSvBkf/ldVREPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864800; c=relaxed/simple;
	bh=niPuRhL6Pgd07aH/20QdFIn8eoJVpNMdOlzn9lF+/kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nVJQOY1B/dOF/PNffYCna9LXf0cgaIS+v5q//OISVTLmg+jH6kcEP6RR42PSg13jvzcLfLtZFL2F+lOwAQCcBmhrzrOqNMudcrFVSBY9rV1gwY9RnJJvzVu/XT4eRHwwwhHD38ZXmM7QvNmRw4B31JbF9j1m003vt69TaAXIVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VXS9/S/i; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VXS9/S/i"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-81f9339e534so234960939f.3
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 10:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724864797; x=1725469597; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21U3ac/cOm5urSE70KcT8WGMUY38JBEL789Bvqb8gCQ=;
        b=VXS9/S/isU8ZT0f74I4P0rdLFygk1whXBk49Kg2gStKTmbsxftUHxbuW2bnysVS3LO
         Uk6tcwEb6q4/O/uv1h+m6VIPKacCWa18SHFvEQ3mGCNypMceNBfB2Z0ozjOxnLgdab8Q
         /WNsixvkCIj0iKi2HX85XreJDPjOPat9QBhdKlJOv9wAwlHGNmfpekWRzztbDNZdCxrj
         J9TmxOEDtpCgN8m8Cdv+BHE9+zzVQw90FHAImWNVJ6nHOzHYz6/DWhoLIt2wBYUcswfY
         rjrMOtE7WOOojgpXoIJgBnlZEmfO63Qeszd9RWsgUDTjNVLEKLiWoQDC6VbRgwDcgmo7
         vFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724864797; x=1725469597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21U3ac/cOm5urSE70KcT8WGMUY38JBEL789Bvqb8gCQ=;
        b=Zgjdu8JLYXFUH6bm5dB9l7z+N+nQYeE2SILUwQFTogDrFuzi5NHPqrqc3GdYplif/K
         17Dfw1ENMZtZkm/OziblJiXwUlpTUkisiliyLKwZJUB0TMRY9j1FXZMl+Ny4J3YfKlc6
         KXoeU2YbO+CT4OLoW66tRxxt2sVIseC01YV1M9rWGcSBwNgGmumkACxAEqjj14ViEcm8
         X1cAloeD0hv5nZqDOgQ2FLzOJBdpCBNGyOl78Q+veOwEqSf+AIs9PxW4DyGKTTFrWore
         QXGMg2Y52i+U54rOysY4bboKd4G4WUemL2aVUuNQxPfj8WiJHTiHLIkM1XrI1uZVA3wD
         +7HQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuABAyDcEAiACKr6eJZNMSQKyzWc7kWu8Jr8J2ONYDt1RLVggke3eg+VZH2QqPbTgy5n8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ByRyaAtdonrqJcpk9QFCArC5pNu2vFs6sKtu3hXNQbAmIJZE
	4d1uWnhWA6mHxm2pd+bgR7J8vcuGc6phBbtEa5aDqcVQ1I/s1FID3nuL8Pkw480=
X-Google-Smtp-Source: AGHT+IE8PYXvbeO6i3WiC+tQ+/luzvaFO6eDblPneDWqZ4w55d89UWO1vKtyN664t4KRuZdJRWYvyw==
X-Received: by 2002:a05:6e02:1a01:b0:39f:36f3:1959 with SMTP id e9e14a558f8ab-39f377d827emr4848695ab.3.1724864797069;
        Wed, 28 Aug 2024 10:06:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7114bd3bsm3067954173.172.2024.08.28.10.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 10:06:36 -0700 (PDT)
Message-ID: <d056a445-52c3-4407-b792-fdd2b6be204e@kernel.dk>
Date: Wed, 28 Aug 2024 11:06:35 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] introduce the log_issue_time option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/24 1:08 AM, Shin'ichiro Kawasaki wrote:
> When write_lat_log option is set, fio outputs the 'clat' completion
> latency log file. This clat log can be used to analyze IO latency. This
> file can also be considered as an IO trace file as each IO entry can
> fully describe an IO when the --log_offset and --log_prio options are
> also used. However, using the clat log file as an IO trace is inaccurate
> because the time field of each entry uses millisecond units, which is
> too coarse for fast IOs (e.g. when using SSDs). This series proposes the
> new option 'log_issue_time' to address the inaccuracy problem. When this
> option is set, fio adds another field to the log file entries to log an
> IO issuing time in nanoseconds.
> 
> The first four patches in the series clean up the current code as
> preparation. The 5th patch introduces the 'log_issue_time' option. The
> following two patches document the new option. The last two patches add
> two test cases to check the log file format.

In general this looks fine, and I think it's a useful feature. However,
should we have an option to make the generic time in the log entry be
in nsec as well?

-- 
Jens Axboe


