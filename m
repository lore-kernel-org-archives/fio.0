Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5424C5A4ED
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707921916; cv=none; b=G4LMPWaFgkUzA6KDppvh4mWM9OLiTYC3Trg5yxFSl+zcg4JfSBOnPUzAaP1HcFtZEzsanb8yBCoGLZrv8Wfyp8ri4j+tm7Z86+PRzhkc9cpEJSnz8xi03/5hV8hE6QC+4rXSG8LXmqR402FwStDf3MmoOtoK5U84uq/kweN6GVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707921916; c=relaxed/simple;
	bh=SWxrfPi9WpMWvYxMy+61EM5+1jVJu3QpXiLyC65Se5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OnS4ZBZFEZXjvio0f2bEMzUGp1pp862fvo8dNttkr4R5Ad96hyU43DyQNYtDahrNW1jnPwwXTwCC13Aq2mZsxlDBFotdKglZDmwWnFnNn+Dm/ttF3LFXmqri5YkDoEQK19gwZO4S+asUpPvs+8wDcMfFJOpQRPcmzPMn/RwW1js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BvHlRfWi; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BvHlRfWi"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-363d6b409b1so3221855ab.1
        for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707921912; x=1708526712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G5iyNCJqrR39KBiGelURIc/GLpwm9clof9Z6eky6zUU=;
        b=BvHlRfWijll5ijs0Tg4Ys13wiuDM2W2gGQjhnAcu0Jy4eSfhPZH7rUjP8ypUyAATxT
         8GFCj8JoQGD4NtT0fTNUkAihT2jiz3MvQrH3+RBtkui0RuQJUIPbCYTCCNQ4qaIhXveN
         hcnYQfCjaNYmK0FjiYvzBItL/o1hCer45UUuhbgZPt1M2ysKuw5QvxKmirPnGVk21PYg
         0vsnHPZaOudZ5aTWcc69rl+JMzgu4aRcpjtdoT39qEFjcFXqOuXJzYhgll/b1POVJFGx
         d2YDSBZtnOCa/VX1OntCGlOp3oQ5SNHIF8rPpR9wXhizpLdZKr5uj4LSSHGqkXoxLZY0
         B7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707921912; x=1708526712;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5iyNCJqrR39KBiGelURIc/GLpwm9clof9Z6eky6zUU=;
        b=gg+r3HbPT1hADKnQY6VOpTVRc1dEvHzcJsjfMOB+A8Zm4QXaclJi2LLKpjHbZOL0I/
         TW3sP2C5+Gp02oVSSY0JBvXhDtswetkNWUMHoo4Wx1zEwPiXunaQMhvX4ruDgeC0RaY6
         WRdaaWESEKRRFJs1mPbTN61IvvX3Hhasl79LytnBGItSRHKxJTbR8rDWNyY9fF6k0/MH
         oafhw9xi4c9rESnEo5kNJPO701ps3LSrvNN4FQKiZclV5Vl+Erviy5J4k6Sa9ymlH0b2
         NcAhtcn0+Tz/SzAui4+/QK5m7rsOb5siBY6ZjoG2KnWQVErSOrNeX1xFlpRWUgYGVmxH
         ZhTg==
X-Gm-Message-State: AOJu0YxJn3pOEsfPUeKxsQe1XHtW/TwmT6OXoDhYtPAVj74pzEY9oyLM
	3+PDFpcVK42P2s/9G/jI9XfqyMo7ZhEjuuJtaeE4qsa6DWImcTihRYQdS4qo/4A=
X-Google-Smtp-Source: AGHT+IEkwYpqgwTr167riXBOOj2fluFxabFlHA9KWSwsiO3C9Vx23o9LzblofcU1q8yVfXgZHhLeig==
X-Received: by 2002:a05:6e02:1ca7:b0:363:d7d2:1ddb with SMTP id x7-20020a056e021ca700b00363d7d21ddbmr2665333ill.0.1707921912366;
        Wed, 14 Feb 2024 06:45:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWOU4LZMpKPwBh1NJ4spgD/bG8pwq6JzaxbPOqYzsAwmSF+if8lM2ZPbf2pO1efFa+pZWE8ovG+Vt3QEMBNBqThi2CVRqyaZ5tkzTTSg5bPOS0OusUnxax1
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t9-20020a92cc49000000b003642c859d28sm480617ilq.79.2024.02.14.06.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 06:45:11 -0800 (PST)
Message-ID: <e22fc6a1-609f-4005-8f16-0c18687917f2@kernel.dk>
Date: Wed, 14 Feb 2024 07:45:11 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] engines/io_uring: add multi range dsm support
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
 <CGME20240214064927epcas5p468b8554a7555bb666a0147df11db9d28@epcas5p4.samsung.com>
 <20240214120624.135416-4-ankit.kumar@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240214120624.135416-4-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/24 5:06 AM, Ankit Kumar wrote:
> Update the io_uring_cmd ioengine to support multiple ranges for trim.
> This includes allocating buffer for multiple ranges, and changes to
> the nvme trim helper functions.
> Add an example on how to use multi range trim.

Looks good.

-- 
Jens Axboe

