Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBE620D4FC
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789677943; cv=none; b=j+4y3T6X/1rjPxnnuTK+Rqp7Csg8GhRPCum4FyV9nlmY1szH+9I1rukjvxt79HPJPiIaFRpj8rqa8IikNR7DKEBPxUwKRM7e9ZbjUza2rRk0i35mLIBosSEUC5Qukerni9p1pWEYGQVwuDFUhw7DjfFMcBCJ5wqPqeEYYekeiJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789677943; c=relaxed/simple;
	bh=a/nFA7dtFF4pI20Aeq2Vx8vOgCmPe9v0tfUdVL907DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pHy92Uano0kG3ECk41Q6/d/v/X8jsHLBk2p9eTVef4kpXXyrpABMOCh+JmsTmM+bIraHIBwYOlb26R7uOri0WZ8k2T72+gM/Tv6IxTeb0dCWiWy9o5+nAnYutVD9Awaaa04X2TT0OZdKJZNEdVH8jO4USivbQvc+N70d0n9/V7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=D2bDEID6; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="D2bDEID6"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49cd38e0f79so340655e9.3
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789677938; x=1790282738; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+GvfUcgofxoXwnlKe/nxIRzP+hnJJCVxFzQk9qbUIdM=;
        b=D2bDEID6iukVkt5BuuV+Z8HoPoc4Pwz2tQT71c/LVMY3SRqEFsZUZS1hgMdMfuEpig
         ZHwnD+eFvZpcwqoNv+cBjuYcMoDdCqdJt2kQWNm8uT427cdiZ1vZXZug+YBWrKub/oLe
         eOEa+lf/Zb404mbWGIf0YG4+WSdJ3MvpQORSq3Z0ibbm7xLHISdkIRUcCjidLarF6Z50
         RLR9UcXCuxtq46FWLWS0WX/kmq8K4OT4PtHpa4gyQavQc37hcbUDIIa2weCXANnupoF2
         AOgPaVF4ZSObzPlFahpHiz8gurGQ7dTbaWrt8wxrpj7XsDSXT87AKmpkqWIPxHjGbX10
         0dVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677938; x=1790282738;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+GvfUcgofxoXwnlKe/nxIRzP+hnJJCVxFzQk9qbUIdM=;
        b=pm412BnJyacSkmBmjiy33SMSNxeua7cAD1PVvImSn4C4lEu1EQgJlq7Zc6vl8FgGDE
         wvKJ4bO9xKwa/BTBBKgt0+Pas2jpdOWePYXpG6T1GDTJEk2tTCBsD2QPeeGK20DP0Bpa
         RmWuFKxfT0LjtKFFSMdR2U7EmOcwWvUy7EZiHUg5nVsazta/BCDrHW7hc9DI0iUzW/bQ
         F/VDNDyAEep8IgYynAYXSzsczcHG81dhsawh6GOKU0hJ9U0qfKY0xmqqzNmUjCvL2BT2
         9r4WR7fCDXhDjCmW8KQrMSbjbVBvqLxgKblurEm+0NgpZUOAqRujw5nP5UGBDBPQyE+Q
         cQhw==
X-Forwarded-Encrypted: i=1; AKwUvBx5Op+Z2rHA/qS2O7WP6TwS+vg50WVNFaIuyg1sjFq4VH60SpXU13CZUkAnVbXYtwZhh8g=@vger.kernel.org
X-Gm-Message-State: AFuF++k7P1EQjMZDwrBLvE5OlrgfCuSGQDUe3CyXYoEoqSAXxuTWFhAK
	/etD78Tgedg028puIpODVZXehm9m0QpWPHjlWmwww08ocJVS5h0rzwaYTG3cEcLTe9w=
X-Gm-Gg: AYBFou0gfNBENFw6bx+m/7v4fWRG/d1NUIt5zTAcDH+Z2O/RP1L58frA9pCTKmUbKgf
	MqozE8QxBBWeg3syycXXqSLDXL8Ig/+6kWnxLRGzOsxdzdzMw9HLx/Xvm190ygfCXsHr2ecv3U0
	aRzqjeGvMqBB6mFwsGkEWDaXKnXJoys4JDfGehp8/aNUsGtMGGv13eSrSk3baYBJqLDVVa9/tGu
	UcrVLZkYC25porX1N5uPlfxvOnPHTE8vGOFlXWt7y6ZylPB3vjiBWM+2aVO5KT4oq1uBJ75tG3M
	E+dm9AINkM8G6UGcnBwBCEOUx0he8zGqklpQpds89HxzjxsnUo8p40rSt7xvDS7ut5FGazyklW/
	qmJC9TCQ4726/fwuC1x6FkiZn81Hm2ShyJXpnXpa1VYfL1gIU9avxk3v7SSNRm1wC/rlYsGmU5y
	cUVt+bQsOg9E/mpIG2zhkUDqQDuECCVW3tsqc/Mgink1Ss+qgcex3rB9FdZP2Vuu3bvWZUZ4t/u
	02W9WxOshsFoe1OG9GRVF4ldSXvY3D7yXbGB8D3XjfokMmAzNK7AJmYCA==
X-Received: by 2002:a05:600c:4e50:b0:49c:ee20:e787 with SMTP id 5b1f17b1804b1-49fc566443emr3629735e9.1.1789677938327;
        Thu, 17 Sep 2026 13:45:38 -0700 (PDT)
Received: from [192.168.1.112] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf413dcsm17833920f8f.31.2026.09.17.13.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:45:36 -0700 (PDT)
Message-ID: <cc91f33f-5153-466a-80db-b2102cbed1c4@kernel.dk>
Date: Thu, 17 Sep 2026 14:45:35 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fio: server: Warn when listening on network
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-4-sandeen@redhat.com>
 <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
 <53458ab5-5e82-4af0-93ef-d99002c259c2@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53458ab5-5e82-4af0-93ef-d99002c259c2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 2:29 PM, Eric Sandeen wrote:
> On 9/17/26 3:01 PM, Jens Axboe wrote:
>> On 9/17/26 1:41 PM, Eric Sandeen wrote:
>>> Make it crystal clear to users at run time that the client/server
>>> protocol should only be used in trusted environments.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>  server.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/server.c b/server.c
>>> index 34f3f5c0..887ed7ed 100644
>>> --- a/server.c
>>> +++ b/server.c
>>> @@ -2596,6 +2596,13 @@ static int fio_init_server_connection(void)
>>>  	} else
>>>  		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
>>>  
>>> +	if (!bind_sock) {
>>> +		log_info("fio: WARNING: The fio network protocol is neither "
>>> +			 "authenticated nor encrypted.\n");
>>> +		log_info("fio: WARNING: Use this mode only in trusted "
>>> +			 "environments.\n");
>>> +	}
>>> +
>>>  	log_info("fio: server listening on %s\n", bind_str);
>>>  
>>>  	if (listen(sk, 4) < 0) {
>>
>> Let's not pollute the log with that - just document it in the...
>> documentation!
> 
> Which is implicitly already there in the man page, so it's probably
> covered. Could make it more explicit I suppose, tho that's still
> assuming users will read it, heh.

The only people that will read this one are the ones that see it
in a log, breaking their scripts, not the intended audience.
If it's already documented in the man page, then just point any
report like that at the man page!

>> Like I said in a private email, anyone that runs a fio backend
>> outside of a trusted local/test environment needs to get their
>> head examined. By definition, since it's generally used to open
>> block devices and read/write to them it's run as root. And since
>> the environment should be trusted, so should the clients. Anyone
>> thinking otherwise needs to get their head examined.
> 
> I don't disagree. Just floating the idea of making it crystal clear
> at runtime, and like I said, if you don't like the change, I'm
> happy to drop it.

I will just pick up patch 2/3, I think that one is obviously fine.

-- 
Jens Axboe

