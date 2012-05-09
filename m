Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:43983 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755534Ab2EILrw convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 9 May 2012 07:47:52 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id 966DA7A0A4
	for <fio@vger.kernel.org>; Wed,  9 May 2012 13:37:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 931C2146C1C
	for <fio@vger.kernel.org>; Wed,  9 May 2012 13:37:27 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWUy5rqCQlHT for <fio@vger.kernel.org>;
	Wed,  9 May 2012 13:37:27 +0200 (CEST)
Received: from mango.localnet (kaesefondue.of.teamix.net [172.21.123.2])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id 0BF94146C19
	for <fio@vger.kernel.org>; Wed,  9 May 2012 13:37:27 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: Floating point exception in client/server mode
Date: Wed, 9 May 2012 13:37:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201205091337.26414.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens, hi everyone,

Client is 32-bit Debian Wheezy with my 2.0.7 fio package and server is 64-b=
it=20
Debian Wheezy with 2.0.7 fio package.


ms@mango:~/Zeit> cat /proc/version
Linux version 3.2.0-2-686-pae (Debian 3.2.15-1) (debian-
kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-3) ) #1 SMP Sun A=
pr=20
15 17:56:31 UTC 2012


ms@mango:~/Zeit> vim randreadwrite.job
ms@mango:~/Zeit> fio --client=3Dfrisbie randreadwrite.job=20
hostname=3Dfrisbie, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3D2.0.7
<frisbie> zuf=EF=BF=BDlliglesen: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, =
ioengine=3Dsync,=20
iodepth=3D1
<frisbie> zuf=EF=BF=BDlligschreiben: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K=
-4K,=20
ioengine=3Dsync, iodepth=3D1
<frisbie> Starting 2 processes
<frisbie> =3D2): [] [100.0% done] [613K/650K /s] [149 /158  iops] [eta 00m:=
00s]
zuf=EF=BF=BDlliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D8090
zsh: floating point exception  fio --client=3Dfrisbie randreadwrite.job
ms@mango:~/Zeit#136> cat randreadwrite.job=20
[global]
size=3D2g
runtime=3D60
direct=3D1
[zuf=EF=BF=BDlliglesen]
rw=3Drandread
[zuf=EF=BF=BDlligschreiben]
rw=3Drandwrite


root@frisbie:~# fio --server=3D
fio: server listening on 0.0.0.0,8765



root@frisbie:~# fio --server=3D
fio: server listening on 0.0.0.0,8765
^C
fio: terminating on signal 2
root@frisbie:~# cat /proc/version
Linux version 3.2.0-1-amd64 (Debian 3.2.6-1) (ben@decadent.org.uk) (gcc=20
version 4.6.2 (Debian 4.6.2-14) ) #1 SMP Fri Feb 17 05:17:36 UTC 2012



This is reproducable. Second time I used fio --server (without the =3D sign=
) - no=20
difference.

Any ideas?

Thanks,
--=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
