Return-Path: <axboe@kernel.dk>
Subject: Re: client/server histograms
References: <CAJ9yE1D8JXLgmbmx5_PXfiPM33vHyMZpVTK4sAinccEvMKX8yg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <49bef06a-483a-6f42-2778-1e57fdaa4306@kernel.dk>
Date: Thu, 25 Aug 2016 22:41:29 -0600
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1D8JXLgmbmx5_PXfiPM33vHyMZpVTK4sAinccEvMKX8yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karl Cronburg <kcronbur@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/24/2016 11:32 AM, Karl Cronburg wrote:
> What would be the best way to get an fio server to send the histogram
> samples to a client? i.e.:
>
> - Should I make a new FIO_NET_CMD or can I easily modify the existing
> IOLOG one? Presently each sample has a pointer to a histogram array in
> place of the sample value.

I'd probably reuse the existing IOLOG command, just with an appropriate
log type. You'd need to turn it into something that can be sent over the
network easily, of course.

> - The histograms compress nicely (because sparseness), but should I be
> compressing them immediately after compressing the time/direction/size
> values of the sample? I tried doing it after all the io_sample structs
> are compressed, but then samples in one pdu need the histogram values
> in a not-yet-parsed pdu.

Might need to see the code you already have to help you with that one.

-- 
Jens Axboe

