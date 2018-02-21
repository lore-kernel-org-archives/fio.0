Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:45707 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932674AbeBUQgn (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Feb 2018 11:36:43 -0500
Received: by mail-vk0-f50.google.com with SMTP id k187so1306700vke.12
        for <fio@vger.kernel.org>; Wed, 21 Feb 2018 08:36:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+ecfTjemvzb67WBFzYQThaL+bQTbFv8+QbHOOvfD4G+Mjj-vw@mail.gmail.com>
References: <CALjAwxjUHo=ShAZrtPfLkQLRep3D8KEuByfrLkBNZUAeFqYuFA@mail.gmail.com>
 <CA+ecfTjemvzb67WBFzYQThaL+bQTbFv8+QbHOOvfD4G+Mjj-vw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 16:36:12 +0000
Message-ID: <CALjAwxgcOxGgk1JN6bVcvKiK5iUgv7d0bGiLK+_ruPdf7uuqyQ@mail.gmail.com>
Subject: Re: [ Inquire FIO-butterfly test ] method concept and flow , notice
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jacky Chen <jackyc423@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Jacky,

On 21 February 2018 at 15:25, Jacky Chen <jackyc423@gmail.com> wrote:
>
> I want to know the detail flow and concept related section "2.7. Butterfl=
y seek pattern"=C2=B6

I'm afraid I'm still confused! I'm not sure there's much more detail to giv=
e...

In terms of concept there's a disk I/O pattern where each I/O
alternates from being at the "start" and then being at the "end" of
the disk but each seek moves further away from the starting position
over time over time and this sequence is sometimes known as a
butterfly or funnel pattern. Here are a few other descriptions turned
up by a Google search
(https://www.google.co.uk/search?q=3D%22butterfly%22+disk+seek ):
https://superuser.com/questions/1125238/what-exactly-is-a-funnel-seek-test
, https://github.com/linux-test-project/ltp/blob/63a69aa547209f57a182e5a48d=
1e3eff4c878281/testcases/kernel/io/disktest/README#L132-L133
, https://searchcode.com/codesearch/view/25334606/ .

Perhaps if you think of it in terms of a disk with 4 blocks the
pattern would be:
read block 0
read block 3
read block 1
read block 2
read block 2
read block 1
read block 3
read block 0

This is just a specific example of the general rule given in the commit:

# Assumes the blocks start at 0
for block in totalblockcount
do
 read block
 read (totalblockcount - block - 1)
end

> How to do this experiment on my platform?

You'll have to modify and run the example job as described in my previous e=
mail.

> if we need do "read/write random sectors in single pass (20% min),butterf=
ly test "

The concept of a random butterfly workload doesn't make sense to
me - if the choice of the next "sector" is random then by definition you're=
 not
trying to follow a particular pattern, no? Perhaps whoever wrote your
quoted text meant pick the next I/O randomly from a different half of
the disk to the previous I/O? Perhaps they were describing two different pa=
sses
(pass 1 random, pass 2 butterfly)? You'd have to ask whoever wrote
that for clarification as to what they meant.

> it seemed need to modify below parameters in butterfly_customiz.fio .
>    1.#size=3D50%
>    2.#offset=3D50%
>    3......etc.

You don't have to modify those if you don't need to. The comment is
just there a note on how to cope with preventing the "forward" I/O to
from moving past the "backward" I/O when they meet in the middle.

> For fit the  butterfly test request , Do you have any suggestion of the c=
ustomize butterfly.fio ? or any stuff related this topic ?

Nothing more than I've already posted I'm afraid. Good luck!

--
Sitsofe | http://sucs.org/~sits/
