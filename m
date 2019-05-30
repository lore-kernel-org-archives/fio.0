Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22785 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3RPf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 May 2019 13:15:35 -0400
From: Kris Davis <Kris.Davis@wdc.com>
Subject: Write operations stalled and split into 4KB sequential during
 blktrace replay containing trims
Date: Thu, 30 May 2019 17:15:32 +0000
Message-ID: <DM6PR04MB4697EECACF2FBDA63DF2996181180@DM6PR04MB4697.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Need help to understand and resolve a blktrace replay with trims issue.  So=
rry, this is a rather long note, but puzzling issue:=20

The problem:=20
If I replay a blktrace containing trims and writes, the trims occur at the =
expected timing and size, but all of the otherwise random writes are split =
into groups of 4KB sequential writes, and are intermittently delayed (for s=
econds) related to the trim operations.  Fio debug io,blktrace, and write_i=
ops_log indicates fio is replaying the operations correctly, but a blktrace=
 of the blktrace replay indicates operations writes do not happen as record=
ed by fio. =20


How to reproduce:=20
Building fio from head (with proposed patch https://github.com/axboe/fio/pu=
ll/777 to fix assert error when blktrace replay contains trims)
Note: I've tried this several times with various OS levels and fio revision=
 and mapping to one cpu - failures seem consistent

FIO command to produce the replay blktrace
----------------------------------------------------------------
Fio two jobs to perform 256MB Random Trims along with 256KB Random Writes a=
t the same 64MB BW rate, while collecting blktrace. =20
> blktrace -d /dev/nvme0n1 -o p2-trimwrites-gen=20
> fio --output=3D"p2-trimwrites-gen.out" --output-format=3Dnormal --direct=
=3D1 --runtime=3D30s --filename=3D"/dev/nvme0n1" --ioengine=3Dlibaio  --num=
a_cpu_nodes=3D0 --numa_mem_policy=3D"bind:0" --overwrite=3D1 --unified_rw_r=
eporting=3D0 --name=3D"Writes" --bs=3D256KB  --rate=3D64MB --rw=3Drandwrite=
 --write_iops_log=3D"p2-trimwrites-gen-writes" -name=3D"Trims" --bs=3D256MB=
 --rate=3D64MB --rw=3Drandtrim  --write_iops_log=3D"p2-trimwrites-gen-trim"
> blkparse -i p2-trimwrites-gen -o /dev/null -d p2-trimwrites-gen.bin

The actual write operations are restricted according to max_hw_sectors_kb t=
o 127, so the writes are split into 3 sequential operations: 248+248+16 blo=
cks as indicated in the block trace.
>   blkparse -i p2-trimwrites-gen -o p2-trimwrites-gen.blkparsed
>   grep ' Q ' p2-trimwrites-gen.blkparsed > p2-trimwrites-gen.blkparsedq  =
      # helps to see timing and sequence
>   egrep 'Q|C' p2-trimwrites-gen.blkparsed > p2-trimwrites-gen.blkparsedqc=
  # include completions - nothing surprising=20


Blktrace Replay
--------------------------------------------
When the original blktrace is replayed while collecting another blktrace to=
 check:
> blktrace -d /dev/nvme0n1 -o p2-fio-twreplay &
> fio --output=3D"p2-fio-twreplay.out" --output-format=3Dnormal --direct=3D=
1 --filename=3D"/dev/nvme0n1" --ioengine=3Dlibaio --numa_cpu_nodes=3D0 --nu=
ma_mem_policy=3D"bind:0" --overwrite=3D1 --unified_rw_reporting=3D0 --log_o=
ffset=3D1 --name=3D"TrimWrite" --write_iops_log=3D"p2-fio-twreplay"  --repl=
ay_redirect=3D/dev/nvme0n1 --read_iolog=3D"p2-trimwrites-gen.bin"
> blkparse -i p2-fio-twreplay -o p2-fio-twreplay.blkparsed
> grep ' Q ' p2-fio-twreplay.blkparsed > p2-fio-twreplay.blkparsedq   =20
> egrep 'Q|C' p2-fio-twreplay.blkparsed > p2-fio-twreplay.blkparsedqc

The fio io log indicates that fio is issuing operations with timing and siz=
es as indicated in original blktrace  (1st two deallocates occur quickly wh=
ile fio adjust to rate, then they occur 4 seconds apart, with intervening w=
rite operations).=20
2nd deallocate at 353 ms:=20
    279, 1, 1, 126976, 447737622528
    279, 1, 1, 8192, 447737749504
    283, 1, 1, 126976, 352846086144
    283, 1, 1, 126976, 352846213120
    283, 1, 1, 8192, 352846340096
    353, 1, 2, 268435456, 145492017152    <- 2nd deallocate
    355, 1, 1, 126976, 644440915968           <-=20
    355, 1, 1, 126976, 644441042944           <- Expected write operation s=
plit
    355, 1, 1, 8192, 644441169920               <-=20
    359, 1, 1, 126976, 289736491008
    359, 1, 1, 126976, 289736617984

The fio result statistics also seem to indicate that all is well, with trim=
 and write rates somewhat close to expectations:=20
TrimWrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D13167: Fri May 24 10:48=
:29 2019
  write: IOPS=3D674, BW=3D56.2MiB/s (58.9MB/s)(1920MiB/34156msec)
...
  trim: IOPS=3D0, BW=3D67.5MiB/s (70.7MB/s)(2304MiB/34156msec)


HOWEVER, the blktrace gathered during the replay indicates reality is diffe=
rent. =20
The deallocates occur with the expected timing and sizes, but the writes ar=
e delayed and occur as 4KB sequential writes, rather than the fio recorded =
124K+124k+8k writes
    259,0    6      136     0.133395386 13167  Q   D 398458880 + 524288 [fi=
o]                 <- first two deallocates (they are not waiting on comple=
tions, but I don't now here)
    259,0    6      140     0.273302506 13167  Q   D 284164096 + 524288 [fi=
o]
    259,0    6      144     5.211904696 10263  Q   W 1602560 + 8 [kworker/u=
97:0]         <- writes held off by something (prior deallocate has long ag=
o completed), and writes become 4KB sequentials
    259,0    6      147     5.211914136 10263  Q   W 1602568 + 8 [kworker/u=
97:0]
    259,0    6      150     5.211916318 10263  Q   W 1602576 + 8 [kworker/u=
97:0]
    259,0    6      153     5.211918422 10263  Q   W 1602584 + 8 [kworker/u=
97:0]
    259,0    6      156     5.211920629 10263  Q   W 1602592 + 8 [kworker/u=
97:0]
...
    259,0    4   154632     5.910154830 10263  Q   W 1563763184 + 8 [kworke=
r/u97:0]
    259,0    4   154636     5.910159723 10263  Q   W 1563763192 + 8 [kworke=
r/u97:0]
    259,0    6    87359     8.623207082 13167  Q   D 939524096 + 524288 [fi=
o]            <- latter deallocates also bundled (writes held up seemingly =
till all deallocates complete)=20
    259,0    6    87363    12.865571718 13167  Q   D 61341696 + 524288 [fio=
]
    259,0    6    87367    17.108236841 13167  Q   D 708313088 + 524288 [fi=
o]
    259,0   12        1    21.350936497 13167  Q   D 965214208 + 524288 [fi=
o]
    259,0   12        5    25.593485851 13167  Q   D 1087897600 + 524288 [f=
io]
    259,0   12        9    29.836349325 13167  Q   D 445120512 + 524288 [fi=
o]
    259,0    4   154640    30.955897677 10263  Q   W 1563776000 + 8 [kworke=
r/u97:0]   <- writes finish up without delays, again only as 4KB sequential=
 groups.
    259,0    4   154643    30.955909105 10263  Q   W 1563776008 + 8 [kworke=
r/u97:0]
    259,0    4   154646    30.955911370 10263  Q   W 1563776016 + 8 [kworke=
r/u97:0]


An fio debug=3Dblktrace,io didn't seem to show anything different than the =
io log.

It seems likely there is some interaction between fio and the kernel or dri=
ver, though it appears to only occur replay.

The write io problem DOES NOT occur if the trims are filtered out of the bl=
ktrace  (--replay_skip=3Dtrim).   Then the write operations rate and sizes =
occur as the expected 124K+124k+8k write groups

Any ideas?  I've also tried with centos 7.2, 7.3, 7.4 - which are kernels 3=
.10...=20
Thanks

Kris Davis



