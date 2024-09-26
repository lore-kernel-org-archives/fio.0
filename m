Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8231891BA
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 21:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727385440; cv=none; b=e4IhFv4pl+c3hU5L9Og82P09EUo6e2VmryWXleohdrFS5EecOssAbKGEAJfe44WC9y0V+FlLWSEEWAqLOzgv/MZEfnKdD5Nd08OYpPWQRL5FqpNeuIMOXvgD9sHbdAS0eZ3SqwR5yXF3enHRWskpT5DoBrKYaOw3vHhMb8c8yV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727385440; c=relaxed/simple;
	bh=1y/P7pg61at83B+YbZ4fMapjtGURYEUHNAzNwAFGuns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8lPbz8oLPY2jIM9Wz/1X7vHT3zi3sjgYnYDDq+g5nIhDYcU9qFJkCsv7zloO47+EYLpLh5Tq2TsCIngwq4Jwid1Xyq3NaUbp7ILZDi24VoudQXNmGsvM0VPCGbndZFujLWYQimDOTYZWweQSJnsAuYpgwAUt1BSnMjTK4MJWSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Afbrqclk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Afbrqclk"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20b2ee76302so894345ad.3
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727385437; x=1727990237; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CZs6p2wGUW/JIHds7GiQ22DzYzAxP1TDMS8jVzyqgh0=;
        b=AfbrqclkDUSHThy00+q8z3vimXcX+NvNy5twi5lga9Ba1mqeND1D1SWSydvvJFitDQ
         G97XgUhG7bFy3cknFIAkB31iEvzFCJYC/bRO4rXaH3PTEIe5ysubrrhnIfwUygz3+pyI
         7pk9kLU3ofsJ02TU556UhlqqST998ntUZpKus0omH8G3rvbxzlEuC8Sdcn2vZ/Fgvxb6
         wtj78Ot+SMkOZ7v/dUUpA6IzrIH0+L9fAs32c6PjXoYKEm7en/J3jlChix03HBEW5gSW
         ByQCXWNtIu5O7xnk5gVSyhZXV8Lxg4UPk/VtyFsZ0PwhdMMN58MjyLbpo4rXRIXAO7Yw
         DgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727385437; x=1727990237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZs6p2wGUW/JIHds7GiQ22DzYzAxP1TDMS8jVzyqgh0=;
        b=xODN2aAYoOE76myTWPikWOsSaWtj6fLlHW3Yn0+/BmzJCT2LBQb0AXjwFNY0bPe5SO
         H8tAitfrdB2FYrCgeHICyQTMeImaoJ49PQeB7n3f/MWZB/35/gbk7xVg2IvAHLnHC0RG
         ZAgPXFyK/b2dm4Bzrv5eBwSfjcOlOGt6Agv46b0YLm8vsH/h7wLEc+MqghexvsiMl2xK
         mKfSHQxsTgJ6Vpt9xyoNb0BDJCG9wVhSxNjJyn7oCqB3grKpBYNTB/HtQcQNxN4l7kZb
         39M7OFzFEiMou1isd+e/6ATK2XT0CNldzwEX/e9Vhwtk56YzOdfk26+IpWGX0slbCpqH
         42Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWAGq23FWV9hLM0q3DwtwQ5nnzvxZQVifbSh48STcYu0hJG1rG/YGFywteoEXuBnSlvTGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGFLg7Z5IUP5KMxHcB5Byadft8/Cb+4aXrHZ+8We7g9R4woq3b
	mXGjPiqd/1Pd/hPk4eez+JYgu7JhsAT29zggtne6xxLT0lPsBWaE
X-Google-Smtp-Source: AGHT+IE+tcC88gyMqV489doSyTW4den9F8u9DNiBgO+HRli6qhP107YL+yDscwFas3wZzYWndu1saA==
X-Received: by 2002:a17:902:d488:b0:207:457f:b8f6 with SMTP id d9443c01a7336-20b367d535fmr6854805ad.2.1727385436894;
        Thu, 26 Sep 2024 14:17:16 -0700 (PDT)
Received: from minwoo-desktop ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e0d488sm2597025ad.147.2024.09.26.14.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 14:17:16 -0700 (PDT)
Date: Fri, 27 Sep 2024 06:17:12 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
Message-ID: <ZvXPWDEOokazVd3V@minwoo-desktop>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
 <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
 <d84566e1-40aa-4c5e-ad68-32607b4db695@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d84566e1-40aa-4c5e-ad68-32607b4db695@kernel.dk>

On 24-09-26 15:06:49, Jens Axboe wrote:
> On 9/26/24 12:08 PM, Vincent Fu wrote:
> > On 9/26/24 13:48, Jens Axboe wrote:
> >> On 9/25/24 6:41 PM, Minwoo Im wrote:
> >>> diff --git a/io_u.h b/io_u.h
> >>> index ab93d50f967e..20afad667ee1 100644
> >>> --- a/io_u.h
> >>> +++ b/io_u.h
> >>> @@ -22,6 +22,7 @@ enum {
> >>>       IO_U_F_BARRIER        = 1 << 6,
> >>>       IO_U_F_VER_LIST        = 1 << 7,
> >>>       IO_U_F_PATTERN_DONE    = 1 << 8,
> >>> +    IO_U_F_DEVICE_ERROR    = 1 << 9,
> >>>   };
> >>>     /*
> >>
> >> The patches you sent should've been a series, how are they supposed to
> >> both apply when you add an item here for each of them as if the other
> >> one doesn't exist?
> >>
> >> I'll fix it up, but for the future, if patches depend on each other, it
> >> should be a series. Please check if everything works when it's pushed
> >> out, which should be shortly.
> >>
> >> And since I'm on a plane and this doesn't appear to want to send, when
> >> you do see it, please also add HOWTO additions similar to the fio.1
> >> additions you made.
> >>
> > 
> > Also, Minwoo, we are seeing some build failures with your patches with
> > compilers rejecting abs(io_u->error) since error is unsigned. Please
> > fix that up as well.
> 
> Doh yes, I fixed that up now.

I appreciate for your fix!

> 
> > I do have a bot that automatically runs mailing list patches through
> > our CI, but it does not report the results to the list and I am not
> > always quick enough to manually report CI failures:
> > 
> > https://github.com/fiotestbot/fio/actions

Vincent,

I will have a look into the CI when I posted patches to the mailing list.
It's super cool to have it.

> 
> Send them to the list! It's not like it's a high traffic list, and
> that's super useful. Mostly because it gets the same coverage as a
> github pr then, but also because it'll inform the submitter that there's
> an issue without either you or me letting them now. Hence it saves time
> and cycles, which is a big win in my book.
> 
> -- 
> Jens Axboe
