Return-Path: <axboe@kernel.dk>
Date: Wed, 22 Nov 2017 11:10:34 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] rdma: Add bind option
Message-ID: <20171122181032.GA20487@kernel.dk>
References: <1510181253-7632-1-git-send-email-sbates@raithlin.com>
 <CF527084-479C-4085-8C3F-2F6D5F607825@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF527084-479C-4085-8C3F-2F6D5F607825@raithlin.com>
To: Stephen Bates <sbates@raithlin.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "logang@deltatee.com" <logang@deltatee.com>, "elliott@hpe.com" <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

On Wed, Nov 22 2017, Stephen  Bates wrote:
> >In certain configurations it can be useful to bind a rdma_cm to a
> >particular network interface. For example in multi-path or loopback.
> >
> >Add a bindname option that the local rdma_cm will try and bind too.
> >
> >The bind code is based off that used in rping [1].
> >
> >[1] https://github.com/linux-rdma/rdma-core/blob/ \
> >    master/librdmacm/examples/rping.c
> >
> >Signed-off-by: Stephen Bates <sbates@raithlin.com>
> >Reviewed-by: Logan Gunthorpe <logang@deltatee.com>>
> 
> Hi Jens
> 
> Do you have any concerns or issues with this patch?

No looks fine to me, seemed to have missed the original.

-- 
Jens Axboe


