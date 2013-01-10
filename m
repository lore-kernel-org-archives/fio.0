Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54662 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3AJMSU (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:20 -0500
Message-ID: <50EEB187.9000906@fusionio.com>
Date: Thu, 10 Jan 2013 13:18:15 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix  an overflowing.
References: <201301101937119708856@gmail.com>
In-Reply-To: <201301101937119708856@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 2013-01-10 12:37, majianpeng wrote:
> Because nr_files and new_size are not same types.It can cause new_size
> less than zero.Then realloc will be failed.

Thanks, applied.

-- 
Jens Axboe

