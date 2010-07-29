Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:39044 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0G2I5a (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Jul 2010 04:57:30 -0400
Message-ID: <4C51425D.2010507@fusionio.com>
Date: Thu, 29 Jul 2010 10:57:01 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio crash after running an I/O stress test for about half an  hour
References: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
In-Reply-To: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On 07/26/2010 04:17 PM, Bart Van Assche wrote:
> Hello,
> 
> When I run the fio command below, fio triggers a segmentation fault
> after about half an hour. Is this a known issue ?

[snip]

OK, took a quick look. It's an artifact of using norandommap with a
short job like yours, when it finds an alias in the rbtree it only
removes it. So it sticks around in memory and will never get cleaned.
So 10 loops would get you 600k of lost memory, 1000000 would bump you
way into the OOM territory.

The below should fix it, I have committed that fix.

diff --git a/log.c b/log.c
index 5fc8f64..80d3742 100644
--- a/log.c
+++ b/log.c
@@ -231,6 +231,7 @@ restart:
 			assert(ipo->len == __ipo->len);
 			td->io_hist_len--;
 			rb_erase(parent, &td->io_hist_tree);
+			free(__ipo);
 			goto restart;
 		}
 	}

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
