Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1A7E7D0B1
	for <fio@archiver.kernel.org>; Thu, 21 Sep 2023 20:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjIUUgJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjIUUfo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 21 Sep 2023 16:35:44 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E6E8D9EC
        for <fio@vger.kernel.org>; Thu, 21 Sep 2023 10:43:48 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a1e0cc1a2514c-7a29ef55d5fso541167241.3
        for <fio@vger.kernel.org>; Thu, 21 Sep 2023 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695318228; x=1695923028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWSFgjQ0BkZu4HxX2PL6KItRwnFUqbqbsdhx5Irg240=;
        b=AhRqp8y81SCApXEDiYPEB7agc+vUkLVX2pVJovU5+dpzSYcBJ6Cnxd1nMW1HDqajtZ
         bqFW0pDQlv6Tyq/lsL4ZYe0+d2g8fGkHvSLRpKnbkr7JGqp7r62cQJMOOQX00eGPYQVg
         HOLl7ijM/lich0MMvWPN9mwaF9CLMP1Lx2ZuMb0uFOe35MxY0WIe4mFwxHamig3mHH3H
         9NySDEBcqgz1kn3EqqRbklB+IVWLDsZ5+KddDw8vkuv+v0knfELqjDqHt81N1q5YoNem
         +mDMLYR2p/dFz1SCTazDdwBVLSfRYXFOTwVcoAz0LBZpUQfGmD4pzJzjFZmo0u6GtJwZ
         Vr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695318228; x=1695923028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWSFgjQ0BkZu4HxX2PL6KItRwnFUqbqbsdhx5Irg240=;
        b=s+vjzIWwHYM7FwwA+BSshnQFSiC9qnqr0oJFZT33l3qRLKAZz94I1mVodDadwg+oie
         mLQEONNDVhylgEYgq5pbYlf+AbjSutdmVyuyfv3Yj+lwlZFOtvBqiD+DBQA0zUz5gCBM
         oHV98FL5uQxGLKEe+i/UbYodXATcRY4iAaAeiDEA0RDJGeZazlyDWh1scJ/7KwUU14hL
         yzHAl5Deg1QJvOCLb2IYeFQaKvIGoY2v3DYAyYhoYuPfwCqpa1PhraWpqYLjI1x76Q8a
         oRGfwVWJ0H1cy+TMTDEDoI4z4DYGjxQhruM95kD9ADEv2yawfFXmhCDRufD+2XyH9lQI
         H+kA==
X-Gm-Message-State: AOJu0Yz+TF9COf/6u5b9ess7+BycZaDEf3nGCnnS6kuv1BcLwYVNZK3Z
        U7sIL52OmoXOfxpIwUyo3hg7RUfmPbg+LjLhvHWBxv0H
X-Google-Smtp-Source: AGHT+IHjd4wGlwhZsBCuF2kjBQHitNk3zUh3zqF+aCwFT6YYsPHdAMxj6tb8viVT4At9leYbudqxto2QfT8id5FhNyU=
X-Received: by 2002:a67:e994:0:b0:452:7767:9058 with SMTP id
 b20-20020a67e994000000b0045277679058mr6828268vso.31.1695318227681; Thu, 21
 Sep 2023 10:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ3QLKcSM6oRGuyzJ4tquzP5UUfju7KQfkuBZpHdz_eGHL0Gvw@mail.gmail.com>
 <d210f947-6457-f46a-45bc-a167e8de330c@gmail.com>
In-Reply-To: <d210f947-6457-f46a-45bc-a167e8de330c@gmail.com>
From:   Jay Han <jayhan258@gmail.com>
Date:   Thu, 21 Sep 2023 11:43:36 -0600
Message-ID: <CAJ3QLKdBxYi0iXXHaBJ+x7uypeU8HSo3zh0ESVWQWSPD_hFrnA@mail.gmail.com>
Subject: Re: Clat calculation
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Thank you very much, Vincent!

I guess the difference between FIO clat and the time delta from
blktrace is caused by the start time for clat. What is interesting to
me is that every action combination I tried as the time delta in
blkparse is generally lower than what FIO clat reported.


On Tue, Sep 19, 2023 at 6:38=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On 9/18/23 12:54, Jay Han wrote:
> > Hello,
> > I am seeing a stiff delta between the fio clat vs blktrace data and
> > wondering how fio clat is measured in terms of the I/O processing
> > step. In blktrace, I measured the time delta between the complete(C
> > action) and issued(D action) per LBA basis.
> >
> > Can you tell me how fio clat is calculated please?
> >
> > Thank you,
> > Jay.
>
> Here is an extended discussion of fio's latency calculations:
>
> https://github.com/vincentkfu/fio-blog/wiki/How-does-fio-measure-latency
