Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F263C433EF
	for <fio@archiver.kernel.org>; Sat, 29 Jan 2022 06:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbiA2Gwc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 29 Jan 2022 01:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiA2Gwb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 Jan 2022 01:52:31 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EA3C061714
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 22:52:31 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id j12so6829865qtr.2
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 22:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6IttGQyDgudEWw15wOtd827g7V+l936sxN9Yhe0v90k=;
        b=cdwcpdrSjdKmuySYH89TqBkTY147MLqVwk1OMra7nGRMHXH3vyG7useSineGl9VLHU
         tycSuAJPAzptLO0d0eufsg1MVz4zvDTdk91hyLBk7e6y+j7F0V32esSjZiJT7qTR0swj
         /lMH2ygTiXFcEKICB8TR7XotlC+r0TMghbHMPb8hm3mhp+MzTnzXnv5cvXaeTJXeTj9s
         YSVVg+roW5uiM0IBBUle3f7hXmSPTnvZA9rL6BozZf4QF2BwxnM5U9dvtt8KWr9JOzZq
         zskfqh0S/j8IDayxjNJk6xi+UdEf0LNrtBgaG0p/M4AH5fSyFUzHSdxJRwyiZTUSBfCy
         PX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6IttGQyDgudEWw15wOtd827g7V+l936sxN9Yhe0v90k=;
        b=EB3/vh830/VeXIfcDUoI5BX2/yyhe7/3qStfl5WSvZ86hVBpmwBnqQD+BfSup32py0
         wKFArDRhwZvo88HKTrZG9JsK2HzV7ckcDsV5DClGAnHJ1W/3pzqXPX6D6ilqiSTrp3at
         axip2NO5EfwmUFBS9qOoIaEzA5k7blnD80VnrGMHoduG7lkNx1sQWJhKlkwBykrJq0tq
         UoIYVNxVMkKRhu2DZSfU+YdPm7Z99C9VNRWSoXJWyWPMlBYq3KFdBYwvl1khAPI5d6rW
         Ke99lh9C3UTvKQl2r/mxaW6CgM63pkuJPomwRuPB1CVKH8LfOU072XMh5kovL64EDJcq
         tDzw==
X-Gm-Message-State: AOAM532xHDPSUwn5CRUGWKsIgkvJtADq8vnNHcNARt8kyPKl/7fnmBkm
        c9PsKYJoYOJgd7dO1b4+wGNxOPzPrb3I4u6BCYvIS3p6aMXWwA==
X-Google-Smtp-Source: ABdhPJxSoQvAwolOluynCPn0JJZEjAgAwFHIDuOe61BbbdJ/vvH0y0aG58vI0dGsyD1SYr3IUw5oqEbhScWc/ybEuus=
X-Received: by 2002:ac8:7f09:: with SMTP id f9mr3686898qtk.143.1643439150729;
 Fri, 28 Jan 2022 22:52:30 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com> <CADqNVToqmzWAkkxJxe4r9M05H6ZcYRffG5pvdiHUuERMS8ojkw@mail.gmail.com>
 <7a3e701e-e3ab-4dc5-2326-387d80c38061@opensource.wdc.com>
In-Reply-To: <7a3e701e-e3ab-4dc5-2326-387d80c38061@opensource.wdc.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Sat, 29 Jan 2022 00:52:17 -0600
Message-ID: <CADqNVTozhnoDrAhpcwWn+_3gPgUS8DnrLrrbtMjeGiuwPvSyjQ@mail.gmail.com>
Subject: Re: A fio job that just waits?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jan 28, 2022 at 6:16 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
> OK. There may be a bug then, startdelay is not accounting for the fact
> that the wait_for option is being used. Can you try the stonewall option
> instead of wait_for ?

I'm seeing the same behavior when I replace wait_for with stonewall.
E.g., a time of just over 20 seconds for:
time sudo fio --ioengine=libaio --direct=1 --filename=/dev/nvme1n1
--rw=write --iodepth=16 --bs=128k --name=job1 --size=15GB
--runtime=10s --time_based --name=job2 -size=15GB --runtime=10s
--time_based --stonewall --startdelay=5s

This is also the behavior I'd expect (but not want of course) based on
the code in backend.c .

It's also the behavior I see when I put a single job with a start
delay in a file and invoke fio with the same file twice. E.g., foo.fio
with contents of:
[job]
ioengine=libaio
direct=1
filename=/dev/nvme1n1
rw=write
iodepth=16
bs=128k
size=15GB
runtime=10s
time_based=1
startdelay=5s

and then invoking

time sudo fio foo.fio foo.fio

gives a runtime of 25 seconds, when I'd expect 30 =  (5 second wait +
10 second execution ) * 2

In most of the cases it seems like the ETA is confused by the behavior
two.  ETA jumps instantaneously from 15 down to 10 when the first run
of foo.fio is complete and the second one begins.
