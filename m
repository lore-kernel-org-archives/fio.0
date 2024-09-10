Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8035419DF85
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983771; cv=none; b=iYNOfOpZZKf+0l3EpZJ6TNAwWV+8y4hxGfnwHEaU6lN/F9oDpdml/Yjs907TQH60BZyLJMHz90bxfJlMNWJmp8vUbrp74uQzqJBKKp1a0roOJvJVPPL4Z1v9gwVKVRrO2wCSjC1d2cFk5tILl024AUYPmO1rvcnIQB4/CGOaRds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983771; c=relaxed/simple;
	bh=oyHjx78Y1hYj+BhT8LdqzwBvknt4zpR7nOtaxsJsUBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FW3iO5b0OgfJNeAyzIgjOmoeTKH5xKsPnBu+RDQ+kPpp33jhdC9iKYWnONStkk4sXwV2HY6i5zxX7qfhdVFiWn2rTv0m+Kn/IkTyAoQIjHFRAjsbMUy4wfqYtMNazQbuOYKw+1LVtPZBSKkLMPhIneEF9f0nItjz01+8tpHu+IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P9Nn7QCs; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P9Nn7QCs"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-82ceab75c05so114793839f.0
        for <fio@vger.kernel.org>; Tue, 10 Sep 2024 08:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725983768; x=1726588568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=39NVOggJtV2jEcENDkiIC/H0t+OVBl9FGPG5Z15YY7Y=;
        b=P9Nn7QCsyqA9nrzQ4I8yhOHIPncn4WJgjzYZR6EDYKWntx0g1+P77OgTIV0w3xJMvw
         4lyuo0PXulFv5dkpTXoeYwSNPcIu/lnUokV0zmHpEFzGvXVQyXstVbuhSChsFCQHBxgv
         FcFtYiY9iH7qgF9vUqlXXI2f+jIaNld4ryEMxw4hBbZKZm1qkLNsTjSji7882bgU0ECe
         PYRQyDTz150HYIbMv8ZxRgqTJbHbQyEgTIx9GFRVSmJe+J3scM7UfL0A7FASgcRH0vKH
         cDrQJbPm6KlONKzIhkYe/l/0NFnFoO68FASezn4p4NZf4eGuPAut8016rP4WBd2fmfwi
         LBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725983768; x=1726588568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=39NVOggJtV2jEcENDkiIC/H0t+OVBl9FGPG5Z15YY7Y=;
        b=QWAYcQYfJHGjX1O1ALxlByrql+VDsialbcdvjohfURV1IQMSvrkJExyaXgeAa0tTAD
         ZhWWgHl+tV2KN1OIgzrJtEN2F6kKATi8X/IVNDhKZiYNnt1XSwCEY4DwlxXRLGLPjEeo
         RLyZONo7rnWKh6HHSmvEH/+NUZk/NubVXLLFpjAAkEu9aF/C1Go8n8pHLQjpRff/5xY/
         IGYO786aqAyp3bkS82+8amrFIjeyaXvEfV/D6wgVn4EJnaZpLNyC6G6a5I35Bcz04EJ2
         UudE0EDI8dyMzporyKVbv8h0ixCY7BuWzM5zF0bobkNQnJuQ3rVGS1BdcLH9rVL0Rlg8
         0eUg==
X-Forwarded-Encrypted: i=1; AJvYcCWFPMNHhG6kU6lqLU6dp2MBpUkcBmz3es4MeZD0/h1RV+Z6w8Z8Z9G3i6uIASoEKfBvCWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG4+GcDg1JdME5BKa+5LO/rQMoj+BbKfYfYdfQOxSDm34Revo2
	opQ/sPtDsFm6hYbopLwT400I0pyogIf/MR0fYRCY7VGA0rNEhKNKhBtk+Mr4gyQ=
X-Google-Smtp-Source: AGHT+IEDE2cNiokIIrtCaKxj6MHIQGIfKH05Piv4G6zs/SBEGU9x3LqvkCqY4XhyvBy/IXUxvnO3rg==
X-Received: by 2002:a05:6602:2dd1:b0:82d:581:8862 with SMTP id ca18e2360f4ac-82d05818939mr221099739f.10.1725983768486;
        Tue, 10 Sep 2024 08:56:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa73539bbsm209044839f.21.2024.09.10.08.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 08:56:08 -0700 (PDT)
Message-ID: <80443d11-538a-46cc-ae81-c2f945d68ee1@kernel.dk>
Date: Tue, 10 Sep 2024 09:56:07 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7255db3d-abb5-4371-9cb1-e12cf41f979c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 4:03 AM, John Garry wrote:
> On 10/09/2024 02:01, Jens Axboe wrote:
> 
> + Dave, who might be interested in this
> 
>>> I was preparing a v2 the same as this, but do you think that I should
>>> just add a new verify option for atomic writes to ignore the header?
>>> Or is just saying "you have selected atomic=1, so I'll just ignore the
>>> header for you" ok?
>> I'm still not following why atomic writes make this any different. They
>> should not. If you have multiple writers writing the same blocks, yeah
>> you will get verification errors. This is true for any kind of write, be
>> it buffered, dio, or atomic. So unless I'm missing something here, I'd
>> just drop that patch.

(side note - please wrap your email lines, I always re-wrap when
replying)

> Some background is that main selling point of atomic writes is that we
> guarantee writes to storage will not be torn for a power failure or
> kernel crash.
> 
> Another aspect of atomic writes is that they handle racing writes and
> reads, such that a read racing with a write will see all the data from
> the write or none. Well, SCSI and NVMe guarantee this if using
> RWF_ATOMIC, but it is not formally stated as a feature of RWF_ATOMIC.
> 
> It can be argued that having racing reads and writes is an application
> bug. Furthermore, as I understand, even if posix guarantees that
> regular writes are "atomic", it is not the case generally.
> 
> So one part of the relevance of atomic writes to fio verify is that we
> can verify that atomic writes "safely" handle racing read and writes.
> For this, the CRC checks would be successful if we have many jobs;
> however header sequence numbers are not. Hence patch 4/7.
> 
> I had also been using the verify feature to test atomic writes for
> power failures. In this case, I run a single verify job with
> --rw=write, power fail, and use verify in read mode to prove no
> invalid data in the file, like:
> 
> fio --filename=mnt/file --direct=1 --rw=read --bs=8k --iodepth=100 --na
> me=iops --numjobs=1 --loops=1 --verify=crc64 --ioengine=libaio
> --verify_fatal=1 --group_reporting  --exitall_on_error
> 
> This power fail test is what I am mostly interested in.
> 
> So my point is that the patch to ignore invalid headers could be
> dropped, but let me know your thoughts.

Gotcha, that makes sense. For atomic writes, it's totally fine to have
overlapping writers if the write size is in the atomic units, but we can
of course expect sequences to be out of order depending on which one
makes it to stable storage. But you have no checks for whether or not
the write size is within the atomic range?

I think dropping patch 4 and adding a verify option to specifically
ignore the sequence would make sense, leaving the control in the hands
of the user. And then bonus points for adding an example job file (with
comments) in your series that shows how to use atomic writes (and uses
that option) would be useful.

-- 
Jens Axboe
