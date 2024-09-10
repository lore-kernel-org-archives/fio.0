Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB40320F
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725930068; cv=none; b=IftWXDlUR17cmsOGEWknId6mjKy8aQmeimJN+vdmjh0SMCJWJJDBHme3sTZ80m3qjyZTy0VfEBOXudp/cUOWcmi84SuQuglsEDiJrj+QKfhGAJnPJgL7cvhPWKCv0zYUS5vqffBpBEzRIollW6mvP/XF4qNB1S+1ZnfDNML2xRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725930068; c=relaxed/simple;
	bh=gGTugDRO+wLznLoJ4ZRZHcPmRaXbWWbTqghVQ+T3ESY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1OAywp3U0CtmVrxkVgUZw6bFxONjkz2RK/tdHTn5oFkwvlR6VKtPU/mIcGnclpt75lM86powdsdyUClhqbLKCpSb/Q/4v/QH3JY0VWCt7GQzeE/9vXEkBSYB1D9QWx0U4EGeNm++n1yiwAWX5ga4EUFQBKognGwKaFMhjGrv3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zwtgmMIS; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zwtgmMIS"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d89229ac81so3901688a91.0
        for <fio@vger.kernel.org>; Mon, 09 Sep 2024 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725930064; x=1726534864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tepqBODxEI7dugFHMabEQpMka2JsZAwzQ3E1naVwm20=;
        b=zwtgmMISfCZHTDkTUt2m7fCL1U73jZRaYgGHq0SYwDJUuvo5nC6KRMJZhpstE1yUOF
         w5ZfSVMQmjqC+TIFcRndxCDnDnbOeBDepabwA94q2zI/0O1hjV4f7fhnDl3yQN1aRxm4
         5rhUlk3qR8OFy+t0tf88SoaUIZenD51JsqYpUv3lO2uskcXfayCtQI+j2xxXdkKWYjUI
         aZuRt9i6cQUTGT/PwxEr69fvd6nmYm0FOWy9l3Jb0VSh5wIZeqN36X5Gx3nA+YY1VF1s
         YA02B9hfrSTOPQGbTppgCaF92CMjfgoHB+4xktZKinEDioVeSBePnwPBZLnDs6Ndrv1u
         rHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725930064; x=1726534864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tepqBODxEI7dugFHMabEQpMka2JsZAwzQ3E1naVwm20=;
        b=QaDxWNPMGb5QN6scAUObtT02V9AVo+clGCa9nBurQx1E8yn2NiM7B+nmrWbUQkEf/U
         3xhETqZfen2j2vVUfZtVy1OIUnUW3sqybq52/gmFLawMoePi5KlYfyMwcfDOfcVmvcT4
         OPjXJKEBR+eZ4WORR5pFa5aX/aqhjmUjoFHRsCHiHksUmu6o+PwkTX8OL7VCo32AY1ig
         H6BsZlCHKjdeg2xxQSAx/L7dRs3k/ByrL48QH4OP4JINLdPEv9TxLm6bgyLYeqhRx6tH
         1VZfpQ1ASc/msIUt7UtLCUYKSx7Q/kh1boCRgGGVwlTg9DJ8TTj1ANjFIKlDcqkaa9jl
         8RWw==
X-Forwarded-Encrypted: i=1; AJvYcCW2n8av5hcXVe/XZ4WPYg4Dhsy0Dknx5uB12o2Xldig3tkpGR7UFMopfHtQVl6LCHQpZu4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNdKS4LPHh7faHzo54lAH6ah5CZdecORQlR6UPN7QcsivzRrDx
	ix2mEl69QjnHjHtxibxWFnfizwkw30Xn6IbWKCWG/KaJFWpyDskk4F2BYxuB/KnrVuw6hRv7PgX
	a
X-Google-Smtp-Source: AGHT+IH0nCGRSDsk8iRnl5WtUUSwZgo3jaWOIUmEbsyZvwDXS9sa9myFBkyeE7JtgmoG2tBBmDLfCw==
X-Received: by 2002:a17:90a:4b88:b0:2d8:b26f:694f with SMTP id 98e67ed59e1d1-2dad50106abmr15748347a91.17.1725930063790;
        Mon, 09 Sep 2024 18:01:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadbfe4b41sm7279274a91.8.2024.09.09.18.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 18:01:03 -0700 (PDT)
Message-ID: <f689c9ea-b677-4521-8363-1c4f2f3c81f0@kernel.dk>
Date: Mon, 9 Sep 2024 19:01:02 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: John Garry <john.g.garry@oracle.com>, fio@vger.kernel.org
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <5b1ac00d-a67f-4a5a-8018-a183903ffdc0@kernel.dk>
 <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1185aac7-de61-4071-83fe-802b52e458e2@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/24 2:28 PM, John Garry wrote:
> On 09/09/2024 20:53, Jens Axboe wrote:
>> John,
>>
>> Maybe it wasn't clear, but I committed that change I mentioned in my
>> initial reply basically right after.
> 
> Thanks for doing that.
> 
>> If you could send a v2 on top of
>> the current tree, that'd be great.
> 
> I was preparing a v2 the same as this, but do you think that I should
> just add a new verify option for atomic writes to ignore the header?
> Or is just saying "you have selected atomic=1, so I'll just ignore the
> header for you" ok?

I'm still not following why atomic writes make this any different. They
should not. If you have multiple writers writing the same blocks, yeah
you will get verification errors. This is true for any kind of write, be
it buffered, dio, or atomic. So unless I'm missing something here, I'd
just drop that patch.

-- 
Jens Axboe
