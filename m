Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7145E220F4F
	for <fio@vger.kernel.org>; Wed,  7 May 2025 07:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603763; cv=none; b=qbEYkXaZ/dGsWsfN1qUdYc81nTBITPZnT9JErmtQ9oxr3I+fhGM62fkKcc7vmZhpsuY/XCxDyL+HeMuRXhlWQzkCd+w4AD9O56sngv0yrrO8fEKsdpT76W/wTnnLn5zJ92ZgvLSnJiw2zxdcdmW9kQEj1xIFo1udZaM/xL4vXJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603763; c=relaxed/simple;
	bh=Gx0gHMcUrH9PTsx4RHELsyVT5XCbTCo1uVpl73XGPzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tWtNyQGBESuAFICTuZ1FEasU5cqUbT5d+DqfzVsUy5GB3W7HbpepdCB6vYvqs4IutqpEIrZ7Ne5LX2R15TdEF7ZhhE4IvYVe7EjoIOfDm+Hqyt06UVj4j9S/HSjZXNFKUMe9a8sNbo/C66lF54upuLZ+eHJuWAtOarUCscVZDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zxr5XAwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zxr5XAwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214D6C4CEE7;
	Wed,  7 May 2025 07:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746603761;
	bh=Gx0gHMcUrH9PTsx4RHELsyVT5XCbTCo1uVpl73XGPzI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Zxr5XAwaApb+fnwhNSfMtu7UP8sP96yquBn/UY3zO6idwnlKtfFkMiLPLDwe5rxvT
	 YT9sdBvAaw5Txc0CZSMKRRq63bNMVhiYptEdQMUbLAfpGjhRXkTQItmYoHmCI1Kxi2
	 OuSjkVGEop/VkhD87z55tVHvpWq3EYwi7TfpEa1ULsfq/UsLIWRiy3T80XxLh/WgiZ
	 WdE7MpA1IIAKb69AIZExFDgCrUcuR4sVx5ufA7Pi+JnDwxGfTlW6pqYkONrmCMZDMj
	 U+pKSUh3C6xF3lJ8E4tTgmBU1PFPdP9KW4v2pXAbKnDsGVMujiO8MuHsuqg2LurQk2
	 oagpogXwYG0XQ==
Message-ID: <701b6837-d1e7-4657-9c13-8db297906e16@kernel.org>
Date: Wed, 7 May 2025 16:41:31 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] engines/libzbc: implement move_zone_wp callback
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <20250425052148.126788-4-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250425052148.126788-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 2:21 PM, Shin'ichiro Kawasaki wrote:
> As a preparation for continue_on_error option support for zonemode=zbd,
> implement move_zone_wp() callback for libzbc IO engine.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
