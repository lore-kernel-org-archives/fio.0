Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E05146598
	for <fio@vger.kernel.org>; Tue,  4 Jun 2024 12:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505633; cv=none; b=dYGmcQBqEE/l07zC9t5oE02nD2pcG4TscyZPs0Amo9qJdYynXHZlaHhWR9zrlh3w4byuGbA8Mr47mKaemBKr0AG6cu3FNZ+Ye5YDWECvF1VSCqEyX/Ly5jhsA/SEndGU10U5teMWYyGB67yejmyCfDumKI7aaJ5quW2uX91mjng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505633; c=relaxed/simple;
	bh=RHuj+tfvbqT1GXyQFAfq3FhvTeqSH/pkscRaw0ZN7jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d3Q+UJcBQsCV2KzTBIQi8D7RwSY9r6n82zK2PXvtZQJm8CsovZjDIrxzfcZiuxZ42cDyHCNK19xziQZT1ZSYlp8NRSZox7XlqZy46rOJA671LMpf4jpKPRM/XkEdro7Doof9UbA44NSRU+dYq2JxOnHPp1li7AKLsGMIh6VH35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B3PZvS1t; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3PZvS1t"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7950fac3f6aso93918185a.0
        for <fio@vger.kernel.org>; Tue, 04 Jun 2024 05:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717505630; x=1718110430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ZsnEfPX70+VxE/URYJUUl6Xw1ukgq7lj8u9EnISk6c=;
        b=B3PZvS1tZwXHGuGNF9/QYDSZeUC8LClA9BjH6VHDv0riUVmgqR0D19PgbZagqOiY0d
         Y5VaB91TAjF72D3yoT5MNfnwWBwffqK5znXVzTI7DQRCvA45mnKCVPxtTWCGytDMQx5O
         I9fk/buMCWUO/QYcoYL69ZzaGPvRrFTEwjpnbqkYoGBYZH5caYr/DVENJSaMI1/O9UZh
         mDKWSfKjgIvJTlnw26gSNNN7Ktu9JeuaaFi/f+6SsRCgcnTr67JAJwYlPA6gXvIAqGfi
         IgfSfh4JIInEeeRFgJeg3c8HMU7tgP+nc8f14shin++uTG7m8V6EGmOq4ynSLvXXr0jZ
         sbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505630; x=1718110430;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZsnEfPX70+VxE/URYJUUl6Xw1ukgq7lj8u9EnISk6c=;
        b=b3uKIrfkd6xKXMoxkxmUbRgeRxId4JkGNZ7MYoN00y/IcEYdjTjEs7mHDc+TvMWIX8
         zbZwhQRvhxPUTKTLd+xKSm2CArrNwUKC5zrf9uHFUaiYT0gRRYa6qVDJVx2bw/HgtoZH
         0yKH564IvLvqtuSSgFw1A2aRiOZwWbDENXRdZQcLUSV6m4KkAG0DbkGCDjeBe5If5y3g
         QJNSzz/EsByS4jDEFAbeXqofI++BsCamcFKUO4eMpJIpojyG5WKHbIqrZSLsroSOdu6h
         b22EsifNafTjyhEhNYk19SkKbXUms50pREQDL4UQAlHGa80mo29+m73UiM/E1LvMZ+5u
         5nbA==
X-Gm-Message-State: AOJu0Yzr1zEJ9FQ2QWmQra2wd4cy//mBty0HuAPcxBFewYB+65xolIdI
	XbDEgh0YIal3jVGOc5DchqYevNirXHoW/wv5FWLYjz64bW6eCvgs
X-Google-Smtp-Source: AGHT+IG5ecwNtoqDI1f0zrFuvMesa7PqZ4C3xAIH4WnL0liKPHwCIPTEeU7fEQkF09oaWZdzjULdlQ==
X-Received: by 2002:a05:620a:9c6:b0:792:c0b7:8eb8 with SMTP id af79cd13be357-794f5cd45e6mr1289068485a.61.1717505630186;
        Tue, 04 Jun 2024 05:53:50 -0700 (PDT)
Received: from [192.168.1.206] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43ff257d7aasm49336851cf.81.2024.06.04.05.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 05:53:49 -0700 (PDT)
Message-ID: <a785e38c-809f-4b99-a9f1-dd7b1cbf7e32@gmail.com>
Date: Tue, 4 Jun 2024 08:53:48 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Recent changes (master)
To: Niklas Cassel <cassel@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
References: <20240604120001.4A9441BC015E@kernel.dk>
 <Zl8EgAp7gEUMQSmZ@x1-carbon.wireless.wdc>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <Zl8EgAp7gEUMQSmZ@x1-carbon.wireless.wdc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 08:11, Niklas Cassel wrote:
> On Tue, Jun 04, 2024 at 06:00:01AM -0600, Jens Axboe wrote:
>> The following changes since commit 93dc85482a998440f8e40814014da8cbfe9cf5e8:
>>
>>    Merge branch 'fix-coverity-scan-defect' of https://github.com/parkvibes/fio (2024-05-31 09:46:59 -0400)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.dk/fio.git master
>>
>> for you to fetch changes up to 1757469a81cac5bd662b9cde26f1e5d4f0402181:
>>
>>    Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio (2024-06-03 10:17:38 -0400)
>>
>> ----------------------------------------------------------------
>> Minwoo Im (1):
>>        io_uring: Add 'write_mode' option for optional cmds
>>
>> Vincent Fu (1):
>>        Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio
>>
>>   HOWTO.rst          | 16 ++++++++++++++
>>   engines/io_uring.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   engines/nvme.c     |  4 ++--
>>   engines/nvme.h     |  5 ++++-
>>   fio.1              | 20 +++++++++++++++++
>>   5 files changed, 105 insertions(+), 4 deletions(-)
>>
>> ---
>>
>> Diff of recent changes:
>>
>> diff --git a/HOWTO.rst b/HOWTO.rst
>> index 0b39a892..33a6ad93 100644
>> --- a/HOWTO.rst
>> +++ b/HOWTO.rst
>> @@ -2857,6 +2857,22 @@ with the caveat that when used on the command line, they must come after the
>>   	With writefua option set to 1, write operations include
>>   	the force unit access (fua) flag. Default is 0.
>>   
>> +.. option:: write_mode=str : [io_uring_cmd]
>> +
>> +        Specifies the type of write operation.  Defaults to 'write'.
>> +
>> +                **write**
>> +                        Use Write commands for write operations
>> +
>> +                **uncor**
>> +                        Use Write Uncorrectable commands for write opreations
> 
> FWIW: s/opreations/operations/
> 
> 
> 
>> diff --git a/fio.1 b/fio.1
>> index 9a965cb0..2649529b 100644
>> --- a/fio.1
>> +++ b/fio.1
>> @@ -2640,6 +2640,26 @@ unit access (fua) flag. Default: 0.
>>   With writefua option set to 1, write operations include the force
>>   unit access (fua) flag. Default: 0.
>>   .TP
>> +.BI (io_uring_cmd)write_mode \fR=\fPstr
>> +Specifies the type of write operation.  Defaults to 'write'.
>> +.RS
>> +.RS
>> +.TP
>> +.B write
>> +Use Write commands for write operations
>> +.TP
>> +.B uncor
>> +Use Write Uncorrectable commands for write opreations
> 
> FWIW: s/opreations/operations/
> 
> 
> Kind regards,
> Niklas
> 

Fixed. Thanks.

Vincent
