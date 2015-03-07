Return-Path: <fio-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:34163 "EHLO mx143.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbbCGQLM convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 7 Mar 2015 11:11:12 -0500
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Rate for write IOPS read IOPS
Date: Sat, 7 Mar 2015 16:01:45 +0000
Message-ID: <D1208B18.10E7D%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F09A1BD2D338BE40A1CA59C933A71755@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I need to generate a workload as:

45,000 IOPS (write)
7,000  IOPS (read)

I have tried to use rate_iops and rwmixread and rxmixwrite. I was able to
rate the workload at 52,000 IOPS but no matter the % value that I use at
rwmixread and rwmixwrite, I always have 50/50 read/write.

Is there any way to specify: I want 45,000 IOPS writes and 7,000 IOPS
reads.

Thank you,

All the best

neto

