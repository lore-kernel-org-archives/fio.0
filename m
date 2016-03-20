Return-Path: <axboe@kernel.dk>
Subject: Re: Windows make fails
References: <BN3PR0401MB14579B2785DF531EC8BC867BF78C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56EEC480.8030709@kernel.dk>
Date: Sun, 20 Mar 2016 09:40:48 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14579B2785DF531EC8BC867BF78C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

On 03/18/2016 11:29 AM, Jeff Furlong wrote:
> Hi All,
> The latest fio version seems to fail building on Windows:
>
>    LINK t/gen-rand
> lib/pattern.o: In function `parse_number':
> /fio-fio-2.8_win/lib/pattern.c:78: undefined reference to `strcasestr'
> collect2: error: ld returned 1 exit status
> Makefile:396: recipe for target 't/gen-rand' failed
> make: *** [t/gen-rand] Error 1

Current -git should fix that.

> Also, the Windows builds only seem to pick up the base version number (fio 2.7 or fio 2.8), not the latest git version (fio 2.8-123).  So the last release (e.g. 2.8) build cannot be distinguishable from the latest git version (e.g 2.8-123).

Someone more knowledgable on the windows build needs to answer that... 
Bruce, would adding the -git version be easy enough to do? It's 
available in the FIO_VERSION define.

-- 
Jens Axboe


