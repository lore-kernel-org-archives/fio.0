Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10181C433F5
	for <fio@archiver.kernel.org>; Thu, 23 Sep 2021 09:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4C6A61131
	for <fio@archiver.kernel.org>; Thu, 23 Sep 2021 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhIWJbj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 23 Sep 2021 05:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbhIWJbj (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Sep 2021 05:31:39 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB51C061574
        for <fio@vger.kernel.org>; Thu, 23 Sep 2021 02:30:07 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 73so19975917qki.4
        for <fio@vger.kernel.org>; Thu, 23 Sep 2021 02:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MSNFb58ADFBAn3UTIuHucPUcCPRB3Jt3HAdXg/uJ5gQ=;
        b=q5PYNidis4ACVEIqeglLiMuTh3819dXqC0SQeKdNNTPEHiO1/VrxBqA/W9+eT8ArOs
         R9qV9prx0KrOjA6zIn6kIHgAx3sOlKpPdPnXoCkUZQ4a5pg3xO3Qq3hg8GDYCIiIi0n3
         d0gDU2T9tgBt0a9GXoYqKFQXaiRNuDKufeHH6mHTXSEy10NCV5ffqnPQxHCvSnJUn2QI
         6MutByWs3qogY/4mme006RvFTmyCHnHKVJIHUiR0i9Ps/BXItYTUwPaoHFzqqZajjyUt
         EBvp2bQJKl391UZgU3gIBodGugdyMnErq5PPPeiNw8EakmF+oOtRqJpbBG/L9Itg4WEu
         i1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MSNFb58ADFBAn3UTIuHucPUcCPRB3Jt3HAdXg/uJ5gQ=;
        b=0lCVAE6ng8cbRowqNL5ljiUBtBE4NOnNSxq4BFetXaWcoRidX0ACRZ7LkbzwUkAxxd
         00LYh+8qALo4uGRLdWzV3p/Wl9Vdq5+pP7UMkfOE4bqGt0tMbbhGgI1mcip4gKM5tym3
         o/muDtYdW4mAzvzK3KnvrI3Js3P5nD/q26qKoo4+gVWvmTv199lx9AIlJ7a6Blxzz726
         tpzNtY83TPrIy2JGmVu1t3VRWisAKQWgtqW30g2iNwyfqTS7GKYBExyFHFlegUImLuC+
         NTvUQyCIyFIjYVVHWddybYZLn/9ELwu9jfZo6KL7+WZg2vmRfM9v9nByqS+OVGYK7/NQ
         dTJQ==
X-Gm-Message-State: AOAM532qFfjKYNDVxB9PqT8lWyEuqF7ctcitavrH7ezfs1C6vc9cKvxi
        YPlpqAW72mVyzh1m2Zc/PKfKEI8ZCTsTBm2d7Hcto4x5THI=
X-Google-Smtp-Source: ABdhPJyXq2U5s9Z7IAqTWOSY+6mwvmlmmA14F8K49lpFTIiML1qd8g0Ja31Hf6rFpFWm9ruM60ybJdNm9U27Z7JijCU=
X-Received: by 2002:a25:ad45:: with SMTP id l5mr4620225ybe.228.1632389406702;
 Thu, 23 Sep 2021 02:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAASfLOtCaXJccL1TrZwkpRj0kMFOWcvZwVUEC+m7XTv3MaP0HA@mail.gmail.com>
In-Reply-To: <CAASfLOtCaXJccL1TrZwkpRj0kMFOWcvZwVUEC+m7XTv3MaP0HA@mail.gmail.com>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Thu, 23 Sep 2021 10:29:40 +0100
Message-ID: <CALjAwxiqsYpqwa5HyKGjXcWALFiYH7MB0ZOdisSF3U4+61-=gA@mail.gmail.com>
Subject: Re: Single iolog file created when 2 separate files are expected (write_iolog)
To:     freoone <freoone@gmail.com>
Cc:     fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

On Tue, 21 Sept 2021 at 09:30, freoone <freoone@gmail.com> wrote:
>
>
> I'm trying to run fio to do some random reads with 2 threads
> (numjobs=3D2). I'd like to record iolog for both threads in separate
> files.
> The manual in the 'write_iolog' section says:
> "Specify a separate file for each job, otherwise the iologs will be
> interspersed and the file may be corrupt."
> and later:
> "You can specify a number of files by separating the names with a =E2=80=
=98:=E2=80=99
> character."

The text "you can specify a number of files by separating the names
with a =E2=80=98:=E2=80=99 colon" only applies to the explicit filename opt=
ion
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-filename
) as opposed to other options (like write_iolog) that happen be
filenames.

> So I'm running the following command:
> ./fio  --name=3Dtest2jobs --rw=3Drandread --filename=3Dfile.fio --size=3D=
10M
> --numjobs=3D2 --write_iolog=3Dlog1:log2
> but instead of two files "log1" and "log2" I get a single file
> "log1:log2" containing IOs from both threads.
> Is this a bug in fio or is there some misconception on my part?

To get what you describe you have to avoid usage of numjobs. For
example if I leave make most of the options as global then this works:
./fio --rw=3Drandread --filename=3Dfile.fio --size=3D10M  --name=3Dtestjob1
--write_iolog=3Dlog1  --name=3Dtestjob2 --write_iolog=3Dlog2

--=20
Sitsofe
