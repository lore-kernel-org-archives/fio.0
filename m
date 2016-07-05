Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56619 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbcGEWqD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Jul 2016 18:46:03 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: fio bssplit min bs
Date: Tue, 5 Jul 2016 22:46:01 +0000
Message-ID: <BN3PR0401MB1457A924CEFFE2E186D3840AF7390@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_BN3PR0401MB1457A924CEFFE2E186D3840AF7390BN3PR0401MB1457_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

--_002_BN3PR0401MB1457A924CEFFE2E186D3840AF7390BN3PR0401MB1457_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi All,
Previously we added the bssplit option to accommodate more advanced blocksi=
ze lists.  However, blockalign appears to default to the smallest element i=
n the bssplit list.  If so, we must update the example JESD219 workload to =
explicitly specify blockalign=3D4k, to satisfy the JESD219 workload require=
ment ("data payloads greater than or equal to 4096 bytes are aligned on 4k =
boundaries").  There is no explicit alignment requirement for <4KB blocksiz=
es, so at this time, there seems to be no need to specify a separate alignm=
ent for some blocksizes in bssplit list.

See attached patch for the JESD219 example file.

Regards,
Jeff

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality N=
otice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or l=
egally privileged information of WDC and/or its affiliates, and are intende=
d solely for the use of the individual or entity to which they are addresse=
d. If you are not the intended recipient, any disclosure, copying, distribu=
tion or any action taken or omitted to be taken in reliance on it, is prohi=
bited. If you have received this e-mail in error, please notify the sender =
immediately and delete the e-mail in its entirety from your system.

--_002_BN3PR0401MB1457A924CEFFE2E186D3840AF7390BN3PR0401MB1457_
Content-Type: application/octet-stream; name="jesd219.patch"
Content-Description: jesd219.patch
Content-Disposition: attachment; filename="jesd219.patch"; size=409;
	creation-date="Tue, 05 Jul 2016 22:37:44 GMT";
	modification-date="Tue, 05 Jul 2016 22:37:44 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhLy4vZmlvL2V4YW1wbGVzL2plc2QyMTkuZmlvIGIvLi9maW8vZXhhbXBsZXMv
amVzZDIxOS5maW8KaW5kZXggYWIyYzQwZS4uMjRmMTZmNyAxMDA2NDQKLS0tIGEvLi9maW8vZXhh
bXBsZXMvamVzZDIxOS5maW8KKysrIGIvLi9maW8vZXhhbXBsZXMvamVzZDIxOS5maW8KQEAgLTE0
LDYgKzE0LDcgQEAgcndtaXh3cml0ZT02MAogaW9kZXB0aD0yNTYKIG51bWpvYnM9NAogYnNzcGxp
dD01MTIvNDoxMDI0LzE6MTUzNi8xOjIwNDgvMToyNTYwLzE6MzA3Mi8xOjM1ODQvMTo0ay82Nzo4
ay8xMDoxNmsvNzozMmsvMzo2NGsvMworYmxvY2thbGlnbj00awogcmFuZG9tX2Rpc3RyaWJ1dGlv
bj16b25lZDo1MC81OjMwLzE1OjIwLzgwCiBmaWxlbmFtZT0vZGV2L252bWUwbjEKIGdyb3VwX3Jl
cG9ydGluZz0xCg==

--_002_BN3PR0401MB1457A924CEFFE2E186D3840AF7390BN3PR0401MB1457_--

