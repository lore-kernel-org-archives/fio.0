Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32C8430BB9
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772423236; cv=none; b=ksf12Va7UyP9EwYD0IXU7aCXCPb8gNeL7PzJkNhGDg8+U8oTFjQpLW6BJgozmPF/iI3kFxUhsrWVWJRheSc5F5mQD8LKID5WR9LcsM69iVDZUArs0t3brpvuuKtJBO7x5YfI8sQ+KwjxgQyxljleA1tPySvDIo4I0uyryyyRadM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772423236; c=relaxed/simple;
	bh=eJIxLomTK86sK4sTWI0rq6k7LBzYcN9EN4wFzvCKXJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GHdH0Vy9JcAMKHWbstFT0N1g79eINMBKhI1AybbFap3gjglY6nfsxAzwak5klAmcsmzVRtmTgusNtYx7N4dkecMcV2nILA1ToygTtKV+xS1aPy18AgWtveOquYp8Uqtld7VNzoT4HEKb5CMkEnqHF1eSJSwi2LREk746jnBW8Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOjOm3KH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOjOm3KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27B8C19423;
	Mon,  2 Mar 2026 03:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772423236;
	bh=eJIxLomTK86sK4sTWI0rq6k7LBzYcN9EN4wFzvCKXJA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=lOjOm3KHCP64pz/GVpUCNBtx8CRw7DYWgb6lTvj2oyBO+6maZUYnZRSfA6n2oWlVj
	 efpPTq4mGj2notxbWP+1N24v7fONJjSN4r2z3XqH1hVOK7YgDl59/6r1bja2/4R2hY
	 7jug+l1Yi8Oc67/4h8MqQl6i/Ty0skw2/qiwqvqBUpvLitwnykY9eiVz6tjO+1eYlX
	 TExw2FIgj9a7czXqegEFlz7ODvm7ff9D9zY06RtimmWWe1X/xYKlSkFg2GBKHxOcOC
	 gapl6+hFFjrZyReru+av+Kp5cneGMFmxWKFWKO2ll6ZiPGtQjtyVKea98dnH6yqCkn
	 QQv0fG0JsAxBQ==
Message-ID: <35cc81d1-ef4e-4b21-88ea-6386075677c3@kernel.org>
Date: Mon, 2 Mar 2026 12:41:49 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] zbd: fix write zone accounting
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
 <20260302022609.3526823-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260302022609.3526823-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 11:26 AM, Shin'ichiro Kawasaki wrote:
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
> After the zone selection, it locks the zone. However, when the zone is
> locked, another job such as a trim workload or a write workload with the
> zone_reset_threshold option might have already reset the zone and
> removed it from the write target zones array. This unexpected zone
> removal from the array caused an incorrect zone accounting and the test
> case failure.
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

Please change this to:

		if (zbd_zone_remainder(z) >= min_bs &&
		    zbd_write_zone_get(td, f, z)) {
			need_zone_finish = false;
			goto out;
		}

And move the comment block above the if. You could also improve the comment to
explain why we look at "zbd_zone_remainder(z) >= min_bs"

With that (and the much better commit message), feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

>  		}
>  		pthread_mutex_lock(&zbdi->mutex);
>  	}


-- 
Damien Le Moal
Western Digital Research
