Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17D23161B8
	for <fio@vger.kernel.org>; Wed, 17 Sep 2025 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115217; cv=none; b=VKAUmRdGOkDA9HbLPKc0J3MC8bOVwgBqtZsexpUfhpQTJxF1fKsKHtOiy6a+UuLBLe7/dcVG6YV1HWgJ3k1uPj4GFb0XuQ/tmwuzGJxnhRrGARB9BqiZZVKAZ1D7lHCpS8pzqU/mV7xonYM60gb6g1vLFCFLi4QAcrST1Z51Ibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115217; c=relaxed/simple;
	bh=X3jpTaX3GIxW3MPL2CGKgvgbbmDAokJF387lvI1F7Zo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jhjkxIZ2j1KwwKpnHVVQyCOBwxMGk2rYbhYebVWhk8QEoVskmIAuoq+W1Sn4Cxy5u8C9IjRGftc/+LkZs5NdUeENoA50mqVyW9Mr3pOEo9wDdPXDbaRALRQHk1wj/7+DSsuRecwbeMQEmi2OY9SEsWUeYyzzz4tWRNbX97R1/LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lavQoNzb; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lavQoNzb"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4240111d446so39953105ab.3
        for <fio@vger.kernel.org>; Wed, 17 Sep 2025 06:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758115211; x=1758720011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOs6npMIJLRxGsoOmozW68z5Yujnp5NW0/HA358XBKE=;
        b=lavQoNzbr6APh8+k8g4jY+eCjxInG10jpGHdG01wB2OY9VV/j9h5sGbLIDNjieZQ6c
         0z3KHQ6in11naOJN/kfwE/K/ePrsXycwDd1FIx+WEJiMQf2ee2SqEUuZkXtCTpW5qBpq
         5wvtWiFm5+8RINFRnTO4QasHJNbBSXqxQ+eA+6K/fMMccAzCBp+JJfou+b1iO+p2LoRH
         XIDa6kthnM3NcXC5GogKdW1VHL7ufeShzm7rZV5MuNCVe6/pfuKFsp3z1/anpNQBeYky
         At/SM3KIKF75qK92xYN95BRxU8LyIOQvZDAKVt9KeSwjzM5u7x+Hh/uh+d3Gv80Qm0hm
         zCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758115211; x=1758720011;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOs6npMIJLRxGsoOmozW68z5Yujnp5NW0/HA358XBKE=;
        b=rnu3/V1ETucNQ2Aw8KGboOsF97p8OILincyRE313uiqJ8Gaj0GYUrT5fdHJlqkqWCJ
         wKyfwKPmG60DKwWRFASP4YOvwHrk4wuvd0+wDUfNzuebA4kSxnhVy1Q30UvsHNWCbAD1
         BsQsDmmiMKvhXococUIJ7WBRd5S9mAZyO5+4DriA22vP1N9liTxXyefbGxHJI3gMByLs
         MrSFdUCBgbc9I3sMSe+BvOcrrysqdTtKjYNLx1bRxmBu4LqktHWEnliYYEl++tWO8aEc
         JdhuxPFAcUL4gf+h9mHJ4wHz5UYuicNflo4N3/b3vivr2VYR7qoLTBKiUqzW0WNsIt9g
         wpLQ==
X-Gm-Message-State: AOJu0YzZ/EQggDDM/2t/nInC76vQ2gwfGuF6z2MrqJxBNxHAf11cBR0h
	mT4SI4Va8ERzXbBk7wg0uf9/tsaHpSopdw1Zcx7kBq9yCAHjtjvPADtC3XGYyzfkJS4=
X-Gm-Gg: ASbGnculg/mNCQH2fPdZxuCh5UOqGz6i+LSzqzC6RovsFhlAMfhXLR9qpr/4KgqciQ/
	byBRC/KVoLJ50v2rsTD+yIqtV5AyeWRDqXgF/EYa4YOTMM3KlWbTQjDOBl6aIk2RrtABzfiNyI+
	9E2yO3WPW9Z8tb5YJMqXn5/4mFhOYOz0UHrNL4wyfmDEF2a7MfZfFIMH+cxhZU2oA12bP60iL93
	PWY2Z3NTFOoScnDzS5XeosieAhAf9L7imM/mNw9GyQw/y2880RnaN2GXbwOlgMHt1m4/u8vBJEz
	7wZy5TcstLV00jFYSBMTEjDY89JRasMnjTL1hLpACf1Suzc/eC22DS+FHlfHK9QQTfD9UBNU4WY
	zWhAUntI9ps6DZg==
X-Google-Smtp-Source: AGHT+IF3yCmpwlrg2ZQqIAQK1ZMe3zCZvouL0ElcxKK5Y/YC66+ncYYGjCa9dAuoVmPkkd3Omfa9pg==
X-Received: by 2002:a92:cd8c:0:b0:424:2b1:409d with SMTP id e9e14a558f8ab-4241a537fc8mr24937265ab.28.1758115210494;
        Wed, 17 Sep 2025 06:20:10 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4237e5e3212sm61469805ab.44.2025.09.17.06.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 06:20:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, vincentfu@gmail.com, 
 Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, kun.dou@samsung.com, peiwei.li@samsung.com, 
 joshi.k@samsung.com, xue01.he@samsung.com
In-Reply-To: <20250917065838.6204-1-xiaobing.li@samsung.com>
References: <CGME20250917070310epcas5p37da73fbce2e0571548a0d840e20a445f@epcas5p3.samsung.com>
 <20250917065838.6204-1-xiaobing.li@samsung.com>
Subject: Re: [PATCH v2] t/io_uring: Vectored fixed buffer test support for
 nvme passthrough path
Message-Id: <175811520966.364972.15867321524808339056.b4-ty@kernel.dk>
Date: Wed, 17 Sep 2025 07:20:09 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 17 Sep 2025 06:58:38 +0000, Xiaobing Li wrote:
> The current kernel NVMe passthrough path already supports vectored IO
> when using fixed buffers, but fio has not yet adapted it. This patch
> aims to add a corresponding test interface in fio.
> 
> Test results:
> 
> taskset -c 1 t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -V1 -u1 -r4 /dev/ng1n1
> submitter=0, tid=6179, file=/dev/ng1n1, nfiles=1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=1, QD=64
> Engine=io_uring, sq_ring=64, cq_ring=64
> IOPS=289.78K, BW=141MiB/s, IOS/call=1/1
> IOPS=294.68K, BW=143MiB/s, IOS/call=1/1
> IOPS=295.26K, BW=144MiB/s, IOS/call=1/1
> Exiting on timeout
> Maximum IOPS=295.26K
> 
> [...]

Applied, thanks!

[1/1] t/io_uring: Vectored fixed buffer test support for nvme passthrough path
      commit: 80d72cb05a6c54ea1b256dcd69e3e4fdc9294f4f

Best regards,
-- 
Jens Axboe



