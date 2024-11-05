Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7502383
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 21:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730842367; cv=none; b=r16DLDBypChv6wrR6sMEWZZeXlU1P0NRYG3EvVNSDXsj1lAsB+rU3yBGVMP7KmimJPIgkt2ifjO0w6Vprg/ZlTJQumFijeVeOD1jILMmNMTob3m5WIeLTvurX+8Cpg0IVbDKCSzfYDsN95EQ/FnSFT6QhmZsO5voFCP3bBMdx6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730842367; c=relaxed/simple;
	bh=Vl4kVuDHEWAr5kLs+duiJaQAbS4v48GofXLIqLGpWV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tkmArmdxwEnISDTZpVzvMMmx5sBv1iuYoo1Fb+XReP8B3fA1qH+DXgYMn1FOjENcf5w52H+IO2eo5syYvn3N1ih1U6eBx78LKM+Pz1/iOyf+UWusRQvn0Q3rIiifQb/R3WTDr/fqtQNTLlIq1Kkdq9yexStQzvyZPXl2VH/ENTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=guscgwmk; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="guscgwmk"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6cc250bbc9eso45044906d6.2
        for <fio@vger.kernel.org>; Tue, 05 Nov 2024 13:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730842364; x=1731447164; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hqDeEXLwEkIf2KBuZjUym30rQp77SQMtKR383rRcfMw=;
        b=guscgwmkzkyP9BqaWpxP3mz7KU11O6pyKNRgd6hh6u12Fss9iAgybal64Odoq9V+3x
         kbB2jhNFkHPvP0s1H7gXgn+dHp+8p4Wl2dDQyhAT0kyep3zSxhz11loRcYarDC2dB6E+
         mre4YYy6CPBcTpJpjt1Y1xjdkvTvg5mYnggmZgMCuJdcckjfkQkGZzWX7kojf+5Mt3np
         4FX8uVETw1r90IJP0sRrNaFbhNtHgMZCUpdjTs4mbQoWQB8jXXqgs9Yua1I9s6D+h6ph
         JeZuP78yVjOCiodrm9eSqm36AC+QhZSsD7lGYGqqNcsebsgj21nx/XDq1UmR3uVUaswP
         0S3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730842364; x=1731447164;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hqDeEXLwEkIf2KBuZjUym30rQp77SQMtKR383rRcfMw=;
        b=Sg7947/wgx0hIndC6l2fNH1+7z+7o6OsqG7NHNgU4rrutQ2lleKc5uKCkPEfMZMIsO
         U5IwEwVEQ0J62HVR0/LJmSaOGoj3CERI9mfXZZfSwZ/bQJS65Zu3QLUKjtPB0NNHHFSJ
         53SeHlpQOQl/eHajq+pCjB3qfKpgGrpYGRXK2UZ3SD9Axbhy2Au3VCkYlbCrZoyO1kk+
         JXIFvRL895t+S1ApZUngCWa3ooJwaguUO2JvBCyVpN9RIcHzhpFUaGeBhB4Hn1wgkUaa
         NsmTUNh9y4V1ZtSxp3vfyOBaP+xBDTVWv+rCBO39FcY1R5duP62KQbAevkQ8IJwJ2cNX
         j5Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUpS8NqwVwcAy0qTnoVf1sK3sVAJ6xk5xzMbndboj8fwKa9Ebpnq8gx2oXvh6PJFczA+/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMu/Q0kNj8Of+rl9JrYENPQSg303z67Q3Q/6npN13pMMV6L/Yu
	p9U6LYLUWixs9F6WAeNPTe7RSKxvjSaE/Cr6dQb9Z6mSI2pX9cDP
X-Google-Smtp-Source: AGHT+IE2vnXDAvMNaW7lfXY6JJlykJTDXoyTl9axeoV8teIpuPqQlBuRPOVJwugHuDaU3t4Fr/iJ3A==
X-Received: by 2002:a05:6214:419a:b0:6cd:5ff4:cb1f with SMTP id 6a1803df08f44-6d351a92c11mr239415886d6.3.1730842364347;
        Tue, 05 Nov 2024 13:32:44 -0800 (PST)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d353fe76ffsm64249196d6.61.2024.11.05.13.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 13:32:43 -0800 (PST)
Message-ID: <c59db85a-2106-4c54-b5a9-808c916f7f5a@gmail.com>
Date: Tue, 5 Nov 2024 16:32:42 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: blog post on fio write zeroes performance
To: "Terekhov, Mikhail" <Mikhail.Terekhov@dell.com>,
 Adam Horshack <horshack@live.com>, "fio@vger.kernel.org"
 <fio@vger.kernel.org>
References: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
 <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
 <422c7d4a-5b9b-48d5-adf7-355947d18014@gmail.com>
 <IA1PR19MB6449DFD774C96F404487D5E4E5522@IA1PR19MB6449.namprd19.prod.outlook.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <IA1PR19MB6449DFD774C96F404487D5E4E5522@IA1PR19MB6449.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 15:45, Terekhov, Mikhail wrote:
> 
> Internal Use - Confidential
>> From: Vincent Fu <vincentfu@gmail.com>
>> Sent: Tuesday, November 5, 2024 3:37 PM
>> To: Adam Horshack <horshack@live.com>; fio@vger.kernel.org
>> Subject: Re: blog post on fio write zeroes performance
>>
>>
>> When we added write zeroes support for the io_uring_cmd ioengine it was not on
>> our mind that the default behavior for fio is to scramble buffers. Basically these
>> patches just changed the opcode from a regular write to write zeroes.
>>
>> You do have a good point that perhaps fio should be smart enough to avoid
>> touching the buffers when doing write zeroes.
>>
>> Thanks for the feedback!
>>
>> Vincent
> 
> Does it mean that in the regular case (not write zeroes) fio spends significant time scrambling buffers and IO performance is lower than it could be?
> 
> Regards,
> Mikhail

For regular writes on contemporary devices the time that fio spends 
scrambling buffers is small compared to the device response time.

However, if you want the absolute highest write performance or are 
really pushing the limits with a device, it might be worth running the 
job with zero_buffers or scramble_buffers=0 to see what difference it makes.

Vincent
