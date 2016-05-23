Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:59736 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbcEWOtx (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 May 2016 10:49:53 -0400
Received: from localhost (enchanter.cs.umn.edu [160.94.22.228])
	by mail.cs.umn.edu (Postfix) with ESMTP id 7886E39F3B6
	for <fio@vger.kernel.org>; Mon, 23 May 2016 09:41:24 -0500 (CDT)
Received: from mail.cs.umn.edu ([128.101.32.201])
	by localhost (enchanter.cs.umn.edu [160.94.22.228]) (amavisd-new, port 10024)
	with ESMTP id cXFA1-gSDPke for <fio@vger.kernel.org>;
	Mon, 23 May 2016 09:41:23 -0500 (CDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com [209.85.223.175])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 6CE3939F3B4
	for <fio@vger.kernel.org>; Mon, 23 May 2016 09:41:23 -0500 (CDT)
Received: by mail-io0-f175.google.com with SMTP id 190so194722377iow.1
        for <fio@vger.kernel.org>; Mon, 23 May 2016 07:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Mon, 23 May 2016 09:40:43 -0500
Message-ID: <CAB-428mejCjj0dUUEX9GME6Sz4ocNoabzpDmdjDW6f81FtB++w@mail.gmail.com>
Subject: Re: testing thin provisioned block device
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Walker <tim.t.walker@seagate.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, May 23, 2016 at 9:24 AM, Tim Walker <tim.t.walker@seagate.com> wrote:
>
> Hello-
>
> I need to do random writes/reads to some thin-provisioned block
> devices.  Writes are no problem, but I have to make sure the reads
> come from blocks that have already been written (or else the device
> synthesizes fill data).  Pre-filling the device is not desirable since
> they are 8-12 TiB, plus that isn't the way they are really used.
>
> IO at the block level is our customer's requirement, but I'd also be
> interested in the same concept at the file level, where fio randomly
> reads from files that it has randomly written.
>
> I'm sure I'm not the first person who has come up against this, but
> I've searched/Googled the best I can and have come up empty. Can
> somebody point me to the correct switches to force reads to be
> randomly selected from the blocks that have been written by that test
> sequence?
>
> Thanks in advance.
>
> Best regards,
> -Tim

Tim,

If you don't want to mix read and write workload, could you just write
randomly at your block device with one job first, then use the same
random seed in the next job to read those random blocks ?

--Alireza
