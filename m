Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86E191484
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 03:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486380; cv=none; b=PPf17H4jhIZ5KY2BiOA04ZAomY8vM6Tm61+No1RfxJ0mXYOyT6X724qKaUK6sktLyo/pxal7VGhv3WSUjHQ2tBpAUgFcoeimDU8J89jqrMP+bs+uM7VRvZ93V2p25n2L3AHCsKLZpNhstmptXyJKwaVtHXkw2mqSu5Ie1nsIyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486380; c=relaxed/simple;
	bh=Iyow8F464ggWa3U9oPfDF+kMpQgVBh1Ojt1fvstGlII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhyyK7Xs/AuJwkSizSRlz1hfcIApHm6xFiGKb8VunvGq1KaH3YBKYHemPejNiqI5s57MWO1PlXAuSyXrx4sFt6rvJ9KfH6UBElLonh2y30GFtZdL/KTgT1RjUBrj6GJM/Fed3TX5PFHSkjyrV5KmPyjs2A+3id9bwveFlupWAO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F0PugBb+; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F0PugBb+"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c59bce68a1so358830185a.0
        for <fio@vger.kernel.org>; Mon, 26 Jan 2026 19:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769486378; x=1770091178; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HsWANkUAw8xq5KMeisqgoNid92YQniAVOhJ2PFZMZu0=;
        b=F0PugBb+Io9bLDUC0okYDgif+Op8wWCfIWsoDr/fTOOWsnH0FHu36gg/lfyruduHkv
         jDyTcYSRWZsRXfTmaERuMkP2zvMz5ukvkLGT59+oNf1BwPA1h8DMWJlkefMLBx43f+Zs
         4i+M/CMz96b2QXq8eKSR+lFfn4UDxH1sORfdtmjGKBruD0+s9CrUnmv1YOlph1k/0qum
         wmmUcbz+NuT6z1O2A5+IkAkBbag2TJBv1onzE/Sdi5mh24OBVcZ6+VFDEI6AFNbXFsjH
         uYpNwAmRB0zVpgEqmk4v+uxLv72lE9QTvncjqONVooJYDftO6f4Dk8VIbHy3rm0JZJQW
         R6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769486378; x=1770091178;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HsWANkUAw8xq5KMeisqgoNid92YQniAVOhJ2PFZMZu0=;
        b=h2KhDwqTf+HnduKm5Qyj2lCCbhfKBDawq4uOtDmLw4NDJlxfneJDbBuF7nbfF7ivGT
         pt90XCt421cYJyG2CZPWKy/Ipe9VssYv989PDntFMkqsbA4bi/GJyHOTxqNcjP6CyCy8
         mSTsCUesqFJbUZ7SIDGE7xHf8IyEueoPWdj3Oc53AA/WA/81EKhl2Neio+YmKhgUQekg
         Sj8uz8FDsSJumMHwaurSoBuQOoIRMhYjHy2K3kNqjYUbr1Wo8QQHVTQ2urN+coBrBp5S
         iUK2ABczakoKVM/73XRQILqWPrLjaLIpz6o0UWzJ+SIDiO6UhBKh/J0E5TeVY5kLUVkI
         YE5A==
X-Gm-Message-State: AOJu0YzwrO2m1GAmv9pCXFrzUmuxH5nX+1Pq/TH38GcNgzU0LbqLLCFj
	YCjhj8arRlJ5JiqMvcoPHq9+3jmy99Ak7YPPnAy2lpglHcmQ7nCTfMur2tvAc00gPzs=
X-Gm-Gg: AZuq6aKstbI2JFGNjF4shonpqwVM7d505kWb4G8vbxyk9XMVaTQYmNFLkz57oViBSdG
	tIunZktWNLSeAawAtcyKK51yXFxb01axNoCRSWFzuscLQQgBwsuDr4A+aasUCWv27DMVs/3v5Mi
	q6K3ZtXZxNCWsIv2uI0AVS/dUwL1fBB/VrpooLu6Pyftj6DKxfT4seKL/HwfOWhJVy7ijhdfhD+
	d21tKt5M6gKqhe0a2/5MkgntmwveP5UlZrKabNYqdKqu/FPBM5yeXM3P3683SDBVteZ7RnPPPBn
	3gPewJFTj4Qn690IqJVwbmScQ1BD5PavN0B5wWAF+9Jupt/1lIFRm04257ZNAG8SMtIbHmSkB+m
	wQ9jx1d/dF6ZyqbM9a1cRiAoNDosWE4jRRlB+F4u4RN2tWGNh9vqLWAb+TRwO8Y8X6IaXOBplim
	mamsnqr532BBk1FKDc43XDrhFP2S2E0n6vC7s5wcRWO6EqEeboZ4QMv3IlrDiuBGmtBVoRUJs=
X-Received: by 2002:a05:620a:c47:b0:8b1:1585:225d with SMTP id af79cd13be357-8c70b927a02mr60447685a.82.1769486377801;
        Mon, 26 Jan 2026 19:59:37 -0800 (PST)
Received: from [192.168.201.17] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c70a8e55d5sm50360785a.20.2026.01.26.19.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 19:59:36 -0800 (PST)
Message-ID: <9468ef0d-a027-4aba-85f8-5b9ed3b2aee8@kernel.dk>
Date: Mon, 26 Jan 2026 20:59:35 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Introduce the end_syncfs option
To: Damien Le Moal <dlemoal@kernel.org>, Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
References: <20260126061721.270448-1-dlemoal@kernel.org>
 <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
 <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
 <CAOp=CXnJ3Sr2ZGDjiAHdPhi4eKfUo-RtJ0h1oF072ew+Xfcy7Q@mail.gmail.com>
 <7ae36bea-e5c4-4626-bad0-a301ba69777c@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7ae36bea-e5c4-4626-bad0-a301ba69777c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 7:18 PM, Damien Le Moal wrote:
> On 1/27/26 11:15, Vincent Fu wrote:
>> On Mon, Jan 26, 2026 at 9:05?PM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>
>>> On 1/27/26 10:01, Vincent Fu wrote:
>>>> On Mon, Jan 26, 2026 at 1:22?AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>>>
>>>> <snip>
>>>>>                 }
>>>>> +
>>>>> +               if (td->o.end_syncfs) {
>>>>> +                       td_set_runstate(td, TD_FSYNCING);
>>>>> +
>>>>> +                       for_each_file(td, f, i) {
>>>>> +                               if (fio_file_syncfs(td, f))
>>>>> +                                       log_err("fio: end_syncfs failed\n");
>>>>> +                               break;
>>>>
>>>> This seems like it will break out of the loop after syncfs-ing the first file.
>>>> Is this intentional or should fio break only if there is an error?
>>>
>>> It is intentional and it is the entire point of this patch: doing syncfs for the
>>> first file will sync the entire FS, so all the other files will be sync-ed as
>>> well. We thus avoid the entire loop on all files which is extremely slow when
>>> running with a large number of files. We only need to do syncfs() once for the
>>> first file. Ideally, we should do it for the directory specified for the files,
>>> but that is a little more involved as a change.
>>
>> Ok thank you for clarifying.
>> Please emphasize in the documentation that this feature assumes that
>> all files will reside on the same file system.
> 
> OK. Will do in v3.

That seems like a very odd limitation that people will never know about,
and hence it won't do what they think it does. We stat these files for
getting the size, right? Then do a sync for each fs. Only doing the
first is a cop-out imho, and somewhat of a lazy way of doing it.

We either sync any fs that has a file that was written, or let's not add
this feature. That can be done in any number of ways. It's a terrible
option otherwise.

-- 
Jens Axbo
