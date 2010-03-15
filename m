Return-Path: <fio-owner@vger.kernel.org>
Received: from ge0.mail1.hoer.dk.ip.fullrate.dk ([90.185.1.42]:63028 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0COU5J (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Mar 2010 16:57:09 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.70.86])
	by smtp.fullrate.dk (Postfix) with ESMTP id D29039CE62
	for <fio@vger.kernel.org>; Mon, 15 Mar 2010 21:50:29 +0100 (CET)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 84049108124
	for <fio@vger.kernel.org>; Mon, 15 Mar 2010 21:50:26 +0100 (CET)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 2A60E8e1XZN2 for <fio@vger.kernel.org>;
	Mon, 15 Mar 2010 21:50:24 +0100 (CET)
Received: from kurt-III.home.troels.arvin.dk (kurt-III.home.troels.arvin.dk [192.168.1.9])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 5B6541080F1
	for <fio@vger.kernel.org>; Mon, 15 Mar 2010 21:50:24 +0100 (CET)
Message-ID: <4B9E9D92.80701@arvin.dk>
Date: Mon, 15 Mar 2010 21:50:26 +0100
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Does fio write only 0x00s?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm benchmarking a new FC-attached storage system which we are bringing 
into production, in order to see if it yields acceptable performance - 
and to have a baseline for potential performance trouble in the future.

One of the tools I'm using is fio, which is certainly great. Especially 
the fact that it includes data regarding latencies, and that it makes it 
easy to have a mix of reads and writes.

Now, compared to an another FC-attached storage system, and compared to 
a local RAID10, the new system yields fio numbers which are extremely 
much better.
This made me have a quick and superficial look into the files which fio 
works with. I seems that the files contain only 0-bytes.

Does fio only write bytes with a single value?
If so: I would be afraid that some kind of 
compression/de-duplication/thin provisioning feature in the storage 
system invalidates the fio results I'm seeing. Is this a valid fear?

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/
