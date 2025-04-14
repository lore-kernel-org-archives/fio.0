Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E91474DA
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 00:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744591055; cv=none; b=EWGCRFuELUXPvRYN88Qou6jU1pa/d3sHrXYVo4SWoi4WMMhkzDjfWtxLEXWf4Q6SqgEWIsnU+0WCCY6ppNfcfLlmZcB7ri7qpHFcXtDp5lNE/U+wltCw6nWW+YS9H8zMPFryvWGMROgBkmPbu8zNB8Gv4+C153Cn829sfAkiMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744591055; c=relaxed/simple;
	bh=6PJhvVCMDmjjgt0syQCvXRKcNr1D78RMNzwPWDSVak0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iYVR1HkWpYLUOkEOA1aBZe2dhe88OgZTSUMLSprRPUoY9GMw21HwjTu9QNOslosWSCHTm1752IN/T28kDJtuzKDNbLqKHyapx0qeJbiwJ02yHoNlpyxT7n4F0jAbKaLZg+rPd7IE10IC8IRGq+FjvJt6+B72wPFH2+eYzJkkN+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmX9QCe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmX9QCe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC2DC4CEE5;
	Mon, 14 Apr 2025 00:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744591055;
	bh=6PJhvVCMDmjjgt0syQCvXRKcNr1D78RMNzwPWDSVak0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=BmX9QCe6R4QnCTpHdTimOYK5yMtjSpQlwXdvw6huX3ZAmY9wpnzz6xcP0341/vTfP
	 f9cDRyq2DEaagSMSwdPrJaOvLhE2emh4MQdzpFDnQ1cK02Yzy6eLEHNJKVjPW9PrkY
	 McE6nQeOB2CIOsNwUvHzNXOr15D3wRVkZth4xfk+RG4Yv3OqekvhHykwvp0w/ISdI9
	 FC65T/i5rHZ17G8w1osk6K/7hzEOQusahcakfcuo83FDLvFrUjdP48945uVTlWos08
	 idcPX9+rJ7Nas13yKy3mUgOtn+G0Iq+oudYEyL4LPGm4XPo1mLLhcUXZZKM/doDcTn
	 41tI/VyoGUYvA==
Message-ID: <23f20eeb-b81b-423c-9b0f-62eef21192eb@kernel.org>
Date: Mon, 14 Apr 2025 09:36:47 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] zbd: finish zone when all random write target zones
 have small remainder
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
 <20250411111219.57424-4-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250411111219.57424-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 8:12 PM, Shin'ichiro Kawasaki wrote:
> When a random write target offset points to a zone that is not writable,
> zbd_convert_to_write_zone() attempts to convert the write offset to a
> different, writable zone. However, the conversion fails when all of the
> following conditions are met:
> 
> 1) the workload has the max_open_zones limit
> 2) every write target zones, up to the max_open_zones limit, has
>    remainder sectors smaller than the block size
> 3) the next random write request targets a zone not in the write target
>    zone list
> 
> In this case, zbd_convert_to_write_zone() can not open another zone
> without exceeding the max_open_zones constraint. Therefore, It does not
> convert the write to a different zone printing with the debug message
> "did not choose another write zone". This leads to an unexpected stop of
> the random write workload.
> 
> To prevent the unexpected write stop, finish one of the write target
> zones with small remainder sectors. Check if all write target zones have
> small remainder, and store the result in the new local boolean variable
> all_write_zones_have_small_remainder. When this condition is true,
> choose one of the write target zones and finish it. Then return the zone
> from zbd_convert_to_write_zone() enabling the write process to continue.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
