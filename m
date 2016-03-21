Return-Path: <jeff.furlong@hgst.com>
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: Windows make fails
Date: Mon, 21 Mar 2016 18:59:31 +0000
Message-ID: <CY1PR0401MB14665DFD356E947839CD8F25F78F0@CY1PR0401MB1466.namprd04.prod.outlook.com>
References: <BN3PR0401MB14579B2785DF531EC8BC867BF78C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56EEC480.8030709@kernel.dk>
In-Reply-To: <56EEC480.8030709@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

The current git fixes the Windows build error.

However, the current git build on Windows only shows fio version 2.8.

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk] =

Sent: Sunday, March 20, 2016 8:41 AM
To: Jeff Furlong <jeff.furlong@hgst.com>; fio@vger.kernel.org; Bruce Cran <=
bruce@cran.org.uk>
Subject: Re: Windows make fails

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

> Also, the Windows builds only seem to pick up the base version number (fi=
o 2.7 or fio 2.8), not the latest git version (fio 2.8-123).  So the last r=
elease (e.g. 2.8) build cannot be distinguishable from the latest git versi=
on (e.g 2.8-123).

Someone more knowledgable on the windows build needs to answer that... =

Bruce, would adding the -git version be easy enough to do? It's available i=
n the FIO_VERSION define.

--
Jens Axboe

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality N=
otice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or l=
egally privileged information of WDC and/or its affiliates, and are intende=
d solely for the use of the individual or entity to which they are addresse=
d. If you are not the intended recipient, any disclosure, copying, distribu=
tion or any action taken or omitted to be taken in reliance on it, is prohi=
bited. If you have received this e-mail in error, please notify the sender =
immediately and delete the e-mail in its entirety from your system.


