Return-Path: <fio-owner@vger.kernel.org>
Received: from ge0.mail1.hoer.dk.ip.fullrate.dk ([90.185.1.42]:54270 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966133Ab0CPL1l (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Mar 2010 07:27:41 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.70.86])
	by smtp.fullrate.dk (Postfix) with ESMTP id 713479CFD9
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 12:27:39 +0100 (CET)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 4D524108124
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 12:27:36 +0100 (CET)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id MuHr7gi2macA for <fio@vger.kernel.org>;
	Tue, 16 Mar 2010 12:27:31 +0100 (CET)
Received: from [192.168.216.2] (sst-gw [147.29.225.156])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 297A81080EE
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 12:27:31 +0100 (CET)
Message-ID: <4B9F6B25.7070807@arvin.dk>
Date: Tue, 16 Mar 2010 12:27:33 +0100
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Re: Does fio write only 0x00s?
References: <4B9E9D92.80701@arvin.dk> <20100315212219.GQ5768@kernel.dk> <4B9EC06E.2000101@arvin.dk> <20100316080528.GX5768@kernel.dk>
In-Reply-To: <20100316080528.GX5768@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Den 16-03-2010 09:05, skrev Jens Axboe:
> I think what you are missing is that the random writes will create a
> large sparse file. The Output is 10G, and you are doing a lot of reads.
> So you could end up writing only 30% of the 10G, the rest would be
> sparse holes in the file.

Yes, that part about the file sparseness was I had to grasp.

Expressed in another way: If I filter out the null-bytes from fio's 
work-file (cat iometer.1.0 | tr -d '\0'), then the remainder doesn't 
compress at all using gzip with default options.

So I'll stop worrying about storage-side compression/de-duplication when 
interpreting fio's results.

Thanks.

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/
