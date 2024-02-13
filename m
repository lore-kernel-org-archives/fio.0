Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25652111BF
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 19:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852160; cv=none; b=uMop8134uHOrGo/8OISvQ6QvpqKdrC45siRyRzeDDue7LYXGFwSjlyjMsgRSnEt9V2+lCkCX0jkU/0k1jvt8NsekNW4yqm+ZzJoJs49os1RTYNUOWRNvACM1JctfqFZliDqgU3XUNj1ljZjDHz17e6FsYgsM+z94hLkadCCzXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852160; c=relaxed/simple;
	bh=A3Hi9gCCqgpslh+71phU6SEw2IyI6+6nqNq2ZHP73jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5+JNMads2SRn5m31gDKPWaESz4V3+JqvVZu8sSQkTcvFub8IFiGAPgSyWTFUErQtOdjbGz7ivkfz4uwkVRGcFqMbWx9ZGcDWgvda7DoW3k47bRgsh0ldcYfyCc5K3qQvBDiaxP9itRp7PaFsLk+Ja+pwSwJBpQ6IPo0WXPX+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KKEHzlTS; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KKEHzlTS"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so4609145ab.1
        for <fio@vger.kernel.org>; Tue, 13 Feb 2024 11:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707852158; x=1708456958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pA9Uw7BZmhdT51Vuo7U1VvSrJVo4pWtIIrrhwTVnDJU=;
        b=KKEHzlTSAyFAQcaFedYmHHfdFE0NWAqxPY/cRmUIlc93t8lyPqkPa7RS8qCAAafu7v
         c3B+Lfw43iX60Y722fQ6/KXs9l7jN6bMwmoXGlMVI301T+jWUZJRqoLyyIxu8Cv+HyB7
         eovIs4+MrxuBgAiiXYFhvtSaEy4GEoCN42XFEvwH3WPdXvlfYTTNHpo3813TfA7Kj0AF
         jJsMuy75CNYzxQ6ZKHSp1iRfTXFuTyf/GQv7inKujLFwzQNtXaIPNMuGQallM5ZIOrNE
         k2JRszVWAjqSROAWtts+p8pnxXFnElfY5ZXPpY6ZRGbYulB9/XzMaWRjY1RY9/R421s/
         QIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852158; x=1708456958;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pA9Uw7BZmhdT51Vuo7U1VvSrJVo4pWtIIrrhwTVnDJU=;
        b=K9Ob4pxbslrHiT66mvm7JSZYZx6s7QXoQgA2vms7ZaekxB1vI0zARW4ttjsKJ0qqkw
         32tRBWch38dEzNxv+Wq2yY30qo0vby0anqLgImDRSj2/sx9cWhnFDtVR7uu+ra9EqLMu
         j9OFkvyg1iqKaCUmXyBJ2elooXOk826/NKuiJuMss08+HVn9iKXfq/Hlh4VF946QdK4a
         SnGkxLiXN+17Rofk770bxgQxBEAAsIGQwP5Cl2lHE6C7kBowDKot9gYYElwvrdB4KLS5
         ZkF4Q/4FvHg+KmO0C4CW1ENLifd8ENyptuva8wSEVkUi48qw8t1sz+xLci9vglbENyfS
         0Yvg==
X-Gm-Message-State: AOJu0YzQgiSKrM2B3HiMeN2hL1Cg5SzlYw5pK19VNpsETvRLao1L2Rgi
	cs8zX0veOkTBotNGPIEc9cQr7ZGYOsWp1Ob/kzR4yTFjnB59JJCAQhZ83tVlJ85y/CxgOLe6TM6
	R
X-Google-Smtp-Source: AGHT+IHzBfZbGJG45dmJD+zmaBitX8HDToNlFGeQNblHB8wZ/XwFgeFewiWR6pwOors7z2zVrFh9hQ==
X-Received: by 2002:a05:6e02:b4e:b0:363:b545:3a97 with SMTP id f14-20020a056e020b4e00b00363b5453a97mr798964ilu.0.1707852158057;
        Tue, 13 Feb 2024 11:22:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWrLW4krr14XgmnbAimJs/HCr77I+rUiyeMDY2EQNtesVBmOxTDuaUlLMRRzDGsXr5M+91PEFrvTElvXzd8U1rxTiCWjClUMQ==
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x12-20020a92dc4c000000b00363980d75d3sm2607010ilq.2.2024.02.13.11.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 11:22:37 -0800 (PST)
Message-ID: <0e870d15-d86b-41a6-bfcc-f14aaa41b9eb@kernel.dk>
Date: Tue, 13 Feb 2024 12:22:36 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Protection information support for xnvme ioengine
Content-Language: en-US
To: Vincent Fu <vincentfu@gmail.com>, Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org
References: <CGME20240213101603epcas5p226dc1964544edfb1549fba7734884151@epcas5p2.samsung.com>
 <20240213153315.134202-1-ankit.kumar@samsung.com>
 <ad6e4668-2da0-4ff2-afbf-945090dfe50b@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ad6e4668-2da0-4ff2-afbf-945090dfe50b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/13/24 12:21 PM, Vincent Fu wrote:
> On 2/13/24 10:33, Ankit Kumar wrote:
>> This series enables protection information support with xnvme ioengine.
>> The support is provided with the kernel backends that can handle
>> passthrough commands via nvme character device (/dev/ngXnY), or with
>> user space nvme drivers such as SPDK and libvfn.
>>
>> The initial patch adds support for metadata buffer. As we are unaware
>> of metadata size during metadata buffer allocation, we provide an
>> option md_per_io_size. This must be used to specify metadata size for
>> single IO, if namespace is formatted with separate metadata buffer.
>>
>> This then enables the protection information support with and without
>> PRACT bit set for both DIF and DIX cases. The support only covers 16-bit
>> and 64-bit guard protection information format, without storage tags.
>>
>> For the sake of consistency metadata and protection information specific
>> options are the same as the ones used by io_uring_cmd ioengine and SPDK's
>> external ioengine.
>>
>> Ankit Kumar (5):
>>    engines/xnvme: allocate iovecs only if vectored I/O is enabled
>>    engines/xnvme: add support for metadata
>>    engines:xnvme: add support for end to end data protection
>>    engines/xnvme: add checks for verify, block size and metadata size
>>    examples: add PI example with xnvme ioengine
>>
>>   HOWTO.rst             |  10 +-
>>   configure             |   2 +-
>>   engines/xnvme.c       | 331 +++++++++++++++++++++++++++++++++++++++---
>>   examples/xnvme-pi.fio |  53 +++++++
>>   examples/xnvme-pi.png | Bin 0 -> 71285 bytes
>>   fio.1                 |  10 +-
>>   6 files changed, 378 insertions(+), 28 deletions(-)
>>   create mode 100644 examples/xnvme-pi.fio
>>   create mode 100644 examples/xnvme-pi.png
>>
> 
> These patches look good to me. I'll wait a bit in case Jens or anyone
> else has feedback.

Looks OK to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

