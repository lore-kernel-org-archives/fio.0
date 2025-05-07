Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A2021ABAA
	for <fio@vger.kernel.org>; Wed,  7 May 2025 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638567; cv=none; b=H6RoWt5NnGi2ovRCYYlPeOnJs0cSg+VtujetojxbQZj5cetVFCqvkDAgJckDBcB5TaKnpXJRghNwHmM4SUIOyuAb4vg4hSr8yRAAJ18AJ2R67FKY+yotMV6nqoTewGNwl7xTdENEOqCvuNvJEFwEoV/mUxRtv8g4dKh88Yda6qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638567; c=relaxed/simple;
	bh=S9crsziQnaKQ5WxQzdEW6Z0BPU+9XDg2pixx7uJGjBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C8sHgeGcBfSex+L03WKgOYApw0WoR1nwoL5Bl9tnTOlUn54MnfKlQ5KwDyUfIl7up2CvSLbMXcrnrUgy2MvGlxJv+TuCgIMFYnbHe8sLcxOaz3cMdTtArXjABdZlwZ2r8QWZjbc6eVBVfSlQpMV3Of/J9F9HcuN+r80yMBrbtZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z61wEZvP; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z61wEZvP"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3da7642b5deso86665ab.2
        for <fio@vger.kernel.org>; Wed, 07 May 2025 10:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746638564; x=1747243364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xiAVoF0pDIkEnWqZ0CQFhF95wWTV8hHqfjpKSdJV7es=;
        b=Z61wEZvPDaJOlpIBTlUVdYVerWkKoBDiWNhYDzc+ulbihttp29Hp3UUTqs5EcIJEux
         TWOOQRQ3nzeNEbdSMY+1Qn47+sMMuLbMZPjEuLogyzdmILAWnEuwSXXRnXpAV7Y50Y5t
         wmVAjdBNqr6JQW9VnLI3Qc2UNTajrZDI/Oh7FI7gVF4HWjGqhCf2Un2CgUKV7uIB0JG0
         SmOFlxo0uiQAsgdF3QKEJrmQSVou821ggWx8TGCWXRQQYsQQblD30BwVn/pCtdTx3Txq
         YnNk4nLNsePOC43l9cK18hBy2fGQJbjQAuu1YHMtHo4huTxSRgjB2Uww3f1Yir7ho+2p
         ClUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638564; x=1747243364;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xiAVoF0pDIkEnWqZ0CQFhF95wWTV8hHqfjpKSdJV7es=;
        b=Z2P/melPhFOTkAKjU0OqGAEyPdItoQvJyXYEYKH0wgvbRI6ZPSe7L3DyRATxTPcWcx
         WzRgRjXFN2YbHohOIExc8/BxAMuwbV/9A7RcvqI38dUnjGZcWyuRzj6EjA64/TAppE+v
         BdF2bIdL1Hp0L9SxSt/IBmxqCd+hw4ChIIPN/UNB70rRkeyMXw/fHs7sIlSYeTtGZKsi
         pvwdIGud9fmyB+sWrxTGfz0N/tULtJuUdub1meUqhdCutKLH1naWHnxFkOeJKW7/k3zK
         Z7dSfD2uYQYHQryVgiFSX5lO5v41O3qFVG+vydB1Bn84lFkGJRF3GztRmHKWJF1PRtpT
         ENpg==
X-Forwarded-Encrypted: i=1; AJvYcCVbk2QH3tSt6+9UX3QSXBfiVqgJhcISNUwCZs6tuiKrl475VVf5HRohZlUJZe/FLaHalJs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd+mGef1R+h9zkoDbdyiA/wnUk84EJ5rR6WLKmAE0jOPhzTV7x
	ePCjqu3jYuuZHPIm0N/xOFkEF7mspV58j7RC4RwCV4xBdKhAIxG9q4BLGHwueN8=
X-Gm-Gg: ASbGncvpV8uL9xM/ms6spjtke9y9r62uzfLOabwdM3OGM+6ugD2MjPf6HpwNDouNAWK
	nPpd4Pzpn0C4GpQuDvtPNN1W2zzCADU8uCZeqMcN8OVBdiBh7o/d5M3yGvlAmSR6j4NbQBce35Q
	EDaK6o+zVqkz1crm7RRBdDgY63rj3WTkxtrrbTv26xchbeQLWMy2HQeN5qwWlTZmkkvabN0pxWL
	NRUQK0CCH5rmNgOQODWO4rzAVdOwg6U9ZK1IOCnqZGiEcn/xHqiFU4Uyj2dE2sZHQ6rqxGylk4L
	QxLKYUIoa9mRZPqoOHQpXFgRsSjOFn/tbVea
X-Google-Smtp-Source: AGHT+IEJHtth6s5znGsoPeXQ4UZeb9+SeJL00M+fxcFtxv+XRDSrJgqlAfaS3pnL0EQGusns4L4LMQ==
X-Received: by 2002:a92:ca0f:0:b0:3d0:10a6:99aa with SMTP id e9e14a558f8ab-3da7854d61emr6177295ab.4.1746638563885;
        Wed, 07 May 2025 10:22:43 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f597a5sm31781495ab.47.2025.05.07.10.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 10:22:43 -0700 (PDT)
Message-ID: <a4728f95-f894-4ee3-80e9-674635848806@kernel.dk>
Date: Wed, 7 May 2025 11:22:42 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
 <d120fd1e-22e3-46f4-88a6-559f256e20c5@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d120fd1e-22e3-46f4-88a6-559f256e20c5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/7/25 11:19 AM, Vincent Fu wrote:
> On 5/7/25 7:29 AM, Jens Axboe wrote:
>>
>> On Fri, 25 Apr 2025 14:21:40 +0900, Shin'ichiro Kawasaki wrote:
>>> When the continue_on_error options is specified, it is expected that the
>>> workload continues to run when non-critical errors happen. However,
>>> write workloads with zonemode=zbd option can not continue after errors,
>>> if the failed writes cause partial data write on the target device. This
>>> partial write creates write pointer gap between the device and fio, then
>>> the next write requests by fio will fail due to unaligned write command
>>> errors. This restriction results in undesirable test stops during long
>>> runs for SMR drives which can recover defect sectors.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/8] oslib: blkzoned: add blkzoned_move_zone_wp() helper function
>>        commit: 4175f4dbec5d1d9e5e0490026e98b1806188e098
>> [2/8] ioengine: add move_zone_wp() callback
>>        commit: 6f635d6f72ad3d4ae76fff63671a208c27bdaf2d
>> [3/8] engines/libzbc: implement move_zone_wp callback
>>        commit: d4f6fa5e35d6bd20dd648b3aaaad84a0a9a4fa6e
>> [4/8] zbd: introduce zbd_move_zone_wp()
>>        commit: 143aaff963694ee3745c204f414e1e27a759a7df
>> [5/8] zbd: add the recover_zbd_write_error option
>>        commit: 650c4ad385cf7ff320cb34f76784ca63d2daa32e
>> [6/8] t/zbd: set badblocks related parameters in run-tests-against-nullb
>>        commit: 5cbd1644e0dcfeb55e6cb4717259778ed11cc70e
>> [7/8] t/zbd: add the test cases to confirm continue_on_error option
>>        commit: b6002e78926bce20bc168d02c83b7c8f5dd37470
>> [8/8] t/zbd: add run-tests-against-scsi_debug
>>        commit: 4dc6c8da6ed938f12a42f167839100ab551ae8d1
>>
>> Best regards,
> 
> Shin'ichiro, there are some build failures with macOS and Windows:
> 
> https://github.com/axboe/fio/actions/runs/14882253382

Indeed... Guess I should've staged it, in lieu of our CI being
able to pick up and build on-list patches.

Shin'ichiro, please fix those up, thanks.

-- 
Jens Axboe

