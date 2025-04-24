Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D4140E30
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745506972; cv=none; b=PADPG+yAqU+Z5hw3gPFh2CqdMOkx6/iJHBsyab6iWcvevIinvBH6ZcWVSXoXur9OqLyDRncI77vyj0R6HZUjk5V+/duIWLsPtqkPy9Z63WXucRRnjPzd3uO8gUaowiAZQl2ChezDMRcOl1locX/nBmXQFq0Vlo3VHVs3oT7l138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745506972; c=relaxed/simple;
	bh=oc2/zF+kKqmuAuxgijCHN170/BuiOqEwIH8CKYmTpng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wwrs8zRoRq/2Z6+aCK7LPktWt+IAEhkXS18VYBaM3qHSzQDT0k7Kd1tP6n4ge9G1ZmYSmi1JP3lVWtAmmf11Z99FLfjgjBfNJVyJQN6/xbKZfoQg4S12mSXPJi2JBUMGKkm/TpBIRSWykUqTBOrFTmoqAqtVvcwL83bj63eNP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvz+noe4; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvz+noe4"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6f0ad74483fso13170786d6.1
        for <fio@vger.kernel.org>; Thu, 24 Apr 2025 08:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745506970; x=1746111770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bdgRzvEhjd5wCK0sJVSkqkoBPUbzfxcVO85Cx1XRdiE=;
        b=lvz+noe4MEeifWPfdIrtO6SVSnQ2gW75lm5+EbYmWAohPZZpdUNfmdZZmMxlOnEWL8
         viygiOQ/YbGLfYMjg09u76OIfwopAatNcLjDDQE8ftcmzyy5uR8Zb+cTsjhLZvu6Ss9L
         ViK5vL009e+/2SjVnQDhJSVhmJUdluTvLqNgCzvOFojtZfuEmWmdZLwFcuUIOZs1sOq+
         zzVKgCslIQOrzcOjf3fd5gGv84m4VioIropOTsIxrxuLHYbsc7COW71N4d2TldQA+JWr
         QtYMdkayvqoK832NgBOapk5shyom/qzb9VIuH3W8Hh5iHevZ5w+UhI7BD1R7A9GPNfLO
         Y5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745506970; x=1746111770;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bdgRzvEhjd5wCK0sJVSkqkoBPUbzfxcVO85Cx1XRdiE=;
        b=WfQchY5om9o7dxI914nTY67zuu92sOdtAguIwA1K660W4pezEbd9yG5hoBSCZ/O1yU
         ac+/KdRnhoYfXtjCu3jsUG5UtiJlBWbH24Q9dj7zmunu7HpnJVUvrCZwaC02hAhwfaMr
         NPAkoRIc2zMeCyj6tAf/nHEzTbzWfw3+q/0FKOU0nNIAvuVCHIWC7+oLnYGQfHGSCJY5
         p8Bh3gEOUf19Fblei6LtaG2H+XSasSiaLNisZTdXHxUeor8CxwdXyY48OZLrrmoL1R78
         9IRZR87rqI64X7L49dxxjbzBzda0kZYN0Gl4rGmFEJSpa52nwhSCwpQhRyhdBpbBSXna
         RfPg==
X-Forwarded-Encrypted: i=1; AJvYcCVRvqiso/7atCoUkuem6YqQz+Oct9DzUm97AgTlbqBJj9NBwqYfX7aRAxKeIsgnVZL8SRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpBfD7svRdrG7df13aYuyLqRRvwKT1SXZJLZDBDC6t/KgyLxxI
	fdfN1sZaBRUzpqyZVgupBM+79hcqlwebxz1E+MfqVeC0BmMcgkXNFv8rjmzM
X-Gm-Gg: ASbGnct6AR5+nnU/2cB6t9GJJCYE6DqU6fw6kxhKkyKHyEKuVnLz4HzNBPtAT5fjhnu
	67991cznQxKgDL51IyAGrNiCn/qcZWFKe2drNZRRM3bmds6MnBXr0WiYk+edPGjV9NY5wjugpGi
	g0Uu1C90CAkWmhEgt51RNklhUBN0i60CJq1P6RUqtH5RQM6dhH5HLguPWwFeGNwYHUquPhRD46r
	jZxgcWJra/MjEOAZF1w139ErH7Ip5BsISGgBWbBKgxuQO9UzTOBOgERZwy5/hBFhJmhxEPvLKGk
	X+aGQGgC17gS7UHlpWO2XMIQkWFib2v4yZyGz4u0SBPRrAT9a5c9BSJnyDhqMr2BfeBw010J0ns
	4SeBt2ED+08iE5KDE
X-Google-Smtp-Source: AGHT+IG/zyCNCJXV8TXRXh0gM6oqf4UIxKxD2+ij12EM7HWqBA12mLmYWmEvOkfw7o+kGkEP11M8Gg==
X-Received: by 2002:ad4:5d46:0:b0:6ea:d604:9e59 with SMTP id 6a1803df08f44-6f4bfbca06dmr52603366d6.9.1745506969882;
        Thu, 24 Apr 2025 08:02:49 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c0aae68csm10186296d6.97.2025.04.24.08.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 08:02:49 -0700 (PDT)
Message-ID: <fe51ae80-de19-40e8-ab60-4f02c0cd8761@gmail.com>
Date: Thu, 24 Apr 2025 11:02:48 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] t/zbd: set badblocks related parameters in
 run-tests-against-nullb
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
 <20250421123828.82712-7-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250421123828.82712-7-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 8:38 AM, Shin'ichiro Kawasaki wrote:
> As a preparation to add test cases which check that the
> continue_on_error option and the recover_zbd_write_error option work
> when bad blocks cause IO errors, set additional null_blk parameters
> badblocks_once and badblocks_partial_io. These parameters were added to
> Linux kernel recently and allows more realistic scenario of write
> failures on zoned block devices. The former parameter makes the
> specified badblocks recover after the first write, and the latter
> parameter leaves partially written data on the device.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>   t/zbd/run-tests-against-nullb | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
> index 97d29966..f1cba355 100755
> --- a/t/zbd/run-tests-against-nullb
> +++ b/t/zbd/run-tests-against-nullb
> @@ -91,6 +91,9 @@ configure_nullb()
>   		fi
>   	fi
>   
> +	[[ -w badblocks_once ]] && echo 1 > badblocks_once
> +	[[ -w badblocks_partial_io ]] && echo 1 > badblocks_partial_io
> +
>   	echo 1 > power || return $?
>   	return 0
>   }

It would be helpful to have the first kernel version supporting these 
parameters noted in the commit message. This would make things easier 
for anyone setting up a test environment.

Vincent
