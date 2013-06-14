Return-Path: <fio-owner@vger.kernel.org>
Received: from hop-nat-141.emc.com ([168.159.213.141]:32284 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494Ab3FNOos convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 14 Jun 2013 10:44:48 -0400
Received: from hop04-l1d11-si04.isus.emc.com (HOP04-L1D11-SI04.isus.emc.com [10.254.111.24])
	by mexforward.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r5EEiZH2026670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Fri, 14 Jun 2013 10:44:35 -0400
Received: from mailhub.lss.emc.com (mailhubhoprd02.lss.emc.com [10.254.221.253]) by hop04-l1d11-si04.isus.emc.com (RSA Interceptor) for <fio@vger.kernel.org>; Fri, 14 Jun 2013 10:44:25 -0400
Received: from mxhub26.corp.emc.com (mxhub26.corp.emc.com [10.254.110.182])
	by mailhub.lss.emc.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id r5EEiP9X020036
	for <fio@vger.kernel.org>; Fri, 14 Jun 2013 10:44:25 -0400
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Fri, 14 Jun 2013 10:44:22 -0400
Subject: meaning of err=84
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C8324642B5C2@MX44A.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Running the following fio command in Red Hat 6.1

fio --name=myjob --ioengine=libaio --rw=randrw --bs=8k --numjobs=64 --thread  --direct=1 --size=400m --directory=/mnt --rwmixread=50 --rwmixwrite=50 --do_verify=1 --verify=md5 --verify_fatal=1

I got the error message:

myjob: (groupid=0, jobs=1): err=84 (file:io_u.c:1477, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide                                   character): pid=29170: Thu Jun 13 11:56:04 2013

fio returns 1280 (0x500)

What is the meaning of this error message?

Thank you
Konstantin
