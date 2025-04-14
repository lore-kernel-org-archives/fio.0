Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FFD79D2
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744590964; cv=none; b=QKLMj2aXvd168xDcySWMcYs0U7cgxZ8TvnNu+DiPZUUzPZgQ4sI3kYrWkqqi7Jk0DmjFVITiPUoWVAwkfdz64+vk6e1v7ARSIDYNSK3gEohl4XrS7hAzCqlRiucQho22C4nFQ8kfNkT6DTILTRW/U/YD5T1tx7onMistT6zr86g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744590964; c=relaxed/simple;
	bh=mEJi/O3S4YFNZBK0S8GXD9df98TRYwxCHRYrOfV7Z5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C0M2SxfjtS5VYLzxTphgceEBnWGQDE+TNfnLROTvg5B7nkWLMdM++M79KrCbm1wEj/ob+SRVikS+dq4wfXpP4ybUHBkgkfZR1YDBa3w+SbeXbSZ/knCQ7EMTwiV7hzCH0s1VvsZqvAdtOQqFYJxEldGFIo2d0sYTwgT7sPjVvjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Opl1I6nN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Opl1I6nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D21C4CEDD;
	Mon, 14 Apr 2025 00:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744590963;
	bh=mEJi/O3S4YFNZBK0S8GXD9df98TRYwxCHRYrOfV7Z5Q=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Opl1I6nNRfggov7VB8o5PfSTk6L9t6L99w7y/E2C6GNmdc8sEpMLO3E8xj5ZFdu/K
	 XTu4U1YiO/iMVEtRnS+goQAjUoKyI5exnFLwO+eXb25xA8bZzaOO4Fm3ofnbcqqHrU
	 wfybUIw6qmLbIjEQqWgW0K7mBpJ0EB5fD8Z/QNhv1t4VGj3EkeK/jYrjcDtcNu5y7g
	 YfzObkl2QvenpAaMIX05w4eo6i5+c6wGJ0KvmVFzDMxLyfuuCpODElY9zBXqEdhAux
	 g3+bRptebNJpUOC+GESNVQhkguwF457JprtuWKhtdwGcXgALwqd4jW9egPkVmJHXoY
	 2R0NsPnRTMtlA==
Message-ID: <2d3ab242-0a2f-4633-9c1e-92fc13e0e810@kernel.org>
Date: Mon, 14 Apr 2025 09:35:15 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] zbd: factor out zbd_pick_write_zone()
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
 <20250411111219.57424-3-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250411111219.57424-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 8:12 PM, Shin'ichiro Kawasaki wrote:
> To prepare for the following fix, factor out a part of
> zbd_convert_to_write_zone() to the new function zbd_pick_write_zone().
> This function chooses a zone from the current write target zones
> randomly.

Maybe:

This function randomly chooses a zone in the array of write zones.

> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 81 ++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 44 insertions(+), 37 deletions(-)
> 
> diff --git a/zbd.c b/zbd.c
> index 5e0f7f4e..23c18bd3 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1386,6 +1386,43 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
>  		f->zbd_info->num_write_zones / f->io_size;
>  }
>  
> +/*
> + * Choose a zone from the current write target zones randomly, which is in the

Randomly choose a zone in the array of write zones and in the range for the file f.

> + * range of the given f. If such a zone is found, set its index in
> + * f->zbd_info->zone_info[], and return true. Otherwise, return false.

I am confused by this description... This function is not setting anything in
f->zbd_info->zone_info[]... Did you perhaps mean:

If such a zone is found, return its index in f->zbd_info->zone_info[] using
@zone_idx and return true. Otherwise, return false.

?

Other than this, the code looks good to me. So with the descriptions fixed,
feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
