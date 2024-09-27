Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F8F9E4
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 00:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727398482; cv=none; b=nGVETa06AXmHCT7JFEcbt0ToBhYotCRySBoA3YyoJeOSSYk4zmcFB0B7XqkjDxKKVdSuEXPR9qmVdYqPHE2Kyw4/CUzonwIk4Rj3OQ/I/Z96yVDMV9DVaKt9156JckAJ0Qx9Po4ejksyFbM7b6+nUjIjTDp629IDivMP4caP3Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727398482; c=relaxed/simple;
	bh=U90LE8FL5Z4QFPIspt+eRt/9gz1Yf2sMK/MjeoMrafk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=POA5f7zoj5BEKmXpiNSJcoxPXf/86TNCyZPjGwGrR5FcVbqgdD31Mw9+qnBHjxLkQc6pwCs2sj7C6DEuU0TLP6kb84/Sd/glf1uGvNQDKn0Zsb9+yMPunt6GjknrLps70kh1zfnJmn/MANvxOjbL6D7OhfQzjtkbpOJ+4rfq5nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sINrX2JJ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sINrX2JJ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-206aee40676so13677845ad.0
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 17:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727398477; x=1728003277; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BRs70ozWzE8RV1Q93hfwvkFnXp3OK2+COf+WT1jEao8=;
        b=sINrX2JJAG3UHNf7/LMs4fbyaCNSP03tFuNzwdJNNRr9VgCfIjbLzu1cheTRkGIzAC
         7tvWyrLaE89pMq3oI2xGFDCJoek9ZDMsAN5fAIOrCw8XVuz0mb497q6Al5Cxhvjpqy8l
         oBLDyPUYKa9DEYsVObeaIJ4HGAPZqN8CK/mYO80RY46WUGmFxw1R1SHFywJEjmdQ8cYj
         MHJYK/CMf3sqaH+hHzuuf3ERtnx1clnoyyaZbyhR/OyQ49gAe6RwHr3sFvsKzPXVf6pi
         e+36sMkdQCFe7e91afqBI6VXBUbDpzc+MRPly63GMA2Ecr5mS2jnqgq4CWbREYREKB+o
         5LNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727398477; x=1728003277;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRs70ozWzE8RV1Q93hfwvkFnXp3OK2+COf+WT1jEao8=;
        b=ULXct5wq4zuK+HR1U4WKndBrKwmLVZtzqBPsxtF5J2+bn52Qh8xhzMiXOAeq8Ulb7V
         864xqbsf6q4URru8pzAIx8m8hI+5OIzW8cyZCMDAbFW+vt5U03nTI8Lr/jntKKcj/ywC
         KjAN62tJdLTiKkbWaTanRw+QcnlsmsyTqY0unSZwF9Oj0enGy1j48rsnF2kIqzWFSzmo
         KDQiK9jG7COzfIc93iLPH2Wcu5EP9TtSGA8AqGqT3J66tdBdj6R6jzr2rji7Z3RAE2bL
         ievAe/uKLamrP3zlJW0Ou/Ar4inwFrp3rC9TS7GK43KXRsR34k2oJbdlPPc1ALuNOnMz
         y95Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8hdyx+ZtBT59EJ4blguqpRf3ZSTjVsnlqMAoO9/CNrwEZyNetMMZXHm4/BeBXEV9POB4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVxUdcUZOM9OkHhUWNTxhYQtHEXIxcMlEqoRfZDEhbKPRWpA5q
	sBzkF77XOCR7QhvgqUe2OPScbf74As2CWIGWrFHpeg1t3gWmpyqbtRMvydUPa1s=
X-Google-Smtp-Source: AGHT+IFNDY7IVKOYDMt14KKJyCNR8c3W8QNNATG2K0zdJNyb8iLDRDiDFljgZuPdVv+vslKoBcUI0A==
X-Received: by 2002:a17:903:32c7:b0:205:951b:563f with SMTP id d9443c01a7336-20b37b919eamr22246275ad.49.1727398477529;
        Thu, 26 Sep 2024 17:54:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d5eda4sm4040555ad.48.2024.09.26.17.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 17:54:36 -0700 (PDT)
Message-ID: <03b0dae6-bf69-4a3d-9b82-9107b0c25a1d@kernel.dk>
Date: Thu, 26 Sep 2024 18:54:35 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
To: Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
 Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
 <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
 <d84566e1-40aa-4c5e-ad68-32607b4db695@kernel.dk>
 <ZvXTIO3DNbzG5EZ/@minwoo-desktop>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZvXTIO3DNbzG5EZ/@minwoo-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/26/24 3:33 PM, Minwoo Im wrote:
> On 24-09-26 15:06:49, Jens Axboe wrote:
>> On 9/26/24 12:08 PM, Vincent Fu wrote:
>>> On 9/26/24 13:48, Jens Axboe wrote:
>>>> On 9/25/24 6:41 PM, Minwoo Im wrote:
>>>>> diff --git a/io_u.h b/io_u.h
>>>>> index ab93d50f967e..20afad667ee1 100644
>>>>> --- a/io_u.h
>>>>> +++ b/io_u.h
>>>>> @@ -22,6 +22,7 @@ enum {
>>>>>       IO_U_F_BARRIER        = 1 << 6,
>>>>>       IO_U_F_VER_LIST        = 1 << 7,
>>>>>       IO_U_F_PATTERN_DONE    = 1 << 8,
>>>>> +    IO_U_F_DEVICE_ERROR    = 1 << 9,
>>>>>   };
>>>>>     /*
>>>>
>>>> The patches you sent should've been a series, how are they supposed to
>>>> both apply when you add an item here for each of them as if the other
>>>> one doesn't exist?
>>>>
>>>> I'll fix it up, but for the future, if patches depend on each other, it
>>>> should be a series. Please check if everything works when it's pushed
>>>> out, which should be shortly.
>>>>
>>>> And since I'm on a plane and this doesn't appear to want to send, when
>>>> you do see it, please also add HOWTO additions similar to the fio.1
>>>> additions you made.
>>>>
>>>
>>> Also, Minwoo, we are seeing some build failures with your patches with
>>> compilers rejecting abs(io_u->error) since error is unsigned. Please
>>> fix that up as well.
>>
>> Doh yes, I fixed that up now.
> 
> Jens,
> 
> How about the following one for the fix?  (checked with clang)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 6c07c1011c40..85cebf8371cf 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -589,7 +589,7 @@ ret:
>                 io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
>         else
>                 io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
> -       io_u->error = io_u->error;
> +       io_u->error = abs((int)io_u->error);
>         return io_u;
>  }
> 
> io_u->error is unsigned, but it can have negative value as an errno.
> io_u->error should be converted to a positive one especially when it's
> an errno.  If we don't, it will be like Unknown error:
> 
> fio: io_u error on file /dev/ng0n1: Unknown error -22: write offset=429916160, buflen=1048576

Yeah I think that looks good. Can you send this as a patch against the
current tree? I did do a fixup, but way too jet lagged and it's
obviously garbage.

-- 
Jens Axboe
