Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1822200BA9
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 19:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733946227; cv=none; b=oYilA+AWZBOE8Y8ZPFF8UsRjPBrO1p8cSJS9xJylF5oIzRjbkd1zT0qJizNeVGCbtFKe4p2216VqltiLO2bOWWguGgcU5Gbhmt2YuKXFSxDa3zhOQylFfAqMrbIkmwJmj1nIQhaknCKMgy047kJEBZdm6GIkJB/+B859HMZk1hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733946227; c=relaxed/simple;
	bh=yaNbtFKL1yBHk0/BZvYjTwnlhZyi4IeAwcGcLJSkxMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2HKVc3tiHZiQRAdCBCxLHF7TJu9ncRLO8evpmrF3W5hPmg1zGk+x17SpOjJ36aEJBKn9d6PDvp9/n5Aqy2Y6y/89HaaQUb4PfPy1jt9iRkcUpdx1REvcc+Mb2Pvc7Mk6Jc6cJHwWv2malLIt1fZPEXaNyY5HLSo8teUzWqshkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hnJRj9Zb; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnJRj9Zb"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7b6edac3e6cso66770385a.3
        for <fio@vger.kernel.org>; Wed, 11 Dec 2024 11:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733946225; x=1734551025; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmRJuYya/0M36LB39p8pnAOggMUvwnYLaJFXuYoz+gg=;
        b=hnJRj9ZbnQQLuK8nGgD2xqbc0hHV8YzIiBteirWT7AGN8KI80oIBw+CsuZUpaE2aYm
         B4bqu4zmCVoPWdhOooMQXnEtnRXXFaFeB5PG1XKeO0amTP2xix9ZfNnGYiHY+9VbBaZv
         JtYVDxS27J2lfq84jB3YUlsLqaOoZ7i32RSeGupGc0TW31M3SSwVP1wSkY8GkO4yIs/c
         hUzQjf7+0RxbYcakH5a4wStXEBZj1TyMFPSnrmwul67EQ57cMa7xmFIWq5fqzfHkZoSd
         6JQz78A+TTpjcY0XWlGQwkvcGaqcXLaCLeqTPKW5XfYF1klb15YDDf9Y0h3hNJWIEcYT
         oYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733946225; x=1734551025;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmRJuYya/0M36LB39p8pnAOggMUvwnYLaJFXuYoz+gg=;
        b=fZjYObx8YUYx3sAEGs3ThnHM2DyggCPUoWFJak6UD1RH/daNuQpVs3bIcawGuJZza+
         AVYY5NxaLaydQ9auptfl8RY2lod+pVxaMFQCrPdWlBTXWvbhGg2rpQXr+X3grgUKEuF0
         xl8gvlMBhVd/g/6bTgflXDVj2WZ9K4KtGuWQ8lgfsAoPBlw3gZZ4krONIyHyeGRXQux2
         8sWPEIZCSMkV1DU6wbX8Nc5DHxRXAnaWbHxsUChmsagd/zDhkpDz1tOtkVHO8WiV1i7p
         KvwUqsf0/cGB23Bq3LbYmqN+dcygTaYxnYaoS5tSKET6IVZPOqpwCVnx5js4eyVs9nu+
         NAlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL2/8zIg+2yiplVPIG2115o9MHawfb05kgIbD7T4uYGaY7fPyp9swlTlGBIJm58swCwgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPmGDUDkOr3Ji8y2zRsghw2Xx+774m/1wsVqEmjUdMn6j+8/wB
	dmk4b3r+xc0k7mG7GR7OXvct5nN3aqH8ohBakK+c4cW0r40W/RNj
X-Gm-Gg: ASbGncvSL3HKCNHA8d3jcRUnS1lOQLld9RHwY20JjJSFRT/g9zDVcX+5HTUX4ioD+uu
	UDDOnBy83JKhvUUlOCczWlA63bAukABfe7er9tzkCMIj85kyvNMI8RfAA28PklAAMM57I9YkU9l
	JsOzz88PBCHYZhXgRdkARCrAmzaXV9W5hCK5XnD2qUPlhbrDWyHjrmPXOTZYgYQdcEGKGFHAEkG
	vA1lw8+fexgW/6vZWVkISR4kKwpa7oBfe+4s8igbEdPLMSd98IR4+eBnTQn6vFNWbRys4t94NjP
	meB/b78rybsONUHab5rDW7CiIn9uWw==
X-Google-Smtp-Source: AGHT+IEGnqHvjTQcLRnyMkLAE9ztFHcAU5dTxqXF5Hf4lQ6CpLvpEedhPApiBUzQIZ0A7DN/L5Ohbg==
X-Received: by 2002:a05:620a:4085:b0:7b6:ece3:827f with SMTP id af79cd13be357-7b6f252749emr77942285a.2.1733946224555;
        Wed, 11 Dec 2024 11:43:44 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d9063fc63bsm42992716d6.103.2024.12.11.11.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 11:43:43 -0800 (PST)
Message-ID: <18f7301c-9fff-4e7f-aa31-d9199ec1d137@gmail.com>
Date: Wed, 11 Dec 2024 14:43:43 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] engine/io_uring: add write stream support
To: Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
 vincent.fu@samsung.com, axboe@kernel.dk
Cc: Keith Busch <kbusch@kernel.org>
References: <20241211184438.106449-1-kbusch@meta.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20241211184438.106449-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/24 13:44, Keith Busch wrote:
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
>    https://lore.kernel.org/io-uring/20241210194722.1905732-1-kbusch@meta.com/T/#u

[sending this again because I forgot to reply all]

Please add documentation for tihs option. Note that the stream_id option 
already exists for the sg ioengine. Consider using this pre-existing 
name to limit the growth of fio's already voluminous documentation.

Vincent



