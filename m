Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EC115A853
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727372028; cv=none; b=ex14s9FkZpbmx/DMS9GZHmIgCizUVQ/oDThLxtpJcR//rjfKo+nxzLoqgJT5XPFJC+DSQETubVjMQkL7dl+CAy2gZoNpMvQlb1pSZRJQtj7LIn8LEWNANmQKjLcMUxOyzWCsJgvef7mZ+Rfr/S3ozM668h0+1cqrdjg9ZRfA11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727372028; c=relaxed/simple;
	bh=Y19RMdDDekSISXyG6e+wVD1hNSMlszLxx4J2Ud6VmyI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZQrEPP+8ckPBmQj19N7f3Wti5bcHAkAELVf4O/97IlSkiHSO+rDr4GOf9Q2tn/hQmZuR0ODRO2HAT2nuC+aYB3QlKeYw57s4MbQVbRwhhsgfEXtrsBOMuyr414urDcotoY9zQcZgEY8MysFztbnyYgZDPnYCPW/4+AIRlJ90YRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lmG0Vty/; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lmG0Vty/"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82ce1cd2026so43795039f.3
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 10:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727372025; x=1727976825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfBZKk8d4/LDezOJyCa2hGUUdc1tJukd4ugkg3sDgEE=;
        b=lmG0Vty/sDB/geAQ9524DWqxPwkfV2pmSjOW6psqm/nAVuAfc9jB3KC+/HUdYuqo4C
         71g+lxvBf+aKq5m1kIYyG85z9WWFn9CgNLuLOZRNi9+70hivoD3KNMgsmWkwkafueHVj
         oQSfNzgonImVwztf63Ix29FtHzCjyXA4q2tEzNGsBmwDZMapWqOVnKknl2n94hL8Fl/r
         mVFW1x9MJLKgr6l+0xT1xeN+8c6tpvkB/oLvZU9jMlOph1Sw3HU/ZAXH+PrWQ1sWixTJ
         2nMcnew/RT+Dz4TK8CgJ3jffrdb0Tr62EqQoi+nkhrolWDTZTOpCLUlPJf+x0jm7xQfa
         ZQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727372025; x=1727976825;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfBZKk8d4/LDezOJyCa2hGUUdc1tJukd4ugkg3sDgEE=;
        b=ivjmftC5zwXIu+Rnp/Lmocz6vvRMXmXbNlrBgEL0IXNTXze5vdHNgEaLQB4JFg3Z2g
         YcgV0rvzyszsn47uBgZGYfH6DS3mLAFQHKmfSh0y7Gqvb711Xf4h8ZaxPlDIQONGCIIL
         DrN97AMmuE2KaWsDCrp+c3vyI1CBhvlkzbfwDuWgK1o3XPu7iHDjCPyS5FOu4feAG7oM
         BlDgOD8t/ZKvqHImyb9cD1SnhEqYYFsdY9AolTLDijIaxwa7Gg85HSKGls1SE/VynFUD
         wnseZq3+QuYUP0XfXWwJxybHGf8+Y95zFC2Sl0TFOFnjJ9Yj8q6nzJa28ihKWvwLv68U
         TP5g==
X-Gm-Message-State: AOJu0YynBnX+VBLohgRQ8vgIj78L4mFHJNThj/8NBHZA23eNnVbINYHN
	PqzVUphzoQxL74g2C67IXt9MJqC00TcIjyqUwosow9uiv84n6mWTT/7X+UTyS/g=
X-Google-Smtp-Source: AGHT+IEgdpS2CrtUgQxyBaaAtiRSYnC3AoSbZsQUyeZKUgwj44Rt/8yzPgFvD6xGrDjnCPANfSvrGw==
X-Received: by 2002:a92:c266:0:b0:3a1:a57a:40a1 with SMTP id e9e14a558f8ab-3a34515565emr2086255ab.5.1727372024640;
        Thu, 26 Sep 2024 10:33:44 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.128.115])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344df41fcsm404545ab.86.2024.09.26.10.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 10:33:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
In-Reply-To: <20240926010802.27131-1-minwoo.im.dev@gmail.com>
References: <20240926010802.27131-1-minwoo.im.dev@gmail.com>
Subject: Re: [PATCH] io_uring: Support Compare command for verification
Message-Id: <172737201719.348564.14635465598691361511.b4-ty@kernel.dk>
Date: Thu, 26 Sep 2024 11:33:37 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Thu, 26 Sep 2024 10:08:02 +0900, Minwoo Im wrote:
> Added 'verify_mode' option to io_uiring_cmd with --cmd_type=nvme to
> support data compare verification with Compare commands rather than Read
> commands.  This patch newly added IO_U_F_VER_IN_DEV io_u flag to
> represent that verification should be done in device side, not the host
> side to skip the actual verification phase in verify_io_u().
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: Support Compare command for verification
      commit: 6170d92a61da1a0e196352cc68888168c931edcd

Best regards,
-- 
Jens Axboe



