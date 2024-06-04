Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3094BE7F
	for <fio@vger.kernel.org>; Tue,  4 Jun 2024 12:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717503109; cv=none; b=gQYd5tM0bjRFNXY6m9zTxajc8HOoqsM6rZpNAFSd9XLP7RUeTiR3sbA5W/eEdBxMqvLBAaZt5bTKLDWB5z2NuJKAke0tG8MJXNx/HIyG4MpANdZFv1OpBeFm5SJAzuHxaApuYz1p2jE7a55d2RQUSBBeb8BC0dx0Rpw42VEYKdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717503109; c=relaxed/simple;
	bh=17aiQJcndRvWotY3CsabvLYKslcCvNnSmuItOP7hRkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YrLYuoLUD3lod5n0FVbFIWvKZKL4I1z1EufefMtkm/PB4wyyiRelJnaj2raCiHD06R2u8bXUsy3+pXDWK1UxwGOrz3WgsI5C++XyCyy8nkEix9uRdDtOjLR0Kj1Jh0tDpiuN+uckAAjAfmfsdW4wPSR/tAq/zjvbF6QpvKLrdUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIM2boNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIM2boNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C327C2BBFC;
	Tue,  4 Jun 2024 12:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717503108;
	bh=17aiQJcndRvWotY3CsabvLYKslcCvNnSmuItOP7hRkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KIM2boNuDpwWBWEyoX0/2alg15V0RWHbrwlOdVFMwvrCBO1U8Eg76gyXdNd190rxd
	 7ryZ17R2DbfDruFjAPmwNkA0SN6hlHeAvOKUGUe6KPo2gq8rhO8qssMZpbZ09KxHKx
	 AszkI2McN8BrGMAT6psTE0tNjGHpqRBQJ+sCYoVWKDScSiuCBLP8LD8427z7Ygrw+u
	 TjDuzguABRRBRnaLE8ig6h+F3wzNSTMxJAR45Oofx+kQMGBPr9RRpNvsmYI7SVx0VK
	 luxQArnoc7Dg9HfEqg/Z4lWVlI0Z+5vHU9KGlY7HlS7gIxS7KZbtXLiWN9FyMnqX9n
	 vhATfYv9eICbQ==
Date: Tue, 4 Jun 2024 14:11:44 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
Subject: Re: Recent changes (master)
Message-ID: <Zl8EgAp7gEUMQSmZ@x1-carbon.wireless.wdc>
References: <20240604120001.4A9441BC015E@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604120001.4A9441BC015E@kernel.dk>

On Tue, Jun 04, 2024 at 06:00:01AM -0600, Jens Axboe wrote:
> The following changes since commit 93dc85482a998440f8e40814014da8cbfe9cf5e8:
> 
>   Merge branch 'fix-coverity-scan-defect' of https://github.com/parkvibes/fio (2024-05-31 09:46:59 -0400)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.dk/fio.git master
> 
> for you to fetch changes up to 1757469a81cac5bd662b9cde26f1e5d4f0402181:
> 
>   Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio (2024-06-03 10:17:38 -0400)
> 
> ----------------------------------------------------------------
> Minwoo Im (1):
>       io_uring: Add 'write_mode' option for optional cmds
> 
> Vincent Fu (1):
>       Merge branch 'io_uring_cmd/support-write-family' of https://github.com/samsungds/fio
> 
>  HOWTO.rst          | 16 ++++++++++++++
>  engines/io_uring.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  engines/nvme.c     |  4 ++--
>  engines/nvme.h     |  5 ++++-
>  fio.1              | 20 +++++++++++++++++
>  5 files changed, 105 insertions(+), 4 deletions(-)
> 
> ---
> 
> Diff of recent changes:
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 0b39a892..33a6ad93 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2857,6 +2857,22 @@ with the caveat that when used on the command line, they must come after the
>  	With writefua option set to 1, write operations include
>  	the force unit access (fua) flag. Default is 0.
>  
> +.. option:: write_mode=str : [io_uring_cmd]
> +
> +        Specifies the type of write operation.  Defaults to 'write'.
> +
> +                **write**
> +                        Use Write commands for write operations
> +
> +                **uncor**
> +                        Use Write Uncorrectable commands for write opreations

FWIW: s/opreations/operations/



> diff --git a/fio.1 b/fio.1
> index 9a965cb0..2649529b 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2640,6 +2640,26 @@ unit access (fua) flag. Default: 0.
>  With writefua option set to 1, write operations include the force
>  unit access (fua) flag. Default: 0.
>  .TP
> +.BI (io_uring_cmd)write_mode \fR=\fPstr
> +Specifies the type of write operation.  Defaults to 'write'.
> +.RS
> +.RS
> +.TP
> +.B write
> +Use Write commands for write operations
> +.TP
> +.B uncor
> +Use Write Uncorrectable commands for write opreations

FWIW: s/opreations/operations/


Kind regards,
Niklas
