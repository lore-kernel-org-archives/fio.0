Return-Path: <axboe@kernel.dk>
Message-ID: <53B5A0E3.6060003@kernel.dk>
Date: Thu, 03 Jul 2014 12:28:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [patch] fio.1 - escape the escape character so it shows up
References: <x49bnt6wbgz.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49bnt6wbgz.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/03/2014 12:20 PM, Jeff Moyer wrote:
> Hi, Jens,
> 
> In the filename= text, the escape character gets eaten.  This fixes it
> for me.

Thanks Jeff, works for me as well. Applied.

-- 
Jens Axboe


