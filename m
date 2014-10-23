Return-Path: <axboe@kernel.dk>
Message-ID: <54491C12.3020205@kernel.dk>
Date: Thu, 23 Oct 2014 09:17:38 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --status-interval output race
References: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com> <5447D0F5.7090403@kernel.dk> <CAE56cDsm7-FnX2wwhmryrf-6__ZppK353nvUuXpY-96mTkeHrA@mail.gmail.com> <CALjAwxh-McXiYRid+e0RDW3SxCwGDfLdUeOmvLVpzXPi20auNw@mail.gmail.com> <CAE56cDsQVo2gZRX7n3Y4Ny+=2N2mN9upAL4QtH_yrt0TgwYCDA@mail.gmail.com>
In-Reply-To: <CAE56cDsQVo2gZRX7n3Y4Ny+=2N2mN9upAL4QtH_yrt0TgwYCDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/22/2014 12:19 PM, Michael Mattsson wrote:
> I reran with 2.1.4 and had the same results. 1 in 10 reported successfully.

Can you try current -git? I added some code to properly shutdown status
interval dumps before we finalize everything. It's a cleanup in any
case, but would be nice to know if it impacts your situation.

-- 
Jens Axboe


