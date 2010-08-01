Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:39906 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0HATdc (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 Aug 2010 15:33:32 -0400
Message-ID: <4C55CBF7.8050003@fusionio.com>
Date: Sun, 1 Aug 2010 21:33:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Reduce thread stack size
References: <201008011701.06711.bvanassche@acm.org>
In-Reply-To: <201008011701.06711.bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/01/2010 05:01 PM, Bart Van Assche wrote:
> This patch reduces the stack size required by fio threads and hence allows
> to run fio with 200 or more threads on systems with a moderate amount of
> virtual memory.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> 

Thanks, applied. From a quick look on the stack usage and what
the min pthread stack size is here (16K), only the blktrace load
looks problematic. 

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
