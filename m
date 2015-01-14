Return-Path: <axboe@kernel.dk>
Date: Tue, 13 Jan 2015 22:08:22 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Questions about mmap ioengine
Message-ID: <20150114050816.GB18148@kernel.dk>
References: <CACTTzNb+KW+9sL8_d3X2=b4m96-V0e4j7Z4NwFpmdrjSdirxkw@mail.gmail.com>
 <CACTTzNY2MfpkqDoP3xYW7XDDUoQ23iy2u3AcujYrt37tFo5smA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTTzNY2MfpkqDoP3xYW7XDDUoQ23iy2u3AcujYrt37tFo5smA@mail.gmail.com>
To: Yigal Korman <yigal@plexistor.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Jan 07 2015, Yigal Korman wrote:
> On Wed, Dec 17, 2014 at 10:56 PM, Yigal Korman <yigal@plexistor.com> wrote:
> > Hi,
> > I have a couple of questions regarding the mmap ioengine.
> >
> > One of the benefits of doing mmap() VS write() is bypassing the need
> > of an intermediate buffer.
> > Instead of preparing a buffer for write(), data can be written
> > directly to file with mmap().
> > I want to do some performance comparisons on this subject with fio on
> > different filesystems.
> > After reviewing the code a bit, I saw that the mmap ioengine is only
> > responsible for writing the data.
> > The buffer preparation is done in the common code the same way for all
> > ioengines.
> > Am I understanding this correctly?
> > Is there another way to circumvent the buffer filling and implement
> > writing data directly with mmap?
> 
> I didn't get any answers yet, can someone comment?
> I'll be glad to implement the appropriate behavior myself with some guidance.

Fio can't really do it any other way, if you want to track this as IO.
So it prepares the data contents in its regular IO buffers, then copies
it to the mmap'ed area (or vice versa, for a read). It'd be trivial to
simply have the IO buffer point at the appropriate mmap'ed region, but
then you'd lose any tracking of latencies, bandwidth, etc. In other
words, it would not provide a lot of value.

-- 
Jens Axboe


