Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EB13612EF
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 04:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772168040; cv=none; b=ftFfOg46WQ78NKZjnK9OtzytK7YDbUn396dx4+FrdKpWgo1N8Np6BcTCWUYjE8Rs5fK8w6mr30bObMs2XIjN1QhnSNmACbYr++4F6fB8o05Q8y8FBZRQRhJLbYcoFT9ZksWdn2bSomhqk1XY9PN4bzeO5pRXJ6O6RUA+7j+pi5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772168040; c=relaxed/simple;
	bh=Y9AHYvCfT/gq6+n+iwTwxFpYVHKsmlHLfMs7Cn33LfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m93glArQP9540pAOFq177TTbh4kdlmVcbH0nhTQ53AvdumpUppicBuvfG022LlfjUDyiD7CbDmRDY91ja/GQF3Y95aKNGLUf33A1Pk73ItQ9I3vI1WHBUZOTEWUMOTv0ayugOLwfNmVb67T0O+nNONOzQNV4Kjz34FhzGVHfpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5HfQ5K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5HfQ5K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F02C116C6;
	Fri, 27 Feb 2026 04:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772168040;
	bh=Y9AHYvCfT/gq6+n+iwTwxFpYVHKsmlHLfMs7Cn33LfQ=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=L5HfQ5K9/Xt6goCFqzkoaxjSt8SgAPKk5TA4i0QZyqqa6xEX+uNIMpTupyWuKrRME
	 GOjBT7iZjXZJ6rpn7V3KmGZu17i4ewWVqupH5Fkiz1G50Nn7l4/q2uvOBe1BM4aPCh
	 jy0NLbmZFxiJg6WmXtaGl5Ae3Rgt16oCuwD84irJainKnCKiwcpHo9YMJoJ+T5Mm4l
	 NPFZdDSXbcdhWTnezkqL9CjDFw7UsoeZnK/wKOt0MxpYLVkiWFp0eNeDJQ74OYTDpB
	 8UdW4goljLNEmy3GTEEidqPC7yANyx9yYlHR5+bUyj1NKg42Mgl7VKtewdWQHDhAFc
	 LmUYxQWtkaPow==
Message-ID: <e1c6465e-8eb5-4a4e-b323-c31bccdedad2@kernel.org>
Date: Fri, 27 Feb 2026 13:53:57 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] zbd: fix write zone accounting
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
 <20260216075936.3318729-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260216075936.3318729-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/26 16:59, Shin'ichiro Kawasaki wrote:
> Currently, zbd_convert_to_write_zones() calls io_u_quiesce() when the
> number of write target zones hits one of the limits of write zones. This
> wait by io_u_quiesce() significantly degrade the performance. While I
> tried to remove the io_u_quiesce(), I observed that the test case 58 of
> t/zbd/test-zbd-support failed with null_blk devices that have a
> max_active_zones limit set.
> 
> The failure cause is an incorrect write target zone accounting in
> zbd_convert_to_write_zones(). This function checks the current write
> target zones, and selects one of them as the next write target zone.
> After the zone selection, it locks the zone. But when the zone is
> locked, another job might have removed the zone from the write target
> zones array. This caused an incorrect zone accounting and the test case
> failure.
> 
> To avoid the incorrect zone accounting, call zbd_write_zone_get() after
> the selected zone gets locked. If the zone is removed from the write
> target zones array, the function adds the zone back to the array.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/zbd.c b/zbd.c
> index b71f842c..c511b709 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1693,8 +1693,17 @@ retry:
>  
>  		zone_lock(td, f, z);
>  		if (zbd_zone_remainder(z) >= min_bs) {
> -			need_zone_finish = false;
> -			goto out;
> +			/*
> +			 * The zone might be already removed from
> +			 * zbdi->write_zones[] by other jobs at this moment.
> +			 * Even if the zone has remainder, call
> +			 * zbd_write_zone_get() to ensure that it is in the
> +			 * array.
> +			 */
> +			if (zbd_write_zone_get(td, f, z)) {
> +				need_zone_finish = false;
> +				goto out;
> +			}

The way I understand this is: since we do have a remainder, the zone is not
full, so zbd_write_zone_get() cannot return false. So this looks OK, but is also
very confusing. What about removing the if and instead use an assert checking
that zbd_write_zone_get() returns true ?

Also, it is not clear what the conditions are for a zone that is still not full
to be removed from the array. Can you detail that ?

>  		}
>  		pthread_mutex_lock(&zbdi->mutex);
>  	}


-- 
Damien Le Moal
Western Digital Research
