Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE121B9F5
	for <fio@vger.kernel.org>; Fri, 13 Feb 2026 03:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952361; cv=none; b=qwfT1e9wZL6lXTx75BMHL7oum8lyq/idCWYLe1PqcorKBYgjcHaBghL07+Q9kkKollrrEqteBiA/YwwB0ta+bgJzZwagHZH1j50GFlLfBC6EZiUp5f+UJMluyDJk3Tw5NB+DzYpQAiRnYE4A3PKaG3uZ2WBIts8IP8OmEwI+8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952361; c=relaxed/simple;
	bh=Cae0kJlHUqADRov68My4zoYvGd277+TjT3fSif7LgqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CsWvg8RgPAatKoU83+Bjn3rsWESjYCqvvUreUBOtXJM9ecxbYLYquvC6S5gezVjsBnBhBkBMkEkGhF+QqXNbc8YB5vr3w5F1gQ/ReWRQHkoav+f+laAUktIKtoCAM/wIqQILYJTLRG4yCBdmyK1ifMsdAZUqubqd/6+jcn68xDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6dROs2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6dROs2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEDAC4CEF7;
	Fri, 13 Feb 2026 03:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770952360;
	bh=Cae0kJlHUqADRov68My4zoYvGd277+TjT3fSif7LgqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P6dROs2On51pLsBTcXGqKe0qnWAIJMu+HyK4UxwHZcbahhcDJLFyfw6F4GdzTLuug
	 /fAPXMdCZDEipDJ2Xt3fDgDdl20BDxLdG5yFNP7QsWz6+BpaUUckTlMXuXQITi6OD0
	 j4favaH7gNULkGF8BAR8BeWco59W/CBtKpx0qYLT+lRAMbp4v1oD29MxBek2Vagh4B
	 F1L/mH/PC+ZNgA0ogYZY5oaLqrtI4cPpGi15vjLilMwkOKZy1g0Vp9Ov1vku+jEkMO
	 /P4bS8TKiNvXWNgsw5FOZlzm9Tbry6Md9TOWixP1eYFfR8pzSCffsosEzJTlLpKXgx
	 E/rx5IWkdaIZA==
Message-ID: <4ff6d3ed-6faa-4b1f-a2b3-4032e08f8832@kernel.org>
Date: Fri, 13 Feb 2026 12:12:38 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] fio: Fix error string not matching errno
To: Niklas Cassel <cassel@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, Jorgen S Hansen <jorgen.hansen@wdc.com>
References: <20260206164058.3105327-1-cassel@kernel.org>
 <20260206164058.3105327-2-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260206164058.3105327-2-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/26 01:40, Niklas Cassel wrote:
> When using --error_dump=1 together with --continue_on_error=io and
> --ignore_error=62, we can get an inconsistent error in the summary line
>  produced by __show_run_stats():
> 
> Before patch:
> test: (groupid=0, jobs=1): err= 5 (file:io_u.c:2012, func=io_u error, error=Timer expired): pid=30925: Thu Feb  5 09:15:15 2026
> ...
>   IO depths    : 1=0.8%, 2=1.6%, 4=3.3%, 8=6.6%, 16=13.1%, 32=74.6%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=98.9%, 8=0.0%, 16=0.0%, 32=1.1%, 64=0.0%, >=64=0.0%
>      issued rwts: total=0,122,0,0 short=0,0,0,0 dropped=0,0,0,0
>      errors    : total=4, first_error=62/<Timer expired>
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> The string for errno "err= 5" is incorrectly printed as "Timer expired".
> (The correct string for "err= 5" is "Input/output error".)
> 
> There is thus a mismatch between the errno and the verbose string for the
> errno.
> 
> This problem is this code in __td_verror():
> 
> td->error = ____e;
> if (!td->first_error)
> 	nowarn_snprintf(td->verror, ..);
> 
> I.e. td->error (errno) is updated unconditionally, while td->verror (the
> verbose error string), is updated only if td->first_error is not set.
> 
> Thus, if you get a non-fatal error, it will set td->error and td->error.
> Later, for a non-fatal error, io_completed() will call update_error_count()
> which sets td->first_error, followed by td_clear_error() which will clear
> td->error.
> 
> Thus a second error (fatal or non-fatal) will set td->error, but since
> td->first_error is now set, it will not update td->verror.
> 
> Since td->verror contains the string representation of the errno stored in
> td->error, these two struct members should obviously always be updated at
> the same time.
> 
> If you look at the example print above, you can see that there is another
> print: first_error=62/<Timer expired>
> 
> Which prints td->first_error, and does not even use td->verror. Instead
> show_thread_status_normal() calls strerror(td->first_error) to get the
> error string for td->first_error.
> 
> There is thus absolutely no reason to not set td->verror every time
> td->error is set.
> 
> Remove the useless guard such that the error string will always correspond
> to errno.
> 
> Fixes: f2bba1820a56 ("Add a 'continue_on_error' option to fio")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
