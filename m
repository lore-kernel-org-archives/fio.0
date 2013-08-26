Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:18650 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab3HZVxM (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 26 Aug 2013 17:53:12 -0400
Received: from localhost.localdomain (ppp-94-66-119-230.home.otenet.gr [94.66.119.230])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: apyrgio@admin.grnet.gr)
	by smtps.admin.grnet.gr (Postfix) with ESMTPSA id E7560180DD
	for <fio@vger.kernel.org>; Tue, 27 Aug 2013 00:53:08 +0300 (EEST)
From: Alex Pyrgiotis <apyrgio@grnet.gr>
Subject: [PATCH] LFSR: Do not ignore returning the seed
Date: Tue, 27 Aug 2013 00:52:21 +0300
Message-Id: <1377553942-6835-1-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

Since Juan Casse stirred the LFSR subject, I took a look at the code and found
out that for certain spin values, the seed would not be used. The
following patch fixes that issue.

Most of the people will not be affected by this bug, except for those that
strictly needed a non-repeating LFSR.

Alex Pyrgiotis (1):
  LFSR: Do not ignore returning the seed

 lib/lfsr.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

-- 
1.8.3.4

