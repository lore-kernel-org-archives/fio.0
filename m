Return-Path: <bruce@cran.org.uk>
Subject: Re: Fio 2.0 coming (was "Re: Recent changes")
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=iso-8859-1
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <4E998031.7060807@kernel.dk>
Date: Sat, 15 Oct 2011 13:55:23 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <07F638D7-A704-409B-B58F-9DEC711A84F3@cran.org.uk>
References: <20111014040002.95902484001@kernel.dk> <4E97D492.8080305@kernel.dk> <DA4ADF0A-3461-46AD-B5B7-E24CBAF4D1E9@cran.org.uk> <4E993F9B.2030705@kernel.dk> <4E9942D3.5050702@kernel.dk> <4E998031.7060807@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


On 15 Oct 2011, at 13:44, Jens Axboe wrote:

> Please try current -git, it should work now.

Thanks, it's fixed.

I can crash the client by pressing ctrl-c on the server:

> ./fio -S
fio: server listening on 0.0.0.0:8765
 and ^C>=20
^^^^ there seems to be a random "and" printed?

> ./fio -C localhost examples/tiobench-example

...

<muon> f3: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f3: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f3: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f4: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f4: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f4: Laying out IO file(s) (1 file(s) / 512MB)
<muon> f4: Laying out IO file(s) (1 file(s) / 512MB)
<muon>=20
Assertion failed: (cmdret->opcode =3D=3D cmd.opcode), function =
fio_net_recv_cmd, file server.c, line 187.

Program received signal SIGABRT, Aborted.
[Switching to Thread 28301140 (LWP 100220/initial thread)]
0x281e7207 in kill () from /lib/libc.so.7
(gdb) bt
#0  0x281e7207 in kill () from /lib/libc.so.7
#1  0x280eb377 in raise () from /lib/libthr.so.3
#2  0x281e5d3a in abort () from /lib/libc.so.7
#3  0x281ce0c6 in __assert () from /lib/libc.so.7
#4  0x08074f8e in fio_net_recv_cmd (sk=3D3) at server.c:187
#5  0x08077f95 in fio_handle_clients () at client.c:779
#6  0x08051033 in exec_run () at fio.c:1779
#7  0x08051be1 in main (argc=3D4, argv=3D0xbfbfec04, envp=3DError =
accessing memory address 0xb: Bad address.
) at fio.c:1904
(gdb)=20

--=20
Bruce


