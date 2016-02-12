Return-Path: <fio-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:35136 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbcBLQXA (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Feb 2016 11:23:00 -0500
Received: from zmail24.collab.prod.int.phx2.redhat.com (zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
	by mx5-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u1CGN0w3025447
	for <fio@vger.kernel.org>; Fri, 12 Feb 2016 11:23:00 -0500
Date: Fri, 12 Feb 2016 11:23:00 -0500 (EST)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <1499154031.27756078.1455294180577.JavaMail.zimbra@redhat.com>
Subject: Logging completed IOs only
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey,

I was exchanging on the possibility to use fio to perform write test to a device and then check how does the device handled the power failure.
I thought about using the verify options of it but I was shown that write_iolog does only log IOs that were sent to the device but not the one actually completed.

What do you think about adding an option not to log the IO that were sent but completed ?

That way it would be possible to track what was actually done at the time the log was written.

Cheers,
Erwan
