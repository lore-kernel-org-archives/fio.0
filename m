Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.fullrate.dk ([90.185.1.42]:52212 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab1FAOdo (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jun 2011 10:33:44 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.71.151])
	by smtp.fullrate.dk (Postfix) with ESMTP id C251A9CE4A
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 16:33:43 +0200 (CEST)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id BFB4F108122
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 16:33:42 +0200 (CEST)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id R2EcN0rTrlS4 for <fio@vger.kernel.org>;
	Wed,  1 Jun 2011 16:33:41 +0200 (CEST)
Received: from kurt-IV.home.troels.arvin.dk (kurt-IV.home.troels.arvin.dk [192.168.1.9])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 360ED108103
	for <fio@vger.kernel.org>; Wed,  1 Jun 2011 16:33:41 +0200 (CEST)
Message-ID: <4DE64DC5.3060703@arvin.dk>
Date: Wed, 01 Jun 2011 16:33:41 +0200
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Re: Unaligned AIO/DIO
References: <4DE531D0.40600@arvin.dk> <4DE61875.4070501@fusionio.com> <4DE635E0.8060808@arvin.dk> <4DE63BE8.60105@fusionio.com>
In-Reply-To: <4DE63BE8.60105@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Jens Axboe wrote:
> The iometer like test
> case you are using is meant to be used on a raw block device, not on a
> file system.

OK, but how does one use fio with a raw device? Can you give an example 
of a job specification file for working with a raw block device?

And can that be done in a way which simulates parallel I/O (several 
processes/threads working simultaneously)?

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/
