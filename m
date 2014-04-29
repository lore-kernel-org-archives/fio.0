Return-Path: <axboe@kernel.dk>
Message-ID: <535F0803.3060704@kernel.dk>
Date: Mon, 28 Apr 2014 20:01:39 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Ubuntu-13.10-- fio: engine libaio not loadable
References: <89470388ACB8A24491F3E64F24385FD75A488BB5@wdscexmb03>
In-Reply-To: <89470388ACB8A24491F3E64F24385FD75A488BB5@wdscexmb03>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Stephen Nichols <Stephen.Nichols@wdc.com>, "'fio@vger.kernel.org'" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-04-28 17:59, Stephen Nichols wrote:
> Greetings all.
>
> I have a issues using the libaio engine on Ubuntu-13.10. FIO version 2.1.8 is installed and runs fine if I leave the -ioengine option out of my configuration (it defaults to ioengine sync). When I try and use -ioengine=libaio I receive the errors
>
> fio: engine libaio not loadable
> fio: failed to lead engine libaio
>
> I have use these identical workloads on Suse 11, RH6, and Cent OS systems with no issue. And even after specifically installing libaio on Ubuntu I still see these issues.
>
> apt-get install libaio1
>
> Any ideas? I'm suspecting this is user error but I can't see where I went wrong.

You need libaio-devel (or whatever the package is called) installed, 
otherwise fio can't build with libaio enabled. Watch the configure 
output, it'll tell you what it detects:

$ ./configure
[...]
Linux AIO support             yes

This is also detailed in the "Building" section in the README that came 
with fio.

-- 
Jens Axboe


