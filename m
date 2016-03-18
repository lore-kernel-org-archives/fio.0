Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx2.hgst.com ([199.255.44.37]:51304 "EHLO
	sjc00mx2.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbcCRR35 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 18 Mar 2016 13:29:57 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: Windows make fails
Date: Fri, 18 Mar 2016 17:29:54 +0000
Message-ID: <BN3PR0401MB14579B2785DF531EC8BC867BF78C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
The latest fio version seems to fail building on Windows:

  LINK t/gen-rand
lib/pattern.o: In function `parse_number':
/fio-fio-2.8_win/lib/pattern.c:78: undefined reference to `strcasestr'
collect2: error: ld returned 1 exit status
Makefile:396: recipe for target 't/gen-rand' failed
make: *** [t/gen-rand] Error 1

Also, the Windows builds only seem to pick up the base version number (fio 2.7 or fio 2.8), not the latest git version (fio 2.8-123).  So the last release (e.g. 2.8) build cannot be distinguishable from the latest git version (e.g 2.8-123).

Thoughts on either issue?  Thanks.

Regards,
Jeff



Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

