Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:42608 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751479AbeCWRbb (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 23 Mar 2018 13:31:31 -0400
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w2NHTNqf016558
        for <fio@vger.kernel.org>; Fri, 23 Mar 2018 13:31:31 -0400
Received: from mail-lf0-f72.google.com (mail-lf0-f72.google.com [209.85.215.72])
        by mx0a-000cda01.pphosted.com with ESMTP id 2gw3980p3m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Fri, 23 Mar 2018 13:31:30 -0400
Received: by mail-lf0-f72.google.com with SMTP id h191-v6so4083599lfg.18
        for <fio@vger.kernel.org>; Fri, 23 Mar 2018 10:31:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e52a9bf270dd6a36dd7b46f6015314d93f076f.camel@wdc.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
 <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com>
 <1521132231.2834.4.camel@wdc.com> <CALjAwxj+zGcw0o2uDPd6ZbW2fHJ99vMt0hZsRh1jgxgcrTOnsw@mail.gmail.com>
 <43e52a9bf270dd6a36dd7b46f6015314d93f076f.camel@wdc.com>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Fri, 23 Mar 2018 11:30:48 -0600
Message-ID: <CAODBMznZzLuO5HzrqJ0VPcG0eJ02oK1-K57dFOtDYbFrEEz4Gg@mail.gmail.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "sitsofe@gmail.com" <sitsofe@gmail.com>, Kris Davis <Kris.Davis@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>

Hello Bart,
I've been trying out the ZBC changes with a few drives and workloads,
and the only limitation I've found so far is that random write
workloads with a queue depth > 1 seem to write beyond the write
pointer. This isn't particularly surprising, but I wanted to double
check if this is an expected limitation, and if so, are there plans to
support queued random writes in the future? Other than that, the
changes seem to be working just as advertised. I think your zone
management system will make writing a zone random workload fairly
straightforward. Thank you for the update!

Sitsofe, would you be interested in being sent a ZBC drive? If you
would like to give me an address, we can get one sent to you to help
with validation.
Let me know what you'd like,
Phillip

On Mon, Mar 19, 2018 at 8:21 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Sat, 2018-03-17 at 07:55 +0000, Sitsofe Wheeler wrote:
>> I don't have access to any ZBC devices but I looked over the patch.
>> This seems to be a blend of both both of Philip's suggestions and I
>> quite like it because it centralized most of the logic within the
>> engine itself bar the offset fixing.
>
> Thanks for having taken a look :-)
>
>> Something that could help is
>> if ioengines were able to specify a callbacks to say whether an offset
>> + size is valid or whether the ioengine wants to "fix" them. If it
>> says the offset is invalid we just quietly pretend we did the I/O,
>> reduce the amount of I/O we have to do on this loop and generate the
>> next offset + size. If it chooses to just fix it then we just use the
>> different values it fixed the I/O to (assuming it fits alignment,
>> minimum block sizes etc). How do people see fix mode interacting with
>> things like bssplit? Do we just ban bssplit when in this mode for now?
>>
>> Most engines could leave these unset but it would be perfect for this
>> one and it would stop the typical path having to depend on this
>> particular ioengine being configured in. If fix things up mode is set
>> then I suppose fio could then go on to ban things like lsfr, randommap
>> and random_distribution. I guess one snag with re-rolling in "valid"
>> mode is that you could end up re-rolling forever. I'm no expert but
>> I'm hoping doing another if (engine defines block_checking) on every
>> I/O won't have too much of a hit.
>>
>> Perhaps we just start with "fix" mode see how that goes and move on
>> from there? Something else that could get hairy are verify jobs that
>> are seperate from their write job because the offsets generated during
>> a subsequent verify will not necessarily be invalid at the same points
>> or changed the same way. I suppose inline verify should work assuming
>> write regions haven't been reset due to becoming full.
>
> It's not clear to me why you would like to add such logic in the I/O
> engines? Shouldn't such logic rather be added in a new I/O profile such that
> users who want to run ZBC tests have the freedom of chosing an I/O engine?
>
> I'm not sure that a "fix" mode would work best. Phillip Chen has
> mentioned that we need a mode in which the user can control the number of
> open zones. If a random blocks would be generated first and the open zone
> limit would be applied afer that offset has been generated then most of
> the generated random blocks would have to be discarded since the number
> of open zones is typically much smaller than the number of zones
> supported by a disk. I'm currently looking at how to let I/O profiles
> influence the behavior of get_next_block() in such a way that the number
> of open zones can be limited by an I/O profile without having to reimplement
> fio core logic in an I/O profile.
>
> Regarding implementing write verify: the code that I posted does not yet
> support verifying written data. However, it's not that hard to modify that
> code such that verifying written data becomes possible. My proposal is to
> use the following approach:
> - Before writing starts, reset the zones that fio will write to to avoid
>   that a zone has to be reset in the middle of the write phase, something
>   that would result in data loss.
> - In a single zone, write at the write pointer. This will result in
>   sequential writes per zone from the start to the end of the zone.
> - When verifying data, read the zone from start to end such that read and
>   write offsets match.
>
> Thanks,
>
> Bart.
>
>
>
