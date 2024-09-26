Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDF91885B2
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727386408; cv=none; b=cmzJrcjSiNNvnTwkOrvjbLbVTIT8DzDIcCWf8kgeU+t07SDqon/cqTMEoVOlt+AMlwZ5Vr1Ftg4TvfANluoNBTpLRwAaB6t1q4tyR5XvAT2RklQkNj8cv0cPwEPLQkGnL5qIMsdvGUk67nNFH0mr3PIx3vHkvXbnj4q6k/7d+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727386408; c=relaxed/simple;
	bh=MzI32NFnp65VzeKAp91uBQl5SnN5d5gEziyJmWO5iEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVBHXpGSUWwOn9ngbwbVOmJ1DP9DZXSPcaZl2dk97OAXLbIF4FByxsj8FKfsDm4qbiKWPKPqz5RVv8HWuDNjWqwJbM3TYjuCkaYX7WIsIuvyou4FScwbmU1igsAFpe5bQXgjnVuyttQP6tosgu2nWwq8ajy+PKy7E9djFqtCcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dFeijsJ+; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFeijsJ+"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e0752be2d1so257395a91.1
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 14:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727386407; x=1727991207; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=533s2AqcKBleg10NqFgk3L0ZN2OzRUP8BV+fBJ6crIE=;
        b=dFeijsJ+AxSah0xP5dUqpjt0PQlo9BAwKNui4UhQSOoNYhkFrqGIZn3Fn7daQJN4Wh
         qzRi1927jxCF76/kXffGr50OdHbnQp0Rus/8sSjZEQSS3RZha2xMOw4rhHaGft2zUR1x
         h5OaZ5r3ON/eqKQTyjy+SRVeP3TINLlvGYn38bNXcH9v858xYgJ+ydv2DQwh0UyxWG1y
         4BGhe+bzLWnvF3dQKYu2rO25MTNnFw6MfooAWuKcnwP0Rmf+CtaxvyGg2Kerpoc9Rox5
         8BeVfb73eh8SSbQt6zkWJidxH27cv2mvGNn7uH4/XeILcgwKnSIa66cQC8tyYZ482Oyt
         UOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727386407; x=1727991207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=533s2AqcKBleg10NqFgk3L0ZN2OzRUP8BV+fBJ6crIE=;
        b=eS9ovhrrGNrtD/ohyFlhM6s16kYkEYr9VUTufghyBfqIYVCcAQ6Gxi81luTu5U8rJk
         H0OGxUqAK/p4STMoDhRAJpQNq2IRKFM9o7QLstOmtHgoHHYotKtS5FVmXkPR5Qylt9iA
         luhEYxayeRqO9SafuLFlIU6Y/CNewrqXS2cZ3jv52EQUra3QD2k28VOzO9Sai/iwMtYL
         qPnd8MwCQ3eBIWy/TGLdFHcBcMeNRuPz/TEvVA9H/mOguQSR2DcF41MJ+I5h9wMtPT+K
         Tdue6X1rgFJGWBaDqSAPVap/s3SlukSMJoJmJ81TiFXUVwIGXiXdUmjKxqIsloVLJMxp
         YduA==
X-Forwarded-Encrypted: i=1; AJvYcCUXi1C+wWfUoP8MDvazmHGoFb7nVuvTbAJOVoWcRzEqym+42jxsiW4ItyEyaNuJ6dPxOkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQfbDKheZiPQBj8SE8dE4ZqgMpPYoEG8sCS1roFaqbdiZAEeM2
	Pt4DTik2YFM8Qt/cWy3N6+sbf5LwfArSWGQXiPWsNEjUXuMwt5fl
X-Google-Smtp-Source: AGHT+IG8R7rHMgiFzb21LEaOzpn1iC3+Y4mRHM+GFt+6keFUNbCssu6TRbfa1wcxH05Q4WIgTuoyQg==
X-Received: by 2002:a17:902:e809:b0:207:da7:bd0d with SMTP id d9443c01a7336-20b37b8f671mr5822345ad.15.1727386406606;
        Thu, 26 Sep 2024 14:33:26 -0700 (PDT)
Received: from minwoo-desktop ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37db042fsm2755935ad.115.2024.09.26.14.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 14:33:26 -0700 (PDT)
Date: Fri, 27 Sep 2024 06:33:20 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
Message-ID: <ZvXTIO3DNbzG5EZ/@minwoo-desktop>
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

Jens,

How about the following one for the fix?  (checked with clang)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6c07c1011c40..85cebf8371cf 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -589,7 +589,7 @@ ret:
                io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
        else
                io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
-       io_u->error = io_u->error;
+       io_u->error = abs((int)io_u->error);
        return io_u;
 }

io_u->error is unsigned, but it can have negative value as an errno.
io_u->error should be converted to a positive one especially when it's
an errno.  If we don't, it will be like Unknown error:

fio: io_u error on file /dev/ng0n1: Unknown error -22: write offset=429916160, buflen=1048576

> 
> > I do have a bot that automatically runs mailing list patches through
> > our CI, but it does not report the results to the list and I am not
> > always quick enough to manually report CI failures:
> > 
> > https://github.com/fiotestbot/fio/actions
> 
> Send them to the list! It's not like it's a high traffic list, and
> that's super useful. Mostly because it gets the same coverage as a
> github pr then, but also because it'll inform the submitter that there's
> an issue without either you or me letting them now. Hence it saves time
> and cycles, which is a big win in my book.
> 
> -- 
> Jens Axboe
