Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1B632ED4D
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012303; cv=none; b=g+BhlhN78aLsImrznkpmcvBfqXUhfDgMSFH8OODOb1po+/DWVsfT06f2x/06hvKrGMSL75Lg963xEaLnNWTQmaY0srhSinEjVMrjCicWkw876TKXPg+Au82ti+x8Q/SalmRXv6GQpXvaMJ0QqpIjawmOQWLw60pXq9lv+CbNG4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012303; c=relaxed/simple;
	bh=hKjhpAlK7+A9R1F4tIhw5f3z7pow8qab1tdkBYFpsdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N1yasRd59PHQbMXHYdPXpwKW7YHhRm+ovcI6Z548aZ4YgTJSCFDV1h3pVSMaNNkrEQmvxdaUKpNyF1MdSCMcjqMV6WldTksvihHcRAcdrZxHa58RgdJ01k39OB5ex5/sragb4Ls8bHpwQSePygsQ4drv+/b1WdNLnU85/TstL7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuFeJgW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuFeJgW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF99C4CEF5;
	Wed, 17 Dec 2025 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766012303;
	bh=hKjhpAlK7+A9R1F4tIhw5f3z7pow8qab1tdkBYFpsdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BuFeJgW7F6MCRbq9ELnvhpJZtMxjH5jzWrIi/JeQDl68Bz2bajLHbTGHcQY4ZfQWv
	 0BJ1JwGNGoOiSCpmXSME6n7vGH3zpxUepVkTihmUcviVYnUhaUy+7+rkt2ir857KSo
	 If5n0ZPNjiRWgJFJT+Xmw4/pmw3nb/iXSg6ivr30jtaF+G9hP4yx89PH+i15qKcxS1
	 +wQx6fpC9iGmotXHkTjyJenTaciwzJPSzC16C5SOVpVO/qkAHYDFt0N1Ik0W9cz1EZ
	 3QchsRSPMMXWcB+jv+1Y7mWxPLQU6Qfy04ojLcZiwTo062+KtWwCCKV7YiWIJorLxP
	 ymmY8BHgN+DtA==
Message-ID: <26da4634-1a3c-4365-aa68-a0e7a59f214b@kernel.org>
Date: Thu, 18 Dec 2025 07:58:21 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] time: Evaluate ramp up condition once per second
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-4-jack@suse.cz>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251217161722.6357-4-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 01:17, Jan Kara wrote:
> Instead of evaluating whether ramp up period has finished on each IO
> submission and completion evaluate it once per second and set
> appropriate state variable in thread_data. Later when ramp up period end
> condition will be more complex and would involve stat data from all
> threads, it would unnecessarily slow down IO.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
