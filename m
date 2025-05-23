Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB475291157
	for <fio@vger.kernel.org>; Fri, 23 May 2025 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006393; cv=none; b=YH9uvsVPRWweGIwLU6rUtM8bGvNTnAm8qyCW5Bw7rfD2n47+6o5VjklSQNW7QD4Ca61O0iqnTvCSGyjkXbH5UC9WGO29WZZw+GOuzqtweFfA8G9CLjXgCyNyEry4lKiQQLMm7QYwixSHxJ6YfSsLJQYojaycuOlso3u1hdsTIOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006393; c=relaxed/simple;
	bh=x6skkrXmsLOsgT1RCBvNiK4F9NnVR9Ekug1QkHRCr9E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=RJ492W7qPCK4IDxyb7D50G6DLGRkGvbcRIxwTbUi2PLLsRNGOrMLXqrWgfffhBMjk28Cy0XDZ09a8YCGJ2L2oWMSsyDKsm/yR0SNFeM3FcOtlURSsh7/Tac6/QCeStP3Xqjcil5R48iYUeJoeWocoeTfRuo+mfmDA5lt0rNfTzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R0MoFQzR; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R0MoFQzR"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c542ffec37so1012431785a.2
        for <fio@vger.kernel.org>; Fri, 23 May 2025 06:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748006389; x=1748611189; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJdSHwhqDDzwNZaxbteQ09xH+c8Uo/V2t9qz+n8mP4c=;
        b=R0MoFQzR8g/BxJOUWn1ULe7UjiyjPYHH5OsYSlK5LuTmjkBHeN+2oXsOWppTxKTfu2
         R7DO8ZelVL1TURPd3fxmkqjw5N4UA7uxqQBPLFDCxHocZaLUteofdhbCriOqIOj+9W+v
         /3/O5l7/lMOnNq6uVvK76ALlKhpTH3TNGtb/fjZ7GEYZ7pWvMk9XM1kImjAsVyKqYDmH
         QESCUxfLlbSZ8VzDRV6SEfXYK8w3eqki6s2gvdkAup32+9lnww8ukv/5S7NCPtAvrLm5
         BQzWk+XzwiPi6jDBM0zWSrdKpLBkmibsSVK4OP/MqeDHqV0I1ad4Hfspqzxyzh4CkePX
         MoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748006389; x=1748611189;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJdSHwhqDDzwNZaxbteQ09xH+c8Uo/V2t9qz+n8mP4c=;
        b=GFncCCewpizdBcxG3dygTHH1nFEgaSTjla8feIILF6zYeEKRg+3iksqMs7PkA58/jy
         0fX+UQUqidQCpW6Ztod003sxl1dugDyROachjSNDpQp5JOFrMOc5RZKU5cAo4dcGDtiB
         RZv2H1dShAk32gl5FAahJX6fz/TtchFHqqb1qAfN5I5tT2vmWQlvimK9QL2XbNTO0+Ol
         0eHtQePTBGDalNhfyPvxeABVDwjlBFKnRyRzQLX56oViAYPn+aN/2EgRVlVXOvSsVzgh
         XK24YutUL0R+mQH+ZwPDwHJ9npB0JzIEh8jiaorTBBJiOt3NtERy3hiRvQKKhjQi39g0
         3wvA==
X-Gm-Message-State: AOJu0YxV+NU5/YHsjqNbm1rGBa/YD/cH3NKfd7X0pDn4ipKtqunvw5b1
	YdzRpbZJYolU4RQJ+RBFCfn87NJJvTeZENmuv5u+OHkPmJ20OfBHkEXyri9TpQ==
X-Gm-Gg: ASbGnctlAAFTuyu5Psx08dZQcRH/qlB0Zc/H5bMRIXRT6y88op+YgKwYAEXCpm3+rfU
	0tFlrlIL+jGxOYm6pTQPGVSheqXLDytdlVJmfsXLLWdM0wlB7nIyrmv4pA4xzwyUrO+b9qC8Y7o
	YmZXyATtJQy1MbWNLUMMB0e6N1ax5pgX/mqk1pbX+1Woff+XPM8mSlk6GGpQNv5EkRIRIs65XIJ
	UUxw1Bedznnj57QQ0msrEDMYP7KfNIioHsNP/xp3NyBgmRx/yWMn2gIIkA44Rt9METE+UZBteoN
	nyMNMC4BdKSPXcLylOAzG4TzcqHsdl/UuC1Ioi17YDwE2c/VCw7NVBq67CjUwDtSKD1zg9KJ3Fu
	3fN/utNJauV+790lnaD7/oOK8Egk=
X-Google-Smtp-Source: AGHT+IFWjggHUOR1fnDg2ZaIhNf1NaXx6mXImOEXCUUhHyfitbqzpBumzudNt9LyJE0eWzm2vpakhw==
X-Received: by 2002:a05:620a:2916:b0:7c5:5edb:f4d5 with SMTP id af79cd13be357-7cd467080d6mr3462634585a.2.1748006389379;
        Fri, 23 May 2025 06:19:49 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467db690sm1181054285a.48.2025.05.23.06.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 06:19:48 -0700 (PDT)
Message-ID: <5a63fe42-e127-4415-9353-4d831be58c54@gmail.com>
Date: Fri, 23 May 2025 09:19:48 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Add Zhaoxin support to enable tsc_reliable and
 arch_random features
From: Vincent Fu <vincentfu@gmail.com>
To: fio@vger.kernel.org
References: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
 <174798589185.2695.16933192631855653586@pkrvmf6wy0o8zjz.phsjm35sxllu3kbyy1grtpjsrd.ex.internal.cloudapp.net>
Content-Language: en-US
In-Reply-To: <174798589185.2695.16933192631855653586@pkrvmf6wy0o8zjz.phsjm35sxllu3kbyy1grtpjsrd.ex.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/25 3:38 AM, fiotestbot@gmail.com wrote:
> 
> The result of fio's continuous integration tests was: cancelled
> 
> For more details see https://github.com/fiotestbot/fio/actions/runs/15200130502

The first test attempt was cancelled because Test 13 had not completed 
after nearly 6 hours. This is a longstanding issue that occurs from time 
to time and unrelated to this patch. I re-ran the failing platform and 
this second attempt passed.

Vincent
