Date: Mon, 28 Jan 2013 09:06:35 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Why zipf distribution can not be 1.0
Message-ID: <20130128080635.GR15635@kernel.dk>
References: <CAG5pYQcNzX7LJQeLJCZWK1TRYYQOy5Wy_peKHSoC2OXCiBbYcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5pYQcNzX7LJQeLJCZWK1TRYYQOy5Wy_peKHSoC2OXCiBbYcw@mail.gmail.com>
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sun, Jan 27 2013, Yufei Ren wrote:
> Hi,
> 
> Is the 'zipf theta' the value of the exponent characterizing the zipf
> distribution? If so, why could not it be 1.0? With the following job
> file, fio sent out an error - fio: zipf theta must different than 1.0.
> 
> [job]
> ioengine=null
> rw=randread
> norandommap
> size=1280m
> bs=4k
> random_distribution=zipf:1
> 
> I looked through the fio zipf library but was confused with
> zipf_next() function? Any illustration about this zipf distribution
> generator?

The point is that a theta of 1.0 would be the same as a normal uniform
distrobution. But perhaps it should just be allowed, you should get what
you ask for...

Not sure on your last question. Can you expand on that? If it's on the
zipf distribution in general, google/wikipedia is your friend :-)

-- 
Jens Axboe


