Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FFF111AA
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 19:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852082; cv=none; b=b/LzjaiTwICMBjngOc81RYhmwdiKCY2h/H5/PARFZUkz2eESzp6IKEFg4m99ijwyiNIFwaCYfNW6dNYheNck/2wBofLZEPuVyyn18wPUgKoo6i/m066J9lbmiPJfQH4khUKQouDesnJpcDOfHuR6e94g9Tosz2a8YxJgSriBxzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852082; c=relaxed/simple;
	bh=iKliiwuW0+JT2kaONUR9IPE/agVnKSdHxBDRMpzUkkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOZmX973MYXo6m985oyBaB0pfmo+fDM0pCcLi70Tlo+csny6RdbzYdNdGAL5M4i5+EQxq/GKCfrYOHJKc6kBlXRoWwmq+bH2h4jVc6Ons+zpepCWMU7x2ZJC7rB0OwbNAaePf8BjU2cvmqs3eUdccVys1aXi1qRL78ewalxiql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxVKWKNH; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxVKWKNH"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-68ca1db07ceso26412606d6.2
        for <fio@vger.kernel.org>; Tue, 13 Feb 2024 11:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707852080; x=1708456880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1FPoXl495O7UwMV1kYGNZuQ5/XHp7jUALN9QFXtOFDM=;
        b=JxVKWKNH9XhWpk9CXKNGijrkyzdBSWdKZmxaK878/AbCGfJJyMUH3Ccr503bsGAORz
         PSU3EV5nsIGNX+ifBdR8AHzmGOzkAZ+MuvjeHz+wQrcKgRCGbM84Z1QGxgyy+RgEPZRO
         vDMO+KQMFMm8/ivv0/EYNAn2dZCezMU5LATTbo+RGDdLgCUM4z2tzJB6Y8aLFpNjzuOV
         gU48HtvNZVuYgw4ybqQtLHcciHfirfCsgRMD5vURaOdWxzBcwFRFhRq0AyOwWCrmyOGK
         KicTdERfMUHGQK8r+NRMRoDKcjOhJHSu8UGYcxqNyXh+rB87Zd4Vriv/XOpiOas5WpCj
         bB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852080; x=1708456880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FPoXl495O7UwMV1kYGNZuQ5/XHp7jUALN9QFXtOFDM=;
        b=jawbKqbMm+6p0PaVUoxhwYVRRIh+HFTvZjLNEZVKUurtzmUsBLR5tInNy+HIYRgncO
         Nr/btUfTQS4Hpa082EaHDuTz7kryJe0QBI02RKAa/6oRb4bXKzF5rtz7fCVYkSCs0ilV
         wEQvEdvFGA3g6dTfHefCVLYjd1c9qklYQYEuMeDQM56GtHGgFQWfs3u/o1+QCiPZCQ6k
         rAG0CYus9WvhOaKu+5kbnQalOX6VRpxJFju/dmw1Z25FddWULwxzqaNRkJlsDDe6pk3W
         4U1mtdoeQ5Cp9kuktw/YxKsKxoy5O9rzT0jQr8q5sdK554K3nrKEJHQ4sTW+GJn8jH64
         NX2g==
X-Gm-Message-State: AOJu0Yz51a3/9O9E5IrOu7uNgjiX3bxGbbQXyk6RCMfXXXgamEEo4NDt
	61OH1ACYibkdLBz9Ka48Msc35zE3bJffDzmeJ1/Pqiy0qsOzzZg3
X-Google-Smtp-Source: AGHT+IHs+xskeT6sOpUdkku6XqK9p2mkr3jhoShDA+fE/zr/UxRxVjGV38eCzsaWCkKrx28M7pXH4Q==
X-Received: by 2002:a05:6214:21c8:b0:68c:bcc4:f312 with SMTP id d8-20020a05621421c800b0068cbcc4f312mr573076qvh.61.1707852080163;
        Tue, 13 Feb 2024 11:21:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUBoTr3KhG+INxSUxm3DJr/OMpNAeOkjN6wt3si/sAH3uqGXc+Vbv4Mckn7oYFohi+UOoQJZn5IurCaxsJNUyO/RewAS9JIlZBPo0qU5aCHT/q1O/0=
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ly10-20020a0562145c0a00b0068d1cc639besm1477536qvb.124.2024.02.13.11.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 11:21:19 -0800 (PST)
Message-ID: <ad6e4668-2da0-4ff2-afbf-945090dfe50b@gmail.com>
Date: Tue, 13 Feb 2024 14:21:19 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Protection information support for xnvme ioengine
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org
References: <CGME20240213101603epcas5p226dc1964544edfb1549fba7734884151@epcas5p2.samsung.com>
 <20240213153315.134202-1-ankit.kumar@samsung.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240213153315.134202-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 10:33, Ankit Kumar wrote:
> This series enables protection information support with xnvme ioengine.
> The support is provided with the kernel backends that can handle
> passthrough commands via nvme character device (/dev/ngXnY), or with
> user space nvme drivers such as SPDK and libvfn.
> 
> The initial patch adds support for metadata buffer. As we are unaware
> of metadata size during metadata buffer allocation, we provide an
> option md_per_io_size. This must be used to specify metadata size for
> single IO, if namespace is formatted with separate metadata buffer.
> 
> This then enables the protection information support with and without
> PRACT bit set for both DIF and DIX cases. The support only covers 16-bit
> and 64-bit guard protection information format, without storage tags.
> 
> For the sake of consistency metadata and protection information specific
> options are the same as the ones used by io_uring_cmd ioengine and SPDK's
> external ioengine.
> 
> Ankit Kumar (5):
>    engines/xnvme: allocate iovecs only if vectored I/O is enabled
>    engines/xnvme: add support for metadata
>    engines:xnvme: add support for end to end data protection
>    engines/xnvme: add checks for verify, block size and metadata size
>    examples: add PI example with xnvme ioengine
> 
>   HOWTO.rst             |  10 +-
>   configure             |   2 +-
>   engines/xnvme.c       | 331 +++++++++++++++++++++++++++++++++++++++---
>   examples/xnvme-pi.fio |  53 +++++++
>   examples/xnvme-pi.png | Bin 0 -> 71285 bytes
>   fio.1                 |  10 +-
>   6 files changed, 378 insertions(+), 28 deletions(-)
>   create mode 100644 examples/xnvme-pi.fio
>   create mode 100644 examples/xnvme-pi.png
> 

These patches look good to me. I'll wait a bit in case Jens or anyone 
else has feedback.

Vincent
