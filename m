Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E89536C
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744590588; cv=none; b=aU2WuY+/k441gVpI5fNa+BVuhYgxJV88XM8yX2TVAMKUKmIuJcR8ZyUOHdZnmSfruNVlcuC5yIkSB4R/GiIDCpm2Aq3YO7azucS7ERfYs4ZkuePdSWRALtK9eaXyckBkoMfspxgBdYE9cfPMwPpAI8EHm93/PKS1VXRjdOh97vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744590588; c=relaxed/simple;
	bh=UXGMnpwMk2uCulzR0HWK5FfAEbh9n0oLNizHw25Lfsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FlKh6ttUVEchKiCSoZsCZb1tDEE9J6T0OL2XXWxLPJEEU9MValtqZurk9WiXvVHYLCpxSvLh62Hln1V4jCwK6O37QZmvOnzdZ5YlHplpky6tCNVhELYPsdKRwvHoE0qlX67yVTC3J5tCe93uLT+PF3cPGsciWh+AvC2el527lkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=plXMS9fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="plXMS9fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E62C4CEDD;
	Mon, 14 Apr 2025 00:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744590588;
	bh=UXGMnpwMk2uCulzR0HWK5FfAEbh9n0oLNizHw25Lfsw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=plXMS9fPvCC4kN6eKgSG01oQ4/pl13hzTXbBWNO77WE3kqM+6cP+I/ZukZ9NUYQS0
	 lZyCXrxrlOt6CiJRtwkpL0wx68Ho9Kslv8rYCDX8IPBD0XDAmwqDKZfVy74TdEFd9d
	 lEv0xfDl6ZzuS+/nXvS1yeolwD/IKj+JUHWUCoS17j/vXsyY6Q6yHSpEu1hU4l6CD0
	 ftoPn+fL3CTRzy/6bB3699o9orJRTH64OYimP86p7CBnyUowbqJOvZz+tNdaObcEy8
	 6Z60KIsr5HeZH6lzFpY5LVmI5+a9NrqcNOoUTr+rRZ3bCV9KOXbvctJ/FJnlYIF5v/
	 6KhlPUbGGMRUg==
Message-ID: <ca6da862-71a8-4c40-a6cf-a1b5999edc5e@kernel.org>
Date: Mon, 14 Apr 2025 09:29:00 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] zbd: move zone finish operation to
 zbd_convert_to_write_zone()
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
 <20250411111219.57424-2-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250411111219.57424-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 8:12 PM, Shin'ichiro Kawasaki wrote:
> Currently, when a write target zone has fewer remainder sectors than
> the block size, fio finishes the zone to make the zone inactive (not
> open), so that another zone can be open and used as a write target zone.
> This zone finish operation is implemented in zbd_adjust_block().
> However, this placement is less ideal because zbd_adjust_block() manages
> not just write requests but also read and trim requests.
> 
> Since the zone finish operation is exclusively necessary for write
> requests, implement it into zbd_convert_to_write_zone(). While at it,
> improve the function comment.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

A few nits below. But otherwise, nice cleanup !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  zbd.c | 84 ++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 45 insertions(+), 39 deletions(-)
> 
> diff --git a/zbd.c b/zbd.c
> index ee095b1d..5e0f7f4e 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1396,16 +1396,23 @@ static bool any_io_in_flight(void)
>  	return false;
>  }
>  
> -/*
> +/**
> + * zbd_convert_to_write_zone - Convert the write request to writable zone

Maybe: Convert the target zone of an io_u to a writable zone
?

> + * @td: The fio thread data
> + * @io_u: The I/O unit write request to convert

We do not convert the io_u, but rather, the zones it targets, no ?

> + * @zb: The zone selected at the beginning of the function call. The caller must
> + *      hold zb->mutex.
> + *
>   * Modify the offset of an I/O unit that does not refer to a zone such that
> - * in write target zones array. Add a zone to or remove a zone from the lsit if
> + * in write target zones array. Add a zone to or remove a zone from the list if

Nit: s/list/array

>   * necessary. The write target zone is searched across sequential zones.
>   * This algorithm can only work correctly if all write pointers are
> - * a multiple of the fio block size. The caller must neither hold z->mutex
> - * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
> + * a multiple of the fio block size. The caller must not hold
> + * f->zbd_info->mutex. Returns with z->mutex held upon success.
>   */


-- 
Damien Le Moal
Western Digital Research
