Return-Path: <raeburn@permabit.com>
Message-ID: <50C79326.8010903@permabit.com>
Date: Tue, 11 Dec 2012 15:10:14 -0500
From: Ken Raeburn <raeburn@permabit.com>
MIME-Version: 1.0
Subject: Re: fio --direct=1 and Linux page cache effects
References: <6e624hcpo4.fsf@just-testing.permabit.com> <50C108E9.4050408@kernel.dk> <50C1B02F.3000902@kernel.dk> <6evcc9bdxv.fsf@just-testing.permabit.com> <50C73545.90505@kernel.dk>
In-Reply-To: <50C73545.90505@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/11/12 08:29, Jens Axboe wrote:
> You are right, blkid likely wont be done by then, so it's still down 
> to timing whether it'll help or not. This is pretty annoying. This 
> issue is due to the file being opened for write. But unfortunately we 
> cannot open for read always, as fcntl() wont allow change of file 
> access mode flags. So how about the below. Basically DON'T close the 
> fd, defer that until we really close the file. This will keep one 
> extra fd open until the original is closed, but I don't see that as 
> being an issue.

This patch seems to be working just fine. I have reproduced the case 
where it uses the shadow_fd field, but blkid doesn't run and the page 
cache entries don't get loaded, and in my initial tests with dm-zero, it 
looks like the bimodal performance distribution is gone.

Thanks!

Ken

