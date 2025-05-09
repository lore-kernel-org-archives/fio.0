Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679B11CBA
	for <fio@vger.kernel.org>; Fri,  9 May 2025 00:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746751440; cv=none; b=le8xIuNdXVYP8gp/6xd2SJxWdDtT3vMMUrjfdCzoKsAyfdV7VAhp5+UaCcpAepF/Ix81+camLMenOuwYoJwNGeEz4QX9wqwzM4zLPxjP/VTl9APKPXsq8/lTB4vUAtHfrJqBhpEMk5YS8sOkzNUBVEddiVNrmiauqSMMeUnDvmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746751440; c=relaxed/simple;
	bh=SIGOaPBIBXP0TloWwyYgBYvL47c49/7GUJUqMILiAJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fUzhib6L48zObJ0zFPbAmT9jqyV0GUsvcK5KCBWH9jGyz6RgaX005LlC9BkEjxPsiNvFZORYpW2x+NSd6k+5gZDWNxlp/oyrJz3osVn1SppTe756bmgHf6k8DDFc6TQklZ4oF9EHqGnXuOuyXQ85CEEmFzmlvld2KItagAWM78U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biQmMNFa; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biQmMNFa"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c96759d9dfso249911685a.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 17:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746751437; x=1747356237; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7LGRQ/i0wAdC2XaXoP4RgsTj7c3bOC7ZUUT7sC6qEak=;
        b=biQmMNFanYRzLsjxu/WMUgGE3s0dPHrP5qSqKefgj/EepU8Id/tq9bLKRkkkuujJAz
         DR0AOFFNZEF72g1lBBnvWCJ/3mEFBs2abxYNfjx90eSb39YcajM3Nb6YVulmi8d0pLsp
         hMwpDOPEKZuywLI5mPPxL3lru/CGgz7KkZF5FKVJzTjNR+RKe7Qbvs1NHK03DLSEdUjz
         7g4GIG2mwg1gxgm7YIooiQ4slDXE5TmVUV4Iajw/rY2ePEUrwmsZU6KV2k0d8gaa1tZH
         r/MwuEUsVWiV90l1UFZj2aWZr6tUdslKtbhNIpFcrDwRrDCMKP+HzNxeiPzDpUOiWi7D
         BgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746751437; x=1747356237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LGRQ/i0wAdC2XaXoP4RgsTj7c3bOC7ZUUT7sC6qEak=;
        b=S9GRQnWwE3D6txAT9U3z0A5aKIRlBgshaCb7jiSOfL9zkluGCSN2SACsdzRR3kUvNk
         TyDFBGPzfiodEuu2mZdBIOVoTQXjs+WPhDnarHQ84URIXtG2cblCeoxzOC5Qc01jLu/G
         uetlcrLsKjTrZrQ/qzMd7cQBg8CyzEJCy6FRwc3nvt96i+5CKS48cwfilbMxKtRo+/j1
         AM5L4XnsOcF/7T58LWn8fSsZXG7DoKjbcKKt5GhhimvPwAMgVHNwJ0sX9v6T8fQljjn4
         2XYEoeTGhvVNnyxh/d6V+f405NacndENBiP9OpnhBdplXoNZDlo79JL+KTwFWiFf1IKM
         xLfg==
X-Forwarded-Encrypted: i=1; AJvYcCVXiW9INV1s99jm7bHHtcqU0DiDy9ShP0ZSvv4c+w8z38adtuKzVi4WhCrVw6NSlIlI2zY=@vger.kernel.org
X-Gm-Message-State: AOJu0YylkdNOP1+Sitl8WkWCQOMVxwufjLe7JVw8obkXxJJ5x9c/s8jl
	VsOm0MYHj0xF7Yo2wcDBYdo4I5okb45rRZFiQcF30VsgguclOtuh
X-Gm-Gg: ASbGncuNsSkRl8is2Vc6Sp45CjFyjnVlOBPZa1OTa8FyckK89QEobNXz8M7dKkCeLiN
	aQR/oHV4NP6VRpcXg+jTMlyKRBy0/59DWPbxq3cLzy8Qo58+ffsCITlG+fb2jeZh1622q9+7dmH
	gpVeVXthhxn8+pMEoKuiZMt89gsihSsYsirt/1yrHi6gtKvVChyFft8ePNoEQV50aeq6mc+5gpw
	SA3y1jg0gNllFrtAJHd5B9ERi8z2tWqMNh+w/78rPwg7Qzb1ga5+Rk0Gq55DxkWMRRtRg/ObIrE
	0edPIrr9OUcki/j9sgwtpZ5bXZAVZ6SqGuko9FEA1sWQaLl64RqGZqm78iyuwGSFmoxuP8mcclu
	NxviGw7QZdQHctj4Z
X-Google-Smtp-Source: AGHT+IF7SmxYCzAqWUTOBTHgkCKToCQ34iW9hqy0MCJrlnGemUd+tBtNT32XhOXGCdhIbropz0Y6cQ==
X-Received: by 2002:a05:620a:318f:b0:7c5:4adb:781b with SMTP id af79cd13be357-7cd010d52bbmr337278585a.7.1746751437061;
        Thu, 08 May 2025 17:43:57 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f9bffcsm63354685a.65.2025.05.08.17.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 17:43:56 -0700 (PDT)
Message-ID: <d106f9c1-2615-41ee-ae80-02c22f12917f@gmail.com>
Date: Thu, 8 May 2025 20:43:55 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org,
 Vincent Fu <vincent.fu@samsung.com>
References: <20250508171444.2113-1-vincent.fu@samsung.com>
 <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
 <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
 <CALjAwxiq+jeuvvhRF3CDv51ttb4Fa3seLNzorH=z8N56dxnhOw@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CALjAwxiq+jeuvvhRF3CDv51ttb4Fa3seLNzorH=z8N56dxnhOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/8/25 5:28 PM, Sitsofe Wheeler wrote:
> Hi Vincent,
> 
> On Thu, 8 May 2025 at 18:33, Vincent Fu <vincentfu@gmail.com> wrote:
>>
>> On Thu, May 8, 2025 at 1:18 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 5/8/25 11:14 AM, Vincent Fu wrote:
>>>> The pread and pwrite functions for Windows posix emulation never actually seek
>>>> to the requested offset. Fix this so that the psync ioengine works correctly on
>>>> Windows.
> 
> Oof! Good catch!
> 
> [...]
> 
>>> lol, how broken is that... Does windows have any offset read/write
>>> variants, or is lseek required?
>>
>> I could not find a better way to do this but I am hoping someone who
>> knows more about Windows than I do can weigh in. Sitsofe?
> 
> Sadly (?) I'm not a Windows expert (even if I've occasionally played one) but
> according to an answer on
> https://stackoverflow.com/questions/3852758/equivalent-to-pread-pwrite-in-msvc
> the only thing that can take an offset with the request is ReadFile/WriteFile
> and this is done by passing an OVERLAPPED structure
> (https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-overlapped
> ) which in turn can specify an offset even for synchronous I/O (see
> https://learn.microsoft.com/en-gb/windows/win32/api/fileapi/nf-fileapi-writefile?redirectedfrom=MSDN#synchronization-and-file-position
> ). Unfortunately ReadFile/WriteFile only work with Windows handles but I think
> you can get one from a file descriptor via _get_osfhandle (see
> https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/get-osfhandle?view=msvc-170).
> 
> --
> Sitsofe

Sitsofe, many thanks for taking a look. I think my patch is good enough 
for now but I'm pleased to know that someone who really caress about 
this may be able to eventually improve on it.

Vincent
