Return-Path: <axboe@kernel.dk>
Message-ID: <539F4727.9090805@kernel.dk>
Date: Mon, 16 Jun 2014 13:36:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: Eliminate compilation warning in ppc
References: <1402897096-10997-1-git-send-email-linuxuser1990@gmail.com>
In-Reply-To: <1402897096-10997-1-git-send-email-linuxuser1990@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Sumanth K <linuxuser1990@gmail.com>, fio@vger.kernel.org
Cc: Sumanth K <sumantk2@linux.vnet.ibm.com>
List-ID: <fio@vger.kernel.org>

On 06/15/2014 11:38 PM, Sumanth K wrote:
> From: Sumanth K <sumantk2@linux.vnet.ibm.com>
> 
> Eliminate compilation warning : 'atb_clocktest' defined but
> not used. Function is declared as static in header file. So compiler will
> know if they used or not. Just eliminate the warning by #if 0 /unless we do
> use it.

Thanks, applied. Arguably the code should just be removed whole sale, as
it'll always reside in the git history for someone to resurrect.

-- 
Jens Axboe


