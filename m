Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9952C1F463E
	for <fio@vger.kernel.org>; Wed,  7 May 2025 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603423; cv=none; b=YxfSxGlwhs4CzAlqPIrOZ74SV4FauWjYAX9dMb6UCcBC2xvcggjvnOtADQbA6p5r46Lg9MdvTXJegOlZOlJke3eLUqPLawEtd76X/uRcUoD0DGeIDPXZ73YTJQOBwiejrMfcCUo+Y2QE/qb8qaLW16pldT7q7BNL8Z8sQ0v1vxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603423; c=relaxed/simple;
	bh=Od/Gg36feHotHj4JFX/gKwUFq4l75GjOvJCUrxgzSkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y/LzDaww9El4gcV4rCGN/9tTdbSBdNUet7Hucz2ozdl3PdoKFjk9lwmc5PByl6eUBLJlATIAB2T8AF3qJzsyTTpdgWl22ZHtem3yRqtjDnAysjbBpBjwvkQQ3DlDADvsuQeZGfTv7T64M9059SRoHrs1Qu5UJu1vc6+UppySdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coVu0nMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coVu0nMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0EEC4CEE7;
	Wed,  7 May 2025 07:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746603423;
	bh=Od/Gg36feHotHj4JFX/gKwUFq4l75GjOvJCUrxgzSkM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=coVu0nMPXTgleiyo63w4Xnqbyd179XC1jFfjVHBc0bDeK98LsQDAREZ67ZMJ2m5Jx
	 nb+R3K/sjEXOAtsLP2+E/HKK5TPt3quCyAim+iDtV7nfU4aDwFdKkk5mZNTQllcrF8
	 TVJ5yu11uocPa/xuaTWyEE0UJxkjpIgU3aYwlDhLrpRr0pIEaz4xQmCUR0MPTj933a
	 KPcn+WVZgxuQ0CMtlvxYoqv3lBSLKDSoTRIFW8fnUzqTwlRFpQUfmPYZHpKOhutA8X
	 qykeftTedADGUwBOoVn0qEqOx7AxLmckD20kpX4Ej4JOA7uSeWyVf26PAdhtykYGz+
	 4KPFEfzpEw+tQ==
Message-ID: <fb772b50-0f8a-4d42-9c89-0c581433b421@kernel.org>
Date: Wed, 7 May 2025 16:35:53 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] oslib: blkzoned: add blkzoned_move_zone_wp()
 helper function
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <20250425052148.126788-2-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250425052148.126788-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 2:21 PM, Shin'ichiro Kawasaki wrote:
> As a preparation for continue_on_error option support for zonemode=zbd,
> introduce a new function blkzoned_move_zone_wp(). It moves the write
> pointer by data write. If data buffer is provided, call pwrite() system
> call. If data buffer is not provided, call fallocate() to write zero
> data.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
