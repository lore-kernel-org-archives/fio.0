Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33118 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1FMHsW (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 13 Jun 2011 03:48:22 -0400
Message-ID: <4DF5C0C2.1050300@fusionio.com>
Date: Mon, 13 Jun 2011 09:48:18 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Asynch IO and fill_device
References: <BANLkTi=LKqCz1Pg0w3Pk8i2OzgHcQFat4A@mail.gmail.com>
In-Reply-To: <BANLkTi=LKqCz1Pg0w3Pk8i2OzgHcQFat4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-06-10 21:05, Steven Lang wrote:
> I found an interesting combination of using fill_device when the
> iodepth is greater than 1.  All outstanding IO causes an ENOSPC error,
> but only the first is treated specially.  The remainder come through
> and cause an error exit condition when the IO queue is being cleared.
> So it is impossible to use deep IO with fill device.
> 
> This patch should fix the issue.

Thanks, applied.

-- 
Jens Axboe

