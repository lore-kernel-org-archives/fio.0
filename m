Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902BA823C6
	for <fio@vger.kernel.org>; Fri, 23 Feb 2024 15:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708702446; cv=none; b=En8dKtb7g6eJ5Zzu8t8qdzqnMMvax9jFBqXX+JtWmGUoZMvZ2tJ5zUdTe2SxdRP481SLaO/EB79KrQFiGuevANefjnp2LxkbMiIMBACdCvMfNVdbBZuka6lOXDZ07P2CHquzXKgt3CMaGUHZbH0/euQZY/S1O+ozpKG6T+VhT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708702446; c=relaxed/simple;
	bh=XoxbMBUWjXTKb2zA0pPNXlZdz7FO61BzvERdJ9tK03o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RSlVQPKZQfINL6UkNCZGRbDRHxTG82ZBPIIpxpxXeKrFWHXp0A2Xe2Ujcsf1cZ/ibxTevOI2hyfd3bMlTaJQLUfsEsmXQHHbiGUhOVY5rl4ovYx0WXwV8OcpuiUjOY2N5hENUciMfrxwtZChd+P+U1zpUcSER0aSzsqNfcBnGKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPFZfoz8; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPFZfoz8"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-787aca0b502so29776585a.1
        for <fio@vger.kernel.org>; Fri, 23 Feb 2024 07:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708702443; x=1709307243; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OAfNOKgLYX/PHqEzPPrq1NLjx1BsQXs6+4h39Oxvoyk=;
        b=bPFZfoz8nY9qc46pD693/eEWJO87qg+vhMBWCrKnvyu5F6thJzE8zTTkwRS/m48WOB
         Nhuy1KNV652So0laCmfcoQtxoAUFjGQ9G1s3BVdxFs7OmKivI5zuRJUaCcWindU/mq8T
         mXkjnNzYTvP13d9GLmsaFFqw1L+uQph16q46uCsvKO6souXlFV8ozfEkInOTq/QRrTuz
         bd4G22xfKKNtElU6DX7DNoyOe89J1T8ENtbvoKHjTh+j0kf+HRW68WDX6Pphqcg8AvnE
         74lDXneuIQm1oaeIFV9CIBzUlD2g+LD+zDFiOzg1m1m+8wagBURqLoNKGatUQvFrLDMI
         mqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708702443; x=1709307243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAfNOKgLYX/PHqEzPPrq1NLjx1BsQXs6+4h39Oxvoyk=;
        b=PC0iHT15amH1KLgrBzIGWnUG14Ii1jGejiD3dorrl4gAk0hKbX2hsZX3kGsq6DtZpq
         3d305mBDvw+7Zm1kuQrDtB5sD7LYHBah+40vZTOl7aYVHCft9kAdRVdYwZ+VGCvimI0x
         mQy5nXYH4+CEXa4a6z3qYE6aOK+fT+DXRD3pn7AVHXT+6KLJiIAPqkhQhkIeH8YSdjzo
         vrr20rGl9NYwSzRqhqiqzEaSfH4Yt9Yjkk26Or4lewj53okw5Gzdcbevkex+HigEP9QO
         vE9OGExWHli4kT9MKOhACg5wJY0jaqROOFWQsl327plMT5wHgoIbLOcgdlQLj3zB06fu
         UWTg==
X-Forwarded-Encrypted: i=1; AJvYcCVgPObsT5GAMKgqMcl2nVwlqA5BeNBGq3bq5Po/shJuQZFyUfXJhVyWTqotQi0sGmDPsil5fMuCfIhpiKLF1DyyjY4I
X-Gm-Message-State: AOJu0YzaUocj4L8lXA/0quviJ0TVlkRnalPUqZsfy+z/G4/gt9kjJhrA
	exYfZy3of2yPYjq7mkYN762pOI5ptr3B/obPPHIiXPf8frzxnfQC+YgshvQ/
X-Google-Smtp-Source: AGHT+IFcJY10+g50ZDzz/PWTB68PdEYoCcRDkwU58C7Y2E6ltWwnnfZa8yATC/vJZbLk45qEJGukhQ==
X-Received: by 2002:a05:620a:4c6:b0:787:80c3:fc1d with SMTP id 6-20020a05620a04c600b0078780c3fc1dmr159302qks.49.1708702443297;
        Fri, 23 Feb 2024 07:34:03 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id j16-20020a05620a147000b0078749c88a19sm6533919qkl.0.2024.02.23.07.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 07:34:02 -0800 (PST)
Message-ID: <ca148e22-5886-4b49-9ac6-c82906200122@gmail.com>
Date: Fri, 23 Feb 2024 10:34:02 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: high cpu usage when replaying iolog
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
References: <CAF+0mvmpbx+tcfrH7gz0paXhwg9WVGtD96NS68_2_WsXNKgC3w@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAF+0mvmpbx+tcfrH7gz0paXhwg9WVGtD96NS68_2_WsXNKgC3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/24 15:15, Matthew Eaton wrote:
> Using fio 3.36 and the latest fio from git I noticed high cpu usage
> when replaying iolog:
> 
> fio --name=replay --ioengine=io_uring --direct=1 --iodepth=1
> --read_iolog=test.iolog --replay_redirect=/dev/nvme0n1
> 
> cpu          : usr=50.27%, sys=33.79%, ctx=45686, majf=0, minf=11
> 
> When I revert this commit the cpu usage goes back to normal:
> 
> https://git.kernel.dk/cgit/fio/commit/?id=b85c01f7e9dfc468eb78faf86692433e6105178d
> 
> cpu          : usr=0.23%, sys=0.56%, ctx=219444, majf=0, minf=11
> 
> Is this a bug or expected?
> 

It looks like the original code had the thread sleep for the specified 
delay whereas the new code repeatedly polls for completions until the 
specified delay has elapsed.

I suppose that it makes more sense to poll every once in a while instead 
of continually. Also we should not poll if we are using a sync ioengine.

This does seem like a bug to me. I would be happy to review a patch 
fixing this.

Vincent
