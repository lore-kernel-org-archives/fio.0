Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AAC185628
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727385235; cv=none; b=GVsKgGPUrArGz+aKDe+a3T0H7G5fo32DiHyK59bZiIbgUBjQQ8s8AcaW1pknNOJD/uyT5FatZQAPeAgCtXC6EqIRzd/jHpfmgOeGHRYpilcy51Ex5pTLYaf+X0k8qxyTXQSI3VFeK/EB9lFeGP+hI7xwLtIkT+9mZgOFubsA9Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727385235; c=relaxed/simple;
	bh=LDfUzlWCg1MVFpb6QDJY7+e1WOVI3/9LtzwXOgceh2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ84kmvOtaTdgBGiR6QXOiLEpFDaiH0Ijw2DtHvhjNZiosAa+FETlvMI4ebbC9eGJLoNgDD53Cbvn2q7V8E5gZ0M/xqSG+WQsKTruEBgtbYTSz6lEiP1NZA0nBr3advIHfAeObvGVkcS2UGY6C7kuBB//Slc3Yn+ZNQel27TZQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AuZz6bOu; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AuZz6bOu"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20b05ba4192so1356085ad.1
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727385233; x=1727990033; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CZ8Z7UyzwviTPSNwE4z7h9tvsUmXYfRSj2WxBpY9+4I=;
        b=AuZz6bOuORWwu0nwXUgTcBsm+vj5XBYUOjTY1teMnqsy3rWbzhtQg9zidHi/KmBmfJ
         B45VCadJMj0g7IZ7cysEbbJ8q155Pi08bJ60xC1bZrP2GaesXdpaQjx910jn+IpoZ2fS
         q+5IowrmA6Uu6D3ICpU+APNSq6sgvBk2VfnqgcTejL15Y0DlQOJurIdEkbMiiQi8sgQt
         E7/W6rveLayFGXO1bbDin1HDnrgQM+tcVvpgVw4HSLtJ8nSK1ORwNLicfdSu4urUp0tk
         gv0/aMPFOPAtvGHeWL2D8aYj/tsFMk36JGeirqu71KtRkdqvV1/9q6l0WcoFXxVpPLmj
         Gd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727385233; x=1727990033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZ8Z7UyzwviTPSNwE4z7h9tvsUmXYfRSj2WxBpY9+4I=;
        b=ln9OMYaqcZ7pskOflen716g/+qJL70tEFhF65GkZYIRsXB3aA9SPzkpMnZyuINWHR5
         iF0qlzuR0FxKAL8mhRsaxxIJyHSpySKnDSCXz/+KJ4abO9I1fClWbRf2SVo257RCIT/P
         u4+sAbZg1fYnSzLClNqiXxevFACjAh54esQ+t4ygYkAUIRclX5yOhgJTNi3hqlHjoYYf
         cs8YaGaARyqfFpwz5LCxNlRzAncPTubw4I7Bg/8Nq/lJrCVcBIGTAMj/KnKHxtklJ317
         d2CY9ggBA3MdLIX8SCVl7EYCjo3HzgIQR3Ng830bh8Ni+rpdJgvdh+wxkwVzTdSnj9sE
         gFwg==
X-Gm-Message-State: AOJu0Yxsr6FGVp4gr6Z6lqiloadcR6Cp/nTKNOEOH4cigPIFYP46YmH2
	owP5X1pCbsp35EbvO/wlxdYRVGhA7oBhNeOSnZYtb2scdvnV370CG+hsNg==
X-Google-Smtp-Source: AGHT+IET9i2OCGehYGMRMnnXwK0nd6SkvImu/2exMV3wzb/gZqeNx+9TZ92JMC3EZxSicT0Cm1vxbQ==
X-Received: by 2002:a17:903:244d:b0:205:5410:8f58 with SMTP id d9443c01a7336-20b36cdab28mr6531735ad.8.1727385233019;
        Thu, 26 Sep 2024 14:13:53 -0700 (PDT)
Received: from minwoo-desktop ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d91aecsm2674795ad.89.2024.09.26.14.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 14:13:52 -0700 (PDT)
Date: Fri, 27 Sep 2024 06:13:46 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
Message-ID: <ZvXOirvaZwZtSTVQ@minwoo-desktop>
References: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
 <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1c383a92-ea5c-485f-9015-995c77117dfe@kernel.dk>

On 24-09-26 11:48:22, Jens Axboe wrote:
> On 9/25/24 6:41 PM, Minwoo Im wrote:
> > diff --git a/io_u.h b/io_u.h
> > index ab93d50f967e..20afad667ee1 100644
> > --- a/io_u.h
> > +++ b/io_u.h
> > @@ -22,6 +22,7 @@ enum {
> >  	IO_U_F_BARRIER		= 1 << 6,
> >  	IO_U_F_VER_LIST		= 1 << 7,
> >  	IO_U_F_PATTERN_DONE	= 1 << 8,
> > +	IO_U_F_DEVICE_ERROR	= 1 << 9,
> >  };
> >  
> >  /*
> 
> The patches you sent should've been a series, how are they supposed to
> both apply when you add an item here for each of them as if the other
> one doesn't exist?

My bad.  Sorry for making mess here.  Based on the feature, I think it
should not be a series, but, yes, adding new flags with the same value
is totally a mess.

> 
> I'll fix it up, but for the future, if patches depend on each other, it
> should be a series. Please check if everything works when it's pushed
> out, which should be shortly.

Okay.

> 
> And since I'm on a plane and this doesn't appear to want to send, when
> you do see it, please also add HOWTO additions similar to the fio.1
> additions you made.

Will do it.  Thanks!

> 
> -- 
> Jens Axboe
