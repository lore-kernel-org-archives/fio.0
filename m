Return-Path: <fio-owner@vger.kernel.org>
Received: from mailsrv.s3group.com ([193.120.90.35]:42452 "EHLO
	mailsrv.s3group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaHRPDh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Aug 2014 11:03:37 -0400
Received: from avsrvd.s3group.com (avsrvd.s3group.com [193.120.90.37])
        by mailsrv.s3group.com  with ESMTP id s7IF3Xfi015719
        for <fio@vger.kernel.org>; Mon, 18 Aug 2014 16:03:34 +0100
Received: from avsrvd.s3group.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D132915005D
	for <fio@vger.kernel.org>; Mon, 18 Aug 2014 16:03:33 +0100 (IST)
Received: from excork2.dublin.ad.s3group.com (unknown [193.120.91.10])
	by avsrvd.s3group.com (Postfix) with ESMTP id BF001150052
	for <fio@vger.kernel.org>; Mon, 18 Aug 2014 16:03:33 +0100 (IST)
Message-ID: <53F215C5.5050207@s3group.com>
Date: Mon, 18 Aug 2014 16:03:33 +0100
From: John OCallaghan <john.ocallaghan@s3group.com>
MIME-Version: 1.0
Subject: fio usage question
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org



Hi All

A question on usage of fio. I would like to be able to spin up more than
one fio instance running on the same platform concurrently.

For example, I would like to run one fio instance in time_based mode
doing some stuff. And after a fixed period of time then start a non-time
based fio instance doing some other stuff.

I have tried it out and to my untrained eyes it looks like its going OK.
But I'd love to hear from others with more experience in this area. Is
this something that is recommended?

Will my data skew in some way because fio expects there to be only one
instance of itself playing at any one time?

Any advice would be much appreciated!

John

-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.

