Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37704 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLNBTM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Dec 2017 20:19:12 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] Fix Windows local time
Date: Thu, 14 Dec 2017 01:19:09 +0000
Message-ID: <BN3PR0401MB145737D9588B5617B1017ED48F0A0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

The fio summary output shows when the job completed, but references system =
time on Windows.  On Linux, local time (such as with time zone specifics) i=
s referenced.  This patch converts Windows system time to local time.

Before:
fio-3.2-72-ge80d-dirty
Starting 1 thread
Jobs: 1 (f=3D0): [f(1)][100.0%][r=3D69.6MiB/s,w=3D0KiB/s][r=3D17.8k,w=3D0 I=
OPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1360: Wed Dec 13 23:21:16 20=
17 <--System Time

After:
fio-3.2-72-ge80d-dirty
Starting 1 thread
Jobs: 1 (f=3D0): [f(1)][100.0%][r=3D73.2MiB/s,w=3D0KiB/s][r=3D18.7k,w=3D0 I=
OPS][eta 00m:00s]
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D8088: Wed Dec 13 15:22:07 20=
17 <--Local Time

Regards,
Jeff



diff --git a/os/windows/posix.c b/os/windows/posix.c
index 00f03355..17e18a1f 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -228,12 +228,14 @@ void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *s=
ystemTime)
 {
     FILETIME utcFT;
     LONGLONG jan1970;
+	SYSTEMTIME tempSystemTime;
=20
     jan1970 =3D Int32x32To64(dosTime, 10000000) + 116444736000000000;
     utcFT.dwLowDateTime =3D (DWORD)jan1970;
     utcFT.dwHighDateTime =3D jan1970 >> 32;
=20
-    FileTimeToSystemTime((FILETIME*)&utcFT, systemTime);
+    FileTimeToSystemTime((FILETIME*)&utcFT, &tempSystemTime);
+	SystemTimeToTzSpecificLocalTime(NULL, &tempSystemTime, systemTime);
 }
=20
 char* ctime_r(const time_t *t, char *buf)

