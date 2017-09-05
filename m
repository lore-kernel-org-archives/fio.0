Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] don't change direct I/O xfer size during initial layout
 setup
References: <20170904152317.6065-1-tkusumi@tuxera.com>
 <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
 <CAHndrBkUMYUG-e6dqk9NsBBt7fJkHMH2M70-v9LrQ=K-KiFhtw@mail.gmail.com>
 <CALjAwxgnm7c+64kW7Y+-e36qPg8nYR_7n-=htuL5Pb6FQUPT8g@mail.gmail.com>
 <CAHndrBn0bdfC0kT5cg7TnGE3X6=SAaxCMCf9zORvx8zOxdnObw@mail.gmail.com>
 <21362e1f-e266-9b49-ba62-6ca8d705e7c9@kernel.dk>
 <CAHndrBk6BKQW-YdBzK7=i2VFuuBKu+nT-Uj-9X0BH8w+Nq=g=w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c645b819-a5bf-1dae-cb39-caee7fd434c1@kernel.dk>
Date: Tue, 5 Sep 2017 08:58:55 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBk6BKQW-YdBzK7=i2VFuuBKu+nT-Uj-9X0BH8w+Nq=g=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/05/2017 08:54 AM, Tomohiro Kusumi wrote:
> I think I've made three fixes over the original two commits.
> 
> 1. non O_DIRECT dio support -> committed -> now reverted
> 2. segfault on fio_memfree() -> committed -> now reverted
> 3. this one
> 
> As far as I've seen this is it.

Right, just checked (and reverted) and it's 5 changes all in
all for the change, not including the parent to this email,
which would have made it 6 in all. The original change from Weiping
clearly wasn't well tested or thought through, so it's better
to just kill it all and do it cleanly from scratch instead.

That said, I'm not even convinced we need this change. Logically
it makes sense, but there's really nothing wrong with doing
a buffered layout + cache kill as we have been doing since
the dawn of time in fio.

> (I think pre read can do the same as this function, to avoid
> irrelevant errors, though pre read on dio is contradictory)

Yeah, pre-read with O_DIRECT would be a waste of time.

-- 
Jens Axboe


