Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E5013A24D
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727374136; cv=none; b=T+J/lEbdX7whcMTC8GYpwwDnoOOos/ZIbR8i91nI8JLTjxUdRJFNrfDQDSIc4mKf76ZSNiD4pNTRLDX51+LWww/Bahmvlbzf2YLnsxMl3g6IWMO9Y2PDKyVacpC/X8Bi6ub5t4PNjxnwq+IiEnGOhDPpxTJt4ZI06JxuU4KUWvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727374136; c=relaxed/simple;
	bh=KJw+X6NNz9q8acHvP3imj7TquUU+HltGhsJJwRHZQeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFvuD0duwEIe/zq+11SxeSACGwxUf3EgKdvAVU/tojhtWT0OE55nepEP7kOOL0OmgxpayAyaGVp4CHGjGecn87k2SI9vnpHgjkG0kKl/C1xluEDdIK1UbriYiT4B4WyHcjkv9mDuZS/dOybXyIqfxputcer6/MXrhObSw2IaG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+5PCzht; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+5PCzht"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a9aec89347so96234385a.0
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 11:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727374134; x=1727978934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EEvDhB/g41MAn3HLJJYYg/vMYjAdVp/HkpuDHv06zGM=;
        b=c+5PCzhtUq7w1iFzDlCFWrkBsnxuA2ImQ8y3DLn1OweUkkE5IVJr7ytzVJvZK+3prl
         CtUc62UHVp3H3a4Zwpof1BxxFNgE6osYY5/TrsDN0j2MkLPUW35RlNcX6eHfVPAQ4/51
         MO8aX4PJtDqowU52w9bMbBZq48NhuwLEbdPANosefGGYohtaFLu6qoMDzLztzO6KN+Yo
         1tD7D8eVG5Dgy2VS3DnXdPhQBy4uIL3LZAYCKFVoouLpE9sEz226gV4ZuTzC1dAr8vDW
         Qt8NKqy7RVWQ1CK1ChY5Pmp3XP0ZAh2zB6wvzV0HyzL1iMEx2tD7JBp2XG3dJ9b0sjLq
         hEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727374134; x=1727978934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EEvDhB/g41MAn3HLJJYYg/vMYjAdVp/HkpuDHv06zGM=;
        b=ryiVaQMeTNsf/aFeKxSTl1TFmUi16qqMQdJ2fDv8Ga6ydxazjysvzvuPk0waRNf4+Q
         +7z+RCdpUfiUgB+p5mb05rR0ut2rnVeyii3OG8ggEpYSi4Kji1ucSJL7sZLj7pugbFU4
         GMMo26CHv/0si8HKZkL0yzJYWqBOh2KViqNq5l2G+IY4DSLDZR5m74VJGykC9+mwL1kB
         Aabiqd8FH4iiP9Z7qreXBXfOdOg8iccQvFpMnFenwTzAS5UiX2o4s8MMVr/sLLMP5wMb
         I5rdC8WBndyKFBK3ttjr8dZMoES/Lb23JvWHFGEHmSd23vyxp7ZI28kSngQWmKoWLyYM
         K8mw==
X-Forwarded-Encrypted: i=1; AJvYcCU0bPNVo/7ByFpwrWG9HLmfWVCUUBXUKWOhSTFDebLQ/zSyIr6sVvWtmSQ4o9aKWCpbDps=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjaLogCBWI8cIuwL94dgz/z1mmxdSxNC/nz1I/PDAv05IfRoWE
	Jj1dfjz2lLEp0xmce33WtUOrFCfSdPO/5BwjsOegMAgNxFBLHgZk
X-Google-Smtp-Source: AGHT+IEIrsFpZ3hHIpVXNlF5x5J9RLiXNtOjPcC90Xg4XYyWlaxTPu6IeOnEry5JKPveub/BnyytRw==
X-Received: by 2002:a05:620a:4510:b0:7a9:b021:ee6 with SMTP id af79cd13be357-7ae37824869mr66531085a.11.1727374133803;
        Thu, 26 Sep 2024 11:08:53 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae377d7e05sm13155285a.48.2024.09.26.11.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 11:08:52 -0700 (PDT)
Message-ID: <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
Date: Thu, 26 Sep 2024 14:08:52 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
To: Jens Axboe <axboe@kernel.dk>, Minwoo Im <minwoo.im.dev@gmail.com>,
 fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>, Minwoo Im <minwoo.im@samsung.com>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/24 13:48, Jens Axboe wrote:
> On 9/25/24 6:41 PM, Minwoo Im wrote:
>> diff --git a/io_u.h b/io_u.h
>> index ab93d50f967e..20afad667ee1 100644
>> --- a/io_u.h
>> +++ b/io_u.h
>> @@ -22,6 +22,7 @@ enum {
>>   	IO_U_F_BARRIER		= 1 << 6,
>>   	IO_U_F_VER_LIST		= 1 << 7,
>>   	IO_U_F_PATTERN_DONE	= 1 << 8,
>> +	IO_U_F_DEVICE_ERROR	= 1 << 9,
>>   };
>>   
>>   /*
> 
> The patches you sent should've been a series, how are they supposed to
> both apply when you add an item here for each of them as if the other
> one doesn't exist?
> 
> I'll fix it up, but for the future, if patches depend on each other, it
> should be a series. Please check if everything works when it's pushed
> out, which should be shortly.
> 
> And since I'm on a plane and this doesn't appear to want to send, when
> you do see it, please also add HOWTO additions similar to the fio.1
> additions you made.
> 

Also, Minwoo, we are seeing some build failures with your patches with 
compilers rejecting abs(io_u->error) since error is unsigned. Please fix 
that up as well.

I do have a bot that automatically runs mailing list patches through our 
CI, but it does not report the results to the list and I am not always 
quick enough to manually report CI failures:

https://github.com/fiotestbot/fio/actions

Vincent
