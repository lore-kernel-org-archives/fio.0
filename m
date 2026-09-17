Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F373DDB09
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678056; cv=none; b=AftYLEcOXTfzfiet2Cs8sbk3oV9hfEHRM9C/Jl/vcGEzvvllpZXH8MckW3XmF/5hda8RUGEBIK6B4DZYF30ZYbO3Q1b68VvYF9woUUxNPilnvw5ImvwZ40SUFe+6tjEmeimfBBWuu81PXj5wywPfalqYgRiu0ItUhOV0gVQIHco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678056; c=relaxed/simple;
	bh=2HVMFzmzujvKu6Vp03A5269N1cdW2/FOAoTxk8/f+PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qRGkCUGdnuNNqh9nE8jPeIJiSFvkVmWVaLrSKy6UPl8NgA5w7pJFQl+3JOtxvwHKCbPMYX4RPz/vmFOE03Da8pZEXHPhR04gmCC3yatGcQ0+jH49Mb9OMm7tG+HeWrIyYdA2OUVH0SSb3WX2fUCO1OqWbv7CeFgYSsXue2BDQns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PrKFUU1o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Up7aNYM5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrKFUU1o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Up7aNYM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789678053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gbXR3VxTZJTl8AXEpTlI6TBxSbPL2fUTelZ+16bSPCw=;
	b=PrKFUU1oKF3+DV3PeHi9HHdrjP/Kn2tPRTK0wFvz6cPpnz0nzgmWARRF3x3pctDaP2mU7m
	Tbogn8l1U9LUAdQijZ9Kw0CbOoFZlcFNf5FS8XGghoikZGspsQMzuTGo77V7F9lF2LOQCi
	iji3XSDFAZLftuWrv1H/dANo7p9fYNQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-DApX7qmiMU20rfYLRHMKhw-1; Thu, 17 Sep 2026 16:47:31 -0400
X-MC-Unique: DApX7qmiMU20rfYLRHMKhw-1
X-Mimecast-MFC-AGG-ID: DApX7qmiMU20rfYLRHMKhw_1789678051
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a05d645acso7331885a.2
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789678051; x=1790282851; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gbXR3VxTZJTl8AXEpTlI6TBxSbPL2fUTelZ+16bSPCw=;
        b=Up7aNYM5snunJ/IaPFOEomok+3z8DbVVhz19SELcipgOz6KLojsmL7oj9vvSAashU3
         a8edR/1aR3TEN/UnId5aWr1L+T+HxDrOV5ri3bbdYwSQ8FOtkX/PPjM2SDiAgmnqZpcw
         JfeqgZxhw0YY5bvnWYnrem8HsJfouSuFbHaiIBIItUskIBRjbIqper5uPUjtjdSeZA13
         V8R6YFRRva+uYQWVKkuukcOQv7eCg9OiByG4PhdyeNdun1vOw9uPSYo46DjOm7+pUiCx
         ZAP3nXCMKi3/tIIyyv3L2fRcpl4QsouiFS9QI2EKIaj87SMpLs8MzWg+/E69n6g4NsIS
         mhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678051; x=1790282851;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gbXR3VxTZJTl8AXEpTlI6TBxSbPL2fUTelZ+16bSPCw=;
        b=dGKSNKdsPdEj+l63l/KmMMqRZTRfONRwWBV660GfZ3XkA0mV0xxUwdNQtQMWGWXUSt
         hR4yKAOvyJES9qtQkHk41FWf29vv89vH+VGEaHwOvVJe2ld9UgzTZf5rlowFKNnJfo36
         dbopHLzo3KaIVX8L4kI3ZGDU+vJmVmpV1MW3dyacnn2cIvQPQzdDDSD0tU6OptC2g909
         N0SJ/UJ0X75RusYmiqcOen8u10or5K3yPocuGRVQEpTxt+Hzhnba1XgHCQVygr23v7kB
         X5kvKEOgDc+GJAM2eQjXjE0g3wg4ki0c6/j47dvaMcL2ru+b3YLQh9uebqKrMwYHdrIR
         wVYg==
X-Forwarded-Encrypted: i=1; AKwUvBxB2CqVrpEa+cOMh/MAtOC/dxlBVxCbQV2K5NTtA6EaptY/eF2CjN12hrhGXC4vDETxNzk=@vger.kernel.org
X-Gm-Message-State: AFuF++ni0LVuFh2Z6fIz/NOJP8BereJ85CXf2XE3XJIcoKGIvPVRq8OU
	8IEd6hYnZAWu2DbbG/oBLveIn56B7QDj1F987F0yuMWnvgKPRpWgBEwIxNo2O1oDrRiRv4Ap4Qr
	AHAM4pGwCCtY0xSI0D0BhVTAJ1uCvcw2XI6cvpj0CDSaccDaRzbQ5t0hfxqHa+Ntm
X-Gm-Gg: AYBFou2tJA0owSjhO76AaZEvyliuRWdNqReg6e/GdnxVA9sTT5FEgmed9m3SWqAN3qr
	eK0/aT+i9A53iY3aLC+vJbUY+HGI43T0N2ZyFJJt4qcJRqbWHNe7p+AbasTZWF7qZe0oanwnX5u
	OqfIIQJz3ZBgQiwATAfT4SZgadKtCA+dwtYbcCenGrWyoCXOuCna/UurAL0m0c1bT10nVEu2hqa
	fXhSroAVntP64f4sac1l4TpgJFkuFhyAXk3KHg4rX4vGi0ZOn22pCbITJAyVuORS7fAPLRkkCIp
	6LfzTo8jrqA1aWkGeW/QuBcZt1kbOQ6sm8K7D1dgZXJ6qu/dZsaz5aP2It38pzmbAOowWYFxgcM
	2QFUpMzUcaAR4ADP+BxfyZj1esh9/zW9+692hCXw8cnpEqA==
X-Received: by 2002:a05:620a:6010:b0:939:6dfa:4975 with SMTP id af79cd13be357-93bdca3b456mr20914385a.52.1789678050893;
        Thu, 17 Sep 2026 13:47:30 -0700 (PDT)
X-Received: by 2002:a05:620a:6010:b0:939:6dfa:4975 with SMTP id af79cd13be357-93bdca3b456mr20911885a.52.1789678050246;
        Thu, 17 Sep 2026 13:47:30 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81cf255bsm564087885a.35.2026.09.17.13.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:47:29 -0700 (PDT)
Message-ID: <221f4079-9eb4-45b6-9f22-d3d31727a318@redhat.com>
Date: Thu, 17 Sep 2026 15:47:29 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fio: server: Warn when listening on network
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-4-sandeen@redhat.com>
 <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
 <53458ab5-5e82-4af0-93ef-d99002c259c2@redhat.com>
 <cc91f33f-5153-466a-80db-b2102cbed1c4@kernel.dk>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <cc91f33f-5153-466a-80db-b2102cbed1c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 3:45 PM, Jens Axboe wrote:
> On 9/17/26 2:29 PM, Eric Sandeen wrote:
>> On 9/17/26 3:01 PM, Jens Axboe wrote:
>>> On 9/17/26 1:41 PM, Eric Sandeen wrote:
>>>> Make it crystal clear to users at run time that the client/server
>>>> protocol should only be used in trusted environments.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>  server.c | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/server.c b/server.c
>>>> index 34f3f5c0..887ed7ed 100644
>>>> --- a/server.c
>>>> +++ b/server.c
>>>> @@ -2596,6 +2596,13 @@ static int fio_init_server_connection(void)
>>>>  	} else
>>>>  		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
>>>>  
>>>> +	if (!bind_sock) {
>>>> +		log_info("fio: WARNING: The fio network protocol is neither "
>>>> +			 "authenticated nor encrypted.\n");
>>>> +		log_info("fio: WARNING: Use this mode only in trusted "
>>>> +			 "environments.\n");
>>>> +	}
>>>> +
>>>>  	log_info("fio: server listening on %s\n", bind_str);
>>>>  
>>>>  	if (listen(sk, 4) < 0) {
>>>
>>> Let's not pollute the log with that - just document it in the...
>>> documentation!
>>
>> Which is implicitly already there in the man page, so it's probably
>> covered. Could make it more explicit I suppose, tho that's still
>> assuming users will read it, heh.
> 
> The only people that will read this one are the ones that see it
> in a log, breaking their scripts, not the intended audience.
> If it's already documented in the man page, then just point any
> report like that at the man page!

Fair.

>>> Like I said in a private email, anyone that runs a fio backend
>>> outside of a trusted local/test environment needs to get their
>>> head examined. By definition, since it's generally used to open
>>> block devices and read/write to them it's run as root. And since
>>> the environment should be trusted, so should the clients. Anyone
>>> thinking otherwise needs to get their head examined.
>>
>> I don't disagree. Just floating the idea of making it crystal clear
>> at runtime, and like I said, if you don't like the change, I'm
>> happy to drop it.
> 
> I will just pick up patch 2/3, I think that one is obviously fine.

Sounds good, thanks Jens!

-Eric 

