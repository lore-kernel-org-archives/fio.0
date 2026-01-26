Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A921ABC9
	for <fio@vger.kernel.org>; Mon, 26 Jan 2026 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769410527; cv=none; b=gI4pHYYPsWaJEy+yXDAaLx7XZOq+jvMhV0oj20N/wMFKnmMI3sC3DIVyC7nqS6Cni2FrMiHBhITOYTbD01SCi8iR+WCA3V3iPwB6GUSGDGPoN2ZfNbrIFBeEmEkxlOJJwrRa73YlxiBXQCVhVUpDHoL2xGHiez3POqecTLdsVzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769410527; c=relaxed/simple;
	bh=X1Ehh4y2ZbUnwECLvewZLYpoCU1CXDYkQeh9jDIel+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ua7q8mMiMDJMQq0xfqHfQLtw3MSWzz2fIbgVe7fG34OTS5niyPLKUoeXQWbvPjxuJGvPXm52/ETSrc+tfy0XZ5dx21v3tW8uMKtPwZ/1+5UihwnOm/0kva2gMLd1rmnKpSRV5NgSKzbVFStJYcBLJB5VhUgdguxnqDBhmcLIay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYhlnnfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYhlnnfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF85C116C6;
	Mon, 26 Jan 2026 06:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769410527;
	bh=X1Ehh4y2ZbUnwECLvewZLYpoCU1CXDYkQeh9jDIel+M=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=XYhlnnful+3ujHRhXBFlAh2IT6w04nIHqaRv1Ily3rqObRZ0wbPfzAGOrWGFckbHH
	 gwHLLv6+y2/Z5KysbiPHdhp4b+wlBfi6lar3VMz/8JGow7zgqkf5YYp+M+KRYjR4Ah
	 w3ZsoqcZRHiFBd/ic/rZ/0XU7sS3DalgqPVG1muCrx1x02Hevfs+jvWw3XTHzJL+2+
	 RbM1ojnsZOeC938m+BaOsnjzC4a8UJksVe7ygc54qkInsH1uHd8QmC3a4uwzBHwAR1
	 61IyOckQNVCN2TrlQf98DyxYIHsCkCcuIxxtgtiIFsZSY5zT9F7GkbWzlD75ngYC3A
	 WakNDiD64FaOw==
Message-ID: <67f30e83-bab6-4e44-9f3d-f5d5a2056203@kernel.org>
Date: Mon, 26 Jan 2026 15:50:28 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] zbd: fix problems of random write with unaligned
 block size
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 11:35 AM, Shin'ichiro Kawasaki wrote:
> When random write workload runs with zonemode=zbd and block size
> unaligned to the zone size or the initial write pointer position, two
> problems are observed. The first one is write target zone selection.
> When one zone is filled by the write workload, the same zone is selected
> as the next write target. This results in writes concentrating on
> certain zones despite the workload specifies random write.
> 
> The second problem is write performance. The writes with unaligned block
> size leaves small remainder areas at the end of write target zones. To
> free up the zone resource, current fio does zone finish operations to
> the zones with the small remainder. Fio also calls io_u_quiesce() to
> prepare for the zone finish operation and the write target zone
> switching. These zone finish operation and io_u_quiesce() calls
> significantly degrade the random write performance.
> 
> This series address these problems. The first patch addresses the write
> target zone selection problem. The following four patches address the
> performance problem. Next three patches clean up the code by removing
> the zone finish operation. The last four patches adjust documentation
> and the test set for the changes in the series.
> 
> Shin'ichiro Kawasaki (12):
>   zbd: fix zone selection of random writes
>   zbd: set norandommap=1 when zonemode=zbd is specified
>   zbd: write zone remainders smaller than minimum block size
>   zbd: fix write zone accounting
>   zbd: remove io_u_quiesce() at write target zone switch
>   zbd: remove zbd_finish_zone()
>   oslib: remove blkzoned_finish_zone()
>   ioengine: remove finish_zone()
>   doc: explain norandommap restriction and small remainder of
>     zonemode=zbd
>   t/zbd: avoid test case 14 failure due to no randam map
>   t/zbd: avoid test case 33 failure due to zone end remainder
>   t/zbd: avoid test case 71 failure due to zone end remainder

For the series:

Tested-by Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
