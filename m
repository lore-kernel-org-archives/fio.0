Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45177 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3KZHEP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 26 Nov 2013 02:04:15 -0500
Received: from sits by silver.sucs.swan.ac.uk with local (Exim 4.80)
	(envelope-from <sits@sucs.org>)
	id 1VlCIY-0001U6-3d
	for fio@vger.kernel.org; Tue, 26 Nov 2013 06:39:02 +0000
Date: Tue, 26 Nov 2013 06:39:02 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: --server broken on Windows (2.1.1 and 2.0.14)
Message-ID: <20131126063901.GA4631@sucs.org>
Reply-To: Sitsofe Wheeler <sitsofe@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

The problem with waitpid when trying to connect to an fio in server mode
as mentioned in http://www.spinics.net/lists/fio/msg02319.html from
August still seems to be here with the prebuilt 2.1.1 Windows binaries
on=EF=BF=BDhttp://www.bluestop.org/fio/ . Additionally the Windows client s=
eems
to be unable to read job files when connecting to the server:

example.fio:
[global]
bs=3D256k
direct=3D1
filename=3Dtmp
#fsync=3D1
ioengine=3Dwindowsaio
iodepth=3D8
stonewall
thread
verify=3Dcrc32c-intel
size=3D50M
[sequentialwrite]
do_verify=3D0
rw=3Dwrite

PS C:\Users> & 'C:\Program Files\fio\fio.exe' --server
fio: server listening on 0.0.0.0,8765
fork is not implemented
waitpid is not implemented
fio: waitpid: Function not implemented
waitpid is not implemented

PS C:\Users> & 'C:\Program Files\fio\fio.exe' --client=3D127.0.0.1 .\exampl=
e.fio
writev is not implemented
fio: failed reading job file .\example.fio

The older 2.0.14 binary also has client issues on Windows:
=EF=BF=BD
C:\Users>fio.exe --minimal example.fio
3;fio2.0.14;sequentialwrite;0;0;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;=
0.000000;1.000000%=3D0;5.000000%=3D0;10.000000%=3D0;20.000000%=3D0;30.00000=
0%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=3D0;70.000000%=3D0;80.00000=
0%=3D0;90.000000%=3D0;95.000000%=3D0;99.000000%=3D0;99.500000%=3D0;99.90000=
0%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D0;0%=3D0;0%=3D0;0;0;0.000000;0.00=
0000;0;0;0.000000%;0.000000;0.000000;51200;302958;1183;169;76;1140;128.3050=
00;122.535943;259;6770;5736.430000;678.286887;1.000000%=3D1064;5.000000%=3D=
5600;10.000000%=3D5664;20.000000%=3D5664;30.000000%=3D5728;40.000000%=3D572=
8;50.000000%=3D5792;60.000000%=3D5856;70.000000%=3D5856;80.000000%=3D5920;9=
0.000000%=3D6048;95.000000%=3D6112;99.000000%=3D6752;99.500000%=3D6752;99.9=
00000%=3D6752;99.950000%=3D6752;99.990000%=3D6752;0%=3D0;0%=3D0;0%=3D0;361;=
6985;5864.735000;688.096080;0;0;0.000000%;0.000000;0.000000;0.000000%;0.000=
000%;0;0;0;0.5%;1.0%;2.0%;96.5%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00=
%;0.00%;0.00%;0.50%;0.00%;0.00%;0.50%;1.50%;97.50%;0.00%;0.00%;0.00%;0.00%;=
0.00%;0.00%;0.00%;0.00%;0.00%

C:\Users>fio.exe --client=3D127.0.0.1 example.fio
fio: failed reading job file example.fio

Does anyone have any ideas?

--=20
Sitsofe
