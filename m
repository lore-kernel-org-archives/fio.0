Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40413183CD6
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384816; cv=none; b=ITW51tAnytIIzyjn/JrY13rE+Yoi1FnnTpP8o9uzkCbrbh1gGjl7GjY0Pl98c8oMDZuoGSNb2zcE+J7EJnNi1pJrLTS5o8FItobV8b9HUNqHxWCWPW9f7QpPyyhWx2Mo2j5ZOPDhMem6K9h0cw3skSqceqOvjzCM+dTLS8rziBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384816; c=relaxed/simple;
	bh=nQa1tvk2YJHlJBrrBIKMiF+fdkvJLZzjiqOeOYsTL+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IncYgZR+flcBE5YVq8qHpkCsSVWsK7RlVWSf7N/TRl3eYl6NAjBCfrl/ld3soNHQTvAOBIp51pb0NkRtvmJvFfMWa0+URsugj6dLZQNkecB1kW1bGJ/M/HsKNUEOzAxPV1PFL4yqqaQgd1V5tAoTv3Co24rZ1bUkqRPVK9mwhe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tdnuAlEE; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tdnuAlEE"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71788bfe60eso1212695b3a.1
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 14:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727384811; x=1727989611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KQjzTFTitdPMQNcHpl8KpFRPJIJLPFRq5eMFjsJ4lL8=;
        b=tdnuAlEEOMN+EDoQfpEzrPPmcLO9HxzRisHT4606sAW3r1l2pSHN7tpZKoZnqfaqx9
         fUbFacCNs/YuuUirBQJj02tpp+tjhSvtBCGmo/DOUUYMOWUfhTZtNjxm8JfNyL12BGQV
         tU89qTmqethXZM8IeyedmiljACP+S/dXfDdpakaVPjnrnTSDkRWvVaV+54XwwvhpndGm
         nOhV91MWcat/8mPrEzRmMbWHbdUAjAe3tHheYw/CYKozXChb7rc3rjDhbsUjs1O1wfHt
         m0/ZEOC+O0SSwtsFjZXYbY57zalCL6tsrrisNzMn1Gish3dDZ3bZw+ZlmVbULIsYDFqY
         z2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727384811; x=1727989611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KQjzTFTitdPMQNcHpl8KpFRPJIJLPFRq5eMFjsJ4lL8=;
        b=Qxvuvt3Hv+sIfPSrCQIzckEdKvOok6bIpxyHgl/sNvPZpmKNe0jxihkgbUUtRGLQhp
         BmzOmkEUS8ppiHhWN0ed3R6UPMpn/c/UWkruWMPBClTbUW1AGGzslee2RgTw2v5pE6S6
         y2JZ6xG8gZTgvulV9LkMJA+is8ygk+BWItS/1pSv2hR7iOofz/jZk/zByf8f275GvOrJ
         nuxA7lqV5JuX/7r1y2tQX3AaFLQwGm0yDP3rpYFPyTQcTPvZQDlXddWB3S6TuMGGddtq
         ECdqHyQlkB6i0XZboLVXNO1chfAXHKIdLmD8TEJJKs8AabbqjEjIJxJk8GZs0anT01Jp
         /yIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdl4hILEnN0HacuDSXdqg3p3F7ASJBz8zHaKPo8Nc5fNrpVYggSMdjAExSup38tk+bpV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxeke5K0jnfHKPMyIBk3TsnZKS12IqJU7MDjSsdl+G61OpQMvf
	0KskmniELgSeGtXxXkrzxD0RmZ9TR47NUFaM1MbiIY1iLLSJAK+vPav15BfEw2E=
X-Google-Smtp-Source: AGHT+IG+fmbkDkP+mM7qt6I1zS2ow7MtQbq2bLD/ZKDLej/E3hlKMCFmFSqyLhqy3rA5T2yRccbkow==
X-Received: by 2002:a05:6a21:3a41:b0:1cf:e5e5:263d with SMTP id adf61e73a8af0-1d4fa78a4e9mr1238772637.35.1727384811279;
        Thu, 26 Sep 2024 14:06:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2651622fsm329380b3a.101.2024.09.26.14.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 14:06:50 -0700 (PDT)
Message-ID: <d84566e1-40aa-4c5e-ad68-32607b4db695@kernel.dk>
Date: Thu, 26 Sep 2024 15:06:49 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
To: Vincent Fu <vincentfu@gmail.com>, Minwoo Im <minwoo.im.dev@gmail.com>,
 fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
 <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/26/24 12:08 PM, Vincent Fu wrote:
> On 9/26/24 13:48, Jens Axboe wrote:
>> On 9/25/24 6:41 PM, Minwoo Im wrote:
>>> diff --git a/io_u.h b/io_u.h
>>> index ab93d50f967e..20afad667ee1 100644
>>> --- a/io_u.h
>>> +++ b/io_u.h
>>> @@ -22,6 +22,7 @@ enum {
>>>       IO_U_F_BARRIER        = 1 << 6,
>>>       IO_U_F_VER_LIST        = 1 << 7,
>>>       IO_U_F_PATTERN_DONE    = 1 << 8,
>>> +    IO_U_F_DEVICE_ERROR    = 1 << 9,
>>>   };
>>>     /*
>>
>> The patches you sent should've been a series, how are they supposed to
>> both apply when you add an item here for each of them as if the other
>> one doesn't exist?
>>
>> I'll fix it up, but for the future, if patches depend on each other, it
>> should be a series. Please check if everything works when it's pushed
>> out, which should be shortly.
>>
>> And since I'm on a plane and this doesn't appear to want to send, when
>> you do see it, please also add HOWTO additions similar to the fio.1
>> additions you made.
>>
> 
> Also, Minwoo, we are seeing some build failures with your patches with
> compilers rejecting abs(io_u->error) since error is unsigned. Please
> fix that up as well.

Doh yes, I fixed that up now.

> I do have a bot that automatically runs mailing list patches through
> our CI, but it does not report the results to the list and I am not
> always quick enough to manually report CI failures:
> 
> https://github.com/fiotestbot/fio/actions

Send them to the list! It's not like it's a high traffic list, and
that's super useful. Mostly because it gets the same coverage as a
github pr then, but also because it'll inform the submitter that there's
an issue without either you or me letting them now. Hence it saves time
and cycles, which is a big win in my book.

-- 
Jens Axboe
