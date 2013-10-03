Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38778 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3JCTww (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Oct 2013 15:52:52 -0400
Received: by mail-la0-f41.google.com with SMTP id ec20so2465235lab.0
        for <fio@vger.kernel.org>; Thu, 03 Oct 2013 12:52:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
Date: Thu, 3 Oct 2013 15:52:51 -0400
Message-ID: <CABFR9T00FJqW1DHag2SiOFypTwyg_y9sU=nv_vuKyQmedFHqxg@mail.gmail.com>
Subject: Re: precondition ssd drives w/ fio
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I happen to be doing SSD benchmarks myself and if I read your
questions correctly the following scenarios exist:
1.  Performance of a fresh drive or a drive after a secure erase.
2.  Performance after the disks memory has been completely written to.
 I loose track of the exact wording but I want to say at this point a
disk has to do a read modify write vs just doing a write.

I went with using fio to do full disk sequential writes and also
setting it to a timed run to make sure  it did multiple sets of
writes.

Thanks,
Roger

On Thu, Oct 3, 2013 at 3:31 PM, Brian L. <brianclam@gmail.com> wrote:
> For benchmarking SSD drives, I was told that we should precondition
> our drives to get more accurate real world reading.
>
> I was wondering if anyone is using fio itself to precondition ssd
> drives or use a different script to populate random data on the
> drives?
>
> Thanks in advance.
>
> Brian L.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
