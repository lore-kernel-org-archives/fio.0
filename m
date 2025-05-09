Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9E208AD
	for <fio@vger.kernel.org>; Fri,  9 May 2025 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746752059; cv=none; b=nFC4lroxH1i+HUvtavLPXHIx1ihooQrWco/P/2Fy04lMkt/xIWFSgRHh7qQouUYn5Rtts/z4YHevsd1BBH6Ak88ptGJxm6dYtrdZ7yZiSiyLeWG8IDFapdquTiauIGpBhA/NDT5k2Ac1B9RZ8kgola2KVzEFgZZETMbyrT0dth4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746752059; c=relaxed/simple;
	bh=WTIsTnUzd5hfhrP8unDHHg+yxfSWkECapCQArDecxbc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=dp4FK61CCJPPqOd3UBJaTTSeqJngrabqLIM8WOk3ucMJNRlTWTFHPcitLoLU1zVvip6eK0NlVUmxiG4ogO4XfOF4ZEvLY52Od0Ikp3HzDw/QsOX+XsrBWzhjIfLLo6wy0K0qi1Wm+ijgmLKD7KXjz/BBYIPuK31gLNYwE+oYUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QsEVa+8P; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QsEVa+8P"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c5568355ffso158997985a.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 17:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746752056; x=1747356856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1ixuHJognsuJy5a0UqDcpDTLiw9wonpHwRa7Qv4CJQ=;
        b=QsEVa+8PjJt19UKLZCT12ktOUjRrKxYoFweNTQz5qSJ9oEtGg7rb5YqvEfB2/uB/26
         W47ecRCNP7KwGRBvPlgsBjmxPbnRPoR5w27Tw9s4eYMDSKThWeN4gmhywCsAEc3Evjmr
         yUfkIUkZUq5scOwJqjkI0uZ8B5rXft5Ed0mpYOwmrTONXAIOihUAy0QZ/M1mPTxaUqFs
         VB+QJvZGVOieYOA+VNY/nINC6FFQTOdLanhzILezOmrVS4kFJzcdk+dxPa1jdYA1mS9T
         kfQlLOdeaTkI/cEeabO6RY0rdq9+0RwMLSgWKo8yR8lnMN7P5XusIXHRge5CV3PODt2z
         cZIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746752056; x=1747356856;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1ixuHJognsuJy5a0UqDcpDTLiw9wonpHwRa7Qv4CJQ=;
        b=r1mPiCfe5+5cCWd5oWliLz/+HIVi745l2yNiRZGeNoB3UHkjymYWJTCve3i2YA0v6P
         Nqcq6wkqa7hH7qMPGFO8gsnPNXyCJD1sEx+U+2dOjzP3j0pfJqr9I6c3eTuAKwHdLKwK
         QpLXhWpprs7OAsYWk3ygT0YvcoQkPWlx6V76oc4WQsQEofeMRwwmpJ0m8i0AHTAmgBrQ
         8fO6Zkard5osJzkpLNvtKzdwrRVIm2zMXdq/5HLfCuQ/M/fLL3O7MIm/BVbn9JZM58ks
         3BZYHusZ4ieMs7r3G017hA6ONBeucR4KJnVGaIx/YpKWbLPkYDKinBPdaCwOsA0RRecm
         WhFA==
X-Gm-Message-State: AOJu0YzRNaNJRgwH4B7USQoXWejRQdvS5Tx4Vc1LJNjv82OckF2O7Dbi
	yhlSdlX5GLA6U05yQpXXW/ukY7pNPWV5qfanMJ/ZrEu0TlsdoVZ7C03B
X-Gm-Gg: ASbGncsc9l1TQi3462XdLi4dx/ZhrYKHpcYRd068nGgm1JovNQFJrozZuXg8KFl8zPn
	gJ6hVfkUDUFIGiXzkgdr2z8Oefuqde8aJpDTVgobUtgUAuI0lVJgvDgBpWnSw9ylzQI9hvZTefs
	ftneFLisELjom3/E1Upk0gyetCX2R08579pkNpv7B+FO/Ur7wxJyj5qowXRxAyMMsDumcrVChFW
	IUhcIyySYaPag+oLZIkeXh5hbuh3zbTfyhQN4EOf6lyuch0FfM30B/mlZiLxElB0lJDJQuiVMGI
	ZXCjVMbobTp6yZoXocQWlVKBcxE4gWK6JBB7araQuGB1yrkWkbBZXWSFVl6otOInWLnz4Q7Ri5J
	kBZwy1E61S4fWzpcg
X-Google-Smtp-Source: AGHT+IHYo+9myqUK5ChcBqtVFHdXfEG/7LpV60Ltz8Y1WgDptkOT9kkLmuM701Jzj0om2kyjH6oulQ==
X-Received: by 2002:a05:620a:288e:b0:7ca:ca5d:779e with SMTP id af79cd13be357-7cd0116e26fmr296506585a.47.1746752056508;
        Thu, 08 May 2025 17:54:16 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f63bd8sm64693285a.43.2025.05.08.17.54.16
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 17:54:16 -0700 (PDT)
Message-ID: <41222b13-43d1-4d5a-8803-66fbd265e575@gmail.com>
Date: Thu, 8 May 2025 20:54:16 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] verify pattern interval
From: Fio Test Bot <fiotestbot@gmail.com>
To: fio@vger.kernel.org
References: <20250508185832.3702-1-vincent.fu@samsung.com>
 <174673377441.2581.14259152939735507019@fv-az1694-607>
Content-Language: en-US
In-Reply-To: <174673377441.2581.14259152939735507019@fv-az1694-607>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 3:49 PM, fiotestbot@gmail.com wrote:
> 
> The result of fio's continuous integration tests was: failure
> 
> For more details see https://github.com/fiotestbot/fio/actions/runs/14914258938

Hoisted by my own petard.

There was one test failure with t/jobs/t0010:

https://github.com/axboe/fio/blob/master/t/jobs/t0010-b7aae4ba.fio

This job is a simple io_submit_mode=offload test:

# Expected result: fio runs and completes the job
# Buggy result: fio segfaults
#
[test]
ioengine=null
size=10g
io_submit_mode=offload
iodepth=16

My changes do not touch this code. I looked at Actions runs in the main 
repository and found no similar failures in the 90 days of available 
logs. I did find two failures in Actions logs on my fork:

https://github.com/vincentkfu/fio/actions/runs/14414832872/job/40429681779

https://github.com/vincentkfu/fio/actions/runs/13680647374/job/38251879040

I re-ran the test suite on the failed platform for my patch series and 
it passed:

https://github.com/fiotestbot/fio/actions/runs/14914258938

So I am comfortable that my patches are not responsible for this failure.

Vincent
