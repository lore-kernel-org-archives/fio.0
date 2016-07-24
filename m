Return-Path: <axboe@kernel.dk>
Subject: Re: "errror=Invalid or incomplete multibyte or wide character" &
 "verify: bad header numberio" errors
References: <nmthlt$4m6$1@ger.gmane.org>
 <CALjAwxi_XeY4_yWf=xrNbNpF+a5-p5MjUSXUNQk=o0e0s7ASNw@mail.gmail.com>
 <nn2n46$tbh$1@ger.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b7df6e5e-0fd1-ac62-a144-5c780a8e55ec@kernel.dk>
Date: Sun, 24 Jul 2016 15:46:28 -0600
MIME-Version: 1.0
In-Reply-To: <nn2n46$tbh$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Saeed <ionictea@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/24/2016 09:33 AM, Saeed wrote:
> I reduced the number of jobs down to 1 and now getting no errors.

That was your problem. If you look at your original fio output:

"Multiple writers may overwrite blocks that belong to other jobs. This 
can cause verification failures. "

fio warns you about that as well. And your actual verification errors 
show that to be the case as well:

"verify: bad header numberio 2985, wanted 11 at file /dev/sdb offset
1224704"

-- 
Jens Axboe


