Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:63857 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaLMUcS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 13 Dec 2014 15:32:18 -0500
Received: by mail-la0-f48.google.com with SMTP id gf13so7828677lab.35
        for <fio@vger.kernel.org>; Sat, 13 Dec 2014 12:32:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03>
References: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 13 Dec 2014 23:31:55 +0300
Message-ID: <CANvN+ekgXKivBooiEtpNKApmoWg=Dv-DwYbOKQ0WKcPLqUCnoQ@mail.gmail.com>
Subject: Re: Sequential Commands are essentially random when in mixed
 sequential/random workloads
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stephen Nichols <Stephen.Nichols@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, Dec 13, 2014 at 3:23 AM, Stephen Nichols
<Stephen.Nichols@wdc.com> wrote:
>
> Hi all,
>
> When using fio configuration below..
>
> [global]
> ioengine=libaio
> direct=1
> runtime=600
> bs=32k
> iodepth=8
> rw=randrw
> rwmixread=80
> percentage_random=100,0
>
> [drive1]
> filename=/dev/sda
>
>
> I am expecting to see 80% reads, 20% writes where all reads are random and all writes are sequential. I captured a bus trace of traffic to the disk and the bus trace reflected as much with one issue. The write commands are essentially random. Each write begins at a new random LBA. If 2 or more writes occur in a row, the LBA's are sequential based on the block size BUT I feel the heart of this feature would be to emulate a large file write during random access. With that in mind would it be possible for sequential reads or writes within mixed sequential/random workload to remember the last LBA accessed? In this scenario the writes would still only take up 20% of the workload but when a write did occur it should be the next sequential step from the last write.
>
>
> Snippet from the bus trace for reference
>
> Command                                           LBA
> Read FPDMA Queued:                  19F3F818
> Read FPDMA Queued:                  1CBE2740
> Write FPDMA Queued:                 24E35198
> Write FPDMA Queued:                 24E351A0
> Read FPDMA Queued:                  115A9E10
> Write FPDMA Queued:                 A3C1968
> Read FPDMA Queued:                  20B89488
> Write FPDMA Queued:                 336EE0D0
> Write FPDMA Queued:                 336EE0D8
>
>

The problem is that, with non-trivial percentage_random, fio generates
next sequential offset off the file's last position, but the latter is
global, not per data direction. As a result, with the workload above,
one gets the pattern where next write is sequential with respect to
the last I/O, not the last write as, I believe, the expectation goes.

I've added a debug printout for the last_pos to illustrate the point
in the debug output below. ddir=1 are writes.

Regards,
Andrey

fio: set debug option io
io       5299  load ioengine libaio
drive1: (g=0): rw=randrw, bs=32K-32K/32K-32K/32K-32K, ioengine=libaio, iodepth=8
fio-2.1.14-45-g7003
Starting 1 process
io       5301  invalidate cache /tmp/drive1: 0/1048576
io       5301  get_next_block: last pos 0
io       5301  fill_io_u: io_u 0x121ec00: off=32768/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121ec00: off=32768/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121ec00)=0
io       5301  queue: io_u 0x121ec00: off=32768/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 1
io       5301  get_next_block: last pos 65536
io       5301  fill_io_u: io_u 0x121e900:
off=753664/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121e900: off=753664/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121e900)=0
io       5301  queue: io_u 0x121e900: off=753664/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 2
io       5301  get_next_block: last pos 786432
io       5301  fill_io_u: io_u 0x121e1c0:
off=851968/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121e1c0: off=851968/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121e1c0)=0
io       5301  queue: io_u 0x121e1c0: off=851968/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 3
================================================================
io       5301  get_next_block: last pos 884736
io       5301  fill_io_u: io_u 0x121dec0:
off=884736/len=32768/ddir=1//tmp/drive1
io       5301  prep: io_u 0x121dec0: off=884736/len=32768/ddir=1//tmp/drive1
io       5301  ->prep(0x121dec0)=0
io       5301  queue: io_u 0x121dec0: off=884736/len=32768/ddir=1//tmp/drive1
io       5301  calling ->commit(), depth 4
io       5301  get_next_block: last pos 917504
io       5301  fill_io_u: io_u 0x121dbc0:
off=491520/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121dbc0: off=491520/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121dbc0)=0
io       5301  queue: io_u 0x121dbc0: off=491520/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 5
io       5301  get_next_block: last pos 524288
io       5301  fill_io_u: io_u 0x121d8c0:
off=393216/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121d8c0: off=393216/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121d8c0)=0
io       5301  queue: io_u 0x121d8c0: off=393216/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 6
io       5301  get_next_block: last pos 425984
io       5301  fill_io_u: io_u 0x121d600: off=0/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121d600: off=0/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121d600)=0
io       5301  queue: io_u 0x121d600: off=0/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 7
io       5301  get_next_block: last pos 32768
io       5301  fill_io_u: io_u 0x121d300: off=65536/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121d300: off=65536/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121d300)=0
io       5301  queue: io_u 0x121d300: off=65536/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 8
io       5301  io_u_queued_completed: min=1
io       5301  getevents: 1
io       5301  io complete: io_u 0x121ec00:
off=32768/len=32768/ddir=0//tmp/drive1
io       5301  get_next_block: last pos 98304
io       5301  fill_io_u: io_u 0x121ec00:
off=360448/len=32768/ddir=0//tmp/drive1
io       5301  prep: io_u 0x121ec00: off=360448/len=32768/ddir=0//tmp/drive1
io       5301  ->prep(0x121ec00)=0
io       5301  queue: io_u 0x121ec00: off=360448/len=32768/ddir=0//tmp/drive1
io       5301  calling ->commit(), depth 8
io       5301  io_u_queued_completed: min=1
io       5301  getevents: 1
io       5301  io complete: io_u 0x121e900:
off=753664/len=32768/ddir=0//tmp/drive1
==================================================================
io       5301  get_next_block: last pos 393216
io       5301  fill_io_u: io_u 0x121e900:
off=393216/len=32768/ddir=1//tmp/drive1
io       5301  prep: io_u 0x121e900: off=393216/len=32768/ddir=1//tmp/drive1
io       5301  ->prep(0x121e900)=0


Regards,
Andrey

>
> Let me know what you think, this feature may be working as intended but it seemed off to me.
>
> Thanks,
> Stephen "Nick" Nichols
> Western Digital
> Enterprise Test Development
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
