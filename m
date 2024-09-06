Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF7512F5A5
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 13:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630129; cv=none; b=CtNluDPMGeGtutHmOR2qW5kptAjcTT9hxZUTa7K5a8b4oWiM/NRsyenFVMMN6df8zG8K9XfNlCNBWbA9Ea9w/4HTCyv8sXwNiOxRL060ODDkXEfVQXlefdPVj4ZjV7q/TAbLrz6LlCUC+6+EWErk8R/ZafiZC0hYUUs+CC4Tm3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630129; c=relaxed/simple;
	bh=7F8d/ylXCbBqQtsya+RmI4a9cuI9InFzlBUQlv/osYI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lBuwsT42LhK2ml0lCpKTG0bdo6Tr1OfqeTqxVvqyXmND6nv341ki/s4i0vWdtGJ9TZf1QZn1SInUUUFTgk/cVp9bWz/51yrM7saVbx7VGttZIjDCV2FbLMbArnwhGBJgnEgZghATd617TjXmXJEPwmAWLTP5hmmniSBUESZ6nLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tQ5HLbzs; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tQ5HLbzs"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718d962ad64so487558b3a.0
        for <fio@vger.kernel.org>; Fri, 06 Sep 2024 06:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725630128; x=1726234928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azy4CWhBLaQzGRK9mzrrUVuOoXWQ4RjHvWsjOu0Cs+Y=;
        b=tQ5HLbzsQTh7pHSEnwpdO5ouhKOF0We1G0V4k2nAu3E2dzOKC7r+DL5Vx3dEr/cgHl
         kySOxTR4zAuBp2GbE9pQjfCFY2m/Y/NKOqaYgNX62kJdfDCKZ57P+F8nsitFWasVcGyo
         XCdtaWDQC4GW27rcQx/1Erpv6erUvlo4iWP9sAPUB7yAjArLiwtULhTlovNyL2AD+Kfg
         +f81BiRHB4ct9gLqciSYxBjoL92eeM9AXzdkNdZ/QTlkwQ55kz1KzvTtdAHqcAPS664w
         92M372SWTz3YrgDaMjVlVqgBdiDVbXuU0uYXhK+BSUUQxG5ZDkQ1cfYypZY7BPSDbdhO
         fyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630128; x=1726234928;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=azy4CWhBLaQzGRK9mzrrUVuOoXWQ4RjHvWsjOu0Cs+Y=;
        b=WSkzu8X8QxYUs268UKwbu6r9+PRtaRLCxNx7mmBcgTDtyj+3y4yAM4e9szKJHhc3hX
         zcIEunNlqX8BjLMt4bd1WK9h5f32J176m2vgvt+Mq4ZG9BdlzW5U75XNKZ3qOCLY9xIX
         et6WP7UDyYYbaaMoSse7da1oQRAedsUrcz8MXvSaLAuccXfsnPdlJNlV/jQYZz67I6oI
         h5+1gAdCDjO5pAmdKqWgZVOEx3Ew11DxURC0qtaDstsp7NiOVyetXNEoXNDy0ipjR8fa
         nW85ffte5rsklOoXtlcSb/h/gPPQwc97h7+Zp3txg4kDSnXnIEX4P5NW2B6vceAbWldB
         e+GA==
X-Gm-Message-State: AOJu0YwpuYTnWol/K3TMmfsgrQ0FRXFAvEoaCtmB/wMhRLPhJHdSgTi/
	QuRdH8DfnLEOAUz0QMSKyjaoV/5Kofd7+5d/0YSa/SKTBRwOy1onTY959FqUomjaD31SHK8mVkJ
	V
X-Google-Smtp-Source: AGHT+IHSCiifjyhOqTUG5g01gYAkjlSzPU3DiFOTEbg7cHQvIkxeprb+MTnWnwnMWIzjpbzcRBIdyw==
X-Received: by 2002:a05:6a20:6f93:b0:1c6:a562:997f with SMTP id adf61e73a8af0-1cf1d25e64dmr2281863637.42.1725630127714;
        Fri, 06 Sep 2024 06:42:07 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadbfe4b41sm1562641a91.8.2024.09.06.06.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 06:42:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
References: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/2] stat: fix the null io_u dereference in
 add_clat_sample()
Message-Id: <172563012665.167604.14757832595850997654.b4-ty@kernel.dk>
Date: Fri, 06 Sep 2024 07:42:06 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 06 Sep 2024 11:37:15 +0900, Shin'ichiro Kawasaki wrote:
> Commit 14d3134a5fc0 ("introduce the log_issue_time option") introduced a
> null pointer dereference failure. The first patch fixes it, and the
> second patch adds the test to confirm the fix.
> 
> Shin'ichiro Kawasaki (2):
>   stat: fix the null io_u dereference in add_clat_sample()
>   t/jobs/t0035: add test for the file operations IO engine
> 
> [...]

Applied, thanks!

[1/2] stat: fix the null io_u dereference in add_clat_sample()
      commit: a0e2faaf7e5d0814f08f8ab337241372fd58be1e
[2/2] t/jobs/t0035: add test for the file operations IO engine
      commit: a189fc720a4d661dc1813981872d08ef586301bc

Best regards,
-- 
Jens Axboe



