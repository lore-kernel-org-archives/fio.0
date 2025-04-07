Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10D820550A
	for <fio@vger.kernel.org>; Mon,  7 Apr 2025 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744037805; cv=none; b=prMf9xrlfcvN4cc7RuNzh+//NJu0OmMOQx3XCDawvJfrZi4p9Rm/1K+kJGWHYvt9rr19k0Lu23ADcGKT/E6ByWcgkK+fOPlGFVFCTHjHBekx77dkcSa1KpBAyYFLZYloRSwrrTh1ZHjKVUUChbgwgM01fQi2toy1OPuESiY4v4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744037805; c=relaxed/simple;
	bh=y+dDL/6pnxJqLA/4MW1l53wlJeju1tsF9K1seSoFX10=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kz8pROwvTYpWAZoXz0tnUnC6jytjYxURY9v441o9dQ9/hLiM6bpOwjp/MI11ZVlGeK5tULDA5cEyCg6vLWPoiozrfuPSYsJqesOh3MGkno23ChVZtUim4MvBUgmEl8rRG0JbDnMNtOw9Q6eRCmbeG/Bc8pd2eUOctayIZCF7ooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsjxsGb3; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsjxsGb3"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6ecfbf1c7cbso79231426d6.2
        for <fio@vger.kernel.org>; Mon, 07 Apr 2025 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744037802; x=1744642602; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Crm5K/ySB00llFixp2e7UMRoLibXpMf9tR8+e+mPYQ=;
        b=SsjxsGb3gtOAOyOSfL97IMpf7i+QfqAdnID3P+X2DcOigTGAgceAuj/ULJYXQI/GIL
         +lixChxzuBooaAq8wZ6eGBf2GsGPFXJ3J2zWLWRaHp88TMFECTcPmWrKo2v3PNPksshr
         Q56fqH26ptSIFnitLyH7MdsIvy+DuBnlnX9KfTiR82x0AMLQT8P5VfEd49AaORwpwjBn
         2h2ocuXyUNgr4b8SGd3p3ogEcEkSjvTGXCzbrJzEzlCO3+RzPidpEJQhcM7kmyPhkEqZ
         ydJlPiolytpg+0bmOlisZTQWrg+T3419FrnsDHK6sL5kwxVsyjsPhHi58CPADSzL8hE2
         d58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744037802; x=1744642602;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Crm5K/ySB00llFixp2e7UMRoLibXpMf9tR8+e+mPYQ=;
        b=Vta0smON4mhb6/0aVZwprM9JUAdRkGTvEH8OVnI8wn0szYki0/WKey2cjWeF9StPXY
         +nYDdNhORepdzeUYga2TA9M1peSBXVg2KbRwh8gUNbeRQyN0nC22JwplFgT0XnAaPUWr
         lMlVlqX4YTxdhI1jr4kPbBed/Iu4+CazQ1D3sLrDAXnfCvttQ3nv09yK0mjA3Gm5CTG/
         5CRIwi4HG+gyG5a7gSa0sGoBpVvgHDwWVLU5Fk47TMYLfgrZsh06e+5o12cizCCXI3xl
         9eQWObsq4uSyP4dtCgewkcA/qOQHStRsCCk2FOfo1PE7kXRZMzLZYSwfupZsvrkqisPU
         l8Dg==
X-Gm-Message-State: AOJu0YwspWTGop9RFaSaVDyf3aXXcAQUfk5Qz4uE+dEDTrzy3WLYJwlm
	xXlob8OG/MkkAqK/hXT61hlbr36+PZSS6JlU9Z8Wp7jlDW6nLDv0MDzola0=
X-Gm-Gg: ASbGncuX849CiitaOB47teMX2Mv5ysF6u0J+rDVvzTIt2o8YxYEWBmaO+LnmiDbt9do
	a3xPO3yavo89Qnh8ba/krz1UIQfEre1/vHTVihP7iE+QE/fyIgttUlhqNFfypO31U/kKXUC36m2
	wgwFYLQ3V2bAtKJ5PowR+n+fOOA67OVM6Yka+7pFcVUj5V9Kuc7F+I8EBvxx9IAJCOPZLHGGRah
	DHvAJpx7iU4q9HTxnxhUiwi7e+62ruXrxiDRstJgiICvFSq6GHLDAcM8aHen2+h/DeJINdagn4c
	E0Tv+tfNXSbulO5GPgodoq580uuDGNZb+btl+pgC/TRjsrYU4n084Ad3wrDXO14QoT5SnD0Nuf9
	iNYRMWQGof2GRMpAhfbJ+
X-Google-Smtp-Source: AGHT+IHBnXaUK9BXOvZHpp+2rXMcs1a8Ue8Iymz8dvhR8KRj7QDoRud447jL4dMu9sFekdpoeGukvQ==
X-Received: by 2002:ad4:5f06:0:b0:6ec:f51f:30f6 with SMTP id 6a1803df08f44-6f01e76a198mr232245556d6.31.1744037802463;
        Mon, 07 Apr 2025 07:56:42 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f047c23sm59037456d6.58.2025.04.07.07.56.41
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 07:56:42 -0700 (PDT)
Message-ID: <02d41ecd-785a-4706-993b-f78fe7746aa7@gmail.com>
Date: Mon, 7 Apr 2025 10:56:41 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] verify trim operations
From: Fio Test Bot <fiotestbot@gmail.com>
To: fio@vger.kernel.org
References: <20250331140204.1971-1-vincent.fu@samsung.com>
 <174343211141.2487.6017345249818370842@fv-az1964-598.n50j0q0wg3ueflgghgs2zwx0ph.bx.internal.cloudapp.net>
Content-Language: en-US
In-Reply-To: <174343211141.2487.6017345249818370842@fv-az1964-598.n50j0q0wg3ueflgghgs2zwx0ph.bx.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/25 10:41 AM, fiotestbot@gmail.com wrote:
> 
> The result of fio's continuous integration tests was: failure
> 
> For more details see https://github.com/fiotestbot/fio/actions/runs/14173747734

The test failure occurred with one case in t/strided.py. In the past 
this script has failed test cases because of LFSR initialization 
failures. I re-ran the failed job and it passed:

https://github.com/fiotestbot/fio/actions/runs/14173747734/job/39703487860

I have committed these patches upstream.

Vincent
