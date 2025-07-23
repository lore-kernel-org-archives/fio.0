Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878C91FE44A
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753291378; cv=none; b=B0wvs5rwtJr1YMzrvpbDKQXzCtoh+oQyuGvQKs/cC1ztCrBKNJYT70SXGxrQnizHqECAbfwV9OnL4UytpFxrQ9LD2xKy+bcC/FVZKaYLDO1hGuhdaxYoJjzI8WqEjKNKgMOKWj/SeXC5Vu2kf8qi4a1T/6bJctL8iikOk9E7tmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753291378; c=relaxed/simple;
	bh=90QtLM2fTzn7+gBFndqS/fRfrEXz1rNuR6aZzKQHesI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XeIpC7fvwzwua+7swi4yIDsEE/DPwu1POBUrnCN1+bAIEkQN5NxVcSj36lQrfmYEK05yt5umG13xHmLDYQm66nxK6Gby42tURe6NaxrXjzbz1ZbcIn5Z558domhvmxxAdXc93x+O6+kbZBCnMwgZiMK0BiFeNht0NvjMVUK+33A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGo6EqJ6; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGo6EqJ6"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-704c5464aecso1139806d6.0
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753291375; x=1753896175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+4DAANqNgV/xc0QmXIqTWHMKdE4Irjr2T1yOA9G3j2w=;
        b=OGo6EqJ6Arm4RSKIY+dpkUe8cm+MA7pDWK+0i/J+ve6J6lteAVuIuaGrpYRc3RzIdo
         WN/lBMwbjbLc+nn/Ma7fw1N7UqLIkmOsy2GN/4Z/8eIJTLf5UoMzqTZ/vbgnsVmXAbRz
         PLm40TsuqLAmVtbBJh2lR3K44Jviu/7syoOReBn/ReulS7U06tcaKpCt8X42XtMN8SsN
         dSXZjfK99LT1i+kQUpIAzvR8QCz9wJysNl+YXWLo9+UTG4rvtdDvsXgY3C/kcVHRt1n5
         BPStAk7gftk50tIv2X6qLHEG69e8Nxuu8ArqGygE5wqyZ16eEZEC9DNK73njaJxvQtYy
         oAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753291375; x=1753896175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+4DAANqNgV/xc0QmXIqTWHMKdE4Irjr2T1yOA9G3j2w=;
        b=DkiTE1MDeS39Vga3fBxPmTtWl31w2WgSVJiEL9m3EX9Xdc5djM/yYpHW6FuMVXEIi9
         ofWBF4CwXZN6JyDHZ4C2NGRXIi0q6nk1ol3Tot2y4SMLCQK2BXm1HH5P7Bu5XaJpEvRK
         12MUJUcyg+xUPBcuJR2ai1PHzenfbIMmcbr0asRPSBEeOnQmVaeqwxbmV6knRIKeg7/5
         JjUAtlsR0+OUunYehCy9lFyM8FPsfWRCS1Y+OUwymGyBohhZZsq49pdBexGsedIbyzEx
         RiqaGyc5t2W5KMBZgVrTveqLYjMhfH7cDKwNxwYamyb9e7a7tsxyzIY9cWonHhE9bh7K
         H72Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0noqMhELyOSxQgpptgW0ilPwHUU1573XVgqF4FRv586p5O5UB//ByYZ3VoefYKUhWnCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfJVdg5JM3YLVdFMR6wi1pABHDAihMD1D9gtTu3Uwznj4K5hYk
	mXMCSohhuLzCNF61WguuDh9+Fhd6/uf79cNvmh5glNYk6jaM1BRxR2IX
X-Gm-Gg: ASbGnctqlKdbhSSjD39QyeGjGEPGJZh5y4LiNh+GHfRj4fIoJ4hxOXBXWGo3Z6AGXyE
	6Dh/qtxpmeIXO+4g6eV4bnB2Jf7sLmW0RCRK0RMsEokjj8CS/6gJsJ4T3zzPYR7RITPM1MbDWLr
	1vVfZrBH44xTE1YkQRbhR08Ds0fap6I1/Eu6KaYP5/SPUvDQz6ZPwzocIOj4+Rlj34PSfkq5RwD
	1ptq3fI4MRuZ/dLFgCO3Qz5Q0gZvNF0ty+TryYzhP475/FzdCti7x4FMlWO5UbRA7+bJWjfBg/E
	KgyAtBSfiye5YMAliHSFT1dAXnuzM8znew9/9VYdzQMvQpUOw26J4q5i2Ju6bgISXAg3uHJnuKQ
	xbbr7gN5+yLlas+zr0rBEVuYpe1OvIFmFysGoTKOlSjmZEmjeBBtuaV21vF01Y6i98dnmQD1Bxd
	I56fP4ig==
X-Google-Smtp-Source: AGHT+IG0m9DDoK5p1e5oCFFAxYTbYFFePv+LyRxRBFWrFZ7WHn8oCwjinl59xuIZTfbFeBx3GUhvRg==
X-Received: by 2002:a05:6214:5005:b0:704:8e39:4c7b with SMTP id 6a1803df08f44-707008513fdmr63950786d6.40.1753291375136;
        Wed, 23 Jul 2025 10:22:55 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051ba6b755sm66452176d6.58.2025.07.23.10.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 10:22:54 -0700 (PDT)
Message-ID: <d3dbac97-318e-4df6-b6df-0c14184bb8c9@gmail.com>
Date: Wed, 23 Jul 2025 13:22:53 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FIO for random seed usage -How to verify the data validation
To: "Yan, Jane" <Jane.J.Yan@dell.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <SN4PR19MB547124FE361F26649D8C7517A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
 <SN4PR19MB54710097436252E45CEAE9E1A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
 <SN4PR19MB547194A3A4A1560CB9A2D2F6A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <SN4PR19MB547194A3A4A1560CB9A2D2F6A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 10:39 AM, Yan, Jane wrote:
> 
> 
> HI, FIO experts, how are you !
> 
> Currently I am using the FIO tool for some testing ,I got a problem which may need your help , Thanks a lot.
> Seems if we used the randseed ,we could not do data validation correctly.
> 
> 
> I want to use the randseed to generate totally same data pattern to do deduplication seems we cannot do data verification if we used the seed ?
> Can you please give me an example how to validate the data with randseed. Thanks .
> My step steps:
> 
> 1. Write configure file:
> 
> [write_test]
> filename=/home/cyc/tmp/seed/testa.txt
> size=8k
> rw=write
> bs=8k
> numjobs=1
> iodepth=1
> direct=1
> sync=1
> randseed=383733983
> buffer_compress_percentage=50
> randrepeat=1
> 
> 2. Validation conf file:
> 
> [write_test]
> filename=/home/cyc/tmp/seed/testa.txt
> size=8k
> rw=read
> bs=8k
> numjobs=1
> iodepth=1
> direct=1
> sync=1
> randseed=383733983
> buffer_compress_percentage=50
> randrepeat=1
> do_verify=1
> 
> 3. Modify the file testa.txt and then do reun the verify file , which did not report errors this is not expected as I change the testa.txt file ,thanks
> 
> Thanks a lot.
> 
> 
> 
> Internal Use - Confidential
> 

You need to tell fio what type of checksum to use for validation. To 
both of your jobs add an option such as

verify=crc32c

Then fio will calculate a crc32c checksum and place it in the verify 
header associated with each IO. When fio reads the data back it will 
compare the checksum calculated from the data with the checksum in the 
header. If there is a mismatch fio will report an error.

See also this overview of fio's verify feature:

https://github.com/vincentkfu/fio-blog/wiki/Verify-overview

Vincent
