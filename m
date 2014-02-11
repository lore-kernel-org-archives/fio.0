Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <52FA7A32.1090307@kernel.dk>
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
Date: Tue, 11 Feb 2014 12:52:36 -0800
Message-ID: <CAF+0mvnGA9a3qMNcH06eOXg8B_rSqGCgDdOfCq1A1_uagZn_9g@mail.gmail.com>
Subject: Re: Fio 2.1.5 release upcoming
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> Just run current -git, I applied the patch.

Ok done, but write io is still 1000 MB.  I checked the size of each
test file and they are all the same size, 21474836 bytes.  Not sure if
the patch was supposed to make a difference here but just fyi.

