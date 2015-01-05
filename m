Return-Path: <axboe@kernel.dk>
Message-ID: <54AAF98A.6090507@kernel.dk>
Date: Mon, 05 Jan 2015 13:52:26 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio-2.1.14-17-g8671 in client/server mode: client continues to
 wait even after server is dead
References: <CAO+GKh3gAXvugqduozYn-0VtG1=t4pdEnznCbM+H3Fd9Xknhqg@mail.gmail.com>
In-Reply-To: <CAO+GKh3gAXvugqduozYn-0VtG1=t4pdEnznCbM+H3Fd9Xknhqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Surendar Chandra <surendar@datrium.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/03/2015 06:52 PM, Surendar Chandra wrote:
> In my case, the server machine rebooted and started a new fio server
> after the client had issued a long running script. The original client
> continues to futilely wait for the server to come back and return
> results for its script. I am on Fedora 17.

Can you check if current -git is better? There was a bug in the timeout
checking for ETA replies, it was using two different time sources for
it... You want to make sure you have this commit:

http://git.kernel.dk/?p=fio.git;a=commit;h=c7b0978381243f25a06464cdbf57bb55a1dbaa33

-- 
Jens Axboe


