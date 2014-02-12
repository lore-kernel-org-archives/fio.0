Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <52FA992D.6050507@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
	<20140209205744.GB2750@kernel.dk>
	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
	<20140210221420.GD4096@kernel.dk>
	<CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>
	<52F95D7B.1000002@kernel.dk>
	<CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
	<20140211152721.GA19057@kernel.dk>
	<CAF+0mvmRUiPo7ZQQTUnUimDzJJ-rO+rkuKmRcUwKcwtvaBQfLw@mail.gmail.com>
	<52FA7A32.1090307@kernel.dk>
	<CAF+0mvnGA9a3qMNcH06eOXg8B_rSqGCgDdOfCq1A1_uagZn_9g@mail.gmail.com>
	<52FA9442.3090309@kernel.dk>
	<CAF+0mv=MifZvs6Nj72x0=ed5+cOKKsNJaLGn+PHEzhAAn6xWXQ@mail.gmail.com>
	<52FA992D.6050507@kernel.dk>
Date: Tue, 11 Feb 2014 16:01:32 -0800
Message-ID: <CAF+0mv=Ab8VEibMJAdT24+ySYyzcQ2E9YWtHGt6aOFrhdMWN+A@mail.gmail.com>
Subject: Re: Fio 2.1.5 release upcoming
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> Weird, this is what I get with your config file:
>
> [...]
>
> Run status group 0 (all jobs):
>   WRITE: io=1023.9MB, aggrb=130026KB/s, minb=130026KB/s, maxb=130026KB/s,
> mint=8063msec, maxt=8063msec
>
> and each file in temp/ is 21474836, which should give us 1023.99MB of IO.
>

Well, that is weird.  I tried on two systems now and both report 1000 MB.

