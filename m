Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC0D1EB40
	for <fio@vger.kernel.org>; Tue, 27 Feb 2024 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709051661; cv=none; b=DA/FTYPhDktbx0IuyGJVaiBGg2mc6V8Bm4CTYJR9hj2ROXB6v4S+F5bwwuvzlzZS6xUR0gg2ZeScbAf/WklWUp1ZVmOWWEb14NmLJ/rVTOkbxejCDEGOdOENZwPfFvv3XGW4xDWQ3nYpEVsoJ9AES18V7XFF/ssEFpQGvCYcFFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709051661; c=relaxed/simple;
	bh=gAwN/aEl5d23OjODohf4z7PhFP5k5i4v0hOS6eDt0JU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYlQwJdt85Z+dKbNe6jlkRmZyn3NgeF5P/ripD9RwlAJih6O9V8fA+lMw9cbBgBRsK9cpS37uedaC9cPNE6doJgbpV5RmBD98l3jxPaD9sfprMGNDrQKUgUp/bkB1XIorMap4tl8qToAW/kNKzZN7iOYUZjVg34Zhrn1OsyBN68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yTAW1zVp; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yTAW1zVp"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc8662581dso2035565ad.1
        for <fio@vger.kernel.org>; Tue, 27 Feb 2024 08:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709051657; x=1709656457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jz625QJZDulIur79IxKGVvKRwAO0j2PUsWeYnsYn9b0=;
        b=yTAW1zVpYgXqKo5obPOF6VMLv36i98Fu2EF94UEPRaKShndC2bgK1MseUKRT8UIXpZ
         55s0a4aWUVNGWtoPMMWFkPNV4bG448+nAal2o2gGC2OtLlIjFisq9ae9U368o2zFpyYp
         0urofAkPw+5nulCk3vDNEABJFXdANRCBK1Ij/pkgW+Rmv3AAswrMt7ILgTfhvmL9jPkX
         Vs+RT2gwCURkjGkZ1oYandIhjo4k+sJWQmDzjI2z6F/yNsB13WUmJUx30otgGh/7jyob
         jsvE0A8ejFqGpuVJXZMKl5vS2SrDi4FRKomzjEPJtRPjMTp0x5W6Nk0KxXlOjXrUgY6J
         ECfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709051657; x=1709656457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jz625QJZDulIur79IxKGVvKRwAO0j2PUsWeYnsYn9b0=;
        b=dxqk2Ave05cFPI6GiNpd62MQibnsSuuCN59qjmwDO1eYrG1CYpEl3dj3ye8oHb8B2i
         xp2UX/ZFwpX+OLJsHHMNVyBzZKknTkPzbmKbRVhGAw0mNtKdN2LfJfQJKAuDiOvOUzFP
         sUP3f4hEwU3VP4vKk9+rJWaHhbp/DRoiDDJKWo68E+NBFo7Xrhj4oleZ0HH3S99HcymN
         9UTWGhmPws8VoUyCRUSnoWRdRBPj8pgpYWNQ0nGomjhjleZb94cvTEavJDu59lumCsjl
         +2PniSRPtrrLb4pcP+PmLJbIunmMtT4UeEgtPNoZDqiQ2LVuogJ7mvZ4KDBwm2HOUghR
         FCIg==
X-Forwarded-Encrypted: i=1; AJvYcCUfSBUq+CLntKi0GSG0AULlwcF2JqumxWJET7uiGjFPrpTEw24a4E87ztj4sWqXsToQSvfPKBMH1jlY9q//ZlcXiIZj
X-Gm-Message-State: AOJu0Yx6FXcpfrh/XombYEdJQsITzZbaDwpG3zjereHIf/8ZEhouurEl
	LKYBMpAxZaCw/o3MCNYC8As+N/E0FrL7wyekS7oMxHApNIllA6eyZEzl72Jn/dw=
X-Google-Smtp-Source: AGHT+IEPvRKwqV9E632/6pK5JyeRB6Qz35+UL3glOLOiIxxvIFv8hKAA4LjG94hjcBIBfenEga92yQ==
X-Received: by 2002:a17:902:ce8e:b0:1dc:abe9:829d with SMTP id f14-20020a170902ce8e00b001dcabe9829dmr4700968plg.3.1709051656872;
        Tue, 27 Feb 2024 08:34:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id p12-20020a1709026b8c00b001d8edfec673sm1702437plk.214.2024.02.27.08.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 08:34:16 -0800 (PST)
Message-ID: <dd061da8-a3e0-4824-a650-8db42300af99@kernel.dk>
Date: Tue, 27 Feb 2024 09:34:15 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] gettime: fix cpuclock-test on AMD platforms
Content-Language: en-US
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <20240227155856.5012-1-vincent.fu@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240227155856.5012-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/27/24 8:26 AM, Vincent Fu wrote:
> Starting with gcc 11 __sync_synchronize() compiles to
> 
> lock or QWORD PTR [rsp], 0
> 
> on x86_64 platforms. Previously it compiled to an mfence instruction.
> 
> See line 47 of https://godbolt.org/z/xfE18K7b4 for an example.
> 
> On Intel platforms this change does not affect the result of fio's CPU
> clock test. But on AMD platforms, this change causes fio's CPU clock
> test to fail and fio to fall back to clock_gettime() instead of using
> the CPU clock for timing.
> 
> This patch has fio explicitly use an mfence instruction instead of
> __sync_synchornize() in the CPU clock test code on x86_64 platforms in
> order to allow the CPU clock test to pass on AMD platforms.

Looks good:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


