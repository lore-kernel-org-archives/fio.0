Return-Path: <fio-owner@vger.kernel.org>
Received: from sm02.isp.telecom.li ([217.173.238.131]:33197 "EHLO
	sm02.isp.telecom.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaCOLWi (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Mar 2014 07:22:38 -0400
Received: from [80.248.201.43] (helo=[192.168.1.35])
	by sm01.isp.telecom.li with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <jvogt@adon.li>)
	id 1WOmUD-0000uI-6L
	for fio@vger.kernel.org; Sat, 15 Mar 2014 12:10:42 +0100
Message-ID: <53243539.5010405@adon.li>
Date: Sat, 15 Mar 2014 12:10:49 +0100
From: jvogt <jvogt@adon.li>
MIME-Version: 1.0
Subject: correct file size to use
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi list

I was wondering:
When i start
fio --name=/srv/mail/test --size=10M --direct=1 --runtime=60 
--time_based --group_reporting --refill_buffer --rw=read --numjobs=1

I get as result:
read : io=1177.4MB, bw=20093KB/s, iops=5023, runt= 60000msec

But when I do a
fio --name=/srv/mail/test --size=10G --direct=1 --runtime=60 
--time_based --group_reporting --refill_buffer --rw=read --numjobs=1

The result is:
read : io=976692KB, bw=16278KB/s, iops=4069, runt= 60001msec
(decrease of 20%, in some scenarios it's even worse with more than 30%)

So how does the file size influence the speed (iops, bandwith)? My 
understanding was that it is not important from which filesize we are 
reading from - important is the block size and if the filesize is not 
big enough, fio just restarts to read the file from the beginning. How 
can that be explained? And which sizes should be used to get reliable 
results?

Thanks
Josef
