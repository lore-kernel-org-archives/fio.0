Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42702 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0AKNw5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jan 2010 08:52:57 -0500
Date: Mon, 11 Jan 2010 14:52:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: io scheduler merges control
Message-ID: <20100111135256.GM4489@kernel.dk>
References: <31699.35262.qm@web55002.mail.re4.yahoo.com> <4B4AC214.5020207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4AC214.5020207@oracle.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gurudas Pai <gurudas.pai@oracle.com>
Cc: john smith <whalajam@yahoo.com>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>, fio@vger.kernel.org

On Mon, Jan 11 2010, Gurudas Pai wrote:
>
>> 3) The third question is why the number of fio reported "merge"(s) is greater than the number of the "ios"?
> These merges are since disk is online. not during the current fio run.  
> Restart the machine/disk and run fio test , then fio should report  
> accurate merge stats.

That's not correct, it is the number of merges that occured while fio
was running. What Alan said is correct, the ios count is the issued
number of ios. Merges can easily be much larger, for this case of small
bs sequential IO it will indeed be pretty huge.

-- 
Jens Axboe

