Return-Path: <seth.vik@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4F91A1B8.2030901@kernel.dk>
References: <CAKa9NmuEcJu7U+M8s4O2C0QPHzpMQE9a0zctfcahP=Q-qq9UCA@mail.gmail.com>
	<4F91A1B8.2030901@kernel.dk>
Date: Fri, 20 Apr 2012 11:13:05 -0700
Message-ID: <CAKa9NmtBX_VgFL2K4nTD-0JPE3ni22y1HC2O8iU6nar6TOdzrA@mail.gmail.com>
Subject: Re: fio causing kernel panic due to zero size requests
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: multipart/mixed; boundary=20cf307ac89571007904be203dab
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--20cf307ac89571007904be203dab
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 10:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-04-20 19:27, Vikram Seth wrote:
>> Hi Jens,
>>
>> Recently we saw an issue where fio created kernel panic because of 0
>> size requests.
>> Pasting the stack trace below.
>>
>> <d>Pid: 13846, comm: fio Tainted: P M 2.6.38.4-
>> <d>RIP: 0010:[<ffffffff8111d90d>] [<ffffffff8111d90d>]
>> __blockdev_direct_IO+0x6a7/0x9ce
>> <d>RSP: 0018:ffff8823fb7e9c18 EFLAGS: 00010246
>> <d>RAX: 0000000000000000 RBX: ffffea007d55d460 RCX: 000000000000000a
>> <d>RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff8812342b80e0
>> <d>RBP: ffff8823fb7e9cd8 R08: 0000000000000001 R09: 0000000000000000
>> <d>R10: 0000000000000000 R11: ffffea0000000000 R12: ffff881233d64400
>> <d>R13: 0000000000000003 R14: ffff881233d64498 R15: ffff8812342b80e0
>> <d>FS: 00007f048cddb6e0(0000) GS:ffff88007e200000(0000) knlGS:0000000000=
000000
>> <d>CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <d>CR2: 000000000040d040 CR3: 000000238ea69000 CR4: 00000000000406f0
>> <d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> <d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process fio (pid: 13846, threadinfo ffff8823fb7e8000, task ffff882432ead=
120)
>> <0>Stack:
>> <c> ffff8823fb7e9c68<c> ffffffff814478ce<c> ffff882300000001<c>
>> ffff8823cf614000<c>
>> <c> ffff882300000004<c> ffffffff814478ce<c> fffffffffffffc00<c>
>> 00000000814478ce<c>
>> <c> ffff8823fb7e8000<c> 0000000000000400<c> 0000000a00000001<c>
>> ffff8823fb7e8000<c>
>>
>> Checking that function it's
>>
>> 0xffffffff8111d90d is in __blockdev_direct_IO (fs/direct-io.c:955).
>>
>> and that points to following line in direct-io.c:
>>
>> =A0955 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(this_chunk_bytes =3D=3D 0);
>>
>> We also tested with following patch from kernel.org
>>
>> f9b5570 fs: simplify handling of zero sized reads in __blockdev_direct_I=
O
>>
>> That resolved the panic problem.
>>
>> Can you please add check to fio that it should error out OR skip 0
>> size accesses ?
>
> It seems you forgot to include the job file that triggered this :-)
> Fio should not be making zero sized reads, but pretty embarassing that
> the kernel oopsed on getting one. It could be a file system issue, a bug
> there triggering a zero sized read.
>
> So how did you trigger this? And on what fs?
>
> --
> Jens Axboe
>

The job file is attached. It is a simple job file doing direct IO (so
no fs) on a flash device.

Vikram.

--20cf307ac89571007904be203dab
Content-Type: application/octet-stream; name=fio-test-file
Content-Disposition: attachment; filename=fio-test-file
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h19k4j4k0

IyBUaGlzIGpvYiBmaWxlIHRyaWVzIHRvIHJ1biBzdGFuZGFyZCBwZXJmIHRlc3RzLgpbZ2xvYmFs
XQpkZXNjcmlwdGlvbj1TdGFuZGFyZCBQZXJmb3JtYW5jZSB0ZXN0CnJ1bnRpbWU9MTI4MApkaXJl
Y3Q9MQpmaWxlbmFtZT0vZGV2L3NkYQpudW1qb2JzPTIwCmdyb3VwX3JlcG9ydGluZwoKW3NlcXJl
YWRfNF0Kcnc9cmVhZApicz00awoKW3NlcXJlYWRfOF0Kc3RvbmV3YWxsCnJ3PXJlYWQKYnM9OGsK
CltzZXFyZWFkXzE2XQpzdG9uZXdhbGwKcnc9cmVhZApicz0xNmsKCltzZXFyZWFkXzMyXQpzdG9u
ZXdhbGwKcnc9cmVhZApicz0zMmsKCltzZXFyZWFkXzY0XQpzdG9uZXdhbGwKcnc9cmVhZApicz02
NGsKCltzZXFyZWFkXzEyOF0Kc3RvbmV3YWxsCnJ3PXJlYWQKYnM9MTI4awoKW3NlcXJlYWRfMjU2
XQpzdG9uZXdhbGwKcnc9cmVhZApicz0yNTZrCgpbc2Vxd3JpdGVfNF0Kc3RvbmV3YWxsCnJ3PXdy
aXRlCmJzPTRrCgpbc2Vxd3JpdGVfOF0Kc3RvbmV3YWxsCnJ3PXdyaXRlCmJzPThrCgpbc2Vxd3Jp
dGVfMTZdCnN0b25ld2FsbApydz13cml0ZQpicz0xNmsKCltzZXF3cml0ZV8zMl0Kc3RvbmV3YWxs
CnJ3PXdyaXRlCmJzPTMyawoKW3NlcXdyaXRlXzY0XQpzdG9uZXdhbGwKcnc9d3JpdGUKYnM9NjRr
Cgpbc2Vxd3JpdGVfMTI4XQpzdG9uZXdhbGwKcnc9d3JpdGUKYnM9MTI4awoKW3NlcXdyaXRlXzI1
Nl0Kc3RvbmV3YWxsCnJ3PXdyaXRlCmJzPTI1NmsKCltyYW5kcmVhZF80XQpzdG9uZXdhbGwKcnc9
cmFuZHJlYWQKYnM9NGsKCltyYW5kcmVhZF84XQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQKYnM9OGsK
CltyYW5kcmVhZF8xNl0Kc3RvbmV3YWxsCnJ3PXJhbmRyZWFkCmJzPTE2awoKW3JhbmRyZWFkXzMy
XQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQKYnM9MzJrCgpbcmFuZHJlYWRfNjRdCnN0b25ld2FsbApy
dz1yYW5kcmVhZApicz02NGsKCltyYW5kcmVhZF8xMjhdCnN0b25ld2FsbApydz1yYW5kcmVhZApi
cz0xMjhrCgpbcmFuZHJlYWRfMjU2XQpzdG9uZXdhbGwKcnc9cmFuZHJlYWQKYnM9MjU2awoKW3Jh
bmR3cml0ZV80XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTRrCgpbcmFuZHdyaXRlXzhdCnN0
b25ld2FsbApydz1yYW5kd3JpdGUKYnM9OGsKCltyYW5kd3JpdGVfMTZdCnN0b25ld2FsbApydz1y
YW5kd3JpdGUKYnM9MTZrCgpbcmFuZHdyaXRlXzMyXQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJz
PTMyawoKW3JhbmR3cml0ZV82NF0Kc3RvbmV3YWxsCnJ3PXJhbmR3cml0ZQpicz02NGsKCltyYW5k
d3JpdGVfMTI4XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTEyOGsKCltyYW5kd3JpdGVfMjU2
XQpzdG9uZXdhbGwKcnc9cmFuZHdyaXRlCmJzPTI1NmsK
--20cf307ac89571007904be203dab--


