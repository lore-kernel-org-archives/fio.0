Return-Path: <prvs=7668c2ce2=Bart.VanAssche@wdc.com>
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Zoned block device support for fio
Date: Thu, 23 Aug 2018 23:00:21 +0000
Message-ID: <a1373211271aee157884ec6dea024ecc2c17331d.camel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <E505991DDA4DF440A796B30BCBD86977@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

Hello,

The code on the master branch of my fio repository on github has been
updated again. The changes compared to the previous version are:
+ACo- A new job option has been added, namely zonemode. zonemode+AD0-zbd ha=
s to be
  specified when filename refers to a zoned block device. zonesize has a ne=
w
  meaning for zonemode+AD0-zbd. When both zonemode and zonesize have been
  specified and filename refers to a regular block device the I/O pattern
  the same as for a zoned block device (at least if all write pointers of t=
he
  zoned block device are reset before fio is started). This behavior change
  was requested by Jens.
+ACo- A subtle bug has been fixed that caused I/O against a zoned block dev=
ice to
  stop early if multiple jobs were doing random writes to the same LBA rang=
e
  and with the random map enabled.
+ACo- The zonemode+AD0-zbd do+AF8-verify+AD0-1 combination no longer causes=
 fio to report
  verify errors when run against the conventional zones of a zoned block
  device.
+ACo- The code for skipping offline zones should now work. Offline zones we=
re not
  skipped in previous versions. I have not yet tested this code - testing t=
his
  change requires access to a real or simulated openchannel SSD.
+ACo- Several new unit tests have been added to t/zbc/test-zbc-support.

See also https://github.com/axboe/fio/pull/585.

Best regards,

Bart.

