Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <548CC380.4070100@kernel.dk>
References: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03> <548CC380.4070100@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sun, 14 Dec 2014 18:20:49 +0300
Message-ID: <CANvN+enb9j_964d9=R-iOq79VCu7ZzjqSw7K6Oz-XNAx-n3aGg@mail.gmail.com>
Subject: Re: Sequential Commands are essentially random when in mixed
 sequential/random workloads
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Nichols <Stephen.Nichols@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sun, Dec 14, 2014 at 1:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/12/2014 05:23 PM, Stephen Nichols wrote:
>> Hi all,
>>
>> When using fio configuration below..
>>
>> [global]
>> ioengine=3Dlibaio
>> direct=3D1
>> runtime=3D600
>> bs=3D32k
>> iodepth=3D8
>> rw=3Drandrw
>> rwmixread=3D80
>> percentage_random=3D100,0
>>
>> [drive1]
>> filename=3D/dev/sda
>>
>>
>> I am expecting to see 80% reads, 20% writes where all reads are random a=
nd all writes are sequential. I captured a bus trace of traffic to the disk=
 and the bus trace reflected as much with one issue. The write commands are=
 essentially random. Each write begins at a new random LBA. If 2 or more wr=
ites occur in a row, the LBA's are sequential based on the block size BUT I=
 feel the heart of this feature would be to emulate a large file write duri=
ng random access. With that in mind would it be possible for sequential rea=
ds or writes within mixed sequential/random workload to remember the last L=
BA accessed? In this scenario the writes would still only take up 20% of th=
e workload but when a write did occur it should be the next sequential step=
 from the last write.
>>
>>
>> Snippet from the bus trace for reference
>>
>> Command                                           LBA
>> Read FPDMA Queued:                  19F3F818
>> Read FPDMA Queued:                  1CBE2740
>> Write FPDMA Queued:                 24E35198
>> Write FPDMA Queued:                 24E351A0
>> Read FPDMA Queued:                  115A9E10
>> Write FPDMA Queued:                 A3C1968
>> Read FPDMA Queued:                  20B89488
>> Write FPDMA Queued:                 336EE0D0
>> Write FPDMA Queued:                 336EE0D8
>>
>>
>>
>> Let me know what you think, this feature may be working as intended but =
it seemed off to me.
>
> Would be easy enough to fix, we just need to track last offset per data
> direction. Does the attached work for you? Totally untested, will test
> on Monday.

Looks like fixed.

Regards,
Andrey

io       8568  load ioengine libaio
drive1: (g=3D0): rw=3Drandrw, bs=3D32K-32K/32K-32K/32K-32K, ioengine=3Dliba=
io, iodepth=3D8
fio-2.1.14-45-g7003
Starting 1 process
io       8570  invalidate cache /tmp/drive1: 0/1048576
io       8570  get_next_block: last read pos 0
io       8570  fill_io_u: io_u 0x176be40: off=3D32768/len=3D32768/ddir=3D0/=
/tmp/drive1
io       8570  prep: io_u 0x176be40: off=3D32768/len=3D32768/ddir=3D0//tmp/=
drive1
io       8570  ->prep(0x176be40)=3D0
io       8570  queue: io_u 0x176be40: off=3D32768/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  calling ->commit(), depth 1
io       8570  get_next_block: last read pos 65536
io       8570  fill_io_u: io_u 0x176bb40:
off=3D753664/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176bb40: off=3D753664/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176bb40)=3D0
io       8570  queue: io_u 0x176bb40: off=3D753664/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 2
io       8570  get_next_block: last read pos 786432
io       8570  fill_io_u: io_u 0x176b400:
off=3D851968/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176b400: off=3D851968/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176b400)=3D0
io       8570  queue: io_u 0x176b400: off=3D851968/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 3
=3D=3D=3D
io       8570  get_next_block: last write pos 0
io       8570  fill_io_u: io_u 0x176b100: off=3D0/len=3D32768/ddir=3D1//tmp=
/drive1
io       8570  prep: io_u 0x176b100: off=3D0/len=3D32768/ddir=3D1//tmp/driv=
e1
io       8570  ->prep(0x176b100)=3D0
io       8570  queue: io_u 0x176b100: off=3D0/len=3D32768/ddir=3D1//tmp/dri=
ve1
io       8570  calling ->commit(), depth 4
io       8570  get_next_block: last read pos 884736
io       8570  fill_io_u: io_u 0x176ae00:
off=3D491520/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176ae00: off=3D491520/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176ae00)=3D0
io       8570  queue: io_u 0x176ae00: off=3D491520/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 5
io       8570  get_next_block: last read pos 524288
io       8570  fill_io_u: io_u 0x176ab00:
off=3D393216/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176ab00: off=3D393216/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176ab00)=3D0
io       8570  queue: io_u 0x176ab00: off=3D393216/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 6
io       8570  get_next_block: last read pos 425984
io       8570  fill_io_u: io_u 0x176a840: off=3D0/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  prep: io_u 0x176a840: off=3D0/len=3D32768/ddir=3D0//tmp/driv=
e1
io       8570  ->prep(0x176a840)=3D0
io       8570  queue: io_u 0x176a840: off=3D0/len=3D32768/ddir=3D0//tmp/dri=
ve1
io       8570  calling ->commit(), depth 7
io       8570  get_next_block: last read pos 32768
io       8570  fill_io_u: io_u 0x176a540: off=3D65536/len=3D32768/ddir=3D0/=
/tmp/drive1
io       8570  prep: io_u 0x176a540: off=3D65536/len=3D32768/ddir=3D0//tmp/=
drive1
io       8570  ->prep(0x176a540)=3D0
io       8570  queue: io_u 0x176a540: off=3D65536/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176b100: off=3D0/len=3D32768/ddir=3D1//t=
mp/drive1
io       8570  get_next_block: last read pos 98304
io       8570  fill_io_u: io_u 0x176b100:
off=3D360448/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176b100: off=3D360448/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176b100)=3D0
io       8570  queue: io_u 0x176b100: off=3D360448/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176a840: off=3D0/len=3D32768/ddir=3D0//t=
mp/drive1
=3D=3D=3D
io       8570  get_next_block: last write pos 32768
io       8570  fill_io_u: io_u 0x176a840: off=3D32768/len=3D32768/ddir=3D1/=
/tmp/drive1
io       8570  prep: io_u 0x176a840: off=3D32768/len=3D32768/ddir=3D1//tmp/=
drive1
io       8570  ->prep(0x176a840)=3D0
io       8570  queue: io_u 0x176a840: off=3D32768/len=3D32768/ddir=3D1//tmp=
/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176a840:
off=3D32768/len=3D32768/ddir=3D1//tmp/drive1
io       8570  get_next_block: last read pos 393216
io       8570  fill_io_u: io_u 0x176a840:
off=3D950272/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176a840: off=3D950272/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176a840)=3D0
io       8570  queue: io_u 0x176a840: off=3D950272/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176be40:
off=3D32768/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 983040
io       8570  fill_io_u: io_u 0x176be40: off=3D98304/len=3D32768/ddir=3D0/=
/tmp/drive1
io       8570  prep: io_u 0x176be40: off=3D98304/len=3D32768/ddir=3D0//tmp/=
drive1
io       8570  ->prep(0x176be40)=3D0
io       8570  queue: io_u 0x176be40: off=3D98304/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176bb40:
off=3D753664/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 131072
io       8570  fill_io_u: io_u 0x176bb40:
off=3D884736/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176bb40: off=3D884736/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176bb40)=3D0
io       8570  queue: io_u 0x176bb40: off=3D884736/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176b400:
off=3D851968/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 917504
io       8570  fill_io_u: io_u 0x176b400:
off=3D655360/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176b400: off=3D655360/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176b400)=3D0
io       8570  queue: io_u 0x176b400: off=3D655360/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176ae00:
off=3D491520/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 688128
io       8570  fill_io_u: io_u 0x176ae00:
off=3D131072/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176ae00: off=3D131072/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176ae00)=3D0
io       8570  queue: io_u 0x176ae00: off=3D131072/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176ab00:
off=3D393216/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 163840
io       8570  fill_io_u: io_u 0x176ab00:
off=3D229376/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176ab00: off=3D229376/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176ab00)=3D0
io       8570  queue: io_u 0x176ab00: off=3D229376/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176a540:
off=3D65536/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 262144
io       8570  fill_io_u: io_u 0x176a540:
off=3D163840/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176a540: off=3D163840/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176a540)=3D0
io       8570  queue: io_u 0x176a540: off=3D163840/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176b100:
off=3D360448/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 196608
io       8570  fill_io_u: io_u 0x176b100:
off=3D557056/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176b100: off=3D557056/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176b100)=3D0
io       8570  queue: io_u 0x176b100: off=3D557056/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176a840:
off=3D950272/len=3D32768/ddir=3D0//tmp/drive1
io       8570  get_next_block: last read pos 589824
io       8570  fill_io_u: io_u 0x176a840:
off=3D458752/len=3D32768/ddir=3D0//tmp/drive1
io       8570  prep: io_u 0x176a840: off=3D458752/len=3D32768/ddir=3D0//tmp=
/drive1
io       8570  ->prep(0x176a840)=3D0
io       8570  queue: io_u 0x176a840: off=3D458752/len=3D32768/ddir=3D0//tm=
p/drive1
io       8570  calling ->commit(), depth 8
io       8570  io_u_queued_completed: min=3D1
io       8570  getevents: 1
io       8570  io complete: io_u 0x176be40:
off=3D98304/len=3D32768/ddir=3D0//tmp/drive1
=3D=3D=3D
io       8570  get_next_block: last write pos 65536
io       8570  fill_io_u: io_u 0x176be40: off=3D65536/len=3D32768/ddir=3D1/=
/tmp/drive1
io       8570  prep: io_u 0x176be40: off=3D65536/len=3D32768/ddir=3D1//tmp/=
drive1
io       8570  ->prep(0x176be40)=3D0
io       8570  queue: io_u 0x176be40: off=3D65536/len=3D32768/ddir=3D1//tmp=
/drive1

>
> --
> Jens Axboe
>

