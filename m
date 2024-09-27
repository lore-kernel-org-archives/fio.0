Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD78F1885A2
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727432344; cv=none; b=lxbqfdJEeGF2Tl3htPQSFZHbpFBzl3WVzf8MmHc6o0Uxo7Y196NwwU2XCs7ilUGftGwh55b7BYa9aDrvYYheHff76OISe1ma7sBU3NZG0AQisWaq02egNhZKxAStXFQJeq+NY3o/V3/qycyTfsRkmYUCZpLOmJOm/DEnHxQ9Y70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727432344; c=relaxed/simple;
	bh=Qp5/lQEZlK70l3MtcvpkE6tFFQI0TT2ks+J97v7qXhQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Hl206mtjqH82h3jBqtklc+V+1nazTbEzqtzRFYQ34AVy4QlBTippZsXQdcqMCuINXI2gUCCiuxnmu+EqjWjDN8rbxZb52Y5dq04/CnWyi15TV1nelmi2+vqextudcUE1XDmYxgG2UP7EosWRSapGkyOLPkdd6WwYpJ3ZfHFJliA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fYKWokeX; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fYKWokeX"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e0b93157caso616312a91.0
        for <fio@vger.kernel.org>; Fri, 27 Sep 2024 03:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727432339; x=1728037139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOSzFI+pEqNKt4UIfbSyDUAWZOX+zl+0pdlojvj0Fqg=;
        b=fYKWokeXDtz40Fm9/sApaQfdbRL3bs1gLEctZ8MgtWZF6W1EzB7GVLfo9WVUghFCYw
         mUPcFEPcB/aKxSQr3HHe9yYuPoufwDa7WzGpZqXVAOIM8aKn/PXVHO8zl1hZ1MMe0kta
         +ZsyDyUL+eCakjrFrWbwhdWdyoHrJutGGXAk6chnZzBnb8JJ/X4w7K4XS5ozbPdXXcuM
         6Zj66r3cF4zu6cztmL/VvLx2zl5DyNn5lcRW8Os69hSGb7p1h8Ps4HoEdFol+74tv0h7
         JMe5VBRYxjsHFUpBAMVx1ALo/VRj+0Sp4ER2jRz+TCg+gtbt31BslMOKsqyqgTqR2a1k
         36Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727432339; x=1728037139;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOSzFI+pEqNKt4UIfbSyDUAWZOX+zl+0pdlojvj0Fqg=;
        b=iVIO5Qte8KefcdZDPP9nnowCmlzbZui0sq+0dIXmzDUKIqkIf1iauw+K+iu06Q1t8L
         9jTlDJjI5xOcHfGXh5Lyf/V4lzjRD+H4TXyB5pLZkR6C1JAZVobTWU/ozNHSjGvtv/Ad
         uZZwHwqPOfi9UdFYQaHvo7lQmHQrqw8Ghm0q/be1K/HuKqsL4yO7M6wxET2aBfBxLu8b
         Rn/wyggfB4GMuAUTbxvzpObDlYrKyEKULIzuy7OtUu/zqHnnRqmtGRZJFLSSrA4PAjP3
         EWzkZpsqAloSnZvEToRdTb+zUm+2p8ITpbAjG9zvAJ5SLqiA5+fvRziKse7r5zBFqNeB
         F6Yg==
X-Gm-Message-State: AOJu0YwFedjmHMq3jplLTwxoSUnnbeR6UYtlLp3uorpGhcVVfwqP2/ze
	DHmKMfWQwSQt/YD8Bno9cvASCbrDu2G6nJWD4XDalWQaw6nHbUnmICpJ1UZD6+3XiPzOmTyQbAC
	qEak=
X-Google-Smtp-Source: AGHT+IGRNYfSh0EvSEVRpbouFCYJ2obNn54PJmXRYPcqLgxrYKqKnLWE1T8lVDdiYFXrcmOtR8Xk+Q==
X-Received: by 2002:a17:90b:300b:b0:2d8:999a:bc37 with SMTP id 98e67ed59e1d1-2e091255254mr9194028a91.19.1727432338678;
        Fri, 27 Sep 2024 03:18:58 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e0b6c7729fsm1666729a91.22.2024.09.27.03.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 03:18:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
In-Reply-To: <20240926225411.13754-1-minwoo.im.dev@gmail.com>
References: <20240926225411.13754-1-minwoo.im.dev@gmail.com>
Subject: Re: [PATCH] HOWTO: update 'verify_mode' for io_uring_cmd
Message-Id: <172743233767.34160.4140518276930897963.b4-ty@kernel.dk>
Date: Fri, 27 Sep 2024 04:18:57 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Fri, 27 Sep 2024 07:54:11 +0900, Minwoo Im wrote:
> 'verify_mode' option has been added by Commit 6170d92a61da
> ("io_uring: Support Compare command for verification").  Added
> description for this option.
> 
> 

Applied, thanks!

[1/1] HOWTO: update 'verify_mode' for io_uring_cmd
      commit: aa665180df233e10ed9a616702d881448d81651b

Best regards,
-- 
Jens Axboe



