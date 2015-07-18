Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.201]:51178 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbGRXJa (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 18 Jul 2015 19:09:30 -0400
Received: from mail-vn0-f49.google.com (mail-vn0-f49.google.com [209.85.216.49])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id DC3983E0C5C
	for <fio@vger.kernel.org>; Sat, 18 Jul 2015 18:09:27 -0500 (CDT)
Received: by vnds125 with SMTP id s125so12104473vnd.1
        for <fio@vger.kernel.org>; Sat, 18 Jul 2015 16:09:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhO0wLVfefuUMFXjKdKQKFnn_-qZbYkWA-2p5aFE3Y7Lg@mail.gmail.com>
References: <CAB-428kbc6uE0fViU9ahW15BtPZi1txKcKnBdgzyb+083SfRZg@mail.gmail.com>
 <CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
 <CAB-428mNs=gPV4yCts16YXMVLSE_HJwAf1KsKah+4qiKxoTGVQ@mail.gmail.com> <CALjAwxhO0wLVfefuUMFXjKdKQKFnn_-qZbYkWA-2p5aFE3Y7Lg@mail.gmail.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Sat, 18 Jul 2015 18:08:48 -0500
Message-ID: <CAB-428k9w=DXq4W9mHcOF-kVa4Apr+36R2aOkQyS-nmdRRmm2g@mail.gmail.com>
Subject: Re: Question about data integrity check
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Grant Grundler <grundler@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>

On Sat, Jul 11, 2015 at 12:20 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> I guess what might be needed to cope with the "stale overwrite / data
> from another part of the disk" scenario is something akin to dt's
> pattern=iot (see
> http://www.scsifaq.org/RMiller_Tools/ftp/dt/dt-UsersGuide.pdf ) so
> each block has a different pattern based on LBA. You still need to
> change the seed of the LBA based pattern on each pass and you'd need
> to know what THAT seed was if you abort partway through a run if you
> wanted to verify things later...
>
> The advantage writing an exact "headerless" pattern has is that it can
> verify patterns written by other tools (this makes it easier to verify
> the operation of commands like WRITE SAME without having to synthesise
> a header).
>
> --
> Sitsofe | http://sucs.org/~sits/

Sitsofa,

I do agree on your point about the header less pattern. Your other
point about the LBA dependent pattern has been kind of implemented in
the fio by Chromium Dev team. They do write and verify "numberio" and
"rand_seed" in each LBA. NumberIO is equal to the number of writes
that has been written so far on the device. Obviously this value is
dependent to the rand_seed.

--Alireza
