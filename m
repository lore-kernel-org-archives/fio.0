Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26773 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbdGXXca (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Jul 2017 19:32:30 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio Windows Invalidate
Date: Mon, 24 Jul 2017 23:31:42 +0000
Message-ID: <BN3PR0401MB1457186B80B40D775D03BF3B8FBB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Commit 22de5d7741f963e57dd5e3bb70d822e992dd2515 seems to have changed how W=
indows works with the default invalidate parameter.  Previously it was not =
needed to specify invalidate=3D0, but now it is needed on Windows.  Without=
 it, fio reports:

fio-2.21
Starting 1 thread
fio: cache invalidation of \\.\PHYSICALDRIVE1 failed: Unknown error
fio: cache invalidation of \\.\PHYSICALDRIVE1 failed: Unknown error

Is the expectation that Windows default invalidate (1) should silently igno=
re this issue, or must the user specify invalidate=3D0 on Windows platforms=
?  Thanks.

Regards,
Jeff

