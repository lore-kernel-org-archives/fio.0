Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:4945 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfEPO7O (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 May 2019 10:59:14 -0400
From: Kris Davis <Kris.Davis@wdc.com>
Subject: Replay of blktrace containing trims causes assert
Date: Thu, 16 May 2019 14:59:11 +0000
Message-ID: <DM6PR04MB4697F5E8A0DEF7A332FF63DF810A0@DM6PR04MB4697.namprd04.prod.outlook.com>
References: <DM6PR04MB46979AAC86FAAEF22257B2A2810F0@DM6PR04MB4697.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB46979AAC86FAAEF22257B2A2810F0@DM6PR04MB4697.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

(this note might be a repeat - notice I previously had email formatted as H=
TML - probably put ended up in bitbucket)

I have an issue replaying an blktrace which contains trim operations. It re=
sults in an assert failure:=20
> fio: fio.h:552: fio_ro_check: Assertion `!(io_u->ddir =3D=3D DDIR_WRITE &=
& !((td)->o.td_ddir & TD_DDIR_WRITE)) && !(io_u->ddir =3D=3D DDIR_TRIM && !=
((td)->o.td_ddir & TD_DDIR_TRIM))'=20

I posted a detailed explanation and a simple patch in https://github.com/ax=
boe/fio/issues/771, along with a pull request.=A0=20
Can someone please take a look?
Thanks
Kris Davis


