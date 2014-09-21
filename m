Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52026 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaIUD5a (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 20 Sep 2014 23:57:30 -0400
Received: by mail-pa0-f47.google.com with SMTP id et14so2468107pad.6
        for <fio@vger.kernel.org>; Sat, 20 Sep 2014 20:57:29 -0700 (PDT)
Received: from Akira-Hayakawas-MacBook-Pro.local (e0109-106-188-109-152.uqwimax.jp. [106.188.109.152])
        by mx.google.com with ESMTPSA id hz1sm5708773pbb.75.2014.09.20.20.57.28
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 20 Sep 2014 20:57:29 -0700 (PDT)
Message-ID: <541E4CA6.8070705@gmail.com>
Date: Sun, 21 Sep 2014 12:57:26 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: [Question] What if the parameter for --size option is smaller than
 the target device?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I resend because the server doesn't ack.
Please ignore the previous, if you receive two. (Please remove from the server)

Hi,

I am writing a test with fio tool (2.0.8) and I am facing a problem.

I just want to submit 512B random write to a block device.
In my case, the size of the device is 2MB and the amount of writes (specified by --size option) is 32MB.

like this (A line from device-mapper-test-suite. Is my command wrong?):
      ProcessControl.run("fio --name=test --filename=#{dev.path} --rw=randwrite --ioengine=libaio --direct=1 --size=#{@param[0]}m --bs=512")

The problem is, the runtime is too short.
The block device is just a single HDD so, it will be 30sec or so. But it's actually 3sec...

My guess is that fio uses min(device size, param to --size) as the amount of writes here.
To investigate it, I increased the size of the device to x10 and saw the runtime gets x10.

My questions are:
1. Is my guess correct?
2. What shall I do to make fio work as I want it to do?

Thanks,
- Akira
