Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA92973AF
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744640874; cv=none; b=Rmrz9uuX4bZeeV4f+xAV5pjTcSdhzl9uZyX61vqyWmNRAHDfQgaEh8d1WW1c1T2vR/AAA0pA7hpNtakN0j6mX+lluGjCPD82vUxFLGjPO8tXnYHfQiWhzKd2hoTnZ21makNMYlTkGmAjoLuS9eg/LAmDc0UzoIxpCMjG2hSf17E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744640874; c=relaxed/simple;
	bh=9FLwsUbP+RhVp0Fpg4JUmOFMlZ3XBebBe/agkuXUDZE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VWnv1AiBvSDyjq4BycVpoTK+H+9kkJ4JoqINwZkd6oip6iwBfQ2ggqMMKSM1MkjiHDMoKeuBjzcq1CaFHAA8iosSiUKSM4FZL3fr8gYOsSUOGDxL+p9WCidAvgULJBRlewIe3u4F5c91H956ND8lpMVGUC+e0nYWPJSyvugcEJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2/Od7gC5; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2/Od7gC5"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86135ac9542so125905939f.1
        for <fio@vger.kernel.org>; Mon, 14 Apr 2025 07:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744640869; x=1745245669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEElf6PODSJD7rjnYDGMEwE8wSd5KsXp3rX9NcRimjw=;
        b=2/Od7gC5/tRq16W5jtn9EFB9Ya6/7khNMiyl+WPtRUG6Aml7JNm1B52ATNwLJR5f9y
         M06lniAWAfLWam7pWQKRyC57SR66NZjSb8OiGh7DOhysrw54xXUR3Zjbuvd93OyR7lXO
         ezHhR1nFHl0VOS6oXAVUMyJ7FX96M5f4onsjau2vwZhwhgMlkAHD+OZ5CFqb0ALAxAqb
         gyx9dtYJVT0N/ySnhwjSybh+zHhQRuZhQuiJNNXwMsInxyu58ugnidIMPJx28mxPaAMY
         JvaS/p2omvtqbpkTY3F5u/JbzopBkpR7KAT7uhiGGJUUnkGhozyQwL8x0g64mobIX+Vb
         ipaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744640869; x=1745245669;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EEElf6PODSJD7rjnYDGMEwE8wSd5KsXp3rX9NcRimjw=;
        b=UZ3CBOYhq88aOh5wpwBLALS2Te5vwhOlqvSGd/X/Ymt9KCqxdJXEKNe+W74hxC1NKF
         6f0oKfKNoSSNhW/HMyte0ZCmCCNjbZU+ShsTS7N0FZPlvcWNtU6zS38Sj0A0G1I1Ux2r
         C8GpwvJMVNqRwycA25AjaVlxcjbkDXRaRfxZ44rvX9+xNepnbUtlMDRW81BqqNRc/gEP
         ZsZU3Lr6t5b6PbCCJ7G71HbqRpMTcf3ABwufeFouXb/6YSMnVex2P9O6v7CW+7nBR8XW
         2vKTTi2oNp6MLGIeIrsmLeLH7kM7Q62nT9XlbKzGetxvmEPju5ZK8lC1aojnkcgEjwAu
         JYxA==
X-Gm-Message-State: AOJu0YwtkqAyvh2d3Khgk9PlBNzobKz7sn74zDWKMvaxK8kPmTijc8F5
	dueWgyfcuNLc/2rG2HpZpC16dcsnDt5bmFgH6HGmjH6/Vj+5dIrr0yJiYjV8NE0=
X-Gm-Gg: ASbGnctzS5fwwOwzrne4m386Zu4HuVbEBcvwEC5AQr6Tp2E2l1QOtsTqO30uAE7HJRw
	0QicAH7+YP7tzJk4MDTMWoUCUH1KFaIGHBfHsTyG8wt2LYT8A2R7rQoJG69PsQF4fE6+GLfVyZk
	kPNqipq6BUz8BPH5t67gdIlCvFyYTEoWeCXZCnaLM29ioqXFUczOQmtNTQAHqIOE6L+gf03s+5c
	8L1bMXyRFRy5wNfkL8Vs5LeqyObwmvh6e7lOWsX3p1kLmajUhfUkcyb6q9xGfQ5UnwO2MweyQEM
	XrWVWEQirLWuRU+VVYQouf+jFBqzmVV0
X-Google-Smtp-Source: AGHT+IF9oYK9sPH/kXncq7JOOukjSVETBkJWYRHnaIE3xd8IRxIxUxUlZ0C3M2mAe2FT2rgXkloTmw==
X-Received: by 2002:a6b:6111:0:b0:85b:5c9a:a9ce with SMTP id ca18e2360f4ac-8616f1d4083mr1600321039f.6.1744640868934;
        Mon, 14 Apr 2025 07:27:48 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505cf84dcsm2616504173.20.2025.04.14.07.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 07:27:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
References: <20250414062721.87641-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 0/4] zbd: fix unexpected random write stop
Message-Id: <174464086664.47032.9166509356507744034.b4-ty@kernel.dk>
Date: Mon, 14 Apr 2025 08:27:46 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 14 Apr 2025 15:27:17 +0900, Shin'ichiro Kawasaki wrote:
> When a random write target offset points to a zone that is not writable,
> zbd_convert_to_write_zone() attempts to convert the write offset to a
> different, writable zone. However, the conversion fails under a specific
> set of conditions. This series addresses the failure. The first two
> patches prepare for the fix. The third patch fixes the failure. The
> fourth patch adds a test case to confirm the fix.
> 
> [...]

Applied, thanks!

[1/4] zbd: move zone finish operation to zbd_convert_to_write_zone()
      commit: 2a87f2690c5fe8f3b2097e626abaed6e53a1c476
[2/4] zbd: factor out zbd_pick_write_zone()
      commit: fbac34f1a4c1205222659770158f8b6c842debcc
[3/4] zbd: finish zone when all random write target zones have small remainder
      commit: e2e29bf6f8300186d267fa46a7b266d14d174575
[4/4] t/zbd: add test for the case all write zones have small remainder
      commit: 96afc2337db197a59fae916b5ff4226af8b0108f

Best regards,
-- 
Jens Axboe



