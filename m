Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33898 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbdCPRPf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2017 13:15:35 -0400
Received: by mail-vk0-f41.google.com with SMTP id r136so27935711vke.1
        for <fio@vger.kernel.org>; Thu, 16 Mar 2017 10:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGpXXZ+bWSkOp3KqUvycgHY1gaonriGX95-7tUQ-nND-sGbaeA@mail.gmail.com>
References: <87fuie2p40.fsf@curie.anarc.at> <CALjAwxjrNpTQTitcZCFA205m6mtE04OC_R_zmsK593hEUK3bPg@mail.gmail.com>
 <CAGpXXZ+bWSkOp3KqUvycgHY1gaonriGX95-7tUQ-nND-sGbaeA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 16 Mar 2017 17:14:58 +0000
Message-ID: <CALjAwxjoWsCh5szMrA6nJfDChQSVZzkPtZ2K4u-AZ6s0HPYKkg@mail.gmail.com>
Subject: Re: could fio be used to wipe disks?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Antoine Beaupre <anarcat@orangeseeds.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Greg,

You make a fair point and perhaps I should have used scare quotes. I'm
aware of the "can't recover anything after first past on disks greater
than 100GByte" debate at least with respect to hard disks and the
challenges that people have hosted across the years that no one has
taken them up on. I do wonder if SSDs (coupled with all their fancy
compression) complicates things a bit though (but the original poster
has stated that's a non-issue).

On 16 March 2017 at 09:58, Greg Freemyer <greg.freemyer@gmail.com> wrote:
>
>
> On Thursday, March 16, 2017, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>>
>> Bear in mind that if you're worried about wiping disks properly you
>> will have to write particular pattern over the disk.
>
>
> I apologize, but I feel the need to correct that.
>
> That was/is true of 20th century manufactured disks when tolerances on disk
> head movement were low.  When drives hit densities of 40 GB per platter it
> quit being true.
>
> The U.S. NIST media sanitation document addressing media holding government
> classified (but not top secret) allowed a single pass of zeros for wiping
> drives larger than 20 GB a decade ago.
>
> dc3dd is a forensic tool maintained by the U.S. DoD computer forensics lab.
>
> dc3dd wipe=/dev/sda writes a single pass of nulls to all bytes/sectors and
> calls it done.
>
> Certainly you can find 20+ year old studies that contradict the above, but I
> don't believe you can find anything from this century that does.
>
> Sorry to be pedantic,
> Greg
>
>
>
> --
> --
> Greg Freemyer
>



-- 
Sitsofe | http://sucs.org/~sits/
