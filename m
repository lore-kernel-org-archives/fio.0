Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-co1nam03on0123.outbound.protection.outlook.com ([104.47.40.123]:15403
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753204AbcI1UV1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Sep 2016 16:21:27 -0400
From: Shahar Glixman <sglixman@velostrata.com>
Subject: fio crash on windows when using json output 
Date: Wed, 28 Sep 2016 20:21:24 +0000
Message-ID: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I am trying to run fio on windows (2012 core), and getting sporadic crashes=
  (~ 1 out of 3 runs) -
Tried both 2.13 (taken from bluestop site: fio-2.13-x64.zip)
And also compiled 2.14 from sources.
In both binaries, when I run the following command:

fio.exe --thread --direct=3D1 --output-format=3Djson --output=3D\fio.result=
s.192.168.1.53.json --name=3DwriteTestFile --filename=3DE\:\throughput.tst =
--size=3D100m --rw=3Dwrite --bs=3D256k --iodepth=3D2 --buffer_comp ress_per=
centage=3D0

The test completes (gets to 100%) and then crash:

Faulting application name: fio.exe, version: 0.0.0.0, time stamp: 0x57bf1de=
1
Faulting module name: msvcrt.dll, version: 7.0.9600.16384, time stamp: 0x52=
15f944
Exception code: 0xc0000005
Fault offset: 0x0000000000003209
Faulting process id: 0x914
Faulting application start time: 0x01d218fd8209cc06
Faulting application path: c:\fio\fio-2.13-x64\fio.exe
Faulting module path: C:\Windows\system32\msvcrt.dll
Report Id: 6ca2ff1e-84f1-11e6-80c4-06db2ed6a2ef
Faulting package full name:=20
Faulting package-relative application ID:

The output file (--output=3D\fio.results.192.168.1.53.json) is empty.

I was able to narrow the problem to creating json output, e.g., when text o=
utput is requested, the crash does not happen.

fio.exe --version
fio-2.14

Thanks in advance
Shahar

