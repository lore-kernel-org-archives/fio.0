Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1951C1D90DB
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675292; cv=none; b=QainsrGgr0ZbloEjyHmNmj+c3280Rjwex616QaZiVGBtsS//pidKdLxG6Fo0eRE7mWtXfM9T+zzowfnkGiGxE7tXv6OWIMY0QGmMti/O/RtAytgFoyPK9dPp3Llo0IObKbjwuKDCksO8RpOpQlXqJA4eUGOQeiMUpSdRSVcjS4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675292; c=relaxed/simple;
	bh=9SDV0XYKx36jy3XjQVU02e+7xD8mk4R22M7ftxn5dC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U9qOR93pdbrq0Jd3QpEC7ay1oJk5yj4FqfPsCNYOqfA0wqvIPwa8WpYn9f7SpQAVAHExClE1zO9HeDBrqK4pWbWt/Wwi65qPlyWT+3chkzc44YOyGdkJ2INxoAEdPL8ysycToNoerff2xtVkqenE5C3XYmETT3oAAicNpfUYhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlmW8J+9; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlmW8J+9"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c0970e2e79so210220185a.3
        for <fio@vger.kernel.org>; Thu, 27 Feb 2025 08:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740675290; x=1741280090; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIJZhI33GgKJaXEDxDSts/HpxytyPUNPXYEhao20BCg=;
        b=IlmW8J+96oUMAKZtPOwoi6hx7uW12WYThZh/zvly6jl4MIEbJnlAi3SAL4OHGEkq0W
         zj9nbUbvSH3lLZLueDZhjbq2z0yQNdoOCHmJ/0hC3fcMee2VL79xbSFB9RaqMy/AyOQl
         WGf3/3pO+/KrLNMLWWVivb5OWFgSxXaSbX5zE1oTkIiY0gX6uJ8CTjXSehovJjeiEP08
         /ckjs3T6JqFuRSpeMMT4D2fJbiYB32UDR8b8ZNK3J8rVh2Go3PVc01SGKPCWhlXEogpd
         SxkDmGbc0qKY4YOHQv1yGODJvKTQpOCkiFiOuMpfUHYlaaPXvVsC+8f9w0DSG1EbYcWS
         ykag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740675290; x=1741280090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIJZhI33GgKJaXEDxDSts/HpxytyPUNPXYEhao20BCg=;
        b=CkglENI20zmWQ8OgkkIeAapUKpL/DgG/eNL9ZLHTDRuuhAzY09dK57IJGZmp2UdF6h
         EOfAhj35H63XhKGD/2WX/lDimKj6frs92h1BQCyQ6cf3mVuNwyRF0w+J53OAlTSgPzfS
         3ugHIttZuGLZYti1o1DZ2NVAfv+QkjOw95jCSLVgVxTBPPWpU315izBIABDz68VwDMME
         E0WUjLEezL0f6f3ygOomMbMgOk50+3/Bs3G6bZGAkkECv1FdIk6lrwn2r+xzJ1Wrk+N8
         Oj8bFnVq1b4afEjV8566owILDsD2XdkqrB0FnS30ZIdnlMUqqoyHiSSCVLsyxeBrTqOn
         8PvQ==
X-Gm-Message-State: AOJu0YwJDKplBxbXGWTPBnaEcBuor+i9BpjExBsJvEBU6Ca6Dte/00GM
	sqWxckt1U2VhE5uRulfcsPEBjbIIsw/P93ENJYSSOQbDr5sa6CsBFvtDwA==
X-Gm-Gg: ASbGncu6auPrhwRq8Yh1lNuqYvapwUuqDwGWhwoK/fJTtk97jHLWpXiOHtm3S8E/7w0
	MjDSmTHpy/akzLIk9iGwleadmUEi8lZa+v9FBN7/knHrfElnFpQVfijpxz5HQbrD70i6JCKbRNp
	wroDF/WqAz/EHWLL34r6yUydsLBfP4EvAHThtaWl0/zN1ZS8IPNG4gNE2PBGAxRU7KgYoYB72R9
	oFdLnHh+zsLP8dF6I5jHnlJfDOtvFfpuf9HTth3glDOawR8RD0966BVr1/EisEz5rS7gxsud4YK
	iMFu/jG8zZ9wXtt5H7GdOLtMS6rNv5XJaVBfqnO840+tuLQZp4X0AT1Vgp6Ob1mRtqZG29RF6dG
	pGQ==
X-Google-Smtp-Source: AGHT+IGQvxOjkngOpcPCNcLYFK297xWv5uKbfjhHvJdMRthUWaYQPnUTzcp7g2OuOPsdVNHei1AA5Q==
X-Received: by 2002:a05:620a:4116:b0:7c0:9e09:4994 with SMTP id af79cd13be357-7c23c048921mr1593301585a.52.1740675289812;
        Thu, 27 Feb 2025 08:54:49 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c378da072fsm124796685a.86.2025.02.27.08.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 08:54:48 -0800 (PST)
Message-ID: <35bee198-cb20-4a29-9960-075c510819d3@gmail.com>
Date: Thu, 27 Feb 2025 11:54:48 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] verify fixes and a new test suite
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 john.g.garry@oracle.com
References: <CGME20250227053350epcas5p31b3b5b47590d70804dade59842d87b27@epcas5p3.samsung.com>
 <20250227104727.1794982-1-ankit.kumar@samsung.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 5:47 AM, Ankit Kumar wrote:
> This series fixes few issues with verify, and introduces a new test
> suite.
> 
> Inital few patches add the missing client/server support for
> verify_write_sequence. This also changes its behavior such that if
> verify_write_sequence is explicitly enabled fio will not disable it
> under any circumstance.
> 
> Numerous header seed mismatch issues have been reported. This series
> introduces a new option verify_header_seed which is similar to
> verify_write_sequence, which allow users to disable any header seed
> verification. For certain workloads which used to overwrite header seed
> before verification, we simply disable the header seed checks now. This
> now includes a few more scenarios such as verify_only mode, read only
> workloads and workloads with norandommap, where the header seed match is
> not guaranteed.
> 
> Few more fixes related to verify_offset, workloads that have offset
> modifiers, verification issue when multiple files are specified, are part
> of this series.
> 
> Lastly this includes robust test suite for verify.
> CI run result: https://github.com/vincentkfu/fio/actions/runs/13552248490
> 
> Note: The fixes in this series doesn't cover experimental_verify and any
> workload with variable block sizes.
> 

I have worked closely with Ankit on these patches and hope others can 
take a look to point out anything we may have missed.

Vincent
