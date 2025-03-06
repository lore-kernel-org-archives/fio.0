Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D7F18DF65
	for <fio@vger.kernel.org>; Thu,  6 Mar 2025 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741288398; cv=none; b=cqaGlnmAT3DwzHDGW19usYpdPi4c13kRdAs4C2Vl48Jo37JVdRQR2PbBB2jsZJ9V3KYDr62rsD9q/X/7E5oMwNURjxbKcW24eeSMr91M8s4A1XhSalDcTVR8Eot0YzCFbT8SxyNppiXi0ts6mED7c3Nd2t519x5PStlSsoon3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741288398; c=relaxed/simple;
	bh=pqqkcLg4t1PrBDVtVtqmCd1F0pjvrpE3GoEXV49mI6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYvYIS5btsJH44GGsZFequEupW+DZc0lMIsmvIcqMRvONS1xTl+3t1qOaSUaJ72g1WhnyMZ7H/1/cjDUYPvPyVSJEtXqgWWNUPutD+e1PFIBeagk4QEN1skvTCYKfC5otA7dSPqkDIynyzB7OC0PRrb2aNMtY55LfOs+At1gAvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCMPHmEf; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCMPHmEf"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c08fc20194so177231985a.2
        for <fio@vger.kernel.org>; Thu, 06 Mar 2025 11:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741288395; x=1741893195; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mBE9sjFHs3221PFaXRGpQGlDjDbOMqVcmWu8Wrfaz48=;
        b=jCMPHmEfqOJrKdpGGx5nIMEK9b4x/1aq13UxBJMsZC0Q+0o3MKtgtByEtke+gM2wyR
         WoafhBEMcSc7lAp8k0uPWkM9XcUl+rbnUmztpTTO3tToecbla0u6DioYSpHX3dkdH3J/
         GFaVE3NeLhRLV3MCYzMdSbIGum10l8EOkjgHrQpKaEbMVoGnb4H0BHf0TOSh2jH/DPKm
         iE3aWdM5C/XVefw2gUQQIFtCbDFyQ0eOmfuTqK9YmKRc2p4MqpyurNatKNpRAXaI+OqS
         OFDFmLWZpx9i1DLODMUZDf39qO6FP3zGkg1ROntieRnMTuogBbyZo9Yu3EsEG5R+HblK
         d7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741288395; x=1741893195;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBE9sjFHs3221PFaXRGpQGlDjDbOMqVcmWu8Wrfaz48=;
        b=EPFh59deHGylKJ/IHnxQuHLTZz0z+AyGQA1CWimXN95gEk1xk2wC6Y1zBbd8fQzUUA
         F0xkC+ptwqDT9Q6r1ZEglHjRI7EIY/f4n30EjjtBOI9yLX7WPUt0hRulJc2yfn0G+BAI
         ONVkYnOP79sp3ZmeLfz6EGwJxvG55z5ia5vFiIbOXAmudPr9Wk6j/I1UNBNovZ5fDVL6
         l4LEZ+l8QMo0yM0OijE84UbjIXvi5V9WvzdK801PyjWof2PkOpid1evMgFT1HOaBRCvF
         fu14fckB9Br3PO7lH2N6Xfezcvt1La0s3P584AaDkvhbQxXnDw/71pZGLMwzQQotAOZA
         HM1g==
X-Forwarded-Encrypted: i=1; AJvYcCU1RfAlGXO1rjCWRzJz0svtHi8SQrTUQvaLVeIzXlRFvGX2tWrUf2IAHfNL32pvVYsRoV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAT6RC3eojxmpcV/9oLMTzVUJeY8sHJXtOmvlGwHc7m6KRPb02
	f2zy0FKKbx131OQBa9517RINq6x4nqyf7MGfYUZvefWMKid4gHAB
X-Gm-Gg: ASbGncv5BPSB48XNuLTN/OQzQ2mopgnGBeK/6W/qnz+I6WfbSTTRO9vvadb+mlnNxzh
	gd/CsQpXSm8ZGEX/BJx+ijTEwYH760HGi4zGcWdXnG24oC/b2AbcxHKcWUUMXyh17Oa39YJUR9y
	LMH2685mTovPwrvXQgotelGGVBh6IY7uaeQHyeh6bgK0j7KGyHbzPKLwKi6vWB6qlHB/2sudswl
	d0WiM6sfzv+TGGyR9uoer/5aP1Jla6YXkQ3TegNiUp5nrJFtwxnCJqvkPl6wuivXG42sl5xH1ig
	g55Qc16MR6t1s2oVsFv44JHVCYryOYCUQu5IcDBq7KA8Uz6JJesVvm++bwTGQGKCUkOf1rwYq98
	IIwkm+SZjaB4PkS4qN0qi
X-Google-Smtp-Source: AGHT+IFnhwk3w/MW5F4DwhlNJqkYjRHemUXndSWSa/rGA3VNgtj6KWVLvD4aP7d2yetjhGjYd2JFJw==
X-Received: by 2002:a05:6214:1c0a:b0:6e0:f451:2e22 with SMTP id 6a1803df08f44-6e9006cbb8amr3793556d6.38.1741288394821;
        Thu, 06 Mar 2025 11:13:14 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8f7170963sm9993636d6.110.2025.03.06.11.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 11:13:13 -0800 (PST)
Message-ID: <7d408229-96fd-4391-8203-a8b07f1155b8@gmail.com>
Date: Thu, 6 Mar 2025 14:13:13 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] verify fixes and a new test suite
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Ankit Kumar <ankit.kumar@samsung.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>,
 "john.g.garry@oracle.com" <john.g.garry@oracle.com>
References: <CGME20250227053350epcas5p31b3b5b47590d70804dade59842d87b27@epcas5p3.samsung.com>
 <20250227104727.1794982-1-ankit.kumar@samsung.com>
 <35bee198-cb20-4a29-9960-075c510819d3@gmail.com>
 <kkdwksy363kqx5q74kccnabibbvuwdvrsyizyxoqnhtlj44bng@kjjwksoai77g>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <kkdwksy363kqx5q74kccnabibbvuwdvrsyizyxoqnhtlj44bng@kjjwksoai77g>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 7:36 AM, Shinichiro Kawasaki wrote:
> On Feb 27, 2025 / 11:54, Vincent Fu wrote:
>> On 2/27/25 5:47 AM, Ankit Kumar wrote:
>>> This series fixes few issues with verify, and introduces a new test
>>> suite.
>>>
>>> Inital few patches add the missing client/server support for
>>> verify_write_sequence. This also changes its behavior such that if
>>> verify_write_sequence is explicitly enabled fio will not disable it
>>> under any circumstance.
>>>
>>> Numerous header seed mismatch issues have been reported. This series
>>> introduces a new option verify_header_seed which is similar to
>>> verify_write_sequence, which allow users to disable any header seed
>>> verification. For certain workloads which used to overwrite header seed
>>> before verification, we simply disable the header seed checks now. This
>>> now includes a few more scenarios such as verify_only mode, read only
>>> workloads and workloads with norandommap, where the header seed match is
>>> not guaranteed.
>>>
>>> Few more fixes related to verify_offset, workloads that have offset
>>> modifiers, verification issue when multiple files are specified, are part
>>> of this series.
>>>
>>> Lastly this includes robust test suite for verify.
>>> CI run result: https://github.com/vincentkfu/fio/actions/runs/13552248490
>>>
>>> Note: The fixes in this series doesn't cover experimental_verify and any
>>> workload with variable block sizes.
>>>
>>
>> I have worked closely with Ankit on these patches and hope others can take a
>> look to point out anything we may have missed.
> 
> Hi Ankit, Vincent, thanks for the work and the heads up.
> 
> I ran t/zbd/run-tests-against-nullb with this series, and observed no failure.
> So it looks good from zonemode=zbd testing point of view.
> 
> I took a glance on the changes and did not find anything wrong. It's ok for me
> to apply the changes.

I have applied the patches with small changes to the test script to skip 
a flaky test on macOS and fix a test that did not run reliably on Windows.

Shinichiro, thank you for testing and taking a look at the patches.

Vincent
