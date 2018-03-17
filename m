Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35025 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbeCQHzi (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Mar 2018 03:55:38 -0400
Received: by mail-vk0-f46.google.com with SMTP id r197so6935763vke.2
        for <fio@vger.kernel.org>; Sat, 17 Mar 2018 00:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521132231.2834.4.camel@wdc.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
 <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com> <1521132231.2834.4.camel@wdc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 07:55:07 +0000
Message-ID: <CALjAwxj+zGcw0o2uDPd6ZbW2fHJ99vMt0hZsRh1jgxgcrTOnsw@mail.gmail.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Kris Davis <Kris.Davis@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>, "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>

On 15 March 2018 at 16:43, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> Adding support for ZBC drives as a profile has a significant disadvantage,
> namely that the different I/O patterns (sequential read, sequential write,
> random read, random write, ...) all have to be reimplemented. That's why I'm
> considering to add ZBC support by modifying what get_next_block() produces.
> Can you have a look at the (barely tested) patch below?

I don't have access to any ZBC devices but I looked over the patch.
This seems to be a blend of both both of Philip's suggestions and I
quite like it because it centralized most of the logic within the
engine itself bar the offset fixing.

Something that could help is
if ioengines were able to specify a callbacks to say whether an offset
+ size is valid or whether the ioengine wants to "fix" them. If it
says the offset is invalid we just quietly pretend we did the I/O,
reduce the amount of I/O we have to do on this loop and generate the
next offset + size. If it chooses to just fix it then we just use the
different values it fixed the I/O to (assuming it fits alignment,
minimum block sizes etc). How do people see fix mode interacting with
things like bssplit? Do we just ban bssplit when in this mode for now?

Most engines could leave these unset but it would be perfect for this
one and it would stop the typical path having to depend on this
particular ioengine being configured in. If fix things up mode is set
then I suppose fio could then go on to ban things like lsfr, randommap
and random_distribution. I guess one snag with re-rolling in "valid"
mode is that you could end up re-rolling forever. I'm no expert but
I'm hoping doing another if (engine defines block_checking) on every
I/O won't have too much of a hit.

Perhaps we just start with "fix" mode see how that goes and move on
from there? Something else that could get hairy are verify jobs that
are seperate from their write job because the offsets generated during
a subsequent verify will not necessarily be invalid at the same points
or changed the same way. I suppose inline verify should work assuming
write regions haven't been reset due to becoming full.

-- 
Sitsofe | http://sucs.org/~sits/
