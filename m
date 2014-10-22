Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxh-McXiYRid+e0RDW3SxCwGDfLdUeOmvLVpzXPi20auNw@mail.gmail.com>
References: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com>
 <5447D0F5.7090403@kernel.dk> <CAE56cDsm7-FnX2wwhmryrf-6__ZppK353nvUuXpY-96mTkeHrA@mail.gmail.com>
 <CALjAwxh-McXiYRid+e0RDW3SxCwGDfLdUeOmvLVpzXPi20auNw@mail.gmail.com>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Wed, 22 Oct 2014 11:19:10 -0700
Message-ID: <CAE56cDsQVo2gZRX7n3Y4Ny+=2N2mN9upAL4QtH_yrt0TgwYCDA@mail.gmail.com>
Subject: Re: --status-interval output race
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I reran with 2.1.4 and had the same results. 1 in 10 reported successfully.

Thanks!
Michael

On Wed, Oct 22, 2014 at 10:37 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 22 October 2014 17:19, Michael Mattsson <michael.mattsson@gmail.com> wrote:
>> On a sample of ten runs I had one successful run with commit
>> 83f7b64ea773. Successful meaning that the last output being the
>> correct summary.
>
> What were your results with the commit _before_ 83f7b64ea773?
>
> --
> Sitsofe | http://sucs.org/~sits/

