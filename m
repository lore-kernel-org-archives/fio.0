Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx2.hgst.com ([199.255.44.37]:5828 "EHLO sjc00mx2.hgst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbcAUVnd convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 21 Jan 2016 16:43:33 -0500
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: Windows Make Broken
Date: Thu, 21 Jan 2016 21:43:30 +0000
Message-ID: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Building version 2.5 on Windows appears broken:


server.c:272:11: error: 'MSG_DONTWAIT' undeclared (first use in this function)
   flags = MSG_DONTWAIT;
           ^
server.c:272:11: note: each undeclared identifier is reported only once for each function it appears in
Makefile:294: recipe for target 'server.o' failed
make: *** [server.o] Error 1


Regards,
Jeff

HGST E-mail Confidentiality Notice & Disclaimer:
This e-mail and any files transmitted with it may contain confidential or legally privileged information of HGST and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited.  If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

