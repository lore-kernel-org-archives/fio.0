Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bsdio.com ([65.103.231.193]:42123 "EHLO muon.bsdio.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730775AbfHOPFT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Aug 2019 11:05:19 -0400
Subject: Re: Recent changes (master)
References: <20190815120002.693802C22FD@kernel.dk>
 <0647fb02-f8db-d611-8079-e7f4348c6715@bsdio.com>
 <cab007cd-10f1-c504-4f1e-3fb45a25d337@kernel.dk>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <bb33d4e0-46d9-486f-62b9-d4cdde61a7b1@bsdio.com>
Date: Thu, 15 Aug 2019 09:05:18 -0600
MIME-Version: 1.0
In-Reply-To: <cab007cd-10f1-c504-4f1e-3fb45a25d337@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org

On 8/15/2019 8:28 AM, Jens Axboe wrote:

>
> I did notice, I just didn't see what was wrong here. Can you remove the
> assert and check the struct sizes of jobs_eta and jobs_eta_packed?


jobs_eta is 168 bytes; jobs_eta_packed is 164.

Adding an extra 32-bit field before run_str fixes the error.


-- 
Rebecca Cran


