Return-Path: <jmoyer@redhat.com>
MIME-Version: 1.0
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 7 Feb 2011 07:56:26 -0700
Subject: Re: test definition help needed
Message-ID: <x49ei7j99lx.fsf@segfault.boston.devel.redhat.com>
References: <4D4C51B2.1090700@austin.ibm.com>
 <4D4F0C09.2010601@fusionio.com>
	<x49oc6n9ak6.fsf@segfault.boston.devel.redhat.com>
	<4D50057F.6010105@fusionio.com>
In-Reply-To: <4D50057F.6010105@fusionio.com> (Jens Axboe's message of "Mon,
 7	Feb 2011 15:45:19 +0100")
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Steven Pratt <slpratt@austin.ibm.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe <jaxboe@fusionio.com> writes:

> Good point. I used to have a warning for that, but dropped it since it
> got annoying when I was testing the buffered aio patches. Perhaps I
> should reinstate it.
>
> In any case, if the result is inspected, it'll be apparent that the
> queue depth was 1 throughout the run.

It might be apparent, but it won't be obvious *why* it's happening for
the uninitiated.  ;-)  It may well be worth putting the warning back
in.

Cheers,
Jeff

