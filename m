Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33608 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbDLKv1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 12 Apr 2015 06:51:27 -0400
Received: by lbbzk7 with SMTP id zk7so40425168lbb.0
        for <fio@vger.kernel.org>; Sun, 12 Apr 2015 03:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANt18PxZvp4LBDnXEujJc4GSogpsvhP+cu=j=VDPN4-=8+91+Q@mail.gmail.com>
References: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
	<CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
	<CANt18PyJoE7e-MqafAD=oYZfo5x0r2gwnvMsF7VXTE3=mwCm2A@mail.gmail.com>
	<CALjAwxiEv6jd5GuRC2rQsdaiGWZmku_tzS0-qQbQxe_RvVAT=A@mail.gmail.com>
	<CALjAwxhti4K021uqXVAOt53Cr=mbPz0V1Q7q32vPfgW3byAo2g@mail.gmail.com>
	<CANt18PzSgzy7zVOXuY26iz9gH=tnTLZiKSE=i=pGxAWrxgVq6g@mail.gmail.com>
	<CALjAwxg5Sq-VkpBe+4+nK3PdgpGKpVDF3eEacGauWYVKbYtJYQ@mail.gmail.com>
	<CANt18PxZvp4LBDnXEujJc4GSogpsvhP+cu=j=VDPN4-=8+91+Q@mail.gmail.com>
Date: Sun, 12 Apr 2015 11:51:24 +0100
Message-ID: <CALjAwxhJ7tGjJHNzHanWw02NTRJuvYcaEeiR6BOWrrjD8BYt1g@mail.gmail.com>
Subject: Re: during fio scenario with verify=meta some jobs fails
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Samuel Shapiro <samuel.sh79@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 12 April 2015 at 11:12, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
> Thanks for the great answer Sitsofe :)
> Will stick to md5 verification while testing FS data integrity.

If fio is in any shape or form CPU bound during writing or
verification I'd probably hint to you that crc32c-intel might be
better tradeoff if fio is running on recent Intel hardware. If you
can't use that (because you aren't on that hardware) you could use
xxhash instead. Both crc32c-intel and xxhash will "detect" less
corruptions than md5 (their checksum is smaller) but they can be
dramatically faster and perhaps allow you to get more runs / more
concurrency in and will still detect common problems.

I failed to answer question 3. of your original mail:

> 3. How can I parse ".state" file so I could compare its data to
> original file on storage?

You only need to use this file if the writing pass is interrupted
before it could be fully completed (so you know when to stop
verifying). I don't think it records the contents of the data being
written but rather how starting parameters and how far along a given
data generation sequence you got (so you have enough to replay it
later)...

Generally speaking and assuming the verification header part of a
block isn't corrupt, verify_dump can be used to make fio dump the
expected and mismatched data into two files for later inspection when
a mismatch is found. If memory serves, non important parts of the
header section may not match between the expected and actual dumps
(e.g. padding between the real values might not match up).

-- 
Sitsofe | http://sucs.org/~sits/
