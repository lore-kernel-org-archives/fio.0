Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975173A1E72
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 23:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766012618; cv=none; b=VOUn5r1/zzLcTPR7l2LZyl7Bq2sCSABUxW8cZj+stBXky59XjgzAF5hUSz2FYHGzgwKtoN2RPlzXW2n0EqFiHuR6a4TTERa7hGAUIcZpgfasnEqIXmw+0qAf/lrZ4JZc7pDxXvpMQX/8vcyy6o0Gbn4UIJlmN+1ac1tZpWEBfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766012618; c=relaxed/simple;
	bh=b7MJ7tm+N6eNoyJhtkwwbXz0GV6IShz8z87RfoHEdCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RXCioE7unAkzerxYt9yAh7nMM+9/4m2pqy/2sS6MvKbVKwJCuTQKAV3MBsMEBIU4Ijf6zDJYko6hAJiZrlcubauOjBoEo0aobVtyA2o+LQPVh6sYFp1zZfDCvigRAyItI9OdGcR+ofCrx/aIJgSVqKONBP7vEYDARQaS9f1ZFmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muuBqJA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muuBqJA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DDFC4CEF5;
	Wed, 17 Dec 2025 23:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766012618;
	bh=b7MJ7tm+N6eNoyJhtkwwbXz0GV6IShz8z87RfoHEdCU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=muuBqJA3C7JhxJrQOTAogXX4wGKU3r5botQ4fUQfuGtluuosZuogfOEnirUPfnDRR
	 FyUddiMwHz20G7YmAAYAkiWsh1yA7aa2WKi2X/qw5qpxMQwh3Su05tZMvP5JjcCL7I
	 ETolq0/YRruMIFKUF/oCx3fk4S0ut3b2Q6EhGvks6jZaueMe2RBdhyg4CBHLOLuQdd
	 d2+PDYIkl8E2b8Py5q2CfFeJBykFOwPaJStUQitYG0VISAJZNd4YIb+19aSWO07QmB
	 WAUsaKGSF6iRN08CP5qmHvWAbA/Sxf/vVanltvsbuT7Sr50Onwx1Wf17qBWaGGY7cj
	 /X4Eg3HfOrv4w==
Message-ID: <7dab8aa5-3ff1-4031-8c9f-30c2bc8cc050@kernel.org>
Date: Thu, 18 Dec 2025 08:03:36 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251217161722.6357-5-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 01:17, Jan Kara wrote:
> In some cases the ramp up period is not easy to define by amount of
> time. This is for example a case of buffered writes measurement where we
> want to start measuring only once dirty throttling kicks in. The time
> until dirty throttling kicks in depends on dirty limit (easy to figure
> out) and speed of writes to the page cache (difficult to know in
> advance). Add option ramp_size which determines the ramp up period by
> the amount of IO written (either by each job or by each group when group
> reporting is enabled).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  HOWTO.rst        |  7 +++++++
>  fio.1            |  6 ++++++
>  options.c        | 11 +++++++++++
>  thread_options.h |  2 ++
>  time.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 9f55a73bde05..49ebae6275a6 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -715,6 +715,13 @@ Time related parameters
>  	:option:`runtime` is specified.  When the unit is omitted, the value is
>  	given in seconds.
>  
> +.. option:: ramp_size=size
> +
> +	If set, fio will wait until the workload does given amount of IO before
> +	logging any performance numbers. Similar considerations apply as for
> +	``ramp_time`` option. When the unit is omitted, the value is given in
> +	megabytes.

Hmm... It may be less confusing/easier to use the regular fio "int" parameter
type here, which takes all the kilo, mega etc suffixes. This means that the
default without any suffix would be bytes, not megabytes.

Other than this, this looks good to me, and indeed super useful when testing
file systems with buffered I/Os so that the initial super fast buffering spike
is easily not accounted for.


-- 
Damien Le Moal
Western Digital Research
