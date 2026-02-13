Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8CC8405C
	for <fio@vger.kernel.org>; Fri, 13 Feb 2026 03:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952643; cv=none; b=TnKYeqBYzzi0SFAV5Baw/G/KdBIpz611MotxS1LNvy6RdGgalCT16k79mIKupdWWwXeluzGk19xwAbaOgr69Xn2RMH0IBjPzgvkNVUqcJIgRE18CC4m3egC3bFMBhZyffL49xkx8AtB8Ho+Y/fn+J/CgiT4cZnMIOhFM+h5uR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952643; c=relaxed/simple;
	bh=53HQJuK/sX88AvKzsQyUXw0zyXHl0QFDLw12EL7VXiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8xcHss26ju8mp8KLp8XFRbwjsQyUI7sAqR0f5fJEclyufBBlIMGkbc9nSEKdz+T9CFVpJSBAs0dwCrjkYX//pWWeqTn8eqB2ZWVVxpKm247Q5oQg6PLLTClM+KTT2e8jwX3ghRDsWaROuoKS6MNtCKvLQqi2UE5qG2MMNqZBOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRY4X/LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRY4X/LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152C9C4CEF7;
	Fri, 13 Feb 2026 03:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770952642;
	bh=53HQJuK/sX88AvKzsQyUXw0zyXHl0QFDLw12EL7VXiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RRY4X/LWJr6L+7skAJwf5ea3kHDCgcW9zY5oKWNWYRUtVxmoaMNndj4+lRGMHNSI2
	 L/NshXe/Vt6hx5m3h2ICTwt5EU6m6RqyGj0ECVuNHrAlIJ7LqQ3g81xGsPAyB+XEVy
	 WAWtYSg9TURwDmmCE71OKorm7TeaVv0O4xjdj1FzR4+zXyFLHyNv/pMDTa+46yNXiR
	 5ZmEI88/egqNtniejuk1KiHsJdCU8hDWeNbADh3CVWkQPW5RHxPEmSFTwX48iF5S0e
	 9IZsHjHMwxG0r+5yAb2XljsRDsfSgbxeJBW/JZYlPJlpeclpS/gQBiHEk/uhnbALH5
	 3LAz4HakZPawg==
Message-ID: <d22e6af8-667b-4000-94a8-3fab53c75607@kernel.org>
Date: Fri, 13 Feb 2026 12:17:20 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_u: Fix inconsistent handling of non-fatal errors
 with option error_dump
To: Niklas Cassel <cassel@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, Jorgen S Hansen <jorgen.hansen@wdc.com>
References: <20260206164058.3105327-1-cassel@kernel.org>
 <20260206164058.3105327-3-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260206164058.3105327-3-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/26 01:40, Niklas Cassel wrote:
> Commit 8b28bd413759 ("backend: Add configurable non fatal error list")
> added an early return in io_u_log_error() for non-fatal errors.
> 
> This early return is performed if the error is a non-fatal error, and if
> error_dump is not set.
> 
> Looking at the help text for the error_dump option:
> "If set dump every error even if it is non fatal, true by default.
> If disabled only fatal error will be dumped."
> 
> So this commit made sure that, if error dump is NOT set:
> For a non-fatal error, io_u_log_error() will return early and will thus:
> 1) NOT print an error to the log
> 2) NOT call td_verror()
> 
> However, if error dump is set, io_u_log_error() will not do an early
> return, instead it will log the non-fatal error and then call td_verror().
> 
> It is clear that the intention is for a non-fatal error to not set
> td->error. (If error_dump is used it should _log_ the non-fatal error.)
> 
> Thus, fix the code such that if error_dump is set, for a non-fatal error,
> we:
> 1) print an error to the log
> 2) NOT call td_verror()
> 
> This will make the behavior in io_u_log_error() consistent.
> If error_dump is set, we will log the non-fatal error, but regardless of
> error_dump being set or not, we do NOT call td_verror() (which would set
> td->error) for a non-fatal error, since that was obviously the intention
> of commit 8b28bd413759 ("backend: Add configurable non fatal error list").
> 
> Fixes: 8b28bd413759 ("backend: Add configurable non fatal error list")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
