Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED334A945
	for <fio@vger.kernel.org>; Wed,  7 May 2025 07:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603466; cv=none; b=abGxHEDgknhhdX/7L7QLrotRT1cKH3ENpAqxCf1V4eFG2EyEE3VwsIrfjRNPeYrXN0Y4JnOYq6mC+KKJJbFgkR7E83zUmyWi3SNOYYNsVA6DO1wRc5iZrrf266fnxjDRV4sF59R8PZ4GfI3W6Yupr2XEKsglCcsF1FoyKscZAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603466; c=relaxed/simple;
	bh=QC+FykEo39zxfvktt/2NlJjTfA14Y8g1jg5UGbw5Qz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hXTYa+JhqvRigzKoGz+iWO0c+Vxyjd4az2YfVOoPllL4sdDMAmT0HZ3PnHTAH0uh3D9rDe/zQu7scOe3mnik2cHLbyF9caE/Snz6jhIjApjeOLw9BJkLpjoxfaCr8/dWB8Ducn6+o+PIUjpT4mmiY1TxR9Hv+KJaQcFM5JAh8/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZJMrjsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZJMrjsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9043C4CEF0;
	Wed,  7 May 2025 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746603464;
	bh=QC+FykEo39zxfvktt/2NlJjTfA14Y8g1jg5UGbw5Qz4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=OZJMrjsP7TZBoym4VbVVjRdn1dLEhNBZb8Epb/Ok6avAhgYk+VSG4r19N4vbWoAXv
	 ze21Fqw6uGfeGALcySEjc3R8CyKJLWvmEJ9uA+gawxpa/aFGqRuW+MLY/B4ZBIFv2i
	 Hnu+W2I0vSU4xsEpdfjKy9baTCyql/ye8u5g9cawmaV/gu3yDsT71yPV9Fl6e5QU+i
	 7riU8Vb0ljn6Vee2sAo9r0S9YUV4MxCY9c3O456HU6yxCbnfgVVUUhvFSlKIHDtGg1
	 ARDGKrw1M+whaK4BWHrtFIsJkxbtIlI+jbp251XT3KrhRnDaNvwXoEU3nUZSelgHtN
	 xNm3sqgOKdJvQ==
Message-ID: <101abde4-e934-477c-8b6f-c0fc6f9f1fac@kernel.org>
Date: Wed, 7 May 2025 16:36:34 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] ioengine: add move_zone_wp() callback
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <20250425052148.126788-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250425052148.126788-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 2:21 PM, Shin'ichiro Kawasaki wrote:
> As a preparation for continue_on_error option support for zonemode=zbd,
> introduce a new callback move_zone_wp() for the IO engines. It moves the
> write pointer by writing data in the specified buffer. Also bump up
> FIO_IOOPS_VERSION to note that the new callback is added.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
