Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47245 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3GQKmb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 17 Jul 2013 06:42:31 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so1573516wgh.26
        for <fio@vger.kernel.org>; Wed, 17 Jul 2013 03:42:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUChTxLS6NVoCSSkTDnrm2m6otLX_OMzcWkqRaOqj2qLqO6yA@mail.gmail.com>
References: <CANUChTxLS6NVoCSSkTDnrm2m6otLX_OMzcWkqRaOqj2qLqO6yA@mail.gmail.com>
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Wed, 17 Jul 2013 11:42:09 +0100
Message-ID: <CANUChTzBTygcPUMMGA+1V1m8tU1jxfmp8A=SrKeVX=W8G57A2A@mail.gmail.com>
Subject: Re: Large Seq Write interspersed with Small Rnd Read
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On 9 July 2013 18:31, Gavin Martin <gavin_martin@xyratex.com> wrote:
> I'm trying to run a particular benchmark for HDD's and need to run
> large sequential writes (1M) and intersperse it with small random
> reads (4K).  I don't think I can run this within a single job, as even
> though I could specify read/write mix (rwmixread) and specify
> sequential/random mix (percentage_random), I am unable to guarantee
> that the reads are in fact random.
>
> So this is my jobfile (fio 2.1);
>
> [global]
> direct=1
> ioengine=libaio
> filename=/dev/sdb
> runtime=30s
>
> [Writes]
> rw=write
> bs=1M
> iodepth=3
> flow=-1
>
> [Reads]
> rw=randread
> bs=4K
> iodepth=2
> flow=30
>

Hi Jens,

I'm struggling to understand how fio is treating the above job file,
one change is the 'flow=30' to 'flow=99' in the last job.

I expected with the 'flow=' argument for it to run through the jobfile
sequentially do a write set the flow to -1 and then do a read and set
the flow to 98, and then follow with x number of writes to get the
flow counter back to 0 before doing another read.  This would then
allow a number of writes followed by 1 read and then another number of
writes, 1 read, etc.  But looking at the output I'm getting it seems
to be doing a number of reads in one block.

If I use the --debug=io output then it shows that it is completing a
number of seq writes (1M) and the 9 rnd reads (4K) before continuing
with the writes again;

io       21111 io complete: io_u 0x709b90:
off=6107955200/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x70a130:
off=6109003776/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709ea0:
off=6110052352/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709b90:
off=6111100928/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x70a130:
off=6112149504/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709ea0:
off=6113198080/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709b90:
off=6114246656/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x70a130:
off=6115295232/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709ea0:
off=6116343808/len=1048576/ddir=1//dev/sdc
io       21112 io complete: io_u 0x709b90:
off=891120726016/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709ea0:
off=3136989032448/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709b90:
off=2730991616/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709ea0:
off=1952185835520/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709b90:
off=1068805836800/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709ea0:
off=1558297432064/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709b90:
off=412885770240/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709ea0:
off=438233067520/len=4096/ddir=0//dev/sdc
io       21112 io complete: io_u 0x709b90:
off=439709462528/len=4096/ddir=0//dev/sdc
io       21111 io complete: io_u 0x709b90:
off=6117392384/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x70a130:
off=6118440960/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709ea0:
off=6119489536/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709b90:
off=6120538112/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x70a130:
off=6121586688/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709ea0:
off=6122635264/len=1048576/ddir=1//dev/sdc
io       21111 io complete: io_u 0x709b90:
off=6123683840/len=1048576/ddir=1//dev/sdc

That is one anomaly that I do not quite understand, any ideas why this
is occurring, is there something wrong with my jobfile?

Next anomaly is the 'write_iolog' option, the above output is from the
last set of reads in a 30 second run, if I look at the iolog from that
run it shows 67 read operations compared to the 77 reported in the
output from the debug log, but there are LBA's listed in the iolog
that are not listed in the debug log, for example;

/dev/sdc read 891120726016 4096
/dev/sdc read 3136989032448 4096
/dev/sdc read 2730991616 4096
/dev/sdc read 1952185835520 4096
/dev/sdc read 1068805836800 4096
/dev/sdc read 1558297432064 4096
/dev/sdc read 412885770240 4096
/dev/sdc read 438233067520 4096
/dev/sdc read 439709462528 4096
/dev/sdc read 1375146094592 4096
/dev/sdc read 1994875674624 4096
/dev/sdc read 2511602016256 4096
/dev/sdc read 2254737641472 4096
/dev/sdc read 3780645670912 4096
/dev/sdc read 1863427309568 4096
/dev/sdc read 2829522800640 4096
/dev/sdc read 2130652815360 4096

LBA ~6016 to ~528 are listed in both outputs, but the rest of the
iolog LBA's do not appear in the debug?  Should both of those outputs
align?

And information you can shed on the above would be appreciated?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
