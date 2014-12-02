Return-Path: <axboe@kernel.dk>
Message-ID: <547E4D11.4040208@kernel.dk>
Date: Tue, 02 Dec 2014 16:36:49 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fix for a race when fio prints I/O statistics periodically
References: <20141105171024.GC25731@vass-desktop> <545E44C6.5060505@kernel.dk> <CAFTzLMNOYv+8uP2wiQOPcLjhZG9zoQiOCNn8_69dYV45Ex8aTQ@mail.gmail.com> <5460DAC3.8000000@kernel.dk> <CAE56cDuRZwUPEhdEmEUzbqs+mRL-RVSG+uqPAgWijQEZKJJ6gA@mail.gmail.com>
In-Reply-To: <CAE56cDuRZwUPEhdEmEUzbqs+mRL-RVSG+uqPAgWijQEZKJJ6gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>
Cc: Vasily Tarasov <tarasov@vasily.name>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/02/2014 04:00 PM, Michael Mattsson wrote:
> Hey,
> I just want to close the loop here. Last week up until now I've
> successfully run several hundred jobs and not a single skewed output
> has come across.
>
> Is this patch integrated into the main code base or the latest release?

The fix is in 2.1.14 as released, so both.

-- 
Jens Axboe


