Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B9779924
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 19:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709580069; cv=none; b=NxW2iTp9j84s7fDes+drR9bLOGFwUMrbzY00Dfv+toQosF7eNj9H7jbTUxSAK3Kln+6c299Xll5daBYm3ugAOaFBIWwRR/Qq+Udc/qV9rQNKXYhSQEE49uVGjWiGjj/Mad+I57qUgp2eQyI+K7p7BJguxTmvUFDv7I0IxcZKYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709580069; c=relaxed/simple;
	bh=8dVdw78kb4hupT5doKe7KtNhg2njN+pGpIqTNW0Ma+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNxNNgX4Zxu0PlKrdK8pbOTZlPt3PCUYKC7hV/CioDmLqJ6TMx4pUv6wY+DEDc2EwCsH6PW9kSGa7qP2pSV5ZJVJqxv1/7SnqG5pnuoOblB1fnYAq/Stz/R5PG2RQlJAn5R38hHeTx3i/BRfaUUvnkVneJvcMRQJJIc4l6QLvWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7l60cK5; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7l60cK5"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a143047a4aso350695eaf.0
        for <fio@vger.kernel.org>; Mon, 04 Mar 2024 11:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709580067; x=1710184867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S6zxDLW9Pnb27MJY9k1uoBWaIDek04EHOTX3Lw3f2fY=;
        b=U7l60cK5i3leba0jTOSWNOtq4tdAsNntKY19NIWbUyGEcmXmhYEhvpm8M5hcrn+f86
         nSAQTYt5o5Uegz7Ynb/CAkv/bNymTyg+czMQQ2l5NssB0VwTMCR5fJenytYILPl44V94
         gfaIQ0UKFjSta9t6qxt//V5jScbXQKphpG/tpg2hhp80p5hlLIjKM+fS4IXc9VoDIhU6
         z8tpzSt291nflxuKg+656xD/QqVusclZATodHh4s9p7Gshq/lS0D4igCtV5LYxIOPbQ+
         5aitz0nbay8ahAIL64jPN3EP6ff34j3mz6q+c+PGhrBUjmVXXMWFeNSXsLX4GHIdPuDY
         bwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709580067; x=1710184867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6zxDLW9Pnb27MJY9k1uoBWaIDek04EHOTX3Lw3f2fY=;
        b=e4smH/Ca8rjBUnonvzeaNKWWM43JgEkQ/h6Yp9sMxDzE3nlfp1nxIUp+ZiNA5qSacT
         zqozBEmyFMi72FZ9giA1YM8oW9f0rw6OaJgyQlW1taBMNFXAI7opJxMN+ZYeRmh3GavD
         bSflT6t/v4gl77D+qEjWaKC9zb5t2UoitGBGfnozBE6d1Nej8K8UunhEtwCGqka62tpt
         KHHHgIAZ7owgyrBMeCQJ5S1PXPuL+0nLt3i1mqRYcjDKiA30SCLXkRk0YitnqKEJJvsd
         JmDQjPkAKlkTd0OXeD9tw8Ulrq/XGztDRIsIhVfy61mhiUJ5cgMSZaAgFwmuCTDMretU
         WH9w==
X-Gm-Message-State: AOJu0YwXxveVzbvCjXMmiSUkTfg/Vej5PejkrlVuwrok/zec2/XEusCV
	nPTAGIVKoX2TUEIox9IUP//RL0/foLyts6C8EcFoLzrCMh/DZGRJ
X-Google-Smtp-Source: AGHT+IFa158lcycgQ9vCfawD3010xKHU3FBUL1fzqnJqBi+dNT+MsVnkw1xCaflUKMPkZG7uTikDIQ==
X-Received: by 2002:a05:6358:7e53:b0:17b:c9cc:f60b with SMTP id p19-20020a0563587e5300b0017bc9ccf60bmr13063116rwm.28.1709580066726;
        Mon, 04 Mar 2024 11:21:06 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id qm14-20020a056214568e00b0068f92234e2fsm5318984qvb.109.2024.03.04.11.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 11:21:06 -0800 (PST)
Message-ID: <f651bf8f-dd6a-4eef-b5aa-4f37489c3e53@gmail.com>
Date: Mon, 4 Mar 2024 14:21:05 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] t/jobs: Further clarify regression test 7
Content-Language: en-US
To: Avri Altman <avri.altman@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org
References: <20240304071851.982-1-avri.altman@wdc.com>
 <20240304071851.982-3-avri.altman@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240304071851.982-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 02:18, Avri Altman wrote:
> Add some more details explaining why the the successful result should be
> 87,040KB data.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   t/jobs/t0007-37cf9e3c.fio | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/t/jobs/t0007-37cf9e3c.fio b/t/jobs/t0007-37cf9e3c.fio
> index d3c98751..a5971759 100644
> --- a/t/jobs/t0007-37cf9e3c.fio
> +++ b/t/jobs/t0007-37cf9e3c.fio
> @@ -1,4 +1,7 @@
> -# Expected result: fio reads 87040KB of data
> +# Expected result: fio reads 87040KB of data:
> +# first read is at offset 0, then 2nd read is at offset 1.5m, then the 3rd
> +# read is at offset 3m, and after the last read at offset 127 - we have only

This is a nit, but please send again with 127 changed to 127m

> +# read 87,040K data.
>   # Buggy result: fio reads the full 128MB of data
>   [foo]
>   size=128mb

