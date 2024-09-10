Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D5198842
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725987368; cv=none; b=USgMAY8H2xJgRBH/iPdtNgueRQ0scW9NPHeJhIeNRCO/Hpy7p9o+t4AZ69p3xI3Kd7xU1ATZGnoZ82t/TZry3PT+VdVYNGdsAQdOwpOmVqolsk76FH2kniUmNe9U9uQICEPT2FtbL2n8a7JddeR8s09hDHevnVhhKCdSTg79FME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725987368; c=relaxed/simple;
	bh=F4xe5U6HMwWlLuPTPB7pQZBAdLp4vmG45GUCx9XbA7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AdExC3V4ywydWo32x2Q5+27IGT26Y0eF4pnqGSaflYqrXZd9sfrpgCqZIuu9cKekTlsA+CtX9ie2UHGreoxnjLXNEmStMj1hoV5icxvSCOM8xZSX8tYle8k5Pz3scChoQXA/swKQrvrQlIXITD7eS9VC6Y77w6LMfEDyJ+zbWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZzWSxQzR; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZzWSxQzR"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39d4a4e4931so3355945ab.2
        for <fio@vger.kernel.org>; Tue, 10 Sep 2024 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725987365; x=1726592165; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KrHOCZmIXMBIga5nZmpWZeE/ir28ACwX9e4+H9aEfk4=;
        b=ZzWSxQzRL3oVwUiiHcILkJ9TiYE6Ciq8Zujy9yW4y6DNHK1OtBHFeI/9V2zUsvyEkP
         3SkVDJtjbXC0YivH7kwQfOwE2eA5t/LshJCcb46LbwLLjGFH0jLrBrnWq5WXQo3LhhkM
         5o2KsDsohOBvtBHfmCazE4Vrp2rBAEuNwXSm3MRmmtHH50pN8FoP0tNdevVFgrks6oQw
         RWLGJudKWawNkzoDgoZNCBrIbkySsYYEbUXo1PgUzQ3fAeaQa7fM4g73n3DFeh2Crxd+
         F+P28XFLhrG/vTCOHkCZLnva1wYoBIRJU5t/33wu5sZiBuTyyPHuIzmFpmEGqoHoyDhX
         jJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725987365; x=1726592165;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrHOCZmIXMBIga5nZmpWZeE/ir28ACwX9e4+H9aEfk4=;
        b=YkR6WdjXHvv2blMBk/qEk24MyfewVnPxao6W/c4kZtsOyWZyFeKOa1mBSPC8P1rYdg
         mhASYrs4YV9KksZjs4zcA4Ay2WqCz7ocaqIZJ0BAn+JRCTr4HuymCclaIM+0VS+8ENoT
         zbJ8m6nyo5oCZH5PpokDF8dllf1z3XmnGMKp1Ga3aPO1k4fIAkcie7CYo8YOo8hBx/Do
         wnSyy8VDjiMVgETcBprmtpfPnohyT/Lx7NrNJ8L+9HS8LTtx8nuvyAoGt32grns6w7Zc
         CBF7cQTZ9oD+D0iQ/tybLL4Jg5Q3UeR80j7GxlN5j1YrJsgdeNctQDWXDH5xRiWqg2+x
         s7hA==
X-Forwarded-Encrypted: i=1; AJvYcCWS0tGfLwhezuSVxVVtpkWrzggt7AJoU2umMHfVDLOgoqAcebZOo5WL/5wxzJ+GavtVZQs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5Bhl2KqDy/RAiK/aQSwe8ctJcU40WkrRRfq6WzwdjEEGHhVl/
	JvzDoInWBR0cWGgQbpO5jo+amBeEnVgYRS63aVlUjSwE2KDi5fdf6PinurXWLtI=
X-Google-Smtp-Source: AGHT+IEgrSZNKaOMRlPvV7Sh7Euf19nziWQWmUo+kbImF5sb37sY0uargHEO7Y+bF75nXKIaPBSB2A==
X-Received: by 2002:a05:6e02:1aae:b0:375:deb0:4c28 with SMTP id e9e14a558f8ab-3a07420f078mr5044155ab.6.1725987364596;
        Tue, 10 Sep 2024 09:56:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09451dbf7sm1711229173.4.2024.09.10.09.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:56:04 -0700 (PDT)
Message-ID: <3660f96b-ab31-40f9-9cfe-ebf5e84b0a4c@kernel.dk>
Date: Tue, 10 Sep 2024 10:56:03 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: John Garry <john.g.garry@oracle.com>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org,
 david@fromorbit.com
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
 <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
 <f689c9ea-b677-4521-8363-1c4f2f3c81f0@kernel.dk>
 <7255db3d-abb5-4371-9cb1-e12cf41f979c@oracle.com>
 <80443d11-538a-46cc-ae81-c2f945d68ee1@kernel.dk>
 <df880559-4408-4bc7-811b-353699c467cd@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <df880559-4408-4bc7-811b-353699c467cd@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 10:38 AM, John Garry wrote:
> On 10/09/2024 16:56, Jens Axboe wrote:
>>>> t drop that patch.
>> (side note - please wrap your email lines, I always re-wrap when
>> replying)
> 
> ok

This one too :)

>>> Some background is that main selling point of atomic writes is that we
>>> guarantee writes to storage will not be torn for a power failure or
>>> kernel crash.
>>>
>>> Another aspect of atomic writes is that they handle racing writes and
>>> reads, such that a read racing with a write will see all the data from
>>> the write or none. Well, SCSI and NVMe guarantee this if using
>>> RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.
>>>
>>> It can be argued that having racing reads and writes is an application
>>> bug. Furthermore, as I understand, even if posix guarantees that
>>> regular writes are "atomic", it is not the case generally.
>>>
>>> So one part of the relevance of atomic writes to fio verify is that we
>>> can verify that atomic writes "safely" handle racing read and writes.
>>> For this, the CRC checks would be successful if we have many jobs;
>>> however header sequence numbers are not. Hence patch 4/7.
>>>
>>> I had also been using the verify feature to test atomic writes for
>>> power failures. In this case, I run a single verify job with
>>> --rw=write, power fail, and use verify in read mode to prove no
>>> invalid data in the file, like:
>>>
>>> fio --filename=mnt/file --direct=1 --rw=read --bs=8k --iodepth=100 --na
>>> me=iops --numjobs=1 --loops=1 --verify=crc64 --ioengine=libaio
>>> --verify_fatal=1 --group_reporting  --exitall_on_error
>>>
>>> This power fail test is what I am mostly interested in.
>>>
>>> So my point is that the patch to ignore invalid headers could be
>>> dropped, but let me know your thoughts.
>> Gotcha, that makes sense. For atomic writes, it's totally fine to have
>> overlapping writers if the write size is in the atomic units, but we can
>> of course expect sequences to be out of order depending on which one
>> makes it to stable storage. But you have no checks for whether or not
>> the write size is within the atomic range?
> 
> I don't currently. If an atomic write size is out-of-range, the kernel
> will reject it with -EINVAL. However -EINVAL can be returned for a
> multitude of issues, so not much help. So I could add a statx call to
> get the limits and then error the fio config (if bs is out-of-range).

Good point, I guess that's good enough then. If it's an invalid
configuration, then the writes will get errored anyway.

>> I think dropping patch 4 and adding a verify option to specifically
>> ignore the sequence would make sense, leaving the control in the hands
>> of the user. 
> 
> I already saw verify modes "no header" and "header only", so I was
> reluctant to add a potentially conflicting new separate option to
> ignore the header sequence. However, I can look to add a new verify
> option to ignore the header sequence and ensure it respects those
> mentioned verify modes.

I think you'd be fine adding a verify_write_sequence bool and just have
it default to true.

>> And then bonus points for adding an example job file (with
>> comments) in your series that shows how to use atomic writes (and uses
>> that option) would be useful.
> 
> ok, I'm happy to do that.

Great, thanks.

-- 
Jens Axboe
