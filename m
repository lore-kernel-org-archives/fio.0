Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgKAJG2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Nov 2020 04:06:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F08C0617A6
        for <fio@vger.kernel.org>; Sun,  1 Nov 2020 01:06:27 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c9so4992268wml.5
        for <fio@vger.kernel.org>; Sun, 01 Nov 2020 01:06:27 -0800 (PST)
MIME-Version: 1.0
References: <CAAEM5qKsqw44j_Bwi7fnJF0KXGcVG9qFp_=Nmg6LiwQ3t+LtBQ@mail.gmail.com>
In-Reply-To: <CAAEM5qKsqw44j_Bwi7fnJF0KXGcVG9qFp_=Nmg6LiwQ3t+LtBQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Nov 2020 09:06:00 +0000
Message-ID: <CALjAwxjJXEaDjacbfT5=rS6XzFxDwJOP5Rnktqc1+Y95UKcWsg@mail.gmail.com>
Subject: Re: Writing/reading OD, MD, ID of a disk
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: siha lawrence <sihaj33@gmail.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, fio <fio@vger.kernel.org>

Hi,

On Tue, 6 Oct 2020 at 13:40, siha lawrence <sihaj33@gmail.com> wrote:
>
> Hi,
>
> What parameters could we use to write/read OD, MD, ID of a disk or
> specific LBAs?
>
> Thanks,
> Siha

It seems like OD (Outer Disk), MD (Middle Disk) and ID (Inner Disk)
are SMR drive terms. I don't know how you explicitly target those...
maybe someone more familiar with SMR would know? (I've CC'd Dmitry in
case they know).

If you want to write a specific LBA you will have to get as close to
the disk as possible. If we're talking Linux you can access the disk's
raw block device (filename=/dev/<dev>), use direct=1, set blocksize to
the underlying block size and then you could play back a hand crafted
iolog (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-read-iolog
/ https://fio.readthedocs.io/en/latest/fio_doc.html#trace-file-format-v2
) where the offset would correspond to the LBA.

--
Sitsofe | http://sucs.org/~sits/

