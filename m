Return-Path: <fabrice.bacchella@orange.fr>
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: IO merge in engine
From: Fabrice Bacchella <fabrice.bacchella@orange.fr>
In-Reply-To: <560EA9C4.6010402@kernel.dk>
Date: Tue, 6 Oct 2015 17:36:37 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <114555AD-64CE-4A15-9466-4AEC0FC519C4@orange.fr>
References: <599D12BD-A1A9-42D7-ADE1-70ADACA9E177@orange.fr> <560EA9C4.6010402@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


> Le 2 oct. 2015 =E0 17:59, Jens Axboe <axboe@kernel.dk> a =E9crit :
>=20
> On 10/02/2015 04:04 PM, Fabrice Bacchella wrote:
>> When writing my new hdfs engine, I met a problem with IO merge.
>>=20
>>=20

>> Is there a way to prevent that in fio, or is that up to my engine to =
manage that and merge IO ?--
>=20
> It sounds like a bug in the fio accounting, for the case of short =
reads/writes. That doesn't happen very often elsewhere, so not =
unreasonable to expect that is the case. Feel free to poke around and =
figure it out. Let me know if that doesn't work out, and I'll take a =
stab at fixing it up.
>=20


I'm using this simple fio script:
[global]
size=3D1m

ioengine=3Dnet
hostname=3Dlocalhost
port=3D8765
filename=3Dlocalhost,8765,tcp
[job1]
rw=3Dwrite
bs=3D<something>
numjobs=3D1


And launching a fio listener with :
./fio --server

With ./fio --debug=3Dio,file sample.fio and bs=3D654820, I got:
io       15106 ->prep(0x779f40)=3D0
io       15106 queue: io_u 0x779f40: =
off=3D0/len=3D654820/ddir=3D1/localhost,8765,tcp
io       15106 io complete: io_u 0x779f40: =
off=3D0/len=3D654820/ddir=3D1/localhost,8765,tcp
...
io       15705 fill_io_u: io_u 0x1926f40: =
off=3D654820/len=3D654820/ddir=3D1/localhost,8765,tcp
io       15705 prep: io_u 0x1926f40: =
off=3D654820/len=3D654820/ddir=3D1/localhost,8765,tcp

     issued    : total=3Dr=3D0/w=3D2/d=3D0, short=3Dr=3D0/w=3D0/d=3D0, =
drop=3Dr=3D0/w=3D0/d=3D0

It fails for the second IO with
 job1: (groupid=3D0, jobs=3D1): err=3D104 (file:engines/net.c:684, =
func=3Dxfer, error=3DConnection reset by peer): pid=3D15106: Tue Oct  6 =
16:11:59 2015,=20

but that's not the problem. It does 2 654820 bytes IO, as requested


With bs=3D654821 and adding strace -f -e trace=3Dsendto , I got:
io       15157 prep: io_u 0x1660f40: =
off=3D0/len=3D654821/ddir=3D1/localhost,8765,tcp
io       15157 ->prep(0x1660f40)=3D0
io       15157 queue: io_u 0x1660f40: =
off=3D0/len=3D654821/ddir=3D1/localhost,8765,tcp
[pid 15157] sendto(3, =
"\220\240@\6\371\341\277>\0\0\0\0\0\0\0\0\202\2\7\320\343\6H\26P\340\277\3=
70\330\30e\30"..., 654821, MSG_MORE, NULL, 0) =3D 654820
io       15157 requeue 0x1660f40
io       15157 io_u_queued_completed: min=3D1
io       15157 getevents: 0
io       15157 prep: io_u 0x1660f40: =
off=3D654820/len=3D654821/ddir=3D1/localhost,8765,tcp
io       15157 ->prep(0x1660f40)=3D0
io       15157 queue: io_u 0x1660f40: =
off=3D654820/len=3D654821/ddir=3D1/localhost,8765,tcp
=20
and it still failling, fio is doing another IO, at the good offset, but =
wrong length, I think it should now try to read 1 byte. It try a second =
IO but not to finish the first one.

With bs=3D1m, I got:
io       15205 prep: io_u 0x862f40: =
off=3D0/len=3D1048576/ddir=3D1/localhost,8765,tcp
io       15205 ->prep(0x862f40)=3D0
io       15205 queue: io_u 0x862f40: =
off=3D0/len=3D1048576/ddir=3D1/localhost,8765,tcp
[pid 15205] sendto(3, =
"\220\240@\6\371\341\277>\22\24\200\320\36y\313\26\202\2\7\320\343\6H\26P\=
340\277\370\330\30e\30"..., 1048576, 0, NULL, 0) =3D 654820
io       15205 requeue 0x862f40
io       15205 io_u_queued_completed: min=3D1
     issued    : total=3Dr=3D0/w=3D1/d=3D0, short=3Dr=3D0/w=3D1/d=3D0, =
drop=3Dr=3D0/w=3D0/d=3D0

So only 654820 bytes are read, the IO is requeued, but not send.

For sequential IO, the result is not totally wrong and the net engine =
won't do random IO :
fio: network IO can't be random

But with my libhdfs engine, I'm getting wrong results, because it can do =
random IO and segmented random IO are very different than segmented =
serial IO. Other engine like rbd might have the same problem.



