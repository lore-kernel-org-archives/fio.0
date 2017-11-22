Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CF527084-479C-4085-8C3F-2F6D5F607825@raithlin.com>
References: <1510181253-7632-1-git-send-email-sbates@raithlin.com> <CF527084-479C-4085-8C3F-2F6D5F607825@raithlin.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 22 Nov 2017 20:13:38 +0000
Message-ID: <CALjAwxjW3grF90L-5tksdtK4u-6fM5_2Y2Cqf7e02Hz0yjBa4w@mail.gmail.com>
Subject: Re: [PATCH v3] rdma: Add bind option
Content-Type: text/plain; charset="UTF-8"
To: Stephen Bates <sbates@raithlin.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "logang@deltatee.com" <logang@deltatee.com>, "elliott@hpe.com" <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

On 22 November 2017 at 18:01, Stephen  Bates <sbates@raithlin.com> wrote:
>>In certain configurations it can be useful to bind a rdma_cm to a
>>particular network interface. For example in multi-path or loopback.
>>
>>Add a bindname option that the local rdma_cm will try and bind too.
>>
>>The bind code is based off that used in rping [1].
>>
>>[1] https://github.com/linux-rdma/rdma-core/blob/ \
>>    master/librdmacm/examples/rping.c
>>
>>Signed-off-by: Stephen Bates <sbates@raithlin.com>
>>Reviewed-by: Logan Gunthorpe <logang@deltatee.com>>
>
> Hi Jens
>
> Do you have any concerns or issues with this patch?

One quick suggestion - any chance you could update the HOWTO and fio.1
documentation to include the new ioengine parameter?

-- 
Sitsofe | http://sucs.org/~sits/

