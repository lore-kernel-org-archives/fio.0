Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59057 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbFCTbB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Jun 2015 15:31:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1Z0EMV-0000Jf-U8
	for fio@vger.kernel.org; Wed, 03 Jun 2015 21:30:04 +0200
Received: from lmcpra.ericsson.ca ([192.75.88.231])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 03 Jun 2015 21:30:03 +0200
Received: from viali.lee by lmcpra.ericsson.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 03 Jun 2015 21:30:03 +0200
From: FIO-User-KKV <viali.lee@gmail.com>
Subject: Parameter Issue with 'ratemin'...
Date: Wed, 3 Jun 2015 19:21:22 +0000 (UTC)
Message-ID: <loom.20150603T211024-259@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, I am using Fio 2.2.8.
I have an issue when setting the parameter 'ratemin'.
It only accepts '0'!
no matter what non-zero values I set, 

e.g., 
sudo fio -name "SOURCE"  -numjobs 1  -bs 1M   -rw write -direct 1 -runtime 
50 -filename=/dev/vdb  -prio 0 -ratemin=1K

I will end up quickly with "fio: minimum rate exceeds rate"!
Could anyone know what's wrong there?

Thanks!

