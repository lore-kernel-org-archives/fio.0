Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20831BEF9D
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733944305; cv=none; b=EnwEUkW4gQULUQbAsNPHKHdeqOBtLrjJgUztmjrDLqfRvoktqKUUjnl8BE8hhgLtWDqgUvtDWUXGCSVVZ5IIWoucsWYrtkr3HEbV5HSpWY7bcgyj3YhmU+d0IFl0u6osWifo9msuzc0/9iAQvp/Opt9erCWSxL/Bqk3mnUwLFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733944305; c=relaxed/simple;
	bh=AJehtg3cESp2RbwGtGdD5yZbD6bW/KfVdYYRJyIsq60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hT43kkje7k+pUOrv7BKCjsr70Fkyw7HUZ2YOVJduG/hZEO5FVs15buU5nkACWq6hpR1DvKoZazjpFxUu316CCn14h9xnFnG5v6RJ2+4RYQ+Yf7+YAbuwlR1IGRJC4vTn1eWam04X0moNWfYjv+NjkCMlWTdt16KRPtHRldUcaRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uwhYPrqE; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uwhYPrqE"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-71df00181b2so1767862a34.0
        for <fio@vger.kernel.org>; Wed, 11 Dec 2024 11:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733944300; x=1734549100; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KaVzca0j9t0pcEnQDCr905Q6mExrjjXJZi+MODiq2rA=;
        b=uwhYPrqEhZPs/eLyJ/2DjRm+RHl6OLqS3zw3Ut08f67YLl38UigsLVF9ORoJ0gfJmQ
         3qmtbrLJsT6RZgxH2NVT1f+/lotTmcCY+Iq4U3wirLpvOSVcr/X9+zTBDSEEekRdDEsw
         KiS5mfelBWKo1MdqE91vUHJNF2xbXiJ2UP2iaWSMc5T8Rb7gESYnd3nITbOnzC+edcIz
         UPT4ljbXraBfZ3w5I9PrpsEv+7QrLYVitZsRiqQ097fprg6ji5CSVCKdIExan60Xt405
         juZuaEvg1efE6WWpKQ221wIq78QF+G89O+lG57l4KqU9/SIbXStsjaPUaNKH/N6p+km1
         /pfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733944300; x=1734549100;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KaVzca0j9t0pcEnQDCr905Q6mExrjjXJZi+MODiq2rA=;
        b=vCZAhotedivLA3uibgyWK5/5gRVXV2gEXl+cuswIESvAkfr35bgxQ8g/f45RmaS/sm
         5t14cv03ceRtqxhZn3daC3Hc7ajo+wTXB/ZIOfurbiCQO2b+GBr0nVllaL5rhtbY1Mce
         GaLcmMtD+pQqHnGmP4jceBFgjOne6ffJytKvbw0CA93ZEhVmtZWgaABnJdyFbDGf0qkk
         h8h+TLVMsy7RbvQoNgfjICTMgiaF7vdaHBn4SazI7If4EsxNrR71mCzCE3TrSHhcikQr
         F0qew0XmSz1Sb0IepPFXBlvYohy/z7koVQBZiG31a6zs1PwLhCtqgIJAb8JNdaTL4dMk
         cQCw==
X-Forwarded-Encrypted: i=1; AJvYcCXOJHsU4EWYF7DwZqLcIgWwkACRNf2b7IT2aGiXnLVB5czlP0anRfvdvzqDDnh2HTnJirw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeZ0tvWrp++lildOf2JpP2dtEDFTrDMRfX2VDBYb3cX9ddBzhG
	inErUkWig/WNMHkS482O5LtdKSJqfnZxI2EFO3l0y9hVqhazFeh87PrtYnxr3hrVxL4+ZZQtqdC
	3
X-Gm-Gg: ASbGnct7cB4YPRLOQb89JBqR0L7UlBLzdRnfbbJpWCJxrpG9CaMBcP+pF7BAApfUYrS
	kJVzw345CnjTXNnx9bsWb24pgBT4zFH7RS+VsLUPH31xvEJq7K3/AVaeNuoHYqoGQq8a4os4vRA
	vXw6KhFSVfYySi+cWK5q3zRcCcmgOUlAXZave8E1Ks21W6Ll7z3HhC9Kef1e023YDZm8D/Yp3S1
	OYcY+Cyr3oMOuNgDNXUqiJcxwHA14lmv6YtvC51Kx2T84suCw==
X-Google-Smtp-Source: AGHT+IESYgiGaoaa6vRYMgitidrG/rtpc4tQJpsiASXOBZb2fG+xRBlvMQIY6KoxbAr8GHzRfJEIcw==
X-Received: by 2002:a05:6830:6d09:b0:71e:5a:f4e7 with SMTP id 46e09a7af769-71e29c3ada0mr510209a34.19.1733944300123;
        Wed, 11 Dec 2024 11:11:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f2c977c6a2sm1114848eaf.39.2024.12.11.11.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 11:11:39 -0800 (PST)
Message-ID: <a6d45369-3c64-420d-a897-3fcc0390d8a5@kernel.dk>
Date: Wed, 11 Dec 2024 12:11:38 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] engine/io_uring: add write stream support
To: Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, vincent.fu@samsung.com
Cc: Keith Busch <kbusch@kernel.org>
References: <20241211184438.106449-1-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20241211184438.106449-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/24 11:44 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Let a user specify a write stream specific to each job. You can check
> the block device's max_write_streams sysfs queue attribute for the valid
> range of stream values.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> This depends on the kernel side supporting this feature. The latest is
> here, which I *think* appears to have stablized on the API.
> 
>   https://lore.kernel.org/io-uring/20241210194722.1905732-1-kbusch@meta.com/T/#u

Looks fine to me, but let's hold off on the fio side until the kernel
changes are at least staged for a kernel.

-- 
Jens Axboe
