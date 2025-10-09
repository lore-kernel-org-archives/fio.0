Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2371E0E1F
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 19:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760037436; cv=none; b=DmRP7+N8yV6fjo0SvFQx04L5PayYTCa5VyjIm1vOyFicr7agVFuWJCm4wp0MH268x82I2LOr6nGokg1oAo6acXZSHoPinGPYfZVqFfjzybsp3hkjj3valtNIMNx1qBdqKigDJdmV0bYf6HdW/H0mttK9GlZNkk768RMDeDe4KiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760037436; c=relaxed/simple;
	bh=2pteDlpbBv9kMOhGuGVu2yiFOymwmAW9rG71csgD/eU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Gx7QWRGZWj3skPJYH3T516nUIet0ZvGP0AN9hVfRzC1VET+zzQE8EmQo1RJxshobtOXej/EWSTyLYxNui+z79nQSem0fQ7KMO/WNSvYVdCBpoAdC/en+URa+UNOTtFC33tiDdu9/rLp6Fi9VQiqlTOB3CBg8oZ5tnyuvwdwpOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GQVSvZho; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GQVSvZho"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-9032edd72c1so148540939f.3
        for <fio@vger.kernel.org>; Thu, 09 Oct 2025 12:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760037432; x=1760642232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGB1EtUzU/+AoIV/kUyhjweHGICmyTtKRGJfVxy6wFA=;
        b=GQVSvZhoLOsHIccefLUhBwZ5R/Y3dDG14aiE0NFsvAhU02j9pnbTMHq5RegX3qXGbn
         l5SNLvLiqJSH6H4BpVlBDLMomi+/KqaW23j2Z3kyIXv6cKyw335m69XDsL2XVW/Qeqid
         52GzKvKDtPP5YBttQMW7IfCiSzQLgV3y0D+hFE5O8oY1eCBWKNnD7eNGcfEmTTlyzxVK
         iOIAq19Wv9JxKxz9GujyVNLw+4SwA8mUjvYeZyj8z8auAUvhDICsrZSKB9QpRdsN2WJX
         nh2NaW2LU1mNIkfVcWviQQjbmcK2WIfIhOL7pot2VtmBSl9tJf3RE4bOn26LLMYxBSCl
         RnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037432; x=1760642232;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGB1EtUzU/+AoIV/kUyhjweHGICmyTtKRGJfVxy6wFA=;
        b=k29p7sjTO+8F4layEw7gdgT90loHsbDrZYlplNCxPna3yvsfdwQbderFeofjaFHH2C
         gbUwWwLkHuBOCZFbFHzXUT5KHkpmXLbGJ/GDccvNlotwjRy2bNi7NjQMnWbzr9YRXyGY
         Wkb7rS6HKW/tfwAgPITsLLvRHmIrEL4FnPbKA/h8ka68KnwwXq3/bRsG09r6nbhYwUCP
         62ixP8rjpYff8NUKqV8igC8ZDeeqMKb0tsfmIKJ6UQIRQ+4HQI1an01OfyoK4glqlcZG
         SIC7mxJvap4Kwe1hbpt2Gsz2cJlgM5sbOVAyfg0J/q45yPX45mNNP0uu6/rMV15cZOis
         cWLw==
X-Gm-Message-State: AOJu0YxAaNFXVQgWEfB7Pwfz+cfmLWsdxF/Le5IPGSXgj0aB50wnNG8f
	XTqJ6jZvDGp3HVINT1N6HeWPh8n7rz8Vjasu+smrF7dVdsi2LIG6L4eSvzmzAN7VKPo=
X-Gm-Gg: ASbGncuZe0gPZuRE0m5+pGqVGs7+pGsBu1Zb2OCbRR/1XS5CwJsdP5e4YP7EDQrYaAj
	fcBMNfn3TRwD+e6YUaqm1qTbwAZv73ypK4KZ+kIcon4q3F27xSiKclPyxL2x19EdKv3jtRb5b9q
	Sad2OWWjVYpMkPK5epputHEPVkFFYEUGo55oeMNVQOgkUDJSXKljoeXSEfzvtrJ4l+aS2It6ROI
	B/2cn6u5pa1j10gPhx4ljZh/LaWlld/d1GyN26Vk0tg5TCUNkyYVOy2niMK748G7SzQGxHVrLbo
	bMQKAp0rz5/jPYuNYGvPRzX81wFlZ9py7bP8tVv/hPyR2YA8nonLLpDHAZO4EfbskUnAppGSjcW
	wlOqKklN0sv4f6dcboA74APrvYEUesDkP1tiAvw==
X-Google-Smtp-Source: AGHT+IELH63jIN6jlHBQc6bGXt3xeoATRJE4hxbrpRMrw1pBQyDXSOh2zyRL5CZnKb6GfJ/5zL7sbQ==
X-Received: by 2002:a05:6e02:2783:b0:424:866:ec6d with SMTP id e9e14a558f8ab-42f8736d251mr86940925ab.12.1760037432374;
        Thu, 09 Oct 2025 12:17:12 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6cd58e48sm104502173.17.2025.10.09.12.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 12:17:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
References: <20251009023928.1634382-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 0/2] stat: improve zone reset count reporting
Message-Id: <176003743168.2240982.13106636429467744423.b4-ty@kernel.dk>
Date: Thu, 09 Oct 2025 13:17:11 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 09 Oct 2025 11:39:26 +0900, Shin'ichiro Kawasaki wrote:
> When the zbd zonemode is specified, write or trim workloads can trigger
> zone resets. Fio tracks the count of zone resets and includes the
> information in its reports. However, current implementation has two
> problems. Firstly, the zone reset count is reported even when the zbd
> zonemode is not specified. For non-zbd zonemode, the zone reset count is
> meaningless. Secondly, the zone reset count is not reported when the
> json output format is specified. This series resolves these two problems
> with two patches respectively.
> 
> [...]

Applied, thanks!

[1/2] stat: report zone reset count only when zonemode is set to zbd
      commit: 7089300f2dae18dbcb05dbb75fe73606658a12d9
[2/2] stat: report zone reset count in json output format
      commit: b9b306b542afb8a3059c2035fb2034a89e4660d1

Best regards,
-- 
Jens Axboe



