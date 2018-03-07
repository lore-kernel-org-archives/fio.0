Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:45226 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933502AbeCGQBu (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Mar 2018 11:01:50 -0500
Received: by mail-vk0-f46.google.com with SMTP id k187so1593546vke.12
        for <fio@vger.kernel.org>; Wed, 07 Mar 2018 08:01:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Mar 2018 16:01:18 +0000
Message-ID: <CALjAwxg0qObPUrZPxKF=34zHGx00QWGOKeHsjRR3c4=bdhB8dg@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rob Scheepens <rob.scheepens@nutanix.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>

Thanks for following up.

Do you happen to know how far it would get on runs where it went on to
hang? Would it be it in the middle of a job or was it still doing
setup or varied? Would it take hours to happen?

On 7 March 2018 at 15:39, Rob Scheepens <rob.scheepens@nutanix.com> wrote:
> Adding to David's comments: my success percentage was roughly 30%. Most o=
f the time, 2 out of 3 runs would hang.
>
> Thanks for your involvement here Sitsofe.
>
> \Rob
>
>
> =EF=BB=BFOn 07/03/2018, 17:33, "David Knierim" <knierim@nutanix.com> wrot=
e:
>
>     Sitsofe,
>        Thanks for your interest in resolving this issue.  I no longer hav=
e a system to dig into this issue at the moment, but I will attempt to get =
back to this issue soon.
>       That being said, I like your questions and I am happy to answer the=
m:
>
>     >  can you check whether fio 3.5 also reproduces the problem?
>     When I get a system to run on, I will attempt to reproduce the issue =
with fio 3.5.
>
>     Yes, the example fio command line examples you showed are indeed what=
 the script is supposed to be doing.
>
>     If it helps, I also have a bash script which generates the same fio c=
ommands as the python script which also reproduces the issue.
>
>     I have not attempted to reproduce the issue with files or less raw di=
sks.   I can see your desire for a simplified reproducer.   When I get back=
 to this issue, I will see what I can come up with.   I am sure something s=
impler will reproduce the issue, but I have not spent the time to find some=
thing simpler that works.  I will explore number of disks/files, numjobs an=
d also determine if the working set makes any difference.
>
>     In my experience, the python script never completed when run on Windo=
ws.  Rob had better luck than I did and the script ran to completion for hi=
m several times, but it also showed the failure multiple times as well, but=
 I don't remember what the pass percentage was for him.
>
>     When I run the same python or bash script on Linux (just updating the=
 path to the raw disks and the ioengine), it runs 100% reliably.

--=20
Sitsofe | http://sucs.org/~sits/
