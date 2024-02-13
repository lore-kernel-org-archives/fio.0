Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60025FB8F
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852451; cv=none; b=F47u3zfCZGje256d3fgoGEt9Xi28LTbLrl1051V4zFFvUpN/YuhTqlgJDc8P678lRrdaC3dqHeaKv6m1IUPma3rlZqW1JZ/JoiPIw5BlaRkOSGU4vXtc7BTu8YZBsge/Y4HDV7VklbKXNE4liO5oXO393mvBYYKjuZM5W6wZWaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852451; c=relaxed/simple;
	bh=6QzgesfzMp6BGd55Lgc5wu96jbl2uUxX/lcx/7pX07M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGUEV/Afw714EJ/l9joVM2zSYKf32IndJ6N7wwtIXkJVu7+RlhwfELtewjy5xY1JLk0wDME4Iw+ufypHDKekiH1sERO+bqQPQDKo4SgA96+3bR/kEAFehiW6gB0rA0M3OSYNBww4YUS4kzpvzAgbdzcbh0yO6fMeff8YzY7TMLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZ+9WhSu; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZ+9WhSu"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-785d57056b0so133249785a.0
        for <fio@vger.kernel.org>; Tue, 13 Feb 2024 11:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707852448; x=1708457248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=olhDuazqSiV1oFrhOGYGS5DxjbMIstwj+i9bo/eCO1A=;
        b=IZ+9WhSuYTwBOzkZtKt558bsx/6O9Nj0Y2rX/MSt3GxqDjvi7Kxxfg9APU3c8ZdqwY
         BAbjAjXJmC9Enqvcgs7Ij7iVLqcC5K2l4e+fgXzz9DExDhyxGpD+O+zmojZBToaGg1BG
         1FbuEyceMKPz+venRBte/qmgpk6JxKEY8dQRTI99W9fAlLTwwqH7aq+DXpvn6zg4oOZo
         tJ1yMq9OzJrIZlThkRPJ4LMSnb1Mp3+sxBxzPhFXKaC+jmU//CoYFaV2MdsmN6T+/6H+
         T7vnRT162eTQirbKDtEv3f9tqRAlAztQPh2KPb0rzD8S9ly0kFxXrCffELdhugbCV5zm
         yXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852448; x=1708457248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=olhDuazqSiV1oFrhOGYGS5DxjbMIstwj+i9bo/eCO1A=;
        b=MRFk07S8/2bn9cZ5AzdyKrDg2H+4Jq6/r0Bx3lHEU8T0s7wibw4PwGwcysTFmnFY12
         NbFRxTCdEF6TbatsTHQNF2esJ8hp0k2Md3aZxqfHCzgyensQbRfThSEX1XkOZRXQm0Oi
         KQEh2ZwiOp3/pDq/9K2m+02C1EcdcoDJnYq4J4Eb1+a9a2wqeDOAv1/1Q0yo1c9KsODH
         fsa+mVO/KXBbEwJCzAY4SLgJTjAcH5HePh26infvrCuP67no1XR6L3e9zfo3iHKrIOAe
         f/FB/KZ0wj+53HlYG7UCa5eoecDtX4TGDD8VXAgjwbiQ0feRTjqLHc0hG6VrAAYmUb7D
         xD1w==
X-Gm-Message-State: AOJu0YxhCzWMmHdXkzXpcgEAqgF8Eblc1nv2NitAEJIF/8E4mOt8yIb2
	EI/rudnuB08QOv+chS30SfsO+qFgN5y0OG+DT2CwZc2YJQTW16ePs22+Yr50
X-Google-Smtp-Source: AGHT+IG0I6rqM/PdBBd5llCAYsEsxjBgd7iJC9EvvV7x6vQBK5wgbX28CX+b5FkgdPQyLBJr0mlETQ==
X-Received: by 2002:a0c:dc11:0:b0:68c:c227:4211 with SMTP id s17-20020a0cdc11000000b0068cc2274211mr401769qvk.8.1707852448475;
        Tue, 13 Feb 2024 11:27:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWCAME/xamNnf6Od14zXNdiACOzDj2Od+Ccn4w+42P7T1brQ1LEUcuLUqX2NowPAXmVI0H6h0sPN9LDfSoYuMKlF4FAjnsEkkszaBL9I+/hsuEBKW5FHSqYq84S/A==
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id lv8-20020a056214578800b00684225ef3a0sm1523535qvb.93.2024.02.13.11.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 11:27:28 -0800 (PST)
Message-ID: <ad776be9-0fcf-4cae-9cf5-d429aa66dd83@gmail.com>
Date: Tue, 13 Feb 2024 14:27:27 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Protection information support for xnvme ioengine
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org
References: <CGME20240213101603epcas5p226dc1964544edfb1549fba7734884151@epcas5p2.samsung.com>
 <20240213153315.134202-1-ankit.kumar@samsung.com>
 <ad6e4668-2da0-4ff2-afbf-945090dfe50b@gmail.com>
 <0e870d15-d86b-41a6-bfcc-f14aaa41b9eb@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <0e870d15-d86b-41a6-bfcc-f14aaa41b9eb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 14:22, Jens Axboe wrote:
> On 2/13/24 12:21 PM, Vincent Fu wrote:
>> On 2/13/24 10:33, Ankit Kumar wrote:
>>> This series enables protection information support with xnvme ioengine.
>>> The support is provided with the kernel backends that can handle
>>> passthrough commands via nvme character device (/dev/ngXnY), or with
>>> user space nvme drivers such as SPDK and libvfn.
>>>
>>> The initial patch adds support for metadata buffer. As we are unaware
>>> of metadata size during metadata buffer allocation, we provide an
>>> option md_per_io_size. This must be used to specify metadata size for
>>> single IO, if namespace is formatted with separate metadata buffer.
>>>
>>> This then enables the protection information support with and without
>>> PRACT bit set for both DIF and DIX cases. The support only covers 16-bit
>>> and 64-bit guard protection information format, without storage tags.
>>>
>>> For the sake of consistency metadata and protection information specific
>>> options are the same as the ones used by io_uring_cmd ioengine and SPDK's
>>> external ioengine.
>>>
>>> Ankit Kumar (5):
>>>     engines/xnvme: allocate iovecs only if vectored I/O is enabled
>>>     engines/xnvme: add support for metadata
>>>     engines:xnvme: add support for end to end data protection
>>>     engines/xnvme: add checks for verify, block size and metadata size
>>>     examples: add PI example with xnvme ioengine
>>>
>>>    HOWTO.rst             |  10 +-
>>>    configure             |   2 +-
>>>    engines/xnvme.c       | 331 +++++++++++++++++++++++++++++++++++++++---
>>>    examples/xnvme-pi.fio |  53 +++++++
>>>    examples/xnvme-pi.png | Bin 0 -> 71285 bytes
>>>    fio.1                 |  10 +-
>>>    6 files changed, 378 insertions(+), 28 deletions(-)
>>>    create mode 100644 examples/xnvme-pi.fio
>>>    create mode 100644 examples/xnvme-pi.png
>>>
>>
>> These patches look good to me. I'll wait a bit in case Jens or anyone
>> else has feedback.
> 
> Looks OK to me:
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 

In that case, applied. Thanks!

Vincent
