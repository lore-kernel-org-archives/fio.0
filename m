Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64156 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbeJ3Exb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 00:53:31 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio win affinity broken
Date: Mon, 29 Oct 2018 20:03:16 +0000
Message-ID: <MWHPR04MB032025E64451635D09E474C08FF30@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Back in http://git.kernel.dk/cgit/fio/commit/?id=3Dc479640d6208236744f0562b=
1e79535eec290e2b several updates were made for Windows CPU affinity.  Howev=
er, using the cpus_allowed since fio 3.6 and latest git appears to throw er=
ror messages.  Consider a job:

fio --name=3Dtest --ioengine=3Dwindowsaio --direct=3D1 --rw=3Dwrite --overw=
rite=3D1 --filename=3D\\.\PHYSICALDRIVE1 --runtime=3D1s --thread --cpus_all=
owed=3D0-1 --cpus_allowed_policy=3Dshared

fio_setaffinity: failed to set thread affinity (pid 2768, group 0, mask 100=
00, GetLastError=3D87)
fio_setaffinity: failed to set thread affinity (pid 2372, group 0, mask 200=
00, GetLastError=3D87)
clock setaffinity failed: No error

It seems err 87 is ERROR_INVALID_PARAMETER, but any idea why "GROUP_AFFINIT=
Y struct's Reserved members are not initialised to 0?"  Might it be related=
 to Windows version?  Seems to fail on 2012 and 2016.  Thanks.

Regards,
Jeff



