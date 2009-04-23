Return-Path: <worleys@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20090423055044.GI4593@kernel.dk>
References: <20090422132257.GR4593@kernel.dk>
	 <f3177b9e0904221332w887ef28l7e25959fb24892c8@mail.gmail.com>
	 <20090423055044.GI4593@kernel.dk>
Date: Thu, 23 Apr 2009 09:48:27 -0600
Message-ID: <f3177b9e0904230848g57b546bco735131128ce0a786@mail.gmail.com>
Subject: Re: request for job files
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,

Thanks for the tips!

One other question, in the first case where I use only one group with
multiple file names, where I'm summing 10% of the disks sizes, is fio
going to evenly distribute that size among the disks/files?  That
seems to be the case, but I'm not sure.

Thanks,

Chris
On Wed, Apr 22, 2009 at 11:50 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Apr 22 2009, Chris Worley wrote:
>> On Wed, Apr 22, 2009 at 7:22 AM, Jens Axboe <jens.axboe@oracle.com> wrot=
e:
>> > Hi,
>> >
>> > The sample job files shipped with fio are (generally) pretty weak, and
>> > I'd really love for the selection to be better. In my experience, that
>> > is the first place you look when trying out something like fio. It
>> > really helps you getting a (previously) unknown job format going
>> > quickly.
>> >
>> > So if any of you have "interesting" job files that you use for testing
>> > or performance analysis, please do send them to me so I can include th=
em
>> > with fio.
>>
>> Jens,
>>
>> I normally use scripts to run I/O benchmarks, and pretty much use fio
>> exclusively.
>>
>> Hopefully, in sharing the scripts, you can see usage, and feeback
>> anything I may be doing wrong.
>>
>> In one incarnation, I put all the devices to be tested on the script's
>> command line, then concatenate a fio-ready list of these devices along
>> with a sum of 10% of all the disks with:
>>
>> =A0 =A0 filesize=3D0
>> =A0 =A0 fiolist=3D""
>> =A0 =A0 for i in $*
>> =A0 =A0 do fiolist=3D$fiolist" --filename=3D"$i
>> =A0 =A0 =A0 =A0t=3D`basename $i`
>> =A0 =A0 =A0 =A0let filesize=3D$filesize+`cat /proc/partitions | grep $t =
=A0| awk
>> '{ printf "%d\n", $3*1024/10 }'`
>> =A0 =A0 done
>>
>> Rather than a "job file", In this case I do everything on the command
>> line for power of 2 block sizes from 1MB down to 512B:
>>
>> =A0 for i in 1m 512k 256k 128k 64k 32k 16k 8k 4k 2k 1k 512
>> =A0 do
>> =A0 =A0 for k in 0 25 50 75 100
>> =A0 =A0 do
>> =A0 =A0 =A0 fio =A0--rw=3Drandrw --bs=3D$i --rwmixread=3D$k --numjobs=3D=
32
>> --iodepth=3D64 --sync=3D0 --direct=3D1 --randrepeat=3D0 --softrandommap=
=3D1 \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 --ioengine=3Dlibaio $fiolist --name=3Dtest -=
-loops=3D10000
>> --size=3D$filesize =A0--runtime=3D$runtime
>> =A0 =A0 done
>> =A0 done
>>
>> So the above "fiolist" is going to look like "--filename=3D/dev/sda
>> --filename=3D/dev/sdb", and the "filesize" is going to be the sum of 10%
>> of each disks size. =A0I only use this with disks of the same size, and
>> assume that fio will exercise 10% of each disk. =A0That assumption seems
>> to pan out in the resulting data, but I've never traced the code to
>> verify that this is what it will do.
>>
>> Then I moved to a process-pinning strategy that has some number of
>> pinned fio threads running per disk. =A0I still calculate the
>> "filesize", but just uses 10% of one disk, and assume they are all the
>> same. =A0 Much of the affinity settings have to do with specific bus-CPU
>> affinity, but for a simple example, lets say I just round-robin the
>> files on the command line to the available processors, and create
>> arrays "files" and "pl" consisting of block devices and processor
>> numbers:
>>
>> totproc=3D`cat /proc/cpuinfo | grep processor | wc -l`
>> p=3D0
>> for i in $*
>> do
>> =A0 =A0 files[$p]=3D"filename=3D"$i
>> =A0 =A0 pl[$p]=3D$p
>> =A0 =A0 let p=3D$p+1
>> =A0 =A0 if [ $p -eq $totproc ]
>> =A0 =A0 then break
>> =A0 =A0 fi
>> done
>> let totproc=3D$p-1
>>
>> Then generate "job files" and run fio with:
>>
>> =A0 for i in 1m 512k 256k 128k 64k 32k 16k 8k 4k 2k 1k 512
>> =A0 do
>> =A0 =A0 for k in 0 25 50 75 100
>> =A0 =A0 do =A0echo "" >fio-rand-script.$$
>> =A0 =A0 =A0 for p in `seq 0 $totproc`
>> =A0 =A0 =A0 do
>> =A0 =A0 =A0 =A0 =A0echo -e
>> "[cpu${p}]\ncpus_allowed=3D${pl[$p]}\nnumjobs=3D$jobsperproc\n${files[$p=
]}\ngroup_reporting\nbs=3D$i
>> \nrw=3Drandrw\nrwmixread=3D$k \nsoftrandommap=3D1\nruntime=3D$runtime
>> \nsync=3D0\ndirect=3D1\niodepth=3D64\nioengine=3Dlibaio\nloops=3D10000\n=
exitall\nsize=3D$filesi
>> e \n" >>fio-rand-script.$$
>> =A0 =A0 =A0 done
>> =A0 =A0 =A0 fio fio-rand-script.$$
>> =A0 =A0 done
>> =A0 done
>>
>> The scripts look like:
>>
>> # cat fio-rand-script.8625
>> [cpu0]
>> cpus_allowed=3D0
>> numjobs=3D8
>> =A0filename=3D/dev/sda
>> group_reporting
>> bs=3D4k
>> rw=3Drandrw
>> rwmixread=3D0
>> softrandommap=3D1
>> runtime=3D600
>> sync=3D0
>> direct=3D1
>> iodepth=3D64
>> ioengine=3Dlibaio
>> loops=3D10000
>> exitall
>> size=3D16091503001
>>
>> [cpu1]
>> cpus_allowed=3D1
>> numjobs=3D8
>> =A0filename=3D/dev/sdb
>> group_reporting
>> bs=3D4k
>> rw=3Drandrw
>> rwmixread=3D0
>> softrandommap=3D1
>> runtime=3D600
>> sync=3D0
>> direct=3D1
>> iodepth=3D64
>> ioengine=3Dlibaio
>> loops=3D10000
>> exitall
>> size=3D16091503001
>>
>> [cpu2]
>> cpus_allowed=3D2
>> numjobs=3D8
>> =A0filename=3D/dev/sdc
>> group_reporting
>> bs=3D4k
>> rw=3Drandrw
>> rwmixread=3D0
>> softrandommap=3D1
>> runtime=3D600
>> sync=3D0
>> direct=3D1
>> iodepth=3D64
>> ioengine=3Dlibaio
>> loops=3D10000
>> exitall
>> size=3D16091503001
>>
>> [cpu3]
>> cpus_allowed=3D3
>> numjobs=3D8
>> =A0filename=3D/dev/sdd
>> group_reporting
>> bs=3D4k
>> rw=3Drandrw
>> rwmixread=3D0
>> softrandommap=3D1
>> runtime=3D600
>> sync=3D0
>> direct=3D1
>> iodepth=3D64
>> ioengine=3Dlibaio
>> loops=3D10000
>> exitall
>> size=3D16091503001
>>
>> I would sure rather do that on the command line and not create a file,
>> but the groups never worked out for me on the command line... hints
>> would be appreciated.
>
> This is good stuff! Just a quick comment that may improve your situation
> - you do know that you can include environment variables job files? Say
> for this a sample section:
>
> [cpu3]
> cpus_allowed=3D3
> numjobs=3D8
> filename=3D${CPU3FN}
> group_reporting
> bs=3D4k
> rw=3Drandrw
> rwmixread=3D0
> softrandommap=3D1
> runtime=3D600
> sync=3D0
> direct=3D1
> iodepth=3D64
> ioengine=3Dlibaio
> loops=3D10000
> exitall
> size=3D${CPU3SZ}
>
> (if those two are the only unique ones) and set the CPU3FN and CPU3SZ
> environment variables before running fio ala:
>
> $ CPU3FN=3D/dev/sdd CPU3SZ=3D16091503001 fio my-job-file
>
> repeat for the extra ones you need. It also looks like you can put a lot
> of that into the [global] section, which applies to all your jobs in the
> job file.
>
> As to doing it on the command line, you should be able to just set the
> shared parameters first, then start continue
>
> fio --bs=3D4k ... --name=3Dcpu3 --filename=3D/dev/sdd --size=3D1609150300=
1
> --name=3Dcpu2 --filename=3D/dev/sdc --size=3Dxxxx
>
> and so on. Does that not work properly? I must say that I never use the
> command line myself, I always write a job file. Matter of habbit, I
> guess. Anyway, if we condense your job file a bit, it ends up like this:
>
> [global]
> numjobs=3D8
> group_reporting
> bs=3D4k
> rwmixread=3D0
> rw=3Drandrw
> runtime=3D600
> softrandommap=3D1
> sync=3D0
> direct=3D1
> iodepth=3D64
> ioengine=3Dlibaio
> loops=3D10000
> exitall
>
> [cpu0]
> cpus_allowed=3D0
> filename=3D/dev/sda
> size=3D16091503001
>
> [cpu1]
> cpus_allowed=3D1
> =A0filename=3D/dev/sdb
> size=3D16091503001
>
> [cpu2]
> cpus_allowed=3D2
> =A0filename=3D/dev/sdc
> size=3D16091503001
>
> [cpu3]
> cpus_allowed=3D3
> filename=3D/dev/sdd
> size=3D16091503001
>
> Running that through fio --showcmd, it gives us:
>
> fio --numjobs=3D8 --group_reporting --bs=3D4k --rwmixread=3D0 --rw=3Drand=
rw
> --runtime=3D600 --softrandommap=3D1 --sync=3D0 --direct=3D1 --iodepth=3D6=
4
> --ioengine=3Dlibaio --loops=3D10000 --exitall --name=3Dcpu0
> --filename=3D/dev/sda --cpus_allowed=3D0 --size=3D16091503001 --name=3Dcp=
u1
> --filename=3D/dev/sdb --cpus_allowed=3D1 --size=3D16091503001 --name=3Dcp=
u2
> --filename=3D/dev/sdc --cpus_allowed=3D2 --size=3D16091503001 --name=3Dcp=
u3
> --filename=3D/dev/sdd --cpus_allowed=3D3 --size=3D16091503001
>
> And as a final note, using rw=3Drandrw with rwmixread=3D0, then you shoul=
d
> probably just use rw=3Drandwrite instead :-)
>
> --
> Jens Axboe
>
>

