Return-Path: <fio-owner@vger.kernel.org>
Received: from web55006.mail.re4.yahoo.com ([206.190.58.140]:28999 "HELO
	web55006.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751393AbZLXTM2 (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 24 Dec 2009 14:12:28 -0500
Message-ID: <328428.66762.qm@web55006.mail.re4.yahoo.com>
Date: Thu, 24 Dec 2009 11:12:27 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: io scheduler merges control
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

IOPS-reported numbers for a test vary (more than 30% in my case) from one run to another depending on kernel io scheduler merges (reported in "Disk stats/merges=reads/writes") making it hard to measure/compare performance of block drivers, for instance.

I don't see any way to turn off kernel io scheduler merges (cfq or others)
and I'd ask if you would consider adding support for it, disabling the merges per individual device, using sys-fs maybe?

If you do, adding an option to fio for controlling the merges would be useful too,

thanks,
John



      
