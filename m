Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.viktor.guru ([62.210.97.36]:36728 "EHLO mail.viktor.guru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428AbbJ3JsH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Oct 2015 05:48:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.viktor.guru (Postfix) with ESMTP id D271A12A098F
	for <fio@vger.kernel.org>; Fri, 30 Oct 2015 10:48:05 +0100 (CET)
Received: from mail.viktor.guru ([127.0.0.1])
	by localhost (mail.viktor.guru [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gdllDzoGuRZm for <fio@vger.kernel.org>;
	Fri, 30 Oct 2015 10:48:05 +0100 (CET)
Received: from [10.10.0.21] (unknown [91.185.100.46])
	by mail.viktor.guru (Postfix) with ESMTPSA id 0CA2312A0871
	for <fio@vger.kernel.org>; Fri, 30 Oct 2015 10:48:04 +0100 (CET)
From: vmokric <vojislav.mokric@htec.rs>
Subject: FIO IO units block size setting function
Message-ID: <56333CD3.40101@htec.rs>
Date: Fri, 30 Oct 2015 10:48:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

can someone point me to FIO function which performs IO units block size 
settings? If I, e.g. pass "bs=8k", where does it actually ends up?

I have searched ioctl commands, but couldn't figure out actual function.

I would really appreciate any help, since I need some guidelines within 
perplexed world of Linux IO system.

Regards
