Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58296 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933857AbeFLSL7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Jun 2018 14:11:59 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio environment var bug
Date: Tue, 12 Jun 2018 18:11:57 +0000
Message-ID: <SN6PR04MB40649343247761CFB42764468F7F0@SN6PR04MB4064.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
There seems to be a bug while parsing environment variables when using clie=
nt/server mode.  Consider the following:

# fio -version
fio-3.7-21-gab56

# fio --server=3Dlocalhost&

# cat test.job
[test]
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D${QD}
size=3D100%
bs=3D4k
filename=3D/dev/nvme0n1
runtime=3D5s

# QD=3D1 fio test.job
fio-3.7-21-gab56
Starting 1 process
Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D320MiB/s,w=3D0KiB/s][r=3D81.9k,w=3D0 IO=
PS][eta 00m:00s]

# QD=3D1 fio --client=3Dlocalhost test.job
be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-3.7-21-gab56, flags=3D=
1
fio: failed parsing iodepth=3D${QD}
fio: job test dropped

I haven't deciphered where exactly the issue is in parse.c.  Any thoughts? =
 Thanks.

Regards,
Jeff

