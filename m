Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-sn1nam02on0064.outbound.protection.outlook.com ([104.47.36.64]:12611
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932710AbcISWN7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Sep 2016 18:13:59 -0400
From: Chris Taylor <ctaylor@pivot3.com>
Subject: json ouput is striping the last character of the year on Windows
Date: Mon, 19 Sep 2016 21:40:27 +0000
Message-ID: <MWHPR10MB177593F557B14F7EB39730D68CF40@MWHPR10MB1775.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Windows the year is not correct when using JSON output.

  "time" : "Mon Sep 19 17:21:45 201",

diff --git a/stat.c b/stat.c
index c9148ad..0c64333 100644
--- a/stat.c
+++ b/stat.c
@@ -1650,7 +1650,9 @@ void __show_run_stats(void)
=20
                os_ctime_r((const time_t *) &now.tv_sec, time_buf,
                                sizeof(time_buf));
-               time_buf[strlen(time_buf) - 1] =3D '\0';
+               #if !defined(WIN32)=20
+                    time_buf[strlen(time_buf) - 1] =3D '\0';
+                #endif=20
=20
                root =3D json_create_object();
                json_object_add_value_string(root, "fio version", fio_versi=
on_string);

I tested this patch on Windows and Linux and got the correct time format fo=
r both
  "time" : "Mon Sep 19 21:18:24 2016",
