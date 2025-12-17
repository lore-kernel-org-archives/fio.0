Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068411E0B86
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012024; cv=none; b=qjRVyKx/OFtSE7oqRVKpVpdtDXQUJ/1HXquIpYzCMz6Ru2c9ghEg8r1M6xWdMbKo5138VkTBQlUrWczkLukE5xvXUNi+duQkGIxfwSVZdR+D+cwxHIhHGElDVFQU+zA99beUQGUm43nMbTbEN6L4iyLWzjpcoDVg3HECr/kYmY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012024; c=relaxed/simple;
	bh=RRYFwzU87TLGg/7gMb2xiao/CnLZ1SADo2eG+ycdASE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3jH83XuTS9dSMxz+DFkNc4eNffzYO/LW53u9oQbwERXPeHIGmYuhq+bIcsqGBnoCUmo5ji1fVBd/mHoL9pC7fcuhhrmvpwxm71W6tta3a6nCvkFiJNwMuGsYQVD128dyoloXVD4NOtZbJJYB7oTv+AsDexI1ZgyBweX/d1iVz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bS+zADtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bS+zADtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED88AC4CEF5;
	Wed, 17 Dec 2025 22:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766012023;
	bh=RRYFwzU87TLGg/7gMb2xiao/CnLZ1SADo2eG+ycdASE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bS+zADtpWi/H6XaDCfvlax6XwzHnufuHcDWzCh0DemGGO6uMOwXQ+z6lKf36xmGoo
	 3xg70fIQkostypgaw3z0rBIFgmHd38ebe1ZzKdQs+dsJgxJyBJ7zBMDjLnWsdIrUGg
	 +zs+7riIcxrRSIphUk47x3d0saKcR0PHSeb4JhxpP9XnJxTG6WR8IZsXCuBqWDR2ZW
	 YrMyecwN65AQhlfsM9BhfBlBy3WOhE6IDPLao3gbNu0O5M/CffooKAFxT7/mQWAnwC
	 V/ez4/vW1xQMt083NWwMV54gK5ZWlgtEVBZORFXSi93AqzV3ddo0Rk4D0o//2suKIA
	 Nd/eDfVxfcMCQ==
Message-ID: <05e92077-955f-44ce-9b7d-9f225f26a536@kernel.org>
Date: Thu, 18 Dec 2025 07:53:41 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] td: Initialize ramp_period_over based on options
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-2-jack@suse.cz>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251217161722.6357-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 01:17, Jan Kara wrote:
> Instead of checking whether ramp_time is specified each time we need to
> check whether we are in the ramp period, initialize ramp_period_over
> based on the ramp_time option. This will simplify things more
> significantly later when ramp up period can be defined in a different
> way.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
