Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4D7E111
	for <fio@vger.kernel.org>; Wed,  7 Feb 2024 13:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707313468; cv=none; b=G2GxR8CX+UWVTn47DnKrTiuZbHv7Vaq7FxxmfJamgtmumnhOMp1B51oafPNMLClp7HaGG5GLrP282/dsPzLw2Po6sqbxksQJlLVNWELkCQZh8tSDjmA1QSDAhpOWg+G2amc0HFXFohNxbe5PUHt/llgBmmonKlOk+Fen6UhiSwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707313468; c=relaxed/simple;
	bh=R3LPlhupv6fw+lRbPpDbQT8wWek0LkwDUnxlcz/arqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dlhn+rcbL7gVOK6GrrJsnMrqFo2o1WYehScim53niXigFCCHZ1YkEwS5OwhgxDQTmWwNLL26GFUTasihlkoxo6XfZbVHKgb2kX+l2NuN2mWKsKCPO2nWM2FBc+KvZ/8r/kqq/3La7fZdfWnaTtW7BA2dyLc6rQx1NL1u79Bb+CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JISE5e7o; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JISE5e7o"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-68ca1db07ceso3108846d6.2
        for <fio@vger.kernel.org>; Wed, 07 Feb 2024 05:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707313463; x=1707918263; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5pYqbje8c4mGHyeniqLFzFc4mpGUlMjgXYT2HevUAck=;
        b=JISE5e7oZNYtE0+QOjLr6FhosEK2QZOaoVmDI16aU+JS1JX6hR/bes74RDIb9qF/1h
         SlEwRhDv+f3DXhXiTtgKQg4kmN2QuJBsJkeezjQO5nzIZ3pkHcXElBckGJ46aflAtkAB
         5eKqnusgSF/5gKKVl1T0vKUaIgaGmkaMJL3obiu2G/vbsdoVnd+7m3r4V0AYOJ/T56Gk
         8kVpl2vN9j1fRr4FeqmjnzL8f9v9jDIPCYHcKgEt10cTvvxFsB2rhVo8NmJM9B8rxm2g
         Tp7NTBxWulVbP4aW0cyqOQ0Bh/p+cE6Hkv+Kewj+KizbDpd8pXbgYM7kHxSN5AEHxmA/
         kxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707313463; x=1707918263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pYqbje8c4mGHyeniqLFzFc4mpGUlMjgXYT2HevUAck=;
        b=nvfJDT7QEZtnntcFN9At4BjDk0R3L4NDyVJizMIgTL8o9HZG10DqTBdcvQe0ubx010
         ZS+izrRNlpBoOYJStY9nN/WgZU5DOJgJALw5BOoq450DjmvzS0uE4mLSGqAhNsvAwwWJ
         B0mCX+XLcboQ5pHZ7Ltzm+Nx6vSbNBtTWeNOOIxPkf/u0RcSV8LuYvm8Z6zbVEWzGdoj
         sGlCtzisC1DJ91X100DTa3gW1sz/D3l3lxhut9ABoJAX3MyTkla31cZajO87sR1tXyW2
         qluyeVg3wHRKraHHg6JSR51ddrouDmzWNA/eipH7FmfeqKD1LMy6bS17AfNYWs1tR5LK
         lS5g==
X-Forwarded-Encrypted: i=1; AJvYcCVVwhfRmcjl/Wr2FqoM6ekN4nl5oWQAxs7/Q+GM5nrMnJlIjJdPgbdE88OZZx1kPkDdPiUFw1H/O1wHTjQdWEfwe3ZA
X-Gm-Message-State: AOJu0Yz0UJ93q66lTE9dFcqcsvrQcL6hSzcU5738AF4K3TUY3fIAs9wr
	P5rPzlzkRV9Kgt+rYz3FuU4iA8ltOlqcQzi+0CxQLjkASmUmrfRB
X-Google-Smtp-Source: AGHT+IFd7Y5evhlevQm99Yfbngj01fIj13z3wzQcSDRhvy6Kkt97f5fB81fTJoYe/3kIY+So4+N5jg==
X-Received: by 2002:a05:6214:dc1:b0:68c:ae6d:2953 with SMTP id 1-20020a0562140dc100b0068cae6d2953mr6051833qvt.18.1707313463006;
        Wed, 07 Feb 2024 05:44:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXR+93Y2LAtTHzFg7iDq9addAysOw5GjHyJ1EeV741HBmNBi2EYETfYWONpSx25eZ2tIH2y2162KNHWI0NU/JN2xn721j3xJnrxLxjgHDiF7GN3maAHJ7wdR7YXXPYHYIrY5nelBxQ66AHYHtnDf7/wv++9+JSQfkRnRDLAzZuPGWZw+oKcbKa76t8jW14kU+KyMVSNZJgQ+Eb4rCQzuXs8/JG058N7ZGEYrfkt4JJIB6CuPmuoJXM=
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id oo31-20020a056214451f00b0068c95ebd14csm592088qvb.2.2024.02.07.05.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 05:44:22 -0800 (PST)
Message-ID: <df83e742-b9c0-4ee1-9daf-0262cd184ba0@gmail.com>
Date: Wed, 7 Feb 2024 08:44:21 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] zbd, t/zbd: miscellaneous fixes
Content-Language: en-US
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@samsung.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>,
 Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
 <vydywim2nehpf377qaqq6zkiyla42bdgsgyysypftwdajv4h37@4c6dgrvrbmyh>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <vydywim2nehpf377qaqq6zkiyla42bdgsgyysypftwdajv4h37@4c6dgrvrbmyh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/24 22:05, Shinichiro Kawasaki wrote:
> On Feb 06, 2024 / 19:57, Dmitry Fomichev wrote:
>> This series contains a few patches to make improvements to fio support
>> for zoned block devices (ZBDs).
>>
>> The first patch fixes an assertion that has been reported in the field.
>> The fourth patch fixes a failure that happens while running the unit
>> tests against an uncommon class of ZBDs.
>>
>> The rest are clean ups and some minor feature additions.
> 
> The patches look good to me. I also ran them with my test set and observed no
> regression. For the series,
> 
> Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> 

Applied. Thanks.

Vincent
