Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:37355 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754737AbdL2LZO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Dec 2017 06:25:14 -0500
Received: by mail-vk0-f48.google.com with SMTP id n2so20706253vkf.4
        for <fio@vger.kernel.org>; Fri, 29 Dec 2017 03:25:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAODBMz=eP9o0j_DeBtEzeULv49nSPCbMAjThrno8m8ns2ELdGg@mail.gmail.com>
References: <CAODBMz=eP9o0j_DeBtEzeULv49nSPCbMAjThrno8m8ns2ELdGg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Dec 2017 11:24:42 +0000
Message-ID: <CALjAwxiMLDOXm5bM7PKyOr1Z8y4P+AkP_ovZ3HZ6fdHOOsd=ZA@mail.gmail.com>
Subject: Re: FLEX feature requests
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Phillip Chen <phillip.a.chen@seagate.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Philip,

On 15 December 2017 at 21:29, Phillip Chen <phillip.a.chen@seagate.com> wrote:
> Hello again,
> I've been working on getting FIO running on a FLEX drive and I've been
> accumulating a laundry list of features that would be nice to have and
> I've run into one that is necessary. I also found one bug while
> experimenting with various FIO options that I'll include in the list.
> Here are the changes I'd appreciate seeing starting with the most
> desired. I've included
>
> 1. --ignore_device_size
> The current FLEX protocol maps storage to sectors/bytes greater than
> the reported capacity of the drive. I'd like to run FIO on these out
> of bounds sectors, but right now I can't because I get the error "you
> need to specify valid offset=". Would it be possible to add a flag
> that would let users run IO outside of the reported device capacity?
> Without this I believe that FIO cannot run on the SMR portions of any
> FLEX drive.

Perhaps a "--force_detected_size=int" might be simpler because there
are all sorts of things that look at the file size and make some sort
of calculation based upon it (e.g. offset/size percentages)...

> 2. --readwrite=write_pointer_randwrite:offset,io_size:offset,io_size...
> In write pointer zones, all writes must be at the write pointer, so
> random IO is not possible. However, it would be useful to run
> random-like workloads in which random zones are written to
> sequentially. This would be very similar to the
> random_distribution=zoned_abs argument except for instead of writing
> randomly within a zone, it would write to a specific offset and then
> increment that offset by the amount written, but would stop writing to
> that zone entirely once the incrementing offset reached the end of the
> zone. So if I had 3 zones I wanted to write to that were each 128mb
> long, I could specify something like
> --readwrite=write_pointer_randwrite:0,128m:128m,128m:256m,128m. It
> might also make sense to add distribution percentages like in the
> zoned_abs argument, although I'm not entirely sure what you would do
> with those percentages when a zone got fully written and thus could
> not be picked anymore.
>
> 3. --readwrite=write_pointer_randrw:offset,io_size:offset,io_size...
> Additionally, in write pointer zones, all reads must be below the
> write pointer, so random read IO is restricted. This is why I
> requested the random_distribution:zoned_abs argument, because that can
> be used quite well for issuing random reads to write pointer zones.
> However, I would like to read and write "randomly" to write pointer
> zones so that I can more easily control the read/write ratio as well
> as being able to read data that was written during the same FIO run
> (currently I can use random_distribution:zoned_abs to read randomly
> from the beginning of the zone up to the write pointer at the
> beginning of the FIO run, but I cannot read further after FIO
> increments the write pointer). This workload would write randomly as
> described above, and read between the offset and the incremented
> offset. So before any writes went to the zone, you wouldn't be able to
> read randomly from that zone.
>
> 4. Automatic zone detection with the above two readwrite modes
> I believe this would be quite a bit of work, but it would nice to be
> able to specify the previous two workload types without specifically
> specifying the zones. Instead the user could specify offset and size
> as normal, and additionally specify the zone number (perhaps through a
> new option or perhaps with an extended syntax in the readwrite
> option), and FIO would get the zones and randomly perform write
> pointer legal IO within all the zones specified by the user using
> offset and size. And if the user specified a drive area that contains
> non-write pointer zones, FIO would just do normal IO. It might also be
> possible for me to help with the implementation of this, if that would
> be something you'd be interested in.

I can't help wondering whether the above requires a special "mode" (or
profile) of it's own. It sounds like:
- There needs to be a semi-elaborate zone map. It needs to be possible
to specify the zone map either using a trivial algorithm (e.g. make a
zone every other 128MBytes) or statically (here's a string that
represents the mapping/here's a function that will return a mapping)
- It must be possible to specify the type of a zone (this zone is for
reading/writing/trimming or some combination of these).
- Zones must be able to change their type as a job runs (after a write
zone starts being used it could be useful if it could become a
read/write zone, after it's full only a read zone etc).
- There needs to be control of the next zone picked (e.g. sequential/random).
- A write zone needs a high water write mark to allow write
continuation or to ensure reads from it are below a watermark.
- Certain behaviours in this mode would be blocked (no random writing
to a zone).

If the above sounds along the right lines here are some questions off
the top of my head:
- Does a randommap for blocks still make sense when I no longer have
total freedom over where my next I/O goes?
- What happens when there are more reads than writes? What does it
mean to have a sequential "only reads" job?
- Following on from the above, can reads force a switch to a new zone?
- Do you have more than one write zone open at any one time?

I'm not offering to implement anything but I'm just curious if there's
some sort of overall design that isn't too complicated to use.

> 5. Bug report: --random_percentage sequential behaviour
> It seems that sequential IO is increasing but not sequential when
> using the --random_percentage option. Running the following FIO job:
> fio --name=rand_reads_seq_writes --ioengine=libaio --direct=1
> --exitall --thread --filename=/dev/sdf --runtime=30 --readwrite=randrw
> --iodepth=1 --percentage_random=100,0 --norandommap
> --output-format=terse
> results in an even distribution of reads as expected and writes that
> are increasing but not sequential. Here's an example of writes that I

Hmm not sure on this one - it would be nice to see the reads
interspersed with the writes - it could be each read seeks to a bigger
offset and then the write follows on from it sequentially.

You might be better able to achieve your goal with independent jobs
tied together using flow
(http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-flow
).

> am seeing running this job:
> First 20 writes (sector, sectors written)
> [(0, 8), (3048, 8), (3056, 8), (3064, 8), (3072, 8), (3080, 8), (3088,
> 8), (6408, 8), (7000, 8), (13440, 8), (13496, 8), (13648, 8), (13768,
> 8), (13920, 8), (14288, 8), (14400, 8), (16376, 8), (18824, 8),
> (18936, 8), (19832, 8)]
> Here is my environment information:
> # cat /etc/centos-release
> CentOS Linux release 7.3.1611 (Core)
> # uname -r
> 3.10.0-514.21.1.el7.x86_64
> I saw the same behaviour on fio-3.2 and fio-3.2-81-g3e262 which was
> the newest version I could see as of today.
>
> So I see some bursts of sequential writes, but mostly it seems to be
> skipping around.
>
> I've attached a python 3.6 script that will run this workload and
> collect the IO information using blktrace/blkparse. To run the script,
> use the -h flag to see usage, but at a minimum you'll need to give the
> device handle to run on as the first argument.
>
> Thank you for your help, and let me know if you decide to add these
> features or if I need to provide any further information.

-- 
Sitsofe | http://sucs.org/~sits/
