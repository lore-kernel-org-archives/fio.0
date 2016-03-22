Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0065.outbound.protection.outlook.com ([157.56.112.65]:6845
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbcCVTtt convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 22 Mar 2016 15:49:49 -0400
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
Date: Tue, 22 Mar 2016 19:17:09 +0000
Message-ID: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello fio team, 

Does it possible with fio to simulate a job with IO mixed  for simulating a typical workload of an Oracle database.

1.  12% seqread
2. 8% seqwrite
3. The rest 80% are random of this 30% (24% from total) is write and 70% (56% from total) reads.

I know our to test every  step alone but i want to test step 1,2 and 3 in the same time.


Regards,
Thierry







  