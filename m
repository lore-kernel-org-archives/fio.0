Return-Path: <axboe@kernel.dk>
Subject: Re: Stonewall reverse?
References: <CANvN+emA01TZfbBx4aU+gg5CKfy+AEX_gZW7Jz4HMHvwkdBNoQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56746DCA.201@kernel.dk>
Date: Fri, 18 Dec 2015 13:34:18 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+emA01TZfbBx4aU+gg5CKfy+AEX_gZW7Jz4HMHvwkdBNoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/18/2015 01:28 PM, Andrey Kuzmin wrote:
> Stonewall option enforces post-serialization in that a job with the
> option set waits for all other jobs in the file to complete. I'm
> facing a use case where the reverse might be useful: have a number of
> jobs wait for the specific one to complete. Is that something that can
> be done with the existing options or a new development?

So something like

wait_for=id

and 'id' would refer to a certain job? I can see that being a useful 
primitive, fio can't currently do that. Though it would be pretty easy 
to add.

-- 
Jens Axboe


