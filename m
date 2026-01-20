Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABEA362142
	for <fio@vger.kernel.org>; Tue, 20 Jan 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929387; cv=none; b=Q4MoyosOQXuykKkx/p6utShcjXUux+F0ixEWfUPgIp858mJUK4Z0QDPmFg2Pz+VAlFZPtMx5p/YOTKvYPHYzSkP2gXcyD2Sd57pXxSNW6j1IrEUh2pJjWhci3tRkAcpVzoKHuW5KCce78dR6iS5UgqbAbchqbof4Htk1FtUUdPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929387; c=relaxed/simple;
	bh=zXx1phCPnfy13NKaQ7N4Ujnb9A5S6zYGy9lP4e1lyNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hmxvg9KvvfPJIm1OY8wpKDHzpYaqrqKInx9+4c5rqfbOmAeg3gMcmyRcRMFeKm7PM5SQ0UFh2iQlM5lFtvpz5dqpK4ryWONijWK2EqMQiCh5EvZsnT0xxpshspEQNPVY2tljV+l/bpA0ZwfFwJdcweGu0o0T+22K0zuTwKcjtTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZI69CYf4; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZI69CYf4"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7cfccba483eso1797529a34.0
        for <fio@vger.kernel.org>; Tue, 20 Jan 2026 09:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768929382; x=1769534182; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YHfw7NvC3qyrYBKHk4WQ+arwy7r+C0HFpDPYfT6lC9c=;
        b=ZI69CYf4bewMmo6FGq8yAbP83APZjURcTuQbCYpwa+lrSJQprpBKKtat4+wTFAaj3I
         6KwkXp7UegI3lBXzcqOdz2B9a+VV3kFi9QhiYLBcP+7DkM2tFD/XLd41qHiY84XwcFby
         HuvR1Wro18K/RSmJa+eC172O9HBWPkzE96LHM3JkwrwhzFvV5ypVvYXnXO1kvkAhcpZQ
         ZVC03XFN3yUEKG5yeLeVGetylw9F1SjIWBNjI9uOb0TkQxewOLS7UoYEwu2VJy+dvsl7
         eALIF3gxcChc9zO2C0HekqSpZO9dus+qkSDCqP9E5yALg4xDpuyLYIXnqYAmuuHAJwKI
         Hwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768929382; x=1769534182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YHfw7NvC3qyrYBKHk4WQ+arwy7r+C0HFpDPYfT6lC9c=;
        b=XyP1AyOwtCP1eFL4JPB/93I+v/t/e1I8Rv+OPRp0QrBf0GusPW1W1FF+6+bhflZPjw
         HMNXNQTtUMONM7Xy/GqgW0AgFLHOd54san10ZlWueHNZywOWtJ9fwpwxAE5/C1JEktFh
         8IaCxn+ZJP0WMXpKYbh1pWCRJri9suwpOzWIIWhMQLOsEvbKkMrisWgSli9Lm7589Pgj
         /23CZdqTC68HK7dl9TsbLp7WECfLRN0D4Ja156RAN7scuWeLS1pATt5QrgQDzXfDc03C
         HunPsRzU2I0SAWPlbd3sVk6OBEQMisrziHD/OqEPyacBilaGH9k4WSjxt0L195fAUzkc
         9RnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHKaKntizQ1a7y2MkYDqKn98qKTUgtCTcmpVsZZMz/Aqgo5tb4nnaQ0eYcA+GMJPQdPeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXO/jkkSTb7oiF4thCBTWeBjRae0Q8ncW5ydq31As447O81uFG
	+YHSJpPAetoMwwCOwwX6aNGC/vrXUAI58xdIz7/4QiDLCSYrmn6ZwFHT1S5FVqFNpdBEtpy+pZS
	7kd9vVaY=
X-Gm-Gg: AY/fxX5i0IPwIvcfqIBzHmaq7kqOx7aBsio4wbN+I6rbmS2j1mAVpPGfmaYM7j6r91Z
	toz7l9u+VMFmZxEy1DbwOCR/azBzEEe82LIt4zAXwPOqUeqDkHCKR6jLS+sENhGyjBXIajTlUba
	E80fNVP76zaLD4LSKpGqGtLZ5yg2UjG9/QYdPYPrEqRdE4+uH3YsihQ3qSbJNnY5XZ9FzFp2/h5
	m78TGCLVbgmcu3mQZMhjsJBgHmcGr/t39u+iUdAki9JPf2gHv/kucUDVPqQRPtyEEtNXMf8YD+Z
	m2iKO6Krl4ArvdXWllUHlVHdlZmq+srbLf9d+/CQJ7Us21jLPRDkF+CZd+jHe+Fl7ppYq6gLr4+
	2sHu1NExEVRAD8JeN5uHqPioJZXkXX8dz0iBVnUWNa17/MU6X4ZZZXemo+y9eIjham1I+QpJt1V
	L0RPASANYFgV+XLXL4KjqgRNd4aZKL6Hw/o48Ke4Oc8PGnpiuhDzOcbsd/7ekv+Vd7Sfog
X-Received: by 2002:a05:6830:370e:b0:7c5:31b6:435c with SMTP id 46e09a7af769-7cfdee919a7mr6375035a34.29.1768929382443;
        Tue, 20 Jan 2026 09:16:22 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0d915dsm8714778a34.4.2026.01.20.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 09:16:21 -0800 (PST)
Message-ID: <182c42a6-ae80-4288-a3fa-dfa2014ad56a@kernel.dk>
Date: Tue, 20 Jan 2026 10:16:20 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fio: Add ZBD support to io_uring engines
To: Vishal Jose Mannanal <vishaljm@dropbox.com>, fio@vger.kernel.org
Cc: Eric Shobe <shobe@dropbox.com>
References: <CAOUciekiQpCBKAkAmnNF_3P_tJyL0uTGZdpq8eYY1V0Obrm8mA@mail.gmail.com>
 <CAOUcie=b9ZegmFFa0XKubpXyVwCXMYSO9fup25tQ=CHRbSX4dA@mail.gmail.com>
 <CAOUciekYyR6eenpEgzrt2siFXmSbqn4GhSRVvsNA_jWdSxAf+A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOUciekYyR6eenpEgzrt2siFXmSbqn4GhSRVvsNA_jWdSxAf+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/20/26 9:28 AM, Vishal Jose Mannanal wrote:
> Hi Jens et al.,
> 
> Can we go ahead and approve and merge the following PR:
> https://github.com/axboe/fio/pull/2035
> <https://github.com/axboe/fio/pull/2035> ?

No merged.

> Meanwhile, I will work on posting the liburing-zbd changes upstream
> and adding examples in liburing after that. This will take some time.

Sounds good!

-- 
Jens Axboe
