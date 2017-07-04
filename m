Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjMC_Hk2KUBRjpxS_2Ujc4iMr796h5fDukK1RgGLrJyng@mail.gmail.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com> <20170704180816.39585-2-tkusumi@tuxera.com>
 <CALjAwxjMC_Hk2KUBRjpxS_2Ujc4iMr796h5fDukK1RgGLrJyng@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 4 Jul 2017 22:33:25 +0300
Message-ID: <CAHndrBm96oiGqS4FOcRh0doToaptqhQPHnArMaLJX_AUiyXVLw@mail.gmail.com>
Subject: Re: [PATCH 1/7] man: sync OPTIONS section with HOWTO
Content-Type: text/plain; charset="UTF-8"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hi

Thanks.
I think it's better if there's a way to somehow automatically generate
the man page from HOWTO like you mentioned (and update from that).

I simply don't know high-level documentation tools that this was the only way.
(The current man page also seems to have been written by hand)


2017-07-04 22:03 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> Hi,
>
> On 4 July 2017 at 19:08,  <kusumi.tomohiro@gmail.com> wrote:
>>
>> This commit brings in updates from HOWTO. The exception is --debug
>> option, which is too verbose yet not that important for all debug types
>> to be listed in details.
>
> I've got to take my hat off to you Tomohiro - I thought it was
> difficult enough to update just the HOWTO in the first place. Your
> Herculean effort here brings the two more into sync!
>
> I'm secretly jealous of your productivity... Plus you've set back my
> covert plan to make the current fio man page so useless that we switch
> to having it built from HOWTO (using make -C doc man ) via Sphinx :-).
>
> --
> Sitsofe | http://sucs.org/~sits/

