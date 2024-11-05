Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D60D1CB9E6
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730839023; cv=none; b=tR6/Q0EvLsRDkIU94sXetHdZUacgdzIUrao9drvYRVE8veFBCWhdrOfTdrDB91Du2cudXRoFHOWUe6WL5OuF+f76xVqHV3CYmcJ6osD34FHWO83z8GKC7ebd9/Lcb1NDXzqFsHLikLwZu8KRmQOzrgLsYxS/VrTNmYNoE+HOk7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730839023; c=relaxed/simple;
	bh=J+GYfvn75qjEF5zm6L4/WuVUDvpuLl5aDcTyyltT11c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NKVg1UH7sO48DNfkzf7zv2jRO4qGRGNIjiSFzTSFMn9U6iHUdl91qZkp12Z08diRLEnw2oTL4vheua/SX2Lqr0Y+gbTdjD1y3Vl/HdgSFWqzcyaP9Sei2FtZBRGJbjMZe6Qt59gzOSFoZ8NYXKfsQIDb8INZvN2oOYpkVuphsNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SE62MfLF; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SE62MfLF"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6cbce16d151so38279936d6.2
        for <fio@vger.kernel.org>; Tue, 05 Nov 2024 12:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730839020; x=1731443820; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ruqY60hLeC6kFDHWw8broyO7ygflJAfEe3MLN0zOIZU=;
        b=SE62MfLFp7FTqdOn+8FKcuXgLSNpE7L/1I4H3r7RsCwyNtl+Q9eFvy04AfuZ0xbD8v
         u+LMJTyTTqofqu5qsX7NPDfB5u6dhecBKGef/7HlFsaYNfZ3nNb4cO4N3ik7IMnnXiWG
         nFh0B7/Ic5pqiRcVFO/mE8s/H7mviUsyVvPoH7PGiifDO3bkbbg3zrzYDvmP1Pg6VutR
         zxND7theu0LjN5sXZZHvtj7D2gvnXsj3iW89EqffiigwoJbEgJ9fpod/vqCzhqfoUbE2
         6w3N2gnXJISRa3algmOMGlQNKOwsdhP6ivE7TTX5TNKgSZMj7dV6hdOWgyvHTE7j9viW
         d3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730839020; x=1731443820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ruqY60hLeC6kFDHWw8broyO7ygflJAfEe3MLN0zOIZU=;
        b=L0sPvUobrBhmt+OS+keoHc7wSQaqcoGQpEcjIhuS9djzhaoCKxKXVLRSNKXTz1JbeL
         f3GTXuZAddi+XySPAPxVHupYIfAPkIkMjyvft8RnLbfy3EG4KF8Yd+aOhspz2kgTvx9j
         XHx4xQP98txHmEOeACsSucljzBlp+bGMgfY6N5c0gHJoLnYV12teQ6wLnQCNQGsCURvc
         3scOU4Iy+9EuXmCFKOsFoU/4BRSHygfN1wxIgg2Bay0p0luyh3X3jcQ8EH7eNk7TWUzG
         z6n+ha3MQTSOjV8M/xj/GCs+qsI2m84EdYt+ifnxABklTTFxfJr0+onAF2brmvGFP6sT
         Q57g==
X-Forwarded-Encrypted: i=1; AJvYcCV2bGLbsfHpYt+M/8MYM9EY3L/PjaazNQYnvZzFBpJP76ktVV0eNjvVym1gXic+h34L+CA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwIXmwuYLAjtXQnrI8gCmlxGWb6SKgbcYhT+wPOaf+wGl4ye+n
	9hXby0C2PKD1G6//9WimB8MHJtvJcpjl31lPfQ0SPQb7KsH4Q2TO
X-Google-Smtp-Source: AGHT+IFH4msPtF5IRHliRuKKtprBXNQnx5e40CdU94Y7dAuuceH4dogiDQo1iSKUGz7dQ41WbzHVmw==
X-Received: by 2002:a05:6214:5d0c:b0:6d3:531d:8aa7 with SMTP id 6a1803df08f44-6d3531d8f5bmr323454646d6.25.1730839020239;
        Tue, 05 Nov 2024 12:37:00 -0800 (PST)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d353fc76e5sm64560316d6.39.2024.11.05.12.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 12:36:59 -0800 (PST)
Message-ID: <422c7d4a-5b9b-48d5-adf7-355947d18014@gmail.com>
Date: Tue, 5 Nov 2024 15:36:59 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: blog post on fio write zeroes performance
To: Adam Horshack <horshack@live.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
 <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 15:02, Adam Horshack wrote:
> Nice writeup Vincent. It's been a while since I've looked at the NVMe spec so perhaps I'm asking the wrong question but why is fio managing a data buffer for its handling of the Write Zero command? I would've assumed there's no data payload associated with that NVMe command, thus nothing that should even be subject to internal buffer scrambling inside fio.
> 
> Regards,
> 
> Adam
> 
> 
> ________________________________________
> From: Vincent Fu <vincentfu@gmail.com>
> Sent: Tuesday, November 5, 2024 2:41 PM
> To: fio@vger.kernel.org
> Cc: gost.dev@samsung.com
> Subject: blog post on fio write zeroes performance
> 
> I am pleased to share a blog post about fio write zeroes performance:
> 
> https://github.com/vincentkfu/fio-blog/wiki/How-could-write-zeroes-performance-be-worse-at-higher-queue-depths
> 
> Read about the unexpected performance issue we encountered. Feedback is
> welcome.
> 
> Vincent
> 
> 

When we added write zeroes support for the io_uring_cmd ioengine it was 
not on our mind that the default behavior for fio is to scramble 
buffers. Basically these patches just changed the opcode from a regular 
write to write zeroes.

You do have a good point that perhaps fio should be smart enough to 
avoid touching the buffers when doing write zeroes.

Thanks for the feedback!

Vincent
