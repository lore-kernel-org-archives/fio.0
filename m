Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC05220681
	for <fio@vger.kernel.org>; Wed,  7 May 2025 07:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603863; cv=none; b=IRDWEkhpyfI9HE1y2zAMB27YjOCKaVrcPFoszDaXJAzDfM8/tE7MHyqeOuzBTZhdxoFCyG2RGQYi79bdqaRyusWrMEfwbeSGbLDiErFtHNupsgwH8eZWkt+S+LUiQgsKCAYqZ/rUKm5j84x36JYMKZbni5XbxEICFodpjLGIVZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603863; c=relaxed/simple;
	bh=X2rjrpWA/qNRbN5leOCLcfbsUFkbslhltmW6uqn7MtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F7efEqbwz72Q3Not1rmD33/DgZQTjyShNaCY2gnFMtVkfBwDbeZfsBy6/A7KZNZEUSjWQ6Lg9Ui42AESN14cBxP1YDAlFxkOfMkpvOXEfUNkBJ6qtby6Uv7RdvnzPTW0+AFr5KgMHHsWBiYHxkOw3y92dndHwI2lpfMj/G+4jII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1q9qGvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1q9qGvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDA4C4CEE7;
	Wed,  7 May 2025 07:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746603863;
	bh=X2rjrpWA/qNRbN5leOCLcfbsUFkbslhltmW6uqn7MtA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=X1q9qGvEclw7XgWkHqo2EtWISO5aAQ/16UTK0GKq/ee8p+V5sIi6hWmi3KLO86Pux
	 GHst+qWOH3MySbrbInCKOXgvrLKLG7w7gC79iFDOElY5A1BV4QXwcxJO5Yy4mkKfJ4
	 /rmsV1M12MJDOR5OxQL/ZByPAi8pAaxI9BPDi/7gdufueTvGY2qCnv0q0dZcHBSHrc
	 xmv6QzSCk8LKE4esnwgdaYuC1iEOY8HPeQT6L6yXJ5Z1dD9NEXRQO1C0lrjyJOiwAu
	 qSD7yt0ivopg9nfxPOZfUUUkMQGHhDdt+jxMnKzNynN4vxjn4+T8EDilH+1iYleqeN
	 fGlZvp9kjSENA==
Message-ID: <1e2607ab-b6af-4dc9-9e77-111de64f98cf@kernel.org>
Date: Wed, 7 May 2025 16:43:13 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] zbd: introduce zbd_move_zone_wp()
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <20250425052148.126788-5-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250425052148.126788-5-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 2:21 PM, Shin'ichiro Kawasaki wrote:
> As a preparation for continue_on_error option support for zonemode=zbd,
> introduce the function zbd_move_zone_wp(). It moves write pointers by
> calling blkzoned_move_zone_wp() or move_zone_wp() callback of IO
> engines.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good. One nit below.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +static int zbd_move_zone_wp(struct thread_data *td, struct fio_file *f,
> +			    struct zbd_zone *z, uint64_t length,
> +			    const char *buf)
> +{
> +	int ret = 0;
> +
> +	switch (f->zbd_info->model) {
> +	case ZBD_HOST_AWARE:
> +	case ZBD_HOST_MANAGED:
> +		if (td->io_ops && td->io_ops->move_zone_wp)
> +			ret = td->io_ops->move_zone_wp(td, f, z, length, buf);
> +		else
> +			ret = blkzoned_move_zone_wp(td, f, z, length, buf);
> +		break;
> +	default:
> +		break;

Nit: You can do "return 0;" here and remove the ret variable initialization on
declaration.

> +	}
> +
> +	if (ret < 0) {
> +		td_verror(td, errno, "move wp failed");
> +		log_err("%s: moving wp for %"PRIu64" sectors at sector %"PRIu64" failed (%d).\n",
> +			f->file_name, length >> 9, z->wp >> 9, errno);
> +	}
> +
> +	return ret;
> +}
> +
>  /**
>   * zbd_get_max_open_zones - Get the maximum number of open zones
>   * @td: FIO thread data


-- 
Damien Le Moal
Western Digital Research
