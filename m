Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C6361642
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772167712; cv=none; b=CrvpNJo7AU2Pfs8+xrvuQhKjUIcth8s1MBkfp83lnkw1etwM+j3qmwlKiNSqtM8B7hj2yZEivDNikmcYH8QPNGbDruYy1E9iBYXhNhH6kznTpJERVgRkaezOhAcsQbsVPSi2bJlc03Zg7Y0VXdlmoPawgD22NLwqw7ey/eXnqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772167712; c=relaxed/simple;
	bh=mtpD9L95DgvhlUHn0fTanLgKYpxEixqsJkfNvwiAE6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hiuXJrbGUrS2Y0Tljaf9VIBimpQpS+wsvW8t+WY37NlJxEdj2pwUy/bAjDUvkBiLkjQibwjbayUsd8ZeDNuHqJQAgNUYOzH0HuCgAyFZdMH8vQi+O11lEg0w5r0Acz2gYupXEhTJ7U/bK9QUAeKo3kbimRIJcYUtznKTN6ukt8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzK276cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzK276cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1214C116C6;
	Fri, 27 Feb 2026 04:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772167711;
	bh=mtpD9L95DgvhlUHn0fTanLgKYpxEixqsJkfNvwiAE6I=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=bzK276cRIE7AcvEl6JR3Z5PX36vCp+CMIZCo4dGwXtSov+6vl1jXC1+DYU1dh2Ddn
	 P2+YeGA2Djt7HiEL6vvE89Kx4NHK7mdMJAE5pseVgQCLwGE1C9/hLIomEaCtAGhMYl
	 5y315yolZIaMUUGGJDVnMP/p8wIxH35R63zszBfexrX2dMdafofTsFiw0UHtEmXyfL
	 NJRykkZe4e25Tmj7zyqE0Ua7ee0gHUoW19I0ivvpygPuifwVc0LkZno5OfpmQdxzN+
	 qjHUGvECSHI19SOOZzssFUFxpi7wPQ0oy3wQV8mXQVu4PMxcWQw/0GiE16z/Q0d96N
	 TlZWhtMsDnfRg==
Message-ID: <cfbd8963-228a-42ee-8cfa-f2cbd01a9991@kernel.org>
Date: Fri, 27 Feb 2026 13:48:29 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] zbd: fix zone selection of random writes
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
 <20260216075936.3318729-2-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260216075936.3318729-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/26 16:59, Shin'ichiro Kawasaki wrote:
> In zonemode=zbd, random write workloads targeting zoned block devices
> with max write zones limits such as max_open_zones can not do write
> operations to randomly chosen offset because of the zoned block device
> constraint of writing at write pointers. To adjust the offsets to valid
> positions, fio calls the function zbd_convert_to_write_zone(). This
> function checks the current write target zones as the next offset
> candidates but may fail depending on the conditions of those zones.
> In such cases, the function waits for zone condition changes before
> retrying.
> 
> However, the retry logic begins with the zone where the previous attempt
> ended, and selects the zones that were previously write target.
> Consequently, the same zones are repeatedly chosen for writing,
> resulting in writes concentrating on certain zones despite the workload
> specifying random write.
> 
> To ensure proper zone selection for random writes, modify
> zbd_convert_to_write_zone() to retry the zone selection based on the
> original offset provided to the function. The local variable 'zb' keeps
> the reference to the zone corresponding to the original offset. Use 'zb'
> at the retry attempt start.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
