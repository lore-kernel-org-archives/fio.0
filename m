Return-Path: <axboe@kernel.dk>
Subject: Re: Ensure submission offload worker inherits parent's options
References: <CANvN+entGv7PSde2Q_Ehm7CCMeVO_WLQow-ea9vY6ViXB+=mQg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55EEFAA1.4010401@kernel.dk>
Date: Tue, 8 Sep 2015 09:11:29 -0600
MIME-Version: 1.0
In-Reply-To: <CANvN+entGv7PSde2Q_Ehm7CCMeVO_WLQow-ea9vY6ViXB+=mQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/07/2015 09:11 AM, Andrey Kuzmin wrote:
> Seems to be broken otherwise.
>
> Regards,
> Andrey
>
>      Properly initialize sibling's eo, as otherwise it will miss parent's
>      options.

Thanks, applied.

-- 
Jens Axboe


