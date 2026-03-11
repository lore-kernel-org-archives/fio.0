Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3414383C68
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 07:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212847; cv=none; b=I2OtY0qAE/wQ/FnmHvbqlzwV/g8dKRJ/MK5MieHavgLlRFN39PBxsOAGpfx5xJ952+W7iYAvjp6zTol3u+MlFdYAh4xR/wkxUANo/mxBcAulGGd6WZhRdPwcm1WSCd5dqSNwvbhOSJaT6k8Z9n+nZFFPE9r6YsHrvUkJmEkjMnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212847; c=relaxed/simple;
	bh=bPEYGEHzZO277KKZdNM5bnOT6UYBRuTJspuAuDjRYgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGkmUI58isgNbJJ2NIabY+71IP7D+vHBbFYlzxa61xoNPNB4V2PzEZP1WYryCdxL7FdNj1kDSafGl+Jxz7zcuogot1LRg6JS5Fu0ltn56Q0+VttsJcqpVPFHffvsrXZmrZWdqxT7t/r59erkqpJpxX6ALkZCB0++FxdO4vJ5qVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwHcISfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwHcISfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D28C2BCB1;
	Wed, 11 Mar 2026 07:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773212846;
	bh=bPEYGEHzZO277KKZdNM5bnOT6UYBRuTJspuAuDjRYgs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fwHcISfCJr+vwVVFKIt8CaNBCYJztmCmgiycw57XIihvbt1Tvm4jAm2Lf+9L0SujP
	 qsPLSbxgapscDj0MS8SJkCOxAkVT3oNQbIglzirAZ3HT1TDziK3eplk0SOECOuOuK3
	 4LV/+eL/lBpoTJPh1vug1EqLXQ3LkQgexKl7YYol1i8bfRgr/SLHbgG471NyFeZMzo
	 3r//1MNGCwXQxCR/iNkTzcPX6xqsV+ITkQamfO+jqd7bqdt3KRtk5C/QHKDjMZQfmE
	 MXFRmWCpP8MTaia20nvwI5Ht/agaLLPa9TWbWXeO/SAdFDX+jpGQIpfml2dw/FS9++
	 ndqIxIcGEEVPA==
Message-ID: <af0e0227-5670-4c16-8f11-fc43abbe8da1@kernel.org>
Date: Wed, 11 Mar 2026 08:07:23 +0100
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] backend: correctly handle rate_iops combined with bssplit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 21:58, Dmitry Fomichev wrote:
> Currently, rate_iops does not produce the expected I/O rate with
> workloads that use 'bssplit' option. Consider the following example
> configuration -
> 
> [global]
> direct=1
> time_based
> runtime=30s
> ioengine=io_uring
> thread=1
> 
> [bssplit_rate_iops_repro]
> filename=/dev/sdX
> rw=randread
> iodepth=8
> bs=64K
> rate_iops=50
> 
> This works correctly and ~50 IOPS I/O rate is logged during the run.
> 
> If we replace 'bs=64K' with the following bssplit option -
> 
> bssplit=32ki/20:64ki/40:256ki/10:512ki/25:1mi/5
> 
> in the configuration above, then some incorrect (much lower) IOPS values
> are observed to be in effect at run time.
> 
> This problem happens because fio, in order to derive the required
> I/O rate from 'rate_iops' value provided by the user, simply multiplies
> the IOPS value by the minimum block size (min_bs). Once bps I/O rate is
> calculated this way, the processing for 'rate' and 'rate_iops' becomes
> identical.
> 
> This works if the I/O issued has the uniform min_bs, as in case of using
> 'bs=64K'. However, with 'bssplit' option in effect, fio may issue I/O
> with sizes that are much different from min_bs. Yet the code in
> usec_for_io() currently always calculates I/O issue delays based on
> min_bs leading to incorrect IOPS being produced.
> 
> Fix this by modifying usec_for_io() function to check for
> bssplit+rate_iops being in effect. For this case, derive the IOPS rate
> from bps 'rate' member of thread data and then calculate the delay to
> the next I/O using the IOPS value, not the bps rate.
> 
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
