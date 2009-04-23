Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:41975 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZDWFuy (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2009 01:50:54 -0400
Date: Thu, 23 Apr 2009 07:50:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: request for job files
Message-ID: <20090423055044.GI4593@kernel.dk>
References: <20090422132257.GR4593@kernel.dk> <f3177b9e0904221332w887ef28l7e25959fb24892c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3177b9e0904221332w887ef28l7e25959fb24892c8@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Wed, Apr 22 2009, Chris Worley wrote:
> On Wed, Apr 22, 2009 at 7:22 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Hi,
> >
> > The sample job files shipped with fio are (generally) pretty weak, and
> > I'd really love for the selection to be better. In my experience, that
> > is the first place you look when trying out something like fio. It
> > really helps you getting a (previously) unknown job format going
> > quickly.
> >
> > So if any of you have "interesting" job files that you use for testing
> > or performance analysis, please do send them to me so I can include them
> > with fio.
> 
> Jens,
> 
> I normally use scripts to run I/O benchmarks, and pretty much use fio
> exclusively.
> 
> Hopefully, in sharing the scripts, you can see usage, and feeback
> anything I may be doing wrong.
> 
> In one incarnation, I put all the devices to be tested on the script's
> command line, then concatenate a fio-ready list of these devices along
> with a sum of 10% of all the disks with:
> 
>     filesize=0
>     fiolist=""
>     for i in $*
>     do fiolist=$fiolist" --filename="$i
>        t=`basename $i`
>        let filesize=$filesize+`cat /proc/partitions | grep $t  | awk
> '{ printf "%d\n", $3*1024/10 }'`
>     done
> 
> Rather than a "job file", In this case I do everything on the command
> line for power of 2 block sizes from 1MB down to 512B:
> 
>   for i in 1m 512k 256k 128k 64k 32k 16k 8k 4k 2k 1k 512
>   do
>     for k in 0 25 50 75 100
>     do
>       fio  --rw=randrw --bs=$i --rwmixread=$k --numjobs=32
> --iodepth=64 --sync=0 --direct=1 --randrepeat=0 --softrandommap=1 \
>               --ioengine=libaio $fiolist --name=test --loops=10000
> --size=$filesize  --runtime=$runtime
>     done
>   done
> 
> So the above "fiolist" is going to look like "--filename=/dev/sda
> --filename=/dev/sdb", and the "filesize" is going to be the sum of 10%
> of each disks size.  I only use this with disks of the same size, and
> assume that fio will exercise 10% of each disk.  That assumption seems
> to pan out in the resulting data, but I've never traced the code to
> verify that this is what it will do.
> 
> Then I moved to a process-pinning strategy that has some number of
> pinned fio threads running per disk.  I still calculate the
> "filesize", but just uses 10% of one disk, and assume they are all the
> same.   Much of the affinity settings have to do with specific bus-CPU
> affinity, but for a simple example, lets say I just round-robin the
> files on the command line to the available processors, and create
> arrays "files" and "pl" consisting of block devices and processor
> numbers:
> 
> totproc=`cat /proc/cpuinfo | grep processor | wc -l`
> p=0
> for i in $*
> do
>     files[$p]="filename="$i
>     pl[$p]=$p
>     let p=$p+1
>     if [ $p -eq $totproc ]
>     then break
>     fi
> done
> let totproc=$p-1
> 
> Then generate "job files" and run fio with:
> 
>   for i in 1m 512k 256k 128k 64k 32k 16k 8k 4k 2k 1k 512
>   do
>     for k in 0 25 50 75 100
>     do  echo "" >fio-rand-script.$$
>       for p in `seq 0 $totproc`
>       do
>          echo -e
> "[cpu${p}]\ncpus_allowed=${pl[$p]}\nnumjobs=$jobsperproc\n${files[$p]}\ngroup_reporting\nbs=$i
> \nrw=randrw\nrwmixread=$k \nsoftrandommap=1\nruntime=$runtime
> \nsync=0\ndirect=1\niodepth=64\nioengine=libaio\nloops=10000\nexitall\nsize=$filesi
> e \n" >>fio-rand-script.$$
>       done
>       fio fio-rand-script.$$
>     done
>   done
> 
> The scripts look like:
> 
> # cat fio-rand-script.8625
> [cpu0]
> cpus_allowed=0
> numjobs=8
>  filename=/dev/sda
> group_reporting
> bs=4k
> rw=randrw
> rwmixread=0
> softrandommap=1
> runtime=600
> sync=0
> direct=1
> iodepth=64
> ioengine=libaio
> loops=10000
> exitall
> size=16091503001
> 
> [cpu1]
> cpus_allowed=1
> numjobs=8
>  filename=/dev/sdb
> group_reporting
> bs=4k
> rw=randrw
> rwmixread=0
> softrandommap=1
> runtime=600
> sync=0
> direct=1
> iodepth=64
> ioengine=libaio
> loops=10000
> exitall
> size=16091503001
> 
> [cpu2]
> cpus_allowed=2
> numjobs=8
>  filename=/dev/sdc
> group_reporting
> bs=4k
> rw=randrw
> rwmixread=0
> softrandommap=1
> runtime=600
> sync=0
> direct=1
> iodepth=64
> ioengine=libaio
> loops=10000
> exitall
> size=16091503001
> 
> [cpu3]
> cpus_allowed=3
> numjobs=8
>  filename=/dev/sdd
> group_reporting
> bs=4k
> rw=randrw
> rwmixread=0
> softrandommap=1
> runtime=600
> sync=0
> direct=1
> iodepth=64
> ioengine=libaio
> loops=10000
> exitall
> size=16091503001
> 
> I would sure rather do that on the command line and not create a file,
> but the groups never worked out for me on the command line... hints
> would be appreciated.

This is good stuff! Just a quick comment that may improve your situation
- you do know that you can include environment variables job files? Say
for this a sample section:

[cpu3]
cpus_allowed=3
numjobs=8
filename=${CPU3FN}
group_reporting
bs=4k
rw=randrw
rwmixread=0
softrandommap=1
runtime=600
sync=0
direct=1
iodepth=64
ioengine=libaio
loops=10000
exitall
size=${CPU3SZ}

(if those two are the only unique ones) and set the CPU3FN and CPU3SZ
environment variables before running fio ala:

$ CPU3FN=/dev/sdd CPU3SZ=16091503001 fio my-job-file

repeat for the extra ones you need. It also looks like you can put a lot
of that into the [global] section, which applies to all your jobs in the
job file.

As to doing it on the command line, you should be able to just set the
shared parameters first, then start continue

fio --bs=4k ... --name=cpu3 --filename=/dev/sdd --size=16091503001
--name=cpu2 --filename=/dev/sdc --size=xxxx

and so on. Does that not work properly? I must say that I never use the
command line myself, I always write a job file. Matter of habbit, I
guess. Anyway, if we condense your job file a bit, it ends up like this:

[global]
numjobs=8
group_reporting
bs=4k
rwmixread=0
rw=randrw
runtime=600
softrandommap=1
sync=0
direct=1
iodepth=64
ioengine=libaio
loops=10000
exitall

[cpu0]
cpus_allowed=0
filename=/dev/sda
size=16091503001

[cpu1]
cpus_allowed=1
 filename=/dev/sdb
size=16091503001

[cpu2]
cpus_allowed=2
 filename=/dev/sdc
size=16091503001

[cpu3]
cpus_allowed=3
filename=/dev/sdd
size=16091503001

Running that through fio --showcmd, it gives us:

fio --numjobs=8 --group_reporting --bs=4k --rwmixread=0 --rw=randrw
--runtime=600 --softrandommap=1 --sync=0 --direct=1 --iodepth=64
--ioengine=libaio --loops=10000 --exitall --name=cpu0
--filename=/dev/sda --cpus_allowed=0 --size=16091503001 --name=cpu1
--filename=/dev/sdb --cpus_allowed=1 --size=16091503001 --name=cpu2
--filename=/dev/sdc --cpus_allowed=2 --size=16091503001 --name=cpu3
--filename=/dev/sdd --cpus_allowed=3 --size=16091503001

And as a final note, using rw=randrw with rwmixread=0, then you should
probably just use rw=randwrite instead :-)

-- 
Jens Axboe

