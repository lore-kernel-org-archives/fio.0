Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3DB1F0E25
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 04:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772426515; cv=none; b=PL13kNNv5MW3sYbmywn19XRNP9QX+zzrZMkE8Dv0rChF0uEbJDzH5T3clTo+hsFX7qlYA5KQuzVit8mDrDu2+dCyKg0Xvr/9e4Er5EVLN4CdcJOcPOvDjfxHqwgMgfrdyzJ6TxAsW7q2Phm6QNwkCGQe14w6CVkICCdQcZ41yv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772426515; c=relaxed/simple;
	bh=fcRYR4a6jxr3XgjMBW9vNFEZzI9xovqZAmyb7cbN3hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Tffzr5j2u79RFVj2IniydlK3IuJyKgqOTn3wRQomsOLVXZuVeXzHgI6FWlDJi7z68V/OEz7j8JWyhxxKlY28FiFO95U2zJRlYo9m4Ng5yc6OG/kVWeGWRxpbkHQ0OmsZ9yp7uFGyy9BTrOCfq290sgGkBcHN7Zp0f1nRLhjU1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHFRpsQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHFRpsQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5015C2BC86;
	Mon,  2 Mar 2026 04:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772426515;
	bh=fcRYR4a6jxr3XgjMBW9vNFEZzI9xovqZAmyb7cbN3hA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=PHFRpsQnaWp36he3/jv6atLX6f5uuII7iOFtRgI2hkpmOcFhjRTEv/PxCUnuhWARi
	 YX9uZmK1fKVyQjbJVsaSRfcWUzS6xS8fprWJFm19RrZ+BGuU/+fJGqI+gCywP1TsAA
	 Ow/TKYIH6u+5A3fz/aGPU6g+2hmAxHpqV9wv86H5IIcG8xrIhehBVSvnwfTDl9PGrp
	 LUUrJ1lAlzgLDv4BHbttyjQIsRoeqVRCghyNPxpokRoQgssVfTKgovNQEqoh8fNTDG
	 Adw2vvxKn/a2BvPL8YSAMgBOOtgeGUMrWJraXUvMlBZIXSs1kVjeNaUKTqH+JTMLVc
	 +QpfwL4oqwX8g==
Message-ID: <1d1f28e2-cdb0-42a4-ae7a-eaaccac3647b@kernel.org>
Date: Mon, 2 Mar 2026 13:36:28 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] zbd: introduce write_zone_remainder option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
 <20260302022609.3526823-4-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260302022609.3526823-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 11:26 AM, Shin'ichiro Kawasaki wrote:
> When the specified block size is not aligned with the zone size or the
> write pointer positions at workload start, write workloads create
> unwritten remainder areas at the ends of zones. These remainder areas
> leave zones in the open condition. This disrupts the intended write
> target zone selection.
> 
> Previous commits e1a1b59b0b9b ("zbd: finish zones with remainder smaller
> than minimum write block size") and e2e29bf6f830 ("zbd: finish zone when
> all random write target zones have small remainder") attempted to solve
> this problem by issuing zone finish operation for zones with small
> remainders. However, this approach caused performance degradation due to
> two reasons. First, the zone finish operation requires substantial
> execution time. Second, zone finish operation requires to wait for in-
> flight writes from other jobs to complete, which is done by calling
> io_u_quiesce() before the zone finish operation.
> 
> To avoid the performance degradation, introduce the new option named
> "write_zone_remainder". When the option is specified, issue writes to
> the remainder areas instead of issuing zone finish operation. The write
> operation makes the zones in the full condition in the same manner as
> the zone finish operation, freeing up the zone resource of the device
> and enabling writing to other zones. Also when the option is set, skip
> the io_u_quiesce() which was required before the zone finish operation.
> The performance benefit by eliminating the waits on in-flight writes are
> particularly significant in asynchronous I/O workloads, where the write
> operations to the remainder areas are managed as part of queued I/Os.
> 
> The drawback of this approach is that writing these remainders requires
> write sizes smaller than the minimum block size. As a result, when using
> the write_zone_remainder option, the random map feature must be disabled
> using the norandommap=1 option, which is automatically done when the
> option is specified.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[...]

>  enum {
> -	FIO_SERVER_VER			= 118,
> +	FIO_SERVER_VER			= 119,

Note: this change will conflict with my patches proposing the addition of the
end_syncfs option.

-- 
Damien Le Moal
Western Digital Research
