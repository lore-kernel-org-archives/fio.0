Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:54066 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3E1VRE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 28 May 2013 17:17:04 -0400
Received: from mail.micron.com (ntxboicas01.micron.com [137.201.84.60])
	by mailout.micron.com (8.13.6/8.13.6) with ESMTP id r4SLH2YA005722
	for <fio@vger.kernel.org>; Tue, 28 May 2013 15:17:02 -0600
From: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Subject: RE: FIO 2.1 iops logging problem
Date: Tue, 28 May 2013 21:17:01 +0000
Message-ID: <C8CA972100601A41AE302914E9CE194680367BA4@NTXBOIMBX03.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,

I cannot seem to get the write_iops_log working with FIO 2.1.

I found that write_bw_log now requires write_bw_log=<text> to work. However that does not seem to work on the iops logging. Any idea what I am doing wrong?

Thanks,
Jeff
