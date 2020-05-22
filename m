Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgEVJBb (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 May 2020 05:01:31 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3727BC061A0E
        for <fio@vger.kernel.org>; Fri, 22 May 2020 02:01:31 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id m6so9980650ilq.7
        for <fio@vger.kernel.org>; Fri, 22 May 2020 02:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAF6DVKOmDjTecr4ebiHZWD_5=-8kb4nwHC40tzq71ufFgiWJLg@mail.gmail.com>
 <CALjAwxjN02WtDu5xSV-AAD_9v-VDUwGEXYbVKy_jU5ObwbmQLg@mail.gmail.com>
 <CAF6DVKMMkjrZrEKr4yb6P+MrETKNh9-QHA=MA7sP-=tKPOOMyw@mail.gmail.com> <CAF6DVKPmyhrSJr4hFrBmYHrNTuETQm2b+2JAhUza7su_R7buwQ@mail.gmail.com>
In-Reply-To: <CAF6DVKPmyhrSJr4hFrBmYHrNTuETQm2b+2JAhUza7su_R7buwQ@mail.gmail.com>
From: Debraj Manna <subharaj.manna@gmail.com>
Date: Fri, 22 May 2020 14:31:04 +0530
Message-ID: <CAF6DVKPM3ZTZoWumbEgy3A2wi9kHo3kbC7TGYa2i=EY-HkcLig@mail.gmail.com>
Subject: Re: fio reporting high value of read iops at iodepth 1
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

My below email to the group failed because of the presence of HTML it
seems. Re-sending again with plain text format.

Hi Sitsofe,

Few queries for my understanding

1. Is there a way to bypass the disk/buffer cache while doing a fio
test? I know about direct=1 but that does not always bypass a cache.

 2. "Maybe do I/O on a much larger file to see if the variation
between runs goes down" - Will the file size be in some ratio of my
system configuration?. For example if I am having a RAM of 32 GB then
should I use a file of size of 64 GB or there are some other
recommended best practices?


On Sat, May 16, 2020 at 10:03 PM Debraj Manna <subharaj.manna@gmail.com> wrote:
>
> I had to install libaio-dev. Now it is fine.
>
> On Sat, May 16, 2020 at 9:58 PM Debraj Manna <subharaj.manna@gmail.com> wrote:
> >
> > Thanks for replying.
> >
> > I tried building fio 3.19 as per the link you shared.
> >
> > I did not see any error during the build process.
> >
> > ubuntu@vrni-proxy:~$ fio --version
> > fio-3.19
> >
> > But on trying to use fio I am getting the below error
> >
> > ubuntu@vrni-proxy:~$ suf=`head /dev/urandom | tr -dc A-Za-z0-9 | head
> > -c 13 ; echo ''` && file="/var/lib/ubuntu/fio-$suf" && echo $file &&
> > fio --filename=$file --direct=1  --ioengine=libaio --bs=4K
> > --name=bw-test --rw=randread --iodepth=1 --size=200M ; rm -f $file
> > /var/lib/ubuntu/fio-V9wrfA2MyjvVL
> > fio: engine libaio not loadable
> > fio: engine libaio not loadable
> > fio: failed to load engine
> >
> > On Sat, May 16, 2020 at 8:59 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > >
> > > Hi Debraj,
> > >
> > > On Sat, 16 May 2020 at 16:05, Debraj Manna <subharaj.manna@gmail.com> wrote:
> > > >
> > > > HI
> > > >
> > > > I joined the mailing list yesterday. I am reposting the below query as
> > > > I don't see my yesterday's post in the mailing list archive.
> > > >
> > > > I am using fio-2.2.10 on Ubuntu 16.04.
> > >
> > > Just briefly I'm afraid we (upstream) don't support older versions of
> > > fio. We're all the way up to fio 3.19 at the time of writing (see
> > > https://github.com/axboe/fio/releases ). I'll keep looking but you
> > > might not get much more of a response... It's worth noting that it's
> > > fairly easy to build new versions by hand though:
> > > https://github.com/axboe/fio/blob/fio-3.19/README#L132 .
> > >
> > > > In one of my setup I am observing high value of read iops at io-depth
> > > > = 1.  One run is reporting iops=11418, another run iops=33507 and
> > > > iops=44329This does not seem to be correct. Below are the run results.
> > > > Can someone let me know what is going wrong and if I am hitting some
> > > > known issue in fio.
> > >
> > > In all probability it's unlikely to be fio in this case - your jobs is
> > > only running for 4 seconds and the region you're doing I/O over is
> > > small so any number of things could perturb the iops you get (another
> > > process stealing CPU time, the state of your disks cache, how your
> > > filesystem chose to layout the file, whether the filesystem chose to
> > > do some writeback at that point, what the kernel I/O scheduler chose
> > > to do with the sequence of I/O it was sent etc). For some reason your
> > > underlying disk seems less busier in the first run (util=87.75%) than
> > > the second run (util=62.83%) which hints at outside interference (e.g.
> > > another process doing I/O the same filesystem or even the kernel doing
> > > swap on a different partition of the same disk).
> > >
> > > Given so much has changed since your version I couldn't say if you are
> > > also hitting some fixed bug but as previously mentioned it seems
> > > unlikely. Maybe do I/O on a much larger file to see if the variation
> > > between runs goes down? Good luck!
> > >
> > > > RUN 1
> > > >
> > > > ubuntu@vrni-proxy-release:/var/log/foundationdb$ suf=`head
> > > > /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''` &&
> > > > file="/var/lib/ubuntu/fio-$suf" && echo $file && fio --filename=$file
> > > > --direct=1  --ioengine=libaio --bs=4K  --name=bw-test --rw=randread
> > > > --iodepth=1 --size=200M ; rm -f $file
> > > > /var/lib/ubuntu/fio-oPHRC8lfJujNk
> > > > bw-test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> > > > fio-2.2.10
> > > > Starting 1 process
> > > > bw-test: Laying out IO file(s) (1 file(s) / 200MB)
> > > > Jobs: 1 (f=1): [r(1)] [100.0% done] [49132KB/0KB/0KB /s] [12.3K/0/0
> > > > iops] [eta 00m:00s]
> > > > bw-test: (groupid=0, jobs=1): err= 0: pid=48549: Fri May 15 18:42:08 2020
> > > >   read : io=204800KB, bw=45674KB/s, iops=11418, runt=  4484msec
> > > >     slat (usec): min=4, max=258, avg= 5.53, stdev= 2.20
> > > >     clat (usec): min=0, max=22304, avg=81.16, stdev=230.44
> > > >      lat (usec): min=17, max=22309, avg=86.78, stdev=230.46
> > > >     clat percentiles (usec):
> > > >      |  1.00th=[   14],  5.00th=[   14], 10.00th=[   15], 20.00th=[   16],
> > > >      | 30.00th=[   19], 40.00th=[   19], 50.00th=[   20], 60.00th=[   20],
> > > >      | 70.00th=[   21], 80.00th=[   25], 90.00th=[  266], 95.00th=[  286],
> > > >      | 99.00th=[  532], 99.50th=[ 1400], 99.90th=[ 2832], 99.95th=[ 3088],
> > > >      | 99.99th=[ 5280]
> > > >     bw (KB  /s): min=33760, max=51584, per=98.18%, avg=44842.00, stdev=6783.12
> > > >     lat (usec) : 2=0.04%, 4=0.01%, 10=0.02%, 20=45.62%, 50=35.21%
> > > >     lat (usec) : 100=0.15%, 250=2.24%, 500=15.67%, 750=0.25%, 1000=0.16%
> > > >     lat (msec) : 2=0.28%, 4=0.34%, 10=0.01%, 50=0.01%
> > > >   cpu          : usr=0.98%, sys=10.53%, ctx=51195, majf=0, minf=10
> > > >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> > > >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> > > >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> > > >      issued    : total=r=51200/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
> > > >      latency   : target=0, window=0, percentile=100.00%, depth=1
> > > >
> > > > Run status group 0 (all jobs):
> > > >    READ: io=204800KB, aggrb=45673KB/s, minb=45673KB/s, maxb=45673KB/s,
> > > > mint=4484msec, maxt=4484msec
> > > >
> > > > Disk stats (read/write):
> > > >     dm-6: ios=48310/2, merge=0/0, ticks=3944/0, in_queue=3972,
> > > > util=90.95%, aggrios=51200/40, aggrmerge=0/205, aggrticks=4048/0,
> > > > aggrin_queue=4048, aggrutil=87.75%
> > > >   sda: ios=51200/40, merge=0/205, ticks=4048/0, in_queue=4048, util=87.75%
> > > >
> > > > RUN 2
> > > >
> > > > ubuntu@vrni-proxy-release:/var/log/foundationdb$ suf=`head
> > > > /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''` &&
> > > > file="/var/lib/ubuntu/fio-$suf" && echo $file && fio --filename=$file
> > > > --direct=1  --ioengine=libaio --bs=4K  --name=bw-test --rw=randread
> > > > --iodepth=1 --size=200M ; rm -f $file
> > > > /var/lib/ubuntu/fio-PipAwOU94ybHL
> > > > bw-test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
> > > > fio-2.2.10
> > > > Starting 1 process
> > > > bw-test: Laying out IO file(s) (1 file(s) / 200MB)
> > > > Jobs: 1 (f=1)
> > > > bw-test: (groupid=0, jobs=1): err= 0: pid=48575: Fri May 15 18:42:15 2020
> > > >   read : io=204800KB, bw=134031KB/s, iops=33507, runt=  1528msec
> > > >     slat (usec): min=4, max=19840, avg= 5.38, stdev=87.66
> > > >     clat (usec): min=1, max=3589, avg=23.64, stdev=89.84
> > > >      lat (usec): min=17, max=19863, avg=29.07, stdev=125.52
> > > >     clat percentiles (usec):
> > > >      |  1.00th=[   14],  5.00th=[   15], 10.00th=[   15], 20.00th=[   15],
> > > >      | 30.00th=[   15], 40.00th=[   15], 50.00th=[   16], 60.00th=[   16],
> > > >      | 70.00th=[   16], 80.00th=[   16], 90.00th=[   17], 95.00th=[   17],
> > > >      | 99.00th=[  286], 99.50th=[  318], 99.90th=[ 1576], 99.95th=[ 2352],
> > > >      | 99.99th=[ 3056]
> > > >     bw (KB  /s): min=119592, max=143792, per=99.48%, avg=133333.33,
> > > > stdev=12429.48
> > > >     lat (usec) : 2=0.01%, 10=0.01%, 20=97.54%, 50=0.47%, 100=0.09%
> > > >     lat (usec) : 250=0.05%, 500=1.61%, 750=0.06%, 1000=0.02%
> > > >     lat (msec) : 2=0.06%, 4=0.08%
> > > >   cpu          : usr=1.83%, sys=31.17%, ctx=51196, majf=0, minf=11
> > > >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> > > >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> > > >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> > > >      issued    : total=r=51200/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
> > > >      latency   : target=0, window=0, percentile=100.00%, depth=1
> > > >
> > > > Run status group 0 (all jobs):
> > > >    READ: io=204800KB, aggrb=134031KB/s, minb=134031KB/s,
> > > > maxb=134031KB/s, mint=1528msec, maxt=1528msec
> > > >
> > > > Disk stats (read/write):
> > > >     dm-6: ios=43347/0, merge=0/0, ticks=1080/0, in_queue=1084,
> > > > util=75.80%, aggrios=51200/10, aggrmerge=0/6, aggrticks=1048/0,
> > > > aggrin_queue=1048, aggrutil=62.83%
> > > >   sda: ios=51200/10, merge=0/6, ticks=1048/0, in_queue=1048, util=62.83%
> > >
> > > --
> > > Sitsofe | http://sucs.org/~sits/

