Return-Path: <j.rosenboom@x-ion.de>
MIME-Version: 1.0
Date: Fri, 12 Feb 2016 11:49:51 +0100
Message-ID: <CADr68WbbbL9oE3-OGWqjR5u4uyUSTsBWQ5KCHm_GS2K0vApKUQ@mail.gmail.com>
Subject: Re: Writes being split based on non-aligned partition ending
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Fio <fio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, parted-devel@lists.alioth.debian.org, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

2016-02-12 7:59 GMT+01:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> CC'ing Jens Axboe.
>
> On 11 February 2016 at 09:54, Jens Rosenboom <j.rosenboom@x-ion.de> wrote:
>> 2016-02-11 4:48 GMT+01:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>>> Trying to cc the GNU parted and linux-block mailing lists.
>>>
>>> On 9 February 2016 at 13:02, Jens Rosenboom <j.rosenboom@x-ion.de> wrote:
>>>> While trying to reproduce some performance issues I have been seeing
>>>> with Ceph, I have come across a strange behaviour which is seemingly
>>>> affected only by the end point (and thereby the size) of a partition
>>>> being an odd number of sectors. Since all documentation about
>>>> alignment only refers to the starting point of the partition, this was
>>>> pretty surprising and I would like to know whether this is expected
>>>> behaviour or maybe a kernel issue.
>>>>
>>>> The command I am using is pretty simple:
>>>>
>>>> fio --rw=randwrite --size=1G --fdatasync=1 --bs=4k
>>>> --filename=/dev/sdb2 --runtime=10 --name=test
>>>>
>>>> The difference shows itself when the partition is created either by
>>>> sgdisk or by parted:
>>>>
>>>> sgdisk --new=2:6000M: /dev/sdb
>>>>
>>>> parted -s /dev/sdb mkpart osd-device-1-block 6291456000B 100%
>>>>
>>>> The difference in the partition table looks like this:
>>>>
>>>> <  2      6291456000B  1600320962559B  1594029506560B
>>>> osd-device-1-block
>>>> ---
>>>>>  2      6291456000B  1600321297919B  1594029841920B               osd-device-1-block
>>>
>>> Looks like parted took you at your word when you asked for your
>>> partition at 100%. Just out of curiosity if you try and make the same
>>> partition interactively with parted do you get any warnings after
>>> making and after running align-check ?
>>
>> No warnings and everything fine for align-check. I found out that I
>> can get the same effect if I step the partition ending manually in
>> parted in 1s increments. The sequence of write sizes is 8, 1, 2, 1, 4,
>> 1, 2, 1, 8, ... which corresponds to the size (unit s) of the
>> resulting partion mod 8.
>
> OK. Could you add the output of
> grep . /sys/block/nvme0n1/queue/*size

$ grep . /sys/block/nvme0n1/queue/*size
/sys/block/nvme0n1/queue/hw_sector_size:512
/sys/block/nvme0n1/queue/logical_block_size:512
/sys/block/nvme0n1/queue/max_segment_size:65536
/sys/block/nvme0n1/queue/minimum_io_size:512
/sys/block/nvme0n1/queue/optimal_io_size:0
/sys/block/nvme0n1/queue/physical_block_size:512
$ grep . /sys/block/sdb/queue/*size
/sys/block/sdb/queue/hw_sector_size:512
/sys/block/sdb/queue/logical_block_size:512
/sys/block/sdb/queue/max_segment_size:65536
/sys/block/sdb/queue/minimum_io_size:512
/sys/block/sdb/queue/optimal_io_size:0
/sys/block/sdb/queue/physical_block_size:512

> sgdisk -D /dev/sdb

$ sgdisk -D /dev/nvme0n1
2048
$ sgdisk -D /dev/sdb
2048

> and could you post the information about the whole partition table.

In order to make sure that there is no effect from the other
partitions, I recreated to whole table from scratch:

$ parted /dev/nvme0n1 mklabel gpt
Warning: The existing disk label on /dev/nvme0n1 will be destroyed and
all data on this disk will be lost. Do you want to continue?
Yes/No? y
Information: You may need to update /etc/fstab.

$ parted /dev/nvme0n1 mkpart test1 0% 100%
Information: You may need to update /etc/fstab.

$ parted /dev/nvme0n1 unit s print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 781422768s
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start  End         Size        File system  Name   Flags
 1      2048s  781422591s  781420544s               test1

Result with fio => 4k writes. Note that the ending sector in this case
is == -1 modulo 2048, making the resulting size a true multiple of
2048. Now retry with one sector less at the end:

$ parted /dev/nvme0n1 rm 1
$ parted /dev/nvme0n1 mkpart test1 2048s 781422590s
$ parted /dev/nvme0n1 unit s print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 781422768s
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start  End         Size        File system  Name   Flags
 1      2048s  781422590s  781420543s               test1

Result with fio => 512b writes

> Does sgdisk create a similar problem ending if you use
> sgdisk --new=2:0 /dev/sdb
> ? It seems strange that the end of the disk (and thus a 100% sized
> partition) wouldn't end on a multiple of 4k...

$ parted /dev/nvme0n1 rm 1
Information: You may need to update /etc/fstab.

$ sgdisk --new=1:0 /dev/nvme0n1
The operation has completed successfully.
$ parted /dev/nvme0n1 unit s print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 781422768s
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start  End         Size        File system  Name  Flags
 1      2048s  781422734s  781420687s

Result with fio => 512b writes. Note that the partition end here is at
(disk_size - 34s).


>>>> So this is really only the end of the partition that is different.
>>>> However, in the first case, the 4k writes all get broken up into 512b
>>>> writes somewhere in the kernel, as can be seen with btrace:
>>>>
>>>>   8,16   3       36     0.000102666  8184  A  WS 12353985 + 1 <- (8,18) 65985
>>>>   8,16   3       37     0.000102739  8184  Q  WS 12353985 + 1 [fio]
>>>>   8,16   3       38     0.000102875  8184  M  WS 12353985 + 1 [fio]
>>>>   8,16   3       39     0.000103038  8184  A  WS 12353986 + 1 <- (8,18) 65986
>>>>   8,16   3       40     0.000103109  8184  Q  WS 12353986 + 1 [fio]
>>>>   8,16   3       41     0.000103196  8184  M  WS 12353986 + 1 [fio]
>>>>   8,16   3       42     0.000103335  8184  A  WS 12353987 + 1 <- (8,18) 65987
>>>>   8,16   3       43     0.000103403  8184  Q  WS 12353987 + 1 [fio]
>>>>   8,16   3       44     0.000103489  8184  M  WS 12353987 + 1 [fio]
>>>>   8,16   3       45     0.000103609  8184  A  WS 12353988 + 1 <- (8,18) 65988
>>>>   8,16   3       46     0.000103678  8184  Q  WS 12353988 + 1 [fio]
>>>>   8,16   3       47     0.000103767  8184  M  WS 12353988 + 1 [fio]
>>>>   8,16   3       48     0.000103879  8184  A  WS 12353989 + 1 <- (8,18) 65989
>>>>   8,16   3       49     0.000103947  8184  Q  WS 12353989 + 1 [fio]
>>>>   8,16   3       50     0.000104035  8184  M  WS 12353989 + 1 [fio]
>>>>   8,16   3       51     0.000104150  8184  A  WS 12353990 + 1 <- (8,18) 65990
>>>>   8,16   3       52     0.000104219  8184  Q  WS 12353990 + 1 [fio]
>>>>   8,16   3       53     0.000104307  8184  M  WS 12353990 + 1 [fio]
>>>>   8,16   3       54     0.000104452  8184  A  WS 12353991 + 1 <- (8,18) 65991
>>>>   8,16   3       55     0.000104520  8184  Q  WS 12353991 + 1 [fio]
>>>>   8,16   3       56     0.000104609  8184  M  WS 12353991 + 1 [fio]
>>>>   8,16   3       57     0.000104885  8184  I  WS 12353984 + 8 [fio]
>>>>
>>>> whereas in the second case, I'm getting the expected 4k writes:
>>>>
>>>>   8,16   6       42 1266874889.659842036  8409  A  WS 12340232 + 8 <-
>>>> (8,18) 52232
>>>>   8,16   6       43 1266874889.659842167  8409  Q  WS 12340232 + 8 [fio]
>>>>   8,16   6       44 1266874889.659842393  8409  G  WS 12340232 + 8 [fio]
>>>
>>> This is weird because --size=1G should mean that fio is "seeing" an
>>> aligned end. Does direct=1 with a sequential job of iodepth=1 show the
>>> problem too?
>>
>> IIUC fio uses the size only to find out where to write to, it opens
>> the block device and passes the resulting fd to the fdatasync call, so
>> the kernel will not know about what size fio thinks the device has. In
>> fact, the effect is the same without the size=1G option, I used it
>> just to make sure that the writes do not go anywhere near the badly
>> aligned partition ending.
>>
>> direct=1 kills the effect, i.e. all writes will be 4k size again.
>> Astonishingly though, sequential writes also are affected, i.e.
>> changing to rw=write in my sample above behaves the same as randwrite.
>
> Do you get this style of behaviour without fdatasync (or with larger
> values of fdatasync) too?

Wow, now you see me pretty surprised, I had checked before that
fdatasync=[2,4] did the same thing, but now it turns out that I am
seeing the 512b writes even without fdatasync at all on this NVMe
device.
In fact, if I run this test on an SSD and watch it with btrace, I also
see lots of 512b writes being queued, but again they get merged before
this has too much impact, a typical sample here looks like:

  8,16   5    40466    26.397939811 22948  A  WS 15489 + 1 <- (8,17) 13441
  8,16   5    40467    26.397939888 22948  Q  WS 15489 + 1 [fio]
  8,16   5    40468    26.397939970 22948  M  WS 15489 + 1 [fio]
  8,16   5    40469    26.397940088 22948  A  WS 15490 + 1 <- (8,17) 13442
  8,16   5    40470    26.397940166 22948  Q  WS 15490 + 1 [fio]
  8,16   5    40471    26.397940247 22948  M  WS 15490 + 1 [fio]
...
  8,16   5    48524    26.399000710 22948  A  WS 18175 + 1 <- (8,17) 16127
  8,16   5    48525    26.399000788 22948  Q  WS 18175 + 1 [fio]
  8,16   5    48526    26.399000868 22948  M  WS 18175 + 1 [fio]
  8,16   5    48527    26.399002416 22948  A  WS 18176 + 1 <- (8,17) 16128
  8,16   5    48528    26.399002497 22948  Q  WS 18176 + 1 [fio]
  8,16   5    48529    26.399002845 22948  G  WS 18176 + 1 [fio]
  8,16   5    48530    26.399003324 22948  I  WS 15488 + 168 [fio]
  8,16   5    48531    26.399003405 22948  I  WS 15656 + 168 [fio]
  8,16   5    48532    26.399003449 22948  I  WS 15824 + 168 [fio]
  8,16   5    48533    26.399003494 22948  I  WS 15992 + 168 [fio]
  8,16   5    48534    26.399003535 22948  I  WS 16160 + 168 [fio]
  8,16   5    48535    26.399003577 22948  I  WS 16328 + 168 [fio]
  8,16   5    48536    26.399003622 22948  I  WS 16496 + 168 [fio]
  8,16   5    48537    26.399003662 22948  I  WS 16664 + 168 [fio]
  8,16   5    48538    26.399003702 22948  I  WS 16832 + 168 [fio]
  8,16   5    48539    26.399003742 22948  I  WS 17000 + 168 [fio]
  8,16   5    48540    26.399003782 22948  I  WS 17168 + 168 [fio]
  8,16   5    48541    26.399003822 22948  I  WS 17336 + 168 [fio]
  8,16   5    48542    26.399003862 22948  I  WS 17504 + 168 [fio]
  8,16   5    48543    26.399003902 22948  I  WS 17672 + 168 [fio]
  8,16   5    48544    26.399003942 22948  I  WS 17840 + 168 [fio]
  8,16   5    48545    26.399003987 22948  I  WS 18008 + 168 [fio]

So I think we can forget about the fdatasync, seems that was only some
kind of colored fish. In fact, we also do not need to original writes
to be small, using bs=4M results in the same "+ 1" writes in btrace.

