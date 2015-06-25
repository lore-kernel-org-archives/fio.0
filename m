Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F85E399.3030603@kernel.dk>
References: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com>
 <4F7E35F2.5010701@kernel.dk> <CAN8qX8ZnCCZz3cBbhocdTwXgBqsL=JV=QYFD_OSj4nmEFVUZMQ@mail.gmail.com>
 <4F85E399.3030603@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 25 Jun 2015 00:29:39 -0500
Message-ID: <CAB-428kfhcDuQBrpkd4wg17Vp_Rz-mx0OUMMDhBfYbnhDbXfMA@mail.gmail.com>
Subject: Re: query on verify_dump option
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Suresh Dhanarajan <sureshdrajan@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Apr 11, 2012 at 3:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2012-04-06 02:28, Suresh Dhanarajan wrote:
> > Hi,
> >
> > I am looking for this files in the same location where my fio is and i
> > dont see the two files that you refereed.
>
> Hmm, you really should, if you have verify_dump=1 set. The pattern
> verify is the odd one out, all the other checksum verifiers use shared
> code for this. I'll take a look at this and see if I can reproduce it.
>

Jens,

Not sure if you had a chance to take a look at this issue. I have just
replicate this issue in my setup. The .received and .excpected files
are missing with verify_dump=1.

Here is my job file, would you please kindly take a look and let me
know if my job file is not correct ?

; writes 512 byte verification blocks until the disk is full,
; then verifies written data
[global]
thread=1
bs=128k
direct=1
iodepth=32
size=10G
ioengine=libaio
verify=crc32c
verify_pattern=0x0123456789abcdfe
verify_interval=512

[write-phase]
filename=/dev/sdd    ; or use a full disk, for example /dev/sda
rw=write
;fill_device=1
do_verify=0
verify_state_save=1

[verify-phase]
stonewall
create_serialize=0
filename=/dev/sdd
rw=read
do_verify=1
verify_only
verify_state_load=1
verify_dump=1
error_dump=1
description=dump_pattern


--Alireza

