Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:58770 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750992AbeACQlh (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 3 Jan 2018 11:41:37 -0500
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w03GfLOg042280
        for <fio@vger.kernel.org>; Wed, 3 Jan 2018 11:41:36 -0500
Received: from mail-lf0-f70.google.com (mail-lf0-f70.google.com [209.85.215.70])
        by mx0a-000cda01.pphosted.com with ESMTP id 2f90kh8e2q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 11:41:36 -0500
Received: by mail-lf0-f70.google.com with SMTP id m195so392354lfg.2
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 08:41:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAODBMz=87eO_NGzZy3vudvvcG45xzt2EQ8qsaHON0umqdQQhDw@mail.gmail.com>
References: <CAODBMz=eP9o0j_DeBtEzeULv49nSPCbMAjThrno8m8ns2ELdGg@mail.gmail.com>
 <CALjAwxiMLDOXm5bM7PKyOr1Z8y4P+AkP_ovZ3HZ6fdHOOsd=ZA@mail.gmail.com> <CAODBMz=87eO_NGzZy3vudvvcG45xzt2EQ8qsaHON0umqdQQhDw@mail.gmail.com>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Wed, 3 Jan 2018 09:40:53 -0700
Message-ID: <CAODBMzny3FoOTw_+iWrxXYfMRRFQHY6TsR4ua5A4_HFinW5nTQ@mail.gmail.com>
Subject: Re: FLEX feature requests
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Whoops, forgot to send this in plain text the first time.
Thanks for looking at this. A force_detected_size argument would work
just as well, if that is easier. I'd love to get this argument as soon
as possible so that I can start running FIO on the entirety of FLEX
drives.
As for the zoning:
I can't help wondering whether the above requires a special "mode" (or
profile) of it's own.
Yes, I think these I/O modes are different enough they need their own
specific mode, but I can't think of a better way than specifying it
through the readwrite option. However, it might makes sense to do it
another way.

Your bullet points on all that we need for the zoned I/O all seem spot
on to me except I'm not sure about this one (this also answers your
question on number of open zones):
- There needs to be control of the next zone picked (e.g. sequential/random=
).
I don't know that the idea of a "next zone" really applies here.
Ideally, all specified zones will be randomly issued I/O if they can
be. So initially, all zones would receive I/O, and then if a zone is
filled up it would no longer receive write I/O. Similarly, a readwrite
zone that has not been written to yet will not receive any read I/O
until it has received write I/O.

As for your other questions:
- Does a randommap for blocks still make sense when I no longer have
total freedom over where my next I/O goes?
randommap doesn't make sense for writes which must be written at the
high water mark like you said. I can see randommap being difficult to
implement for the reads, but I don't see any fundamental reason it
couldn't work. However, we tend to run FIO with the norandommap flag
anyway, so if this mode didn't run with randommap that would work for
us.

- What happens when there are more reads than writes? What does it
mean to have a sequential "only reads" job?
I'm not sure I understand the question here. Sequential reads would
work the same as usual, I assume. If you issued a read workload to an
area of the disk that hasn't yet been written, you'll get an abort,
but I think it's the user's responsibility to make sure that doesn't
happen. If you had a write_pointer_randrw workload with a rwmixread >
50, you would need to make sure not to issue reads until at least one
write had been issued. And then afterwards, all reads would need to be
to sectors that have already been written which might result in the
same few sectors being repeatedly read until more writes occur.

- Following on from the above, can reads force a switch to a new zone?
I/O should be distributed randomly among all the specified zones.

Reading through your comments makes me think that maybe it would make
sense when specifying zones for the write_pointer_randrw workload to
specify not just the offset and zone size, but the write pointer (high
water mark) as well.
Thank you for considering this, let me know if I can help in any way.
I would love to contribute to the FIO project if that would help.
Phillip Chen

On Wed, Jan 3, 2018 at 9:34 AM, Phillip Chen <phillip.a.chen@seagate.com> w=
rote:
> Thanks for looking at this. A force_detected_size argument would work jus=
t
> as well, if that is easier. I'd love to get this argument as soon as
> possible so that I can start running FIO on the entirety of FLEX drives.
> As for the zoning:
> I can't help wondering whether the above requires a special "mode" (or
> profile) of it's own.
> Yes, I think these I/O modes are different enough they need their own
> specific mode, but I can't think of a better way than specifying it throu=
gh
> the readwrite option. However, it might makes sense to do it another way.
>
> Your bullet points on all that we need for the zoned I/O all seem spot on=
 to
> me except I'm not sure about this one (this also answers your question on
> number of open zones):
> - There needs to be control of the next zone picked (e.g.
> sequential/random).
> I don't know that the idea of a "next zone" really applies here. Ideally,
> all specified zones will be randomly issued I/O if they can be. So
> initially, all zones would receive I/O, and then if a zone is filled up i=
t
> would no longer receive write I/O. Similarly, a readwrite zone that has n=
ot
> been written to yet will not receive any read I/O until it has received
> write I/O.
>
> As for your other questions:
> - Does a randommap for blocks still make sense when I no longer have
> total freedom over where my next I/O goes?
> randommap doesn't make sense for writes which must be written at the high
> water mark like you said. I can see randommap being difficult to implemen=
t
> for the reads, but I don't see any fundamental reason it couldn't work.
> However, we tend to run FIO with the norandommap flag anyway, so if this
> mode didn't run with randommap that would work for us.
>
> - What happens when there are more reads than writes? What does it
> mean to have a sequential "only reads" job?
> I'm not sure I understand the question here. Sequential reads would work =
the
> same as usual, I assume. If you issued a read workload to an area of the
> disk that hasn't yet been written, you'll get an abort, but I think it's =
the
> user's responsibility to make sure that doesn't happen. If you had a
> write_pointer_randrw workload with a rwmixread > 50, you would need to ma=
ke
> sure not to issue reads until at least one write had been issued. And the=
n
> afterwards, all reads would need to be to sectors that have already been
> written which might result in the same few sectors being repeatedly read
> until more writes occur.
>
> - Following on from the above, can reads force a switch to a new zone?
> I/O should be distributed randomly among all the specified zones.
>
> Reading through your comments makes me think that maybe it would make sen=
se
> when specifying zones for the write_pointer_randrw workload to specify no=
t
> just the offset and zone size, but the write pointer (high water mark) as
> well.
> Thank you for considering this, let me know if I can help in any way. I
> would love to contribute to the FIO project if that would help.
> Phillip Chen
>
>
> On Fri, Dec 29, 2017 at 4:24 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrot=
e:
>>
>> Hi Philip,
>>
>> On 15 December 2017 at 21:29, Phillip Chen <phillip.a.chen@seagate.com>
>> wrote:
>> > Hello again,
>> > I've been working on getting FIO running on a FLEX drive and I've been
>> > accumulating a laundry list of features that would be nice to have and
>> > I've run into one that is necessary. I also found one bug while
>> > experimenting with various FIO options that I'll include in the list.
>> > Here are the changes I'd appreciate seeing starting with the most
>> > desired. I've included
>> >
>> > 1. --ignore_device_size
>> > The current FLEX protocol maps storage to sectors/bytes greater than
>> > the reported capacity of the drive. I'd like to run FIO on these out
>> > of bounds sectors, but right now I can't because I get the error "you
>> > need to specify valid offset=3D". Would it be possible to add a flag
>> > that would let users run IO outside of the reported device capacity?
>> > Without this I believe that FIO cannot run on the SMR portions of any
>> > FLEX drive.
>>
>> Perhaps a "--force_detected_size=3Dint" might be simpler because there
>> are all sorts of things that look at the file size and make some sort
>> of calculation based upon it (e.g. offset/size percentages)...
>>
>> > 2. --readwrite=3Dwrite_pointer_randwrite:offset,io_size:offset,io_size=
...
>> > In write pointer zones, all writes must be at the write pointer, so
>> > random IO is not possible. However, it would be useful to run
>> > random-like workloads in which random zones are written to
>> > sequentially. This would be very similar to the
>> > random_distribution=3Dzoned_abs argument except for instead of writing
>> > randomly within a zone, it would write to a specific offset and then
>> > increment that offset by the amount written, but would stop writing to
>> > that zone entirely once the incrementing offset reached the end of the
>> > zone. So if I had 3 zones I wanted to write to that were each 128mb
>> > long, I could specify something like
>> > --readwrite=3Dwrite_pointer_randwrite:0,128m:128m,128m:256m,128m. It
>> > might also make sense to add distribution percentages like in the
>> > zoned_abs argument, although I'm not entirely sure what you would do
>> > with those percentages when a zone got fully written and thus could
>> > not be picked anymore.
>> >
>> > 3. --readwrite=3Dwrite_pointer_randrw:offset,io_size:offset,io_size...
>> > Additionally, in write pointer zones, all reads must be below the
>> > write pointer, so random read IO is restricted. This is why I
>> > requested the random_distribution:zoned_abs argument, because that can
>> > be used quite well for issuing random reads to write pointer zones.
>> > However, I would like to read and write "randomly" to write pointer
>> > zones so that I can more easily control the read/write ratio as well
>> > as being able to read data that was written during the same FIO run
>> > (currently I can use random_distribution:zoned_abs to read randomly
>> > from the beginning of the zone up to the write pointer at the
>> > beginning of the FIO run, but I cannot read further after FIO
>> > increments the write pointer). This workload would write randomly as
>> > described above, and read between the offset and the incremented
>> > offset. So before any writes went to the zone, you wouldn't be able to
>> > read randomly from that zone.
>> >
>> > 4. Automatic zone detection with the above two readwrite modes
>> > I believe this would be quite a bit of work, but it would nice to be
>> > able to specify the previous two workload types without specifically
>> > specifying the zones. Instead the user could specify offset and size
>> > as normal, and additionally specify the zone number (perhaps through a
>> > new option or perhaps with an extended syntax in the readwrite
>> > option), and FIO would get the zones and randomly perform write
>> > pointer legal IO within all the zones specified by the user using
>> > offset and size. And if the user specified a drive area that contains
>> > non-write pointer zones, FIO would just do normal IO. It might also be
>> > possible for me to help with the implementation of this, if that would
>> > be something you'd be interested in.
>>
>> I can't help wondering whether the above requires a special "mode" (or
>> profile) of it's own. It sounds like:
>> - There needs to be a semi-elaborate zone map. It needs to be possible
>> to specify the zone map either using a trivial algorithm (e.g. make a
>> zone every other 128MBytes) or statically (here's a string that
>> represents the mapping/here's a function that will return a mapping)
>> - It must be possible to specify the type of a zone (this zone is for
>> reading/writing/trimming or some combination of these).
>> - Zones must be able to change their type as a job runs (after a write
>> zone starts being used it could be useful if it could become a
>> read/write zone, after it's full only a read zone etc).
>> - There needs to be control of the next zone picked (e.g.
>> sequential/random).
>> - A write zone needs a high water write mark to allow write
>> continuation or to ensure reads from it are below a watermark.
>> - Certain behaviours in this mode would be blocked (no random writing
>> to a zone).
>>
>> If the above sounds along the right lines here are some questions off
>> the top of my head:
>> - Does a randommap for blocks still make sense when I no longer have
>> total freedom over where my next I/O goes?
>> - What happens when there are more reads than writes? What does it
>> mean to have a sequential "only reads" job?
>> - Following on from the above, can reads force a switch to a new zone?
>> - Do you have more than one write zone open at any one time?
>>
>> I'm not offering to implement anything but I'm just curious if there's
>> some sort of overall design that isn't too complicated to use.
>>
>> > 5. Bug report: --random_percentage sequential behaviour
>> > It seems that sequential IO is increasing but not sequential when
>> > using the --random_percentage option. Running the following FIO job:
>> > fio --name=3Drand_reads_seq_writes --ioengine=3Dlibaio --direct=3D1
>> > --exitall --thread --filename=3D/dev/sdf --runtime=3D30 --readwrite=3D=
randrw
>> > --iodepth=3D1 --percentage_random=3D100,0 --norandommap
>> > --output-format=3Dterse
>> > results in an even distribution of reads as expected and writes that
>> > are increasing but not sequential. Here's an example of writes that I
>>
>> Hmm not sure on this one - it would be nice to see the reads
>> interspersed with the writes - it could be each read seeks to a bigger
>> offset and then the write follows on from it sequentially.
>>
>> You might be better able to achieve your goal with independent jobs
>> tied together using flow
>>
>> (https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__fio.readthedocs.i=
o_en_latest_fio-5Fman.html-23cmdoption-2Darg-2Dflow&d=3DDwIBaQ&c=3DIGDlg0lD=
0b-nebmJJ0Kp8A&r=3DeNMOVQH16Aa4ThAFVwj-O7goG7k06cW3W6DO_yXnzSg&m=3D3A4x6YYo=
q8wPWyaE7AA1n70Jy5344M-RPOb9UqbzurA&s=3De4BaL3RyaD0KPq_axlVnysn7VvtjQ51XHIb=
NHwGGAK8&e=3D
>> ).
>>
>> > am seeing running this job:
>> > First 20 writes (sector, sectors written)
>> > [(0, 8), (3048, 8), (3056, 8), (3064, 8), (3072, 8), (3080, 8), (3088,
>> > 8), (6408, 8), (7000, 8), (13440, 8), (13496, 8), (13648, 8), (13768,
>> > 8), (13920, 8), (14288, 8), (14400, 8), (16376, 8), (18824, 8),
>> > (18936, 8), (19832, 8)]
>> > Here is my environment information:
>> > # cat /etc/centos-release
>> > CentOS Linux release 7.3.1611 (Core)
>> > # uname -r
>> > 3.10.0-514.21.1.el7.x86_64
>> > I saw the same behaviour on fio-3.2 and fio-3.2-81-g3e262 which was
>> > the newest version I could see as of today.
>> >
>> > So I see some bursts of sequential writes, but mostly it seems to be
>> > skipping around.
>> >
>> > I've attached a python 3.6 script that will run this workload and
>> > collect the IO information using blktrace/blkparse. To run the script,
>> > use the -h flag to see usage, but at a minimum you'll need to give the
>> > device handle to run on as the first argument.
>> >
>> > Thank you for your help, and let me know if you decide to add these
>> > features or if I need to provide any further information.
>>
>> --
>> Sitsofe |
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__sucs.org_-7Esits_&=
d=3DDwIBaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DeNMOVQH16Aa4ThAFVwj-O7goG7k06cW3W=
6DO_yXnzSg&m=3D3A4x6YYoq8wPWyaE7AA1n70Jy5344M-RPOb9UqbzurA&s=3D8tMsxQjD_CtE=
ZC28bh0sBO41uV9av9VPjO4dIy4lkAk&e=3D
>
>
