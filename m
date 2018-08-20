Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60114 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbeHUCnJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Aug 2018 22:43:09 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] Fix residual size
Date: Mon, 20 Aug 2018 23:25:29 +0000
Message-ID: <MWHPR04MB03206BA957345969502C3CCC8F320@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

If we target a number of bytes of IO and keep subtracting a xfer_buflen, we=
 need to ensure the residual length is of the same size.


diff --git a/io_u.h b/io_u.h
index 9a423b2..2e0fd3f 100644
--- a/io_u.h
+++ b/io_u.h
@@ -75,7 +75,7 @@ struct io_u {
=20
 	struct io_piece *ipo;
=20
-	unsigned int resid;
+	unsigned long long resid;
 	unsigned int error;
=20
 	/*


Regards,
Jeff



