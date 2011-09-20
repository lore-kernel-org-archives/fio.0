Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:47316
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1ITTzm (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 Sep 2011 15:55:42 -0400
Message-ID: <4E78EFBD.2060603@kernel.dk>
Date: Tue, 20 Sep 2011 21:55:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio benchmark output "error=Too many open files
References: <CAG1+85Fp3HRn+MMQho8X4-34P7mDDdQPj455jCUW3O=wfzPRcQ@mail.gmail.com>
In-Reply-To: <CAG1+85Fp3HRn+MMQho8X4-34P7mDDdQPj455jCUW3O=wfzPRcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: yan li <01jay.ly@gmail.com>
Cc: fio@vger.kernel.org

On 2011-09-20 12:06, yan li wrote:
> Hi fio users and developers,
>     When I run fio benchmark, there are some error in the screen.
>     Does someone meet the same circumstances ?
>     Thanks, ^_^
> 
> #fio fio.cfg
> ......
> fio: pid=29128, err=24/file:filesetup.c:529,
> func=open(/mnt/rw1/rw1.168.2), error=Too many open files
> fio: pid=29039, err=24/file:filesetup.c:529, func=open(/mnt/rw.79.2),
> error=Too many open files
> fio: pid=29040, err=24/file:filesetup.c:529, func=open(/mnt/rw.80.2),
> error=Too many open files
> fio: pid=29074, err=24/file:filesetup.c:529, func=open(/mnt/rw.114.2),
> error=Too many open files
> fio: pid=29026, err=24/file:filesetup.c:529, func=open(/mnt/rw.66.2),
> error=Too many open files
> ......

Fio keeps all of its data files open, and from the jobs below, you have

3*8*128 = 3072

in data files alone, add some house keeping, and perhaps you hit the
limit? Seems a bit odd, given that the typical max is somewhat larger,
and your selinux settings allow higher as well. What do

/proc/sys/fs/file-{nr,max}

show when this happens? You could also freeze fio at this point and ls
-l /proc/pid-of-fio/fd/ to see if something strange is being held open.

-- 
Jens Axboe

