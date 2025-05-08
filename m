Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38867207DEE
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746727256; cv=none; b=WiEee02FOsFHHPdylQQMVvGMA4PMeK5mfERUohKp2tfTcxom9wIh9+a4BkOPFkIgteqHmYgIn62GlX3Lh2H7qNCnURLNqoDkgzSrUQCG4qKVUULx8GOLrfaUV2T9qVIh/db7dqdB0m7oQ6Ln85b6a4LmbSfEH86A0uvkSSXFRaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746727256; c=relaxed/simple;
	bh=idTdPQ5vocZkOZogfcpn2BTPBozlreS7rgrqMkeQHs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qu2r9NeIRxXbJzvfbinYoFOHN4OMj3QqZBNi4bBLa4+lharCBW2tlBZXTx/yrep8thKFhyMdg/b3SxeeT1bZgWI2PloZtqS+9YyduMjKvHkqngnZe23sJaeFXCYawBmxAxohlI47Yn3op2Y4g2fP41bpl835XQKxyxQ/yHMw7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CofqUtk9; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CofqUtk9"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7c5b8d13f73so166967185a.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746727254; x=1747332054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBtjJg1jqOL7GE+L0+dxVPMGoa6D9DxYlcVnmb1EIqA=;
        b=CofqUtk9onVcsCSkcqr5VXppy5s/1vZ5zuybQf9V3TLzJtAI1nOTU+Jmknl/xV8vuE
         neLttZkgDvclbXisjQSHPj9Q38hS1TxKHBsUnD5YqikK3Z0z5ovzlvoMoM7wL6kzy8/x
         mGwDrgnC9hBA4aJcTNDulfj8m3oOcT7xnHY0kDUIHnB1sM1qejxXWDjFNlGPKo2sEK6v
         eOFXY32awGAIhAEreFIB6tKZELJTksQjst8kkmxea6qMWypjUcOTnz6ayhoXUMQ6HZRx
         wnAyMnQbUqTe5fP1xtrgqxJJ0afnhty6xSJP8FOPHSPRebrEUQbdKItjgOqXxQ8FaKOO
         4HRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746727254; x=1747332054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBtjJg1jqOL7GE+L0+dxVPMGoa6D9DxYlcVnmb1EIqA=;
        b=IKk+tjPYgUlRB4jfOVB/0JkoTpuFiSML3F4BwdK/4jRyWdgu7rBKeQpp6oWKjtPtKQ
         Ut0kU7O8NwpnNn6ZwaHp1Qo6VrAzIaMCPapXy09CEoWy35oyVtjdJ4vd+JVYtEC8X4gV
         VjKyKO9gbYWoJ94okgJrR6IFJvUCbF3/WeT/NpmeV3RKqYF0N99D5WXS2a+mx4HkGcWD
         0Ei40Uwes8B5nlQsM4BRMDxXN2SCmBG+yAuIYtDkiUDlyW/qSChzzx2aJZDRSiV1acYf
         wr17u7igzzQKgvWi1pIvS0rMnlDEdQ19sSpK92CFERmwVJOSHe9rm/4EKd1vW6bEvk6F
         bFdg==
X-Gm-Message-State: AOJu0YxjBGvt0tYH0VJX/sOqqfRPm2xTS83PYBM0OpAJIr7CJk74mTHJ
	DVYCUcQO9sMsiTTbXd/bH9GgbZoz3TxjRRJS5Yu1fZbc47xBPsjeq1vxQ+6m
X-Gm-Gg: ASbGncs7pptCJnQGyFhJLz3+I0xFW6aFYzGUG9L1Xx0x5fEMeL6A4Ut8vD684k2L7N1
	sab3HXgMV578dgYniDe9K8jPN3b6ZgB5t2/4Rza8/2HpgeCAJ8646CKcskui+pV/oSOnIPrVxVM
	sumxSKHss48HfMcnjgIJhh1CxhUN604YyUfteDsifVOM40cn8Z7dn4EvGMC5fvg7BRhOidij/Op
	WbRIGR4a39DAaq5TeplSONSldg10qyQHCS1dY0WRYAIaMNTRmD+lRD1jt/v0/Sq71dmtaClbRMA
	Yu8S5CthK1M3Lke6/fKW5asSRrkUidE+e0g6mw2gxu0U08eWqtyBDMZlUgJ0DTtAQYFlL2GRV4A
	iJzbZfzKy4OCHayNV
X-Google-Smtp-Source: AGHT+IFxPWCeu3rFIHKx2YtjnNela8JcoadPm8HzVBFbOvVCpysrSXJ9QZVh0yhh6HnPFg0129j/1Q==
X-Received: by 2002:a05:620a:4556:b0:7ca:bdbe:c5af with SMTP id af79cd13be357-7cd010f3f30mr83688785a.10.1746727253847;
        Thu, 08 May 2025 11:00:53 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4e172sm21564685a.15.2025.05.08.11.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 11:00:53 -0700 (PDT)
Message-ID: <44bebdec-119a-4039-bbcf-db323d74cc30@gmail.com>
Date: Thu, 8 May 2025 14:00:52 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
References: <20250508171444.2113-1-vincent.fu@samsung.com>
 <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
 <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
 <2adb3a16-946c-4adf-9285-a251e018082d@kernel.dk>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <2adb3a16-946c-4adf-9285-a251e018082d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 1:35 PM, Jens Axboe wrote:
> On 5/8/25 11:31 AM, Vincent Fu wrote:
>> On Thu, May 8, 2025 at 1:18?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 5/8/25 11:14 AM, Vincent Fu wrote:
>>>> The pread and pwrite functions for Windows posix emulation never actually seek
>>>> to the requested offset. Fix this so that the psync ioengine works correctly on
>>>> Windows.
>>>>
>>>> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
>>>> ---
>>>>   os/windows/posix.c | 10 ++++++++--
>>>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/os/windows/posix.c b/os/windows/posix.c
>>>> index e3abf383..3e48c3ff 100644
>>>> --- a/os/windows/posix.c
>>>> +++ b/os/windows/posix.c
>>>> @@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
>>>>                off_t offset)
>>>>   {
>>>>        int64_t pos = _telli64(fildes);
>>>> -     ssize_t len = _write(fildes, buf, nbyte);
>>>> +     ssize_t len;
>>>>
>>>> +     _lseeki64(fildes, offset, SEEK_SET);
>>>> +     len = _write(fildes, buf, nbyte);
>>>>        _lseeki64(fildes, pos, SEEK_SET);
>>>> +
>>>>        return len;
>>>>   }
>>>>
>>>>   ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
>>>>   {
>>>>        int64_t pos = _telli64(fildes);
>>>> -     ssize_t len = read(fildes, buf, nbyte);
>>>> +     ssize_t len;
>>>>
>>>> +     _lseeki64(fildes, offset, SEEK_SET);
>>>> +     len = read(fildes, buf, nbyte);
>>>>        _lseeki64(fildes, pos, SEEK_SET);
>>>> +
>>>>        return len;
>>>>   }
>>>
>>> lol, how broken is that... Does windows have any offset read/write
>>> variants, or is lseek required?
>>>
>>> --
>>> Jens Axboe
>>>
>>
>> I could not find a better way to do this but I am hoping someone who
>> knows more about Windows than I do can weigh in. Sitsofe?
> 
> It's probably not a big deal. I did a quick search and doesn't seem like
> one exists for that.
> 

Ok thanks. I will go ahead with it then.

Vincent
