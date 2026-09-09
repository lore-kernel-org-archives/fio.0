Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960863CB8F5
	for <fio@vger.kernel.org>; Wed,  9 Sep 2026 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788984958; cv=none; b=ifOMcBGhfGazjQSc/tdf0X0MGdeVWJQYAFCVv5p4wyJELGXcNXPoD4N7VkB7+JTNNzuseYrRRNXdwrLRhD+PiKG5f7JYSsgM2UNzidzhWEpN1WAE2be5TuVNFztHaV3YzKHcqnsV1dYD+M06WEuV+RqM6gC/jtoUk9xONdoQPhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788984958; c=relaxed/simple;
	bh=jWagc56qeA8CflpZ/8r8CPkhDdr54GzNLzlavOZJF24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iinFzMrceSoYk5deQI/R2s25a2ecQFsItrC2DiZcaZ0aV7kNRabYxv/b5W7p0IXsPps8HDo0xkOiZP9tY9tS6GT3CJ21AvDzQ4OJev2VcYshmkGS9VgEJlcK7LKN+tLK5zKIH4G84ozhnCJWbwRwLj2KaE34lddE26Jap+JxnSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTQU4Hxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTQU4Hxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B72C1F000FF;
	Wed,  9 Sep 2026 20:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788984953;
	bh=SOCUL3XNHZOY+4rGtHXCFYXo1OvVgvmozm/1+8ArLEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GTQU4HxmklqdJ/5DkibMSp3GHhj6KP4vZep78XHHf7JHp/wMCoC8Xk2qoeJCYKDju
	 N2NQt5tV9kKy05Pgf+UYAOddW5P/iC+d8llAAjarFVWFeTCC38so0Jb294+JY5pNRx
	 t5zRPH7BrWrCvKI27/HiKzFZWGRIcZ2SAkQSBQ4rs4NinIwhx6sestR0FCusTPGlUQ
	 E+iOyH1/BgRYmx93Ym+Irhe7IlAxeXJRqPqDgGgBfpanocWV7wnZocKdbPoK4v/LyW
	 s4I/zsvxtsBKPo2YIG3SVorJhGQuBbtb/6tGTf8u8h+toCP1lSScc0crfz2KRWm2KY
	 FBhcECthhx/ZA==
Date: Wed, 9 Sep 2026 14:15:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/3] eta: don't estimate runtime from an unset job epoch
Message-ID: <aqG-eCIozaeovkrb@kbusch-mbp>
References: <20260903172101.1886315-1-kbusch@meta.com>
 <20260903172101.1886315-2-kbusch@meta.com>
 <CAOp=CXnd3oqKZ5OC5Sv6nAkjD6k6979moPNNPoMC_SbnAJz6=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOp=CXnd3oqKZ5OC5Sv6nAkjD6k6979moPNNPoMC_SbnAJz6=Q@mail.gmail.com>

On Wed, Sep 09, 2026 at 01:01:32PM -0400, Vincent Fu wrote:
> I think a better fix would be to improve Fio's state machine so that it does
> not jump directly into TD_RUNNING from TD_INITIALIZED. Perhaps run_threads
> should promote jobs to TD_SETTING_UP instead. And after set_epoch_time()
> succeeds, transition to TD_RUNNING.
> 
> The current patch is safer, but it doesn't address the underlying problem that
> a job is marked as TD_RUNNING when it actually has not attained that state. And
> It's this problem which is one of the sources of the ETA issue.

Sounds good. I thinks this suggestion will result in a cleaner result in
the end. Testing a few things now before sending a new version.
