Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23439208D0
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 05:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772168764; cv=none; b=otcsHV2LnBFAeBK+sHFSdQsRi4UlzdmG+R9O8k9wsPP6s5PQvzk6Ig1Nw3EMDtxOoKryVx60BiPb6ds4hlCQuSM2C/7YCP+kfzsj9QIZRY2K7MWfptz7zU8Y12xTGKmnU+9iWvsu+LpK5G46mpGDFWlEAxp5200CkygVzExj5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772168764; c=relaxed/simple;
	bh=Ht2dKIfCvsBcphF/+03Ir3YFLKFn/sKWn6Yz0sWjdV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oaZ8N1fT1wVzY8hij+MoOQVPjbGj0KBntih+kvZhtB5l+2qI/HkArstV8L66hAkEdEku8DCDZCrfL0tMU0mQIOsscdsuyc0qlfiZ+Ud8ux0aEvGNyLl573fJgkGr2GEcc5wGO2EYXH2t31nsAmrYAeZz7GSxwvnKjvWiCG0Vm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r586kjaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r586kjaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31108C116C6;
	Fri, 27 Feb 2026 05:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772168763;
	bh=Ht2dKIfCvsBcphF/+03Ir3YFLKFn/sKWn6Yz0sWjdV8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=r586kjaTU3BDxHa3EVAZqEvEV8q0rwazkm/aT+jyea5gGJrvV7UvRLVZbcV/5JaVa
	 lO8EwJqQSwnJ28yE+cMowmvJrtmCc/cGk5YsMd8W59KwOBt2n0V1CBlOT5UUFJaBwA
	 8/ChzDpCno5Ni04nLUkQLuj0ZEbr4N4flVd5x/pXuINUa+MUxMCyDb5f6B/arljs4J
	 JUSPYAUPji1mT5uzoR1LxDjYQ+3+xRuYkf9hF7XuqL4dLMZRJHCpO3gnwDwtvW7bdX
	 QvqdknUnPyVKNSc69ntBFiSEc43u9hBdHwXqTOQJ03OcW3mlQnLRkNj0XSqKpCARTk
	 oKuGTv4zWeG5A==
Message-ID: <309b8511-d964-4ae3-9394-243cc8056ea2@kernel.org>
Date: Fri, 27 Feb 2026 14:06:01 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] doc: explain the option write_zone_remainder
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
 <20260216075936.3318729-5-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260216075936.3318729-5-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/26 16:59, Shin'ichiro Kawasaki wrote:
> The recent commit introduced the option write_zone_remainder. Explain
> how it changes handling of zone end remainders. Also, amend the zbd
> zone mode description to explain the default handling of zone end
> remainders.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst | 26 +++++++++++++++++++++++++-
>  fio.1     | 25 ++++++++++++++++++++++---
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index d31851e9..148c650e 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1034,7 +1034,14 @@ Target file/device
>  				all zones instead of being restricted to a
>  				single zone. The :option:`zoneskip` parameter
>  				is ignored. :option:`zonerange` and
> -				:option:`zonesize` must be identical.
> +				:option:`zonesize` must be identical. When the
> +				specified block size is not aligned with the
> +				zone size or the write pointer positions at
> +				workload start, write workloads create unwritten

				If the size of the unwritten space in a zone is
				not a multiple of the specified block size at
				workload start, write workloads create unwritten

> +				remainder areas at the ends of zones and keep
> +				the zones in open conditions. To free up the
> +				open zone resources, fio issues zone finish
> +				operations to the zones with the remainders.
>  				Trim is handled using a zone reset operation.
>  				Trim only considers non-empty sequential write
>  				required and sequential write preferred zones.
> @@ -1167,6 +1174,23 @@ Target file/device
>  	asynchronous IO engine and :option:`verify` workload are specified,
>  	errors out. Default: false.
>  
> +.. option:: write_zone_remainders=bool
> +
> +	When the specified block size is not aligned with the zone size or the
> +	write pointer positions at workload start, write workloads create

Same as above.

> +	unwritten remainder areas at the ends of zones. By default, fio issues
> +	zone finish operations on such zones, transitioning them to the full
> +	condition and freeing up open zone resources. However, zone finish
> +	operations introduces waits for in-flight writes, reducing overall write
> +	throughput. If this option is specified, fio writes data to the
> +	remainder areas instead of performing zone finish operations. This
> +	improves write throughput by avoiding waits for in-flight writes,
> +	particularly in asynchronous write workloads. The drawback of this
> +	option is that it requires fio to perform writes smaller than the
> +	minimum block size. Consequently, the option :option:`norandommap` must
> +	be set. If :option:`norandommap` is not set, it is automatically set.
> +	Default: false.

With the above and similar fix in the man page, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
