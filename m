Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdrmW79u"
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275E3199
	for <fio@vger.kernel.org>; Wed, 22 Nov 2023 12:44:20 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6d645cfd238so122269a34.2
        for <fio@vger.kernel.org>; Wed, 22 Nov 2023 12:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700685859; x=1701290659; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQHOKfB+FlfyWaPa5qiHyvCOfdtdafIb49xfandnUeY=;
        b=WdrmW79uUYqUxdMdnQazDPU2/PDm+/rICB9UCO6o/u2aitrrjUt7QQHVKeEuwHrZ6U
         L/HzB9Yis/tmS0mi7psj/hPnbz1d2OjVvXJHkvWwIbuTUorH0lnderPNa/d1AcCdVnKA
         4Vy2x0vEqIr16BwsZ7+q3tC6uQCL0u4EjBGaKyLAwx4bFw6q1U5veyLs1U5V/k+4fQ62
         /1LFZxsnsY8DerHPJBBQ/4KzuRlNMMG8UBb5Tw9KGu4d0gNIYDkYaj/w+8D1h0Ra9syu
         ycZFFfeJ4FBhv6AqIemHzH2hrAiaZcXdDwSxvJqUHm1xXwcF/Idub74McmlLBniE64yJ
         OY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700685859; x=1701290659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQHOKfB+FlfyWaPa5qiHyvCOfdtdafIb49xfandnUeY=;
        b=UYfEHZ5mX/TQB0J/bCpMCrATgsV/6bHGl/hRg2ZxjIqeWQqLcVxu9BRjxiOF27WAIn
         m9hAFC32hrmUePj4VCo5fHomPjWP/WYGg3ueFS7gOSU2+48DIhyqrj40USHbUxqMJhmB
         wqGykivdy+CuWqxBHwTBPaYzYgq0SNpMUam2AJXy0RT/Cjc5eDwXx78RGzxla7pUmxDG
         uEEqP4nt8Pjw9XZhshX9piYZdvVeO8JLr5jNRuwNykFOfuRZAXXDx46JUY9563HRIJIv
         rlbYBy4/ZHybwWzrVkDbASV9PPWcQ3UDroRzVXgAtwI0u2a2opHEuyKFFa93qTl2IpQy
         sFvg==
X-Gm-Message-State: AOJu0YzB7h6d8e0ji7LaXGL18NQicPQ2RdSHgcCqX4ud5MMfUHE5Iy77
	mDBctr5Y6MoI6pEL+b0ei2mGOcFqK0g=
X-Google-Smtp-Source: AGHT+IHkAEKL2BSYXw4lUpsw9Dh1wJ9YCGdEhJGLGbBoFanbyD/EhRL9w+3hhhn8fk4ojSo1mKRX2w==
X-Received: by 2002:a05:6870:d109:b0:1f9:906c:310f with SMTP id e9-20020a056870d10900b001f9906c310fmr3220641oac.47.1700685859282;
        Wed, 22 Nov 2023 12:44:19 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id x9-20020ac87309000000b0041ea59e639bsm95271qto.70.2023.11.22.12.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 12:44:18 -0800 (PST)
Message-ID: <50406836-9def-4c2b-8a73-ff4d682562e7@gmail.com>
Date: Wed, 22 Nov 2023 15:44:17 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to perform an random read test, with normal distribution
To: bartoszek@dx.net.pl, fio@vger.kernel.org
References: <4c92fe6a414a472aaec12b04eae3ffba@dx.net.pl>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <4c92fe6a414a472aaec12b04eae3ffba@dx.net.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/23 03:29, bartoszek@dx.net.pl wrote:
> Hi!
> 
> I Want to perform a test scenario
> 
> I have a "huge" file in which I want to read out blocks of data randomly 
> with some distribution. For example 20% od blocks in test file will get 
> ~80% od total IO from the engine.
> 
> Placement of blocks within the file is not important
> The only requirement is that some blocks are read out more frequently 
> then others, and the distribution of reads is defined by some parameters
> 
> Test should simulate a VM image reads during VM startup (or runtime) 
> where not all files are used, and some are used more often then others.
> 
> Is there a way to test such scenario using fio?
> 
> Best regards,
> Bartosz Wieczorek
> 

Fio has a random_distribution option that should meet your needs. Take a 
look at the documentation:

https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution

Vincent
