Return-Path: <axboe@kernel.dk>
Subject: Re: client/server test to write to single file from all clients
References: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5727FBC2.1020000@kernel.dk>
Date: Mon, 2 May 2016 19:15:46 -0600
MIME-Version: 1.0
In-Reply-To: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Gurvinder Singh <gurvindersinghdahiya@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/01/2016 01:11 PM, Gurvinder Singh wrote:
> Hi,
>
> First of all thanks for such a nice tool to do IO testing. I am
> wondering if it is possible to test accessing a single file from
> multiple clients to test distributed file system behavior.
>
> The reason for this test is to see if it has different behavior than
> having numjobs > 1 accessing same file running on same host.

Sure, you can do that. Fio doesn't really care about whether the file is 
shared or not. Obviously some things like verification might not work 
properly, but just reading and writing to a shared file, fio doesn't 
care if it's local or not.


-- 
Jens Axboe


