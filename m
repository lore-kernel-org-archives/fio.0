Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:44549 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1BNJPU (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 14 Feb 2011 04:15:20 -0500
Message-ID: <4D58F29B.3000101@fusionio.com>
Date: Mon, 14 Feb 2011 10:15:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Delivery Status Notification (Failure)
References: <AANLkTin2ZjkkFOrwo++EZw0arQnsMrqzy0drUF6WrqDm@mail.gmail.com>	<20cf30564493a84040049c39612f@google.com> <AANLkTikCqfuWKFQU0w=0N6n-C9d-VNUvB1XF+mzXzewp@mail.gmail.com>
In-Reply-To: <AANLkTikCqfuWKFQU0w=0N6n-C9d-VNUvB1XF+mzXzewp@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: wu meng <james.wumeng@gmail.com>
Cc: fio@vger.kernel.org

On 2011-02-14 09:08, wu meng wrote:
> Hi,
> 
> I've a problem on using fio:
> "buffered=bool If value is true, use buffered io. This is the opposite
> of the 'direct' option. Defaults to true."
> So what kind of buffer mean for this option? Is that mean kernel cache
> or user space buffer?

'direct' and 'buffered' control the same thing, they are just opposites.
Both refer to the use of kernel file cache bypass.

-- 
Jens Axboe

