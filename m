Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6342135A3
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746725741; cv=none; b=kj4DkYyX31HOF7R9hI5UnkMfwKHewmBJY7yMb4Iz+HoGPIAYJ/ktzoppEAXcQWAReQDUIfHXTT7UC2Mj4OcxwLbrU9+PaYrkzi+kUBSWhgFCSFziJRl2y9sae9IKPtVl3wY3nF3BbZaDiX+0lSGnpf4XFSDUI+eiHU+xwj89YMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746725741; c=relaxed/simple;
	bh=vsG0EZNakVhemGx60v4i+ro5rnJCMBdzCq9/sJP7lyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPJBR0h3Sz92ApsAhmL+g1HChdfCZqrNYYA3+bRLnuUUC2JPuRnQy8OfylLgapWMZebZtQxmZ/DaXknHkuWptOQMC82gzE6T2jaSXiGjzpZ6DdOtoydr/4ABlq+0Uyr2bxenXr62ZvlHfGBjNcAyT8ud6TDlung2CxoKXzP+LHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qkh7kMsz; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qkh7kMsz"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d93f4fe5baso4405585ab.2
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746725737; x=1747330537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WCcdPX2eU9d1P800ahyxv0r6Hu1ma3gF6xj0lAnfzy8=;
        b=qkh7kMszZsyF2fIEiZHPf1aFI9DfCr0DQ7RBGVVdICXXPY63zSfHy0c7+1mjxpHu3V
         hujpOjQ1giDmOZA8sjji6OHMo0ikijVuIf/kKyHgiygiGtZBTdAu0eOdi11lMuPF8sey
         19vfylR6r6xvxvELfovcZPvKxhKfM3i02ADHpoCdLQPiQnT3u3wj3JzAbSG+wX+R6SpD
         YK5f5oB8/QmOfE319rDe3EjN2T4u2gUJszW5TSosVgBuUjx2kiu+lI/wyifdXMQ+aunn
         YP0Crg4HrPszVGz9sCl7hdHPV2DzxpyTTeTGFafmLhjC3VBhOH2ZGn5CZOd//K1THUaa
         nJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746725737; x=1747330537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCcdPX2eU9d1P800ahyxv0r6Hu1ma3gF6xj0lAnfzy8=;
        b=JK/lvToJWpjnzx77WhsUmJ8VRGg0GpBVGfR2nR6doMTyKljVBS3NdBxOGeEi0FbzJu
         BMovdNRnnR1X1e0SLHaTUQWDCdxEQyx/ZkFiLgNOe0Zyl9zRMp8vwLLKtQeg+0xe04n5
         8ULlXgtCRW65y9HiWVbGbiUsM22Zgbc3Bs96Jo03XGDsiF5nxNtjqQygcrm27APaNFAg
         jJ0QcfCc8b4VS9j080d715/CYwlBeeBAm7HpniZXe21I55JVO/B5HQ7DDvJYMWcKu++Q
         cj+s89/BoUs8tFINQw8sCsNt0a4IXKFSstL+farDcFrzANfM6n1Zg44zj20scyjkziuB
         XIEA==
X-Gm-Message-State: AOJu0YyPXljHVum82EHxSYMPhr2VIZnDN/1gk8OL//nVeyAYFNS/zN+c
	4VJhJg4kP34hJDdSfFofbQS8u6TAMNoROXSDk3QpU+DJyPHBDakSpZ1iye+LNiM=
X-Gm-Gg: ASbGnctOjTNk5/9DSp4drywINwC1+TxKPPrR0+EUabI6OMc5NknRpfesdc7/8x+Pu+U
	OUQn+4sVPIBV6zyATmWBNWn4ANtmblHtgIAsEP2xvGTRIRpZ1GZgQLzT0QsWeD9EuHSZi3los5A
	z38xFNcbgfdlJnr3kl+wPn7uulruTYjlCIUJRYA+AcoxKQrMmHiLL+Kf5P4+qTkdW/DWe3lsEPu
	YZQeu/zpxdjNEWoWTN9EHz4a4HE/agAz8PhwCNcpJehhQkQs1SNB9v/3SrxE5aFsm4a8u7RXupD
	rynm12QEaFwFQZifaV3E3Ocw/fehwZ8yEPqW
X-Google-Smtp-Source: AGHT+IEIu/WBHEr0gUdlNynLQdobKVneI37c+rVwn6Idu90U1DZJh27/mP+/y5Jie6hfo/WbZ71WDQ==
X-Received: by 2002:a92:cd8c:0:b0:3da:7c3f:22dc with SMTP id e9e14a558f8ab-3da7e216581mr4521295ab.20.1746725737341;
        Thu, 08 May 2025 10:35:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa224dc88asm57752173.35.2025.05.08.10.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 10:35:36 -0700 (PDT)
Message-ID: <2adb3a16-946c-4adf-9285-a251e018082d@kernel.dk>
Date: Thu, 8 May 2025 11:35:36 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
References: <20250508171444.2113-1-vincent.fu@samsung.com>
 <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
 <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/25 11:31 AM, Vincent Fu wrote:
> On Thu, May 8, 2025 at 1:18?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/8/25 11:14 AM, Vincent Fu wrote:
>>> The pread and pwrite functions for Windows posix emulation never actually seek
>>> to the requested offset. Fix this so that the psync ioengine works correctly on
>>> Windows.
>>>
>>> Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
>>> ---
>>>  os/windows/posix.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/os/windows/posix.c b/os/windows/posix.c
>>> index e3abf383..3e48c3ff 100644
>>> --- a/os/windows/posix.c
>>> +++ b/os/windows/posix.c
>>> @@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
>>>               off_t offset)
>>>  {
>>>       int64_t pos = _telli64(fildes);
>>> -     ssize_t len = _write(fildes, buf, nbyte);
>>> +     ssize_t len;
>>>
>>> +     _lseeki64(fildes, offset, SEEK_SET);
>>> +     len = _write(fildes, buf, nbyte);
>>>       _lseeki64(fildes, pos, SEEK_SET);
>>> +
>>>       return len;
>>>  }
>>>
>>>  ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
>>>  {
>>>       int64_t pos = _telli64(fildes);
>>> -     ssize_t len = read(fildes, buf, nbyte);
>>> +     ssize_t len;
>>>
>>> +     _lseeki64(fildes, offset, SEEK_SET);
>>> +     len = read(fildes, buf, nbyte);
>>>       _lseeki64(fildes, pos, SEEK_SET);
>>> +
>>>       return len;
>>>  }
>>
>> lol, how broken is that... Does windows have any offset read/write
>> variants, or is lseek required?
>>
>> --
>> Jens Axboe
>>
> 
> I could not find a better way to do this but I am hoping someone who
> knows more about Windows than I do can weigh in. Sitsofe?

It's probably not a big deal. I did a quick search and doesn't seem like
one exists for that.

-- 
Jens Axboe
