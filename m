Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC936210E8
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oI4zKZGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A970C433C8;
	Wed, 20 Dec 2023 01:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703035818;
	bh=kvG9G7axBL+UI21CAZGKSL8BC26cS29V2T64AogvWpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oI4zKZGE1FJQb1Oo3dRHcUXR2v9plEW2FiN9fZkeF1tNA3dtxhIPFitPiTufjPsxp
	 rtdUZtyn0MaZCwXtO4ehJXO9oKesxL8DGO36SKsYFmFhNQ0i1YzbiaRxIqU6+Mhwpf
	 xDRlU8at/GHlE+iiLsGu/aNMg6OFdTXrJS++0eLWM3N2QLzQQ0WqMcEtp6dk5Jqb//
	 BCTz8cticaLdGMnikwam2npEQ8kU029jvrNimAUGlC+e9gGuz0tgNpAgxjnH/0LE+u
	 kA5ya2txtXaryK2ax3gzXTSQrcaQ+wdFl7R43lWh/HMeM61yzswK/8iagiVK29XPrT
	 ngMdc32bTat+w==
Message-ID: <ef95a2ff-fdf1-4965-9302-3f7c2254c898@kernel.org>
Date: Wed, 20 Dec 2023 10:30:17 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] zbd: avoid write with rwmixwrite=0 option
Content-Language: en-US
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
 <20231220005846.1371456-2-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231220005846.1371456-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/23 09:58, Shin'ichiro Kawasaki wrote:
> Since the commit fb0259fb276a ("zbd: Ensure first I/O is write for
> random read/write to sequential zones"), fio issues write as the first
> I/O when zonemode=zbd and rw=randrw options are specified. However, fio
> issues the first write even when rwmixwrite=0 option is specified. Users
> do not expect such write and it confuses the users. To avoid the
> confusion, suppress the write by referring td->o.rwmix[DDIR_WRITE].
> 
> Fixes: fb0259fb276a ("zbd: Ensure first I/O is write for random read/write to sequential zones")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/zbd.c b/zbd.c
> index c4f7b12f..61b5b688 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1876,7 +1876,8 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
>  	if (ddir != DDIR_READ || !td_rw(td))
>  		return ddir;
>  
> -	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
> +	if (io_u->file->last_start[DDIR_WRITE] != -1ULL ||
> +	    td->o.read_beyond_wp || td->o.rwmix[DDIR_WRITE] == 0)
>  		return DDIR_READ;
>  
>  	return DDIR_WRITE;

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

