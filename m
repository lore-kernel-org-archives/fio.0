Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0332ED4D
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012169; cv=none; b=N/lA8geLRpfhLQuJy60/pUybDEGDkCM6BCRNxBYbeoJca6LpyIqjE0ktN6jCoep2fEYz37HBp2Bt6Ea6Ia88K5XUuybBUi0hf1FEO0VGR9aBbSyJL6IXehJSMOX1HDQyQQwm3WEUlyt4wK4zkyCUUFvx3uA4BQlmrR8GZwPzx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012169; c=relaxed/simple;
	bh=HnY+tTA3ulZTj3b+xPhE9QVEeIyNr09AQFAUvLzzuBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1SEaicdEeNsnRaTVJ6onbjWjhipH2ZPk51qYCFD5G6bR3zNGH49302yBbQb9riLA4QhT7+iyHDASbQ3zjenFzBngfNp/yGOsfh5Aalylt+HUSHv76BuEpbS0R09atS8co/g4ijmj4CfHlpbQNhyZhTRoIFKe72BWq+l1mfpwiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WW94Ln1F; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WW94Ln1F"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c730af8d69so3833881a34.1
        for <fio@vger.kernel.org>; Wed, 17 Dec 2025 14:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766012163; x=1766616963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oi+KRlyHlLISNmaW0WYUXl1udSqcMiATTI4RzzPtbJQ=;
        b=WW94Ln1FgROpOBrTe48pcLgYQiXJVP4VyswCWTFHlxzyQcnuVLT0LU4+KtCI5rOdRE
         O2YTSYHp4H23lB1V4h4XOxR6eTinZof+MaO9Qg0mCmWupYmi3+P8DG4J3kY50GgroY3J
         58ndtQFUa89raVoXG+T2qdwJcvRmblDRGD4jYpaECzex1KWk+pQti7gN6OaATPFnk6rM
         1Yv9zZASEe+I1mfUog7ErlBIzv17Zsf0a+33rUdPq7Dk3jzU7OG5IPOURP4fTk7F/sQY
         H6G97y6dTjq/Yj8Nz8b/v/jJV7fNVmgiwwAlk0NpnLgKqV5+vOsaRWGEaog0bES8KV2N
         e3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766012163; x=1766616963;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oi+KRlyHlLISNmaW0WYUXl1udSqcMiATTI4RzzPtbJQ=;
        b=b/DQVaLGFaSWOLxSLS0/mkMk8Hrh+IMB/YMRlgf4nd64/1lFVhTxxNynz0ySssYfd1
         oPUZgPc04Fo+3sCGG+uARAMKAhUhTk2tyNUp0aVACw9K/bRsBrhiUqMxEpjKD3S4+/zV
         pp3BGThHbATMdQPH4sh34uQMfmzU1T6Xbotk/oIDw2+seaEK9G6Gdxtj714G5Se6zLm1
         6dU3MyHUbFO3Hjg+2+j7CB/yPvlHml/u3lbxT75ZlYf61ivRRvr85GEc3syAQ023k3pM
         A/uYVbKvqWr/p2kQUOclMRtVUYMcRL7HcH3hhi4YWbGsfoB0bYgfh9CeKZCobyjzyK9t
         zLsw==
X-Forwarded-Encrypted: i=1; AJvYcCXq4GQPtxU2I30PKlv5R8XMiEvk388Sq76nL37NYC5zki4F+sAlCHQzWqZjqKjzc4rxpmk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr7TQvkgnE5FkoN6EZ3h1Gwu0AKESmfoZQXbiNEQFVILMoYOS3
	qhHnm+s5rsUkV8SFB04eoi9z1pyf4gSp7vGzgUHTzoyro6TX0B9ZVmvfzWpGCfXTRF4=
X-Gm-Gg: AY/fxX515dpW4S9c1jBkWzujFyOVSF1gw2RaJOHFKaz3pNC2IABWgpEjB3ytGmn0l1X
	B3jhP6RWXZlMau79JqTCHY3Msj2d2mGKVBO3iX/nOEVhMc2Jm41+CD58u5j4s2NoBqfSbfXkyoU
	t79JhVLMf+s306BCNN2kdrqIrvCJxxY5jTXOF+icwTtUqNJ6iV/AF2lmMKbgik2z0wla8CejDN7
	chgT/24OCPDkhV1P3IK2ofwn+T1EEqEdYT462YPkgnq4ElAKtYrcYF+ekxPAaunCCm7t7p6UUSM
	9h6ILkg3rf/Dg47SGEHKm1eU8Y5nXiCUlsyTA+CUUbCBxI+lUI6XhLnLuKBlA/bAQ0dXOz5olO+
	1RmG+qc48i9EW5lzOeq1x5lCl19Y9vsawHuwXo3+5SrLMARL5NByGgWnQApsiLVcQOO9dNud7ev
	2Que9vV5O0
X-Google-Smtp-Source: AGHT+IGIiQxqQiVK97ixe3ApVqJpV9K5bVhP3WsFgB7JNnnBpGXQxFhGaFOAMIThwb1mKP7GKWjeHQ==
X-Received: by 2002:a05:6830:4414:b0:7c7:2c63:f2d6 with SMTP id 46e09a7af769-7cae82e39d6mr10915692a34.11.1766012163301;
        Wed, 17 Dec 2025 14:56:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc59a9a905sm477670a34.13.2025.12.17.14.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 14:56:02 -0800 (PST)
Message-ID: <be8e2e1b-a77e-4985-b283-9b22fe87144a@kernel.dk>
Date: Wed, 17 Dec 2025 15:56:00 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251217161722.6357-5-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/25 9:17 AM, Jan Kara wrote:
> In some cases the ramp up period is not easy to define by amount of
> time. This is for example a case of buffered writes measurement where we
> want to start measuring only once dirty throttling kicks in. The time
> until dirty throttling kicks in depends on dirty limit (easy to figure
> out) and speed of writes to the page cache (difficult to know in
> advance). Add option ramp_size which determines the ramp up period by
> the amount of IO written (either by each job or by each group when group
> reporting is enabled).

Looks fine, but needs cconv additions and bumping of the server version
number or this won't work on client/server configurations.

-- 
Jens Axboe

