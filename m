Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20214 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932194AbeFORxp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Jun 2018 13:53:45 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio make warning
Date: Fri, 15 Jun 2018 17:53:41 +0000
Message-ID: <MWHPR04MB032019EDD2993DA29DB190538F7C0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On some kernels, I am getting a make warning:

CC init.o
init.c: In function td_fill_rand_seeds:
init.c:1049:18: warning: array subscript is above array bounds [-Warray-bou=
nds]
    td->rand_seeds[i] =3D FIO_RANDSEED * td->thread_number
                  ^
init.c:1049:18: warning: array subscript is above array bounds [-Warray-bou=
nds]
init.c:1049:18: warning: array subscript is above array bounds [-Warray-bou=
nds]
init.c:1049:18: warning: array subscript is above array bounds [-Warray-bou=
nds]

Regards,
Jeff


