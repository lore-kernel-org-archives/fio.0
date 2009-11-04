Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20091104172932.GD8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
	 <20091104073525.GQ8742@kernel.dk>
	 <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
	 <20091104172932.GD8742@kernel.dk>
Date: Wed, 4 Nov 2009 09:39:19 -0800
Message-ID: <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com>
Subject: Re: Add extra_buff_count flag
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I would rather document it than add it by default in case it starts
hitting memory constraints because its allocating more memory buffers.

Also Iam having difficulty running verify_async/libaio engine/iodepth
and iodepth_batch_complete options together, I will look into it to
see whats causing the issue.

thanks
-radha


On Wed, Nov 4, 2009 at 9:29 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Nov 04 2009, Radha Ramachandran wrote:
>> Yes, iodepth=x works. I did not realise that I could use iodepth with
>> sync engine as well.
>
> Good, we should probably default iodepth to verify_async + 1, if a
> higher number isn't given. And/or document that you probably want to do
> this.
>
> --
> Jens Axboe
>
>

