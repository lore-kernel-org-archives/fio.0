Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ED7281345
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739456849; cv=none; b=B26UV/psZTl2bPI6ZkcRoC3TKU1Oe7p+eLgWMyBnfHhrP+fHMVhSwCDU3JijB3CLudzlpzyAoZpkTUkdfzkBI/NGz55u3sqiXFfH9P+uXtW7zN+sQgiENvsJIbydfVVBChEqCMFXVWxrWAAXpsQWRLQmOcXAFIqZJxoCOm+zs34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739456849; c=relaxed/simple;
	bh=ogAkQav+TD/yyzZLvvo6djmpgi3NBcshwgaXyTsCDDc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XMR8jW54Iy37KEBTIiSi7lDsN2xyev2SR8YP8f02TWT6C6FFt+YQ6I1O+YuITEZ7K+VycXcudpRH0rHuKmWUDAwENfusv4YxCy6csWgx44zfDYTJu1C82WHhywMmiegpedx6jGSpzeSGtBj8baxRghi6vFlOW1LrD7aIj8Wjpas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UmrBANmT; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UmrBANmT"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8553d7576daso26380639f.2
        for <fio@vger.kernel.org>; Thu, 13 Feb 2025 06:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739456846; x=1740061646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfsU6CPQcQ3hUqzo1aSsjavPqF/BJAbHvn+rF/iDGeg=;
        b=UmrBANmT9AsLGJWVGpj6EiM4w+dO6oiInTTgd3gONUjB1R/cl/4nCM/lSJpq9swgbM
         aEN65uWpviHpVwaYRrtk3GnJOteDaQcILX3BYMzqXgVZbJnEaVyyRu05JFi6i5N/vXRI
         RoATHb7wdDkjjoK5e+7fA7Wso/fUrRaUumPc99mJpbf/SaWT04U5uo9A4X7eLxf8/5WR
         girgqmeHV5LztQOJ7rK07DoTQZgwaaHBsY39KXXkxl/FmynJ0yCpy5ik0O2FieahnLV2
         b/dxB1actoknoW0Bj3bq6JXymwOR7L+5Q2wa19VcO2KJPvnpcajkLXTTrISgYOEEJYsN
         cWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739456846; x=1740061646;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfsU6CPQcQ3hUqzo1aSsjavPqF/BJAbHvn+rF/iDGeg=;
        b=JLRMc1nxE+JYhUPT3swY4q05neU+y4qQyyH9qgSpvq4Vw4QSHexpSFTPv4gKDgqBhj
         NYvAKKLg9PJbdZTd07EqZFmFqVlkw4r05xuy7iKH2xLQ/ta0lK0u9b/W/tRfe1iPDn4q
         NXySlVTzBcWSkFxlvKbYOksQCv6FnW1ot2SsSaoxn0Qq7pcdRNrlgTZ7abtNJDWwU1WS
         00Cc4GKDMtkO3KjafvQFsP+XGwq8QQPhr8dRVLrE3MeJ5PhjpwuxJRcUlJzswDC9Unxk
         AQYGVcbZc34JzepV9Wglbr6SLGwsbDfX/xVHAzXRMkdcuPflIh/7RuAGkJxR+G6m/zRn
         SjcA==
X-Gm-Message-State: AOJu0YwUV+DK7OoUfAV54kpA7FcYG1ReppJpms07InM718QJdVFAuIx/
	pJeZ3E3Ke43aBbZIL9u/UaKDLBYvT49n3yPIVN6D+TPoV0PDNpM/0z8dgyplkhU=
X-Gm-Gg: ASbGncv/qkLPYsIMdaT8rGLeQS86ohB3sqR33WppKycmfE1LPosQACXWsH3PMnrFkDX
	RihUJJNULhPazXH4VkIbZOKejSa4DLfE9awoXGzIZGSqsatB96cpBBPHcgoyei8rXrZjgzoDeSL
	67Mxu5hkoywVRzfgIhXTbivpFIzs9nbkz78w0znANfDnjmHJUvgxgFlITplisJE6jGb3uZDbWKG
	kHWn90Mo0EbjJQ6w6QLvnJqawiVzCVFguyxh5XRqI9OG/2BnesglT/1QWPFxzUDIbAvuGfxMLSJ
	u0CkKw==
X-Google-Smtp-Source: AGHT+IGBgV/LebqJGUZOppDzqVxjSQAaLENw9wlSPhSfR2/8/+iOhaCO4lEUFNrOsCl9LIMdDVZGHg==
X-Received: by 2002:a05:6602:158f:b0:855:31ea:da2e with SMTP id ca18e2360f4ac-855635bf6bfmr286937839f.6.1739456845810;
        Thu, 13 Feb 2025 06:27:25 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed281711d1sm346370173.47.2025.02.13.06.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 06:27:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
References: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/3] fix verify stop for verify state of async writes
Message-Id: <173945684489.82112.8335650799457856256.b4-ty@kernel.dk>
Date: Thu, 13 Feb 2025 07:27:24 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 13 Feb 2025 14:25:07 +0900, Shin'ichiro Kawasaki wrote:
> When asynchronous write workloads have the verify option and the
> verify_state_save option enabled, fio saves the last write completions.
> Subsequent verify workloads with the verify_state_load option read the
> saved verify state file. The verify state file stores the last write
> completions up to the iodepth limit. However, each write may take a
> longer or shorter time to complete, causing the write completion order
> to fluctuate. Consequently, the very state file does not always save the
> last _issued_ writes as many as iodepth. If this occures, the subsequent
> verify workloads stop unexpectedly without a message, confusing users.
> 
> [...]

Applied, thanks!

[1/3] verify: print message when verify_state_should_stop() returns false
      commit: ceb624e812ea20316532516f1422211fe6ea8bd3
[2/3] verify: double number of writes to save completions
      commit: 9abce429d3211add643229a593d0b028b51f5942
[3/3] t/verify-state.c: adjust to verify state format change
      commit: 0e0d9a3a3a0aec52836d32d749d4f838b673d73c

Best regards,
-- 
Jens Axboe



