Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: fio 2.0.8 fails to build on mipsel
Date: Tue, 26 Jun 2012 12:45:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201206261245.30704.ms@teamix.de>
To: fio@vger.kernel.org, Sven Hoexter <sven@timegate.de>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens!

Sven and I are currently trying to get fio 2.0.8 into Debian in time for Wh=
eezy:


Building fails on mipsel due to=B9:

    CC crc/sha256.o
    CC crc/sha512.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC memalign.o
    CC server.o
server.c: In function 'handle_probe_cmd':
server.c:411:15: error: 'arch_mips' undeclared (first use in this function)
server.c:411:15: note: each undeclared identifier is reported only once for=
 each function it appears in
make[1]: *** [server.o] Error 1
make[1]: Leaving directory `/build/buildd-fio_2.0.8-1-mipsel-9VXitB/fio-2.0=
=2E8'
make: *** [build-stamp] Error 2


This happens in server.c:

 397 static int handle_probe_cmd(struct fio_net_cmd *cmd)
 398 {
 399         struct cmd_probe_pdu probe;
 400=20
 401         dprint(FD_NET, "server: sending probe reply\n");
 402=20
 403         memset(&probe, 0, sizeof(probe));
 404         gethostname((char *) probe.hostname, sizeof(probe.hostname));
 405 #ifdef FIO_BIG_ENDIAN
 406         probe.bigendian =3D 1;
 407 #endif
 408         strncpy((char *) probe.fio_version, fio_version_string, sizeof=
(probe.fio_version));
 409=20
 410         probe.os        =3D FIO_OS;
 411         probe.arch      =3D FIO_ARCH;
 412=20
 413         probe.bpp       =3D sizeof(void *);
 414=20
 415         return fio_net_send_cmd(server_fd, FIO_NET_CMD_PROBE, &probe, =
sizeof(probe), cmd->tag);
 416 }



=46IO_ARCH is defined to (arch_mips) in arch/arch-mips.h - any idea what
might be going on here?


I'd like to include some patch to have it build on mipsel as well.


[1] https://buildd.debian.org/status/package.php?p=3Dfio&suite=3Dsid

Thanks,
=2D-=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

