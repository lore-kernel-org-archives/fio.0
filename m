Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42159 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbeHVB3Q (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 21:29:16 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: Windows make errors on http
Date: Tue, 21 Aug 2018 22:07:16 +0000
Message-ID: <MWHPR04MB03200B9A3B77890750357EB78F310@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
It seems the latest git is broken for Windows builds:

engines/http.o: In function 'fio_http_cleanup':
http.c:438: undefined reference to '__imp_curl_easy_cleanup'
...

The 3.8 release builds successfully.

Regards,
Jeff


