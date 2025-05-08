Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E528688F
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746724726; cv=none; b=TuEtBJBN3LLGom7+HM0D5BnKt9STosRY5MZ4BxAGLph6Mh6ICO3VSeQfUVrNeEA9j8GY8AQoSXoJQIolxY0gCY37m2Ja/zvKzr5C1uBp64Pu92L/iJZ6VfZqetgqcN5eV+IAuL/KOm5dQCCgDF8BItbWUcnvOdbcIk2Pz083ZUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746724726; c=relaxed/simple;
	bh=1hkzy217qPnz9osk7pG6shseCtQSly7Nh3HILFP2PWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PP+DW8DroPjgSQQRKjIIT+rZRnl/NC6oRLlIuWwO2TMvw50Rsem6fVf/tOpp1yMDMGOF50mRbKcHhrPQ6iRXRyF9VMGUWIE22QTSbgG6MrQf01oIB3j5YwbMm069E3AUYdcBbFTGDQF3j98VKnFmDJ/0mNz//ZnaVzDFw9vGP4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=df4Y3mep; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="df4Y3mep"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6f54036c4b9so11737066d6.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746724723; x=1747329523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAKB1oIB4GEJG1mAmI0R6LF2Y5iBHy6XZ4CuyrN+1sc=;
        b=df4Y3mepXSzZt7KymdGzWZKzds2+4t6hFDfU9LnlO0WlTpiBO8BKAytJjsaOBfGJxT
         XwdARvFkmUPcgwpXTkxO3fKU2pBkFA4tnGBdSbze3vdFxkRxoYee1m6Pp+ZbYFwilgfD
         XixLzlgGw/p9Hmd9YP68oUP4kyMHqpOrwj518Z5OeslxPpopEUKjUqICwsPRgxEX/q7F
         nPpKBgv+PRQPSHdm97mf8x5AHC6KUcPSlzZpPRBHHK16yM6xN8zN8kgwumo1wCpXqLxO
         sUAuxYsD2q2sD48Flc6FX2svjY2DtH9jKhz597UBLSUbTqhQUkJHudYDjg09Cc0ySisu
         n4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746724723; x=1747329523;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAKB1oIB4GEJG1mAmI0R6LF2Y5iBHy6XZ4CuyrN+1sc=;
        b=ciM9i3JpbnnWTP5IqmSzvAcypMcMPNoxLg2ehaqk1FfJesStnBmFNHGKRZotMrpH34
         op5qUAJ8iwcxh2Jaz9OnASqlFjrdyt1mrQ3/CSygQ68DH0eiFwiq66bYQnz8xsgtSFsN
         vb45KZQ6PSZTT/zuwoHT/9+2REfolbqzl7xLV6ZIK4IQiu4xXUl2gT75NI6+d1zjO/5i
         joLD7RoO1bR3T2AtcHVTdg+tkrqevNU1C4sKwugMshSokVPQUwJPGDh7sqUIchQbL1s9
         IF9x06vdK1pw97so/FnuuZTWc9/UN1Wof6dBEvAfvmcIg83P1bofySNkYYKVJl+2MPge
         zQjA==
X-Gm-Message-State: AOJu0YyL49vdENDL1tSbNRcSCsWpyTbl2T15f7wuCPq+gIpCP0OefKUK
	CTHkyZ7HhGM2MPuO/4erWVZJJtideAXQzAuTEQjySfKB2tFrKPDL
X-Gm-Gg: ASbGncvE6U4mtdnhoilUZhzjTnKnYc4U1fj7WTe9rOAEnLbXQDDZ55BpQHQwBut5Zj7
	XwhLbGos2g7no0fYt0eGUVTeaoKX3z15P69i2MBbO59cNueLYmn1cM7zlpZcrfmgVln4JpeeTU6
	O3EJ3NfzmaMpxaCN1+GjOzwddoxkIHNy536mkro6i5GsgjjQx5CFtzXpveZ31fbw4oQ82qy2slK
	geZPt8x1zq9NKmy8LF9n2wuJEOdUSXuoO+DjmwJ46IYGkbzcS/zR7LDfTFnv5fga6/kheOI5EON
	Wg7vi4Y0Ymebiujl7kMZlZsWQwZzejvkUpSLJ10PHp3SpN/c2rvoxDWh6fNzoXFIFqDXR+RXbhZ
	VtgILVXrZLx8RbKJP
X-Google-Smtp-Source: AGHT+IGVj9p92XWixcQVyykO2oqpVzQf5LxFCxTX+GfgIGRTDumGKoJMvBzmCR4iZYqmB8hnKvrh/g==
X-Received: by 2002:a05:6214:5197:b0:6f5:3a79:a4b2 with SMTP id 6a1803df08f44-6f6e47afc9cmr917906d6.14.1746724723308;
        Thu, 08 May 2025 10:18:43 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39e06a6sm2144166d6.2.2025.05.08.10.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 10:18:42 -0700 (PDT)
Message-ID: <0f0fadc3-61fd-4956-b60b-fbb9844f07b2@gmail.com>
Date: Thu, 8 May 2025 13:18:42 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
 <d120fd1e-22e3-46f4-88a6-559f256e20c5@gmail.com>
 <a4728f95-f894-4ee3-80e9-674635848806@kernel.dk>
 <brryp7uhtfs6ujltz5c5v3sq4laqqi4yvrwvndr3masoz7pkrd@5rct3dza32t2>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <brryp7uhtfs6ujltz5c5v3sq4laqqi4yvrwvndr3masoz7pkrd@5rct3dza32t2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 9:28 PM, Shinichiro Kawasaki wrote:
> On May 07, 2025 / 11:22, Jens Axboe wrote:
> ...
>>> Shin'ichiro, there are some build failures with macOS and Windows:
>>>
>>> https://github.com/axboe/fio/actions/runs/14882253382
>>
>> Indeed... Guess I should've staged it, in lieu of our CI being
>> able to pick up and build on-list patches.
>>
>> Shin'ichiro, please fix those up, thanks.
> 
> Sorry for the trouble. I created the fix PR [1], and it's already merged.
> Thanks for the quick action.
> 
> [1] https://github.com/axboe/fio/pull/1893
> 
> To prevent this mistake in the future, I will do compile test on my MacBook,
> or create PR to run the CI.

I actually have a bot that runs mailing list patches through our CI but 
lore.kernel.org recently implemented measures against web scraping bots. 
However, I changed fiotestbot to now masquarade as the Lynx browser and 
it should be working again.

Vincent
