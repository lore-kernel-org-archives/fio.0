Return-Path: <erwan@enovance.com>
Message-ID: <52012346.9040609@enovance.com>
Date: Tue, 06 Aug 2013 18:24:38 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk>
In-Reply-To: <52011D0F.5060308@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 06/08/2013 17:58, Jens Axboe wrote:
> Hi Folks,
>
> I tagged the release of 2.1.2 this morning. The basic changes since
> 2.1.1 are:
>
> - The big graphing rework from Erwan.
> - A fix for a potential verification failure, courtesy of Josef Bacik.
> - Support for randomness of reads and writes independently.
> - Support for setting block sizes (or ranges) for random of sequential
>    IO.
> - Support for multicast network IO in the net ioengine, from Shawn
>    Bohrer.
> - RDMA io engine should now compile and work again, was broken with the
>    recent rewrites. From Yufei Ren.
>
> 65 commits in total, of which I only did 8 of them. I believe that is a
> new record! Thanks a lot for your contributions, keep them coming.
>
I'd like to add also the genfio tool which is very useful to describe 
complex and repetitive fio's jobs.

I'm also adding an url where people can see the kind of graphing 
fio2gnuplot does : 
http://www.flickr.com/photos/ennael/sets/72157634249027122/

Cheers,
Erwan

