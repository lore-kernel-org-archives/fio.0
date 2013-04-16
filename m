Return-Path: <fio-owner@vger.kernel.org>
Received: from server506f.appriver.com ([50.56.144.36]:58124 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965043Ab3DPRy2 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 16 Apr 2013 13:54:28 -0400
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 70056705 for fio@vger.kernel.org; Tue, 16 Apr 2013 12:54:27 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: Fio ignoring runtime after an error?
Date: Tue, 16 Apr 2013 17:54:25 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB026DFC@DAGN05A-E6.exg6.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I think I've run across a case where, during a time-limited test, a soft error occurred on the device and fio continued to run -way- past (overnight) the time limit.

The rough scenario is:
fio test - ok
fio test - ok
fio test - starts
  soft error
fio never ends (and is still pushing traffic as reported by the disk system)

I haven't had a chance to dive into the code yet (fio 2.0.14, linux 2.6.32-279.14.1.el6.x86_64), but can anyone think of a reason why this would happen?

The command line looks like:
fio --name='raid0;16;randread;8;16' --rw=randread --filename=/dev/ethdrv/e107.1 --iodepth=16 --bs=8k --rwmixread=70 --norandommap --group_reporting --time_based --minimal --direct=1 --fill_device=1 --ioengine=libaio --ramp_time=5 --runtime=35 --randrepeat=0

Hopefully, I'll get the clue to inject an error into the disk system and run this down, but that'll take time I don't really have.

Thanks,

z!

