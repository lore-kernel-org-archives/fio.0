Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD75C16CD1D
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727405648; cv=none; b=l+V8P80ZGR8T/dfNnKTjgcpDjAHibEFxM4Ax7SEgzB8IG30mcHIHqSHR6/JbXXroQsm8y/brDZNffg6sMderDPzgF9jiizAlVuCRl3FpJmzkBnk94wBEQJIYKEz4misuJLjq7C4zue4f7veTc0n8hfIhtiBEfKTegNToevwAMbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727405648; c=relaxed/simple;
	bh=H6BPA/h8LsyHoElwICuSchUhAZtLJKEuXkgLierdQ7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKNj5uxcASREwyWr2gjf19A8dCVSN58ECTRhLyxL6Poe6F7scUZHON9M99XwJCc5M43S1YARp6FKvhV9uGoFTrc4C8SNG2M5TxFow8mi6Ac5K/Q8A/qI140qRAlclm7h0uCrcRgEXWwauiAtcsAwI8wcgo8MF/z2wgwkIlDIt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htvBo2Jq; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htvBo2Jq"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7e6bac92bf6so128343a12.3
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 19:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727405646; x=1728010446; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+WrbWjy/5fLQzbAJB7Kubh9n1CvPSlpjcuIbS3rgxUQ=;
        b=htvBo2JqWvtzCQKR9M8QVHUCcz1VMD7+0Bu+FxQlaDqrBTfYbg5a1NalewDxc2YGbP
         VHw+5phKf95jJR07HcNfW+w1+GilTNSrZaHsM9AAClYg0TjyskhsOzRH0OMC3D9LRVyX
         jkyBY1+lq80uiez4dpFrA8IBcGn8fXHk3lynPg1b2kLKs5Gqznb+56vr8JJ47SdbPUbv
         Et4JfSjs4IWAfaXPsy7zcMEt4bU3bUOBGSVjVgG6UCqNLRHbH2d8t3gbWeJwxm2DeTtl
         smjPHItSfc9CJdzsbaGN5WRcqXtCc5MmPGdL6KrsmikrWbNFPyxWoR5ekGiAos/j3tuo
         YAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727405646; x=1728010446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WrbWjy/5fLQzbAJB7Kubh9n1CvPSlpjcuIbS3rgxUQ=;
        b=vo+c8S3vuww5RQ9PBF5KjHDRbjam86a9I9jT/BhAzJIpJgZAkSh5oa4J/FGHSPmYKb
         UVl0RP1VyILD3/GlRrJIurSiPfJwYoIyPgTJuwfdPUGDiBT1wIiYaDOdRuShsGm+CKmP
         ZmthLEc2gDnYrejYDRvXuEPIFfIXngAApAfyNGimJrTSXbJxBaKkAS8ZFE69NvyR+bbv
         i59+E4esjMenwSjdSSKfPHBXKH2iIZ8NX5Xc8/6QD/OpO96dnfvyanmQ7ggSVOBDz5vE
         F9cqdK1YgcbMQusRUYJSj9edw1fPOKGt792p1zgya7zdxKc84FZTHF0RhLnz6UIH0FmM
         Ui9A==
X-Forwarded-Encrypted: i=1; AJvYcCVZGnPvbCjh6n7Bg5DBxqyERp27MFV9DuCsel7Ue+K5VSehIIP247Pak7+cPlGgRN7F538=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmdnA2D0QBIfZqWLPHeQHMfVxfX4sK+7k8xnGlcvSwrHDlWbCC
	ChIyOhc2v+Gdl2Bbqp9BPDyLi0qLouoSRA1hX2MSMdAGtCv8ELPCqBANOQ==
X-Google-Smtp-Source: AGHT+IGwo09TnXJyyl1hjwyd4cRgGN4l0YslH4HyuP08oFTmu4TnLDdd+WjxVdUV97dRGS6Ze+Mpng==
X-Received: by 2002:a05:6a00:18a1:b0:718:e49f:443e with SMTP id d2e1a72fcca58-71b260ac37cmr1272284b3a.7.1727405645924;
        Thu, 26 Sep 2024 19:54:05 -0700 (PDT)
Received: from minwoo-desktop ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26537002sm584984b3a.202.2024.09.26.19.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 19:54:05 -0700 (PDT)
Date: Fri, 27 Sep 2024 11:54:00 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
Message-ID: <ZvYeSFGxxRvW5vVQ@minwoo-desktop>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
 <38ba3cf4-4c3a-4060-a58b-1a7bd7ef8ff9@gmail.com>
 <d84566e1-40aa-4c5e-ad68-32607b4db695@kernel.dk>
 <ZvXTIO3DNbzG5EZ/@minwoo-desktop>
 <03b0dae6-bf69-4a3d-9b82-9107b0c25a1d@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03b0dae6-bf69-4a3d-9b82-9107b0c25a1d@kernel.dk>

On 24-09-26 18:54:35, Jens Axboe wrote:
> On 9/26/24 3:33 PM, Minwoo Im wrote:
> > On 24-09-26 15:06:49, Jens Axboe wrote:
> >> On 9/26/24 12:08 PM, Vincent Fu wrote:
> >>> On 9/26/24 13:48, Jens Axboe wrote:
> >>>> On 9/25/24 6:41 PM, Minwoo Im wrote:
> >>>>> diff --git a/io_u.h b/io_u.h
> >>>>> index ab93d50f967e..20afad667ee1 100644
> >>>>> --- a/io_u.h
> >>>>> +++ b/io_u.h
> >>>>> @@ -22,6 +22,7 @@ enum {
> >>>>>       IO_U_F_BARRIER        = 1 << 6,
> >>>>>       IO_U_F_VER_LIST        = 1 << 7,
> >>>>>       IO_U_F_PATTERN_DONE    = 1 << 8,
> >>>>> +    IO_U_F_DEVICE_ERROR    = 1 << 9,
> >>>>>   };
> >>>>>     /*
> >>>>
> >>>> The patches you sent should've been a series, how are they supposed to
> >>>> both apply when you add an item here for each of them as if the other
> >>>> one doesn't exist?
> >>>>
> >>>> I'll fix it up, but for the future, if patches depend on each other, it
> >>>> should be a series. Please check if everything works when it's pushed
> >>>> out, which should be shortly.
> >>>>
> >>>> And since I'm on a plane and this doesn't appear to want to send, when
> >>>> you do see it, please also add HOWTO additions similar to the fio.1
> >>>> additions you made.
> >>>>
> >>>
> >>> Also, Minwoo, we are seeing some build failures with your patches with
> >>> compilers rejecting abs(io_u->error) since error is unsigned. Please
> >>> fix that up as well.
> >>
> >> Doh yes, I fixed that up now.
> > 
> > Jens,
> > 
> > How about the following one for the fix?  (checked with clang)
> > 
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index 6c07c1011c40..85cebf8371cf 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -589,7 +589,7 @@ ret:
> >                 io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
> >         else
> >                 io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
> > -       io_u->error = io_u->error;
> > +       io_u->error = abs((int)io_u->error);
> >         return io_u;
> >  }
> > 
> > io_u->error is unsigned, but it can have negative value as an errno.
> > io_u->error should be converted to a positive one especially when it's
> > an errno.  If we don't, it will be like Unknown error:
> > 
> > fio: io_u error on file /dev/ng0n1: Unknown error -22: write offset=429916160, buflen=1048576
> 
> Yeah I think that looks good. Can you send this as a patch against the
> current tree? I did do a fixup, but way too jet lagged and it's
> obviously garbage.

Sure, I will, Thanks!
