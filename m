Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049071C07ED
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 05:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737525570; cv=none; b=IoW//wbRWcN7ctczTM0Xroa9XIQ4BJWYHpnrEtujzFXi43T2wmARgpKyhWmGazlP/jRlsI6vpZDzof+zIoirKmfbAGA5JMJjktKiHWlxCjngT2CSZ/+OMHn53s28wdMrqZXjXfzSml/SmU24tfB5ZO+1XsQ5AoigZEz9PE5JIAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737525570; c=relaxed/simple;
	bh=zi9bUhI5wnAhQm+Rx9JxQHEPWi34wMCMUzr1d12xeGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K0w0o7uU+4jnA520EfDDERnDAqYyYM7pUuiqBUOWzYrCi1QQHs4giz3CgTtwn+z9dNvY+hLkUQ1xV7xrwm2hqf+s4QSeqOjt4scclr2GJY/nk0YTEeLdE2x661LXgXrcJdM82IRTv+od+kAFf3g+Bl+UkXu+qDIp8JBmNryVCC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuNb3PFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuNb3PFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ACDC4CEE2;
	Wed, 22 Jan 2025 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737525569;
	bh=zi9bUhI5wnAhQm+Rx9JxQHEPWi34wMCMUzr1d12xeGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KuNb3PFPSvWsJo3dGqlonsVW6xlR7HqMYyyHpIKs2nBBh9b4xU38UlmImv1/ia4P7
	 OVpVdhFFgxDoczg3bBxv5ACWNbfblBMcfPdksx1sNLPXq/W1KtMCv3/jQWir9k9fF6
	 V/YMWft1Gcq13qERu1J3t3N4alrprgRXp5sVAxnzTYwtzrSsi+LV9DCJ6tcwuCh51J
	 NOsa8RUNpzr+5oV/yVahww0Oh+tsS2w0Ggd2D+GWxAkHEj7HHJpcy0J5SzIlYeGk84
	 uApflVWn5mof6jxVW2gAjwqSDwMUOqp3CGh102EDcIMGF17vJlzh7fv+PLPV37iIZf
	 zarA4fhzadRLQ==
Message-ID: <71f6098c-a309-45fb-9af6-0d6afdeb63ab@kernel.org>
Date: Wed, 22 Jan 2025 14:59:24 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] zbd: fix open zone status check for non-write jobs
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Cc: Niklas Cassel <niklas.cassel@wdc.com>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/25 10:38 AM, Shin'ichiro Kawasaki wrote:
> Currently, fio checks if each zone within the IO range is in an open
> condition or not. This check is done even if the job does not perform
> any write operations, and causes confusion among users.
> 
> This series addresses the problem. The first patch fixes it, and the
> second patch adds a test case to confirm the fix.

Looks good to me. For the series:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
