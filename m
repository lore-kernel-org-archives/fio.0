Return-Path: <axboe@kernel.dk>
Message-ID: <5342E2D3.6040706@kernel.dk>
Date: Mon, 07 Apr 2014 11:39:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --status-interval option doesn't work in 2.1.6.1 version
References: <CAEyTGCdvCouz3O-ohfq-Cj9+0X4FkShmZg7gfzE4p+PwHuaDZA@mail.gmail.com>	<5342DFEE.1010608@kernel.dk> <CAEyTGCfLjxcHHh7s6RC3u2ekH5A_OXOqJ3mxyEpEQZ70-umudQ@mail.gmail.com>
In-Reply-To: <CAEyTGCfLjxcHHh7s6RC3u2ekH5A_OXOqJ3mxyEpEQZ70-umudQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/07/2014 11:37 AM, Lakshmi wrote:
> Checked in 2.1.7 , still doesn't work

It definitely does. The fix was this one:

commit 7cd0ec5dc7fafa028fec04bb6e47b81e7dfc600e
Author: Jens Axboe <axboe@fb.com>
Date:   Fri Mar 28 08:09:10 2014 -0600

     Fix wrong time conversion on --status-interval= command line option

and it's included right before 2.1.7 was tagged. So please double check 
your testing.

-- 
Jens Axboe


