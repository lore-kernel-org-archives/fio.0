Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59455 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbbDNIpG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Apr 2015 04:45:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1YhwSt-00039q-TV
	for fio@vger.kernel.org; Tue, 14 Apr 2015 10:45:04 +0200
Received: from 213.233.191.19 ([213.233.191.19])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 14 Apr 2015 10:45:03 +0200
Received: from zahra.estaji68 by 213.233.191.19 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Tue, 14 Apr 2015 10:45:03 +0200
From: Z Es <zahra.estaji68@gmail.com>
Subject: fio filename vs directory
Date: Tue, 14 Apr 2015 05:49:01 +0000 (UTC)
Message-ID: <loom.20150414T074548-942@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

as i understand, there are 2 ways to specify the disk you want the test run
on it. the first one is by filename=/dev/sdx and the second one is by
linking the mount point of the disk to directory flag in fio.
but in these 2 ways i get different results
what is the differences between them?

thanks

