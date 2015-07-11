Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36116 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbGKRUZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 11 Jul 2015 13:20:25 -0400
Received: by lagc2 with SMTP id c2so277864774lag.3
        for <fio@vger.kernel.org>; Sat, 11 Jul 2015 10:20:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-428mNs=gPV4yCts16YXMVLSE_HJwAf1KsKah+4qiKxoTGVQ@mail.gmail.com>
References: <CAB-428kbc6uE0fViU9ahW15BtPZi1txKcKnBdgzyb+083SfRZg@mail.gmail.com>
	<CANEJEGu60H0_2q8NOd9GPWTqw5CcxS2sr2omWeReLhhmfXiy-A@mail.gmail.com>
	<CAB-428mNs=gPV4yCts16YXMVLSE_HJwAf1KsKah+4qiKxoTGVQ@mail.gmail.com>
Date: Sat, 11 Jul 2015 18:20:23 +0100
Message-ID: <CALjAwxhO0wLVfefuUMFXjKdKQKFnn_-qZbYkWA-2p5aFE3Y7Lg@mail.gmail.com>
Subject: Re: Question about data integrity check
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Grant Grundler <grundler@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>

On 7 July 2015 at 22:17, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
> On Tue, Jul 7, 2015 at 3:31 PM, Grant Grundler <grundler@chromium.org> wrote:
>
> Hi Grant,
>
> Thanks for the reply. These additions to FIO that has been done by
> your team in my opinion are truly valuable. However, as you mentioned
> it is sufficient but not intended for a robots data integrity check. I
> am planing to propose some changes and additions to the verification
> frameworks in a couple of days. It would be great if I have your
> attention and comments on that.

I guess what might be needed to cope with the "stale overwrite / data
from another part of the disk" scenario is something akin to dt's
pattern=iot (see
http://www.scsifaq.org/RMiller_Tools/ftp/dt/dt-UsersGuide.pdf ) so
each block has a different pattern based on LBA. You still need to
change the seed of the LBA based pattern on each pass and you'd need
to know what THAT seed was if you abort partway through a run if you
wanted to verify things later...

The advantage writing an exact "headerless" pattern has is that it can
verify patterns written by other tools (this makes it easier to verify
the operation of commands like WRITE SAME without having to synthesise
a header).

-- 
Sitsofe | http://sucs.org/~sits/
