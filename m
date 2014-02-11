Return-Path: <paulliesworld@yahoo.com>
From: "Paul Alcorn" <paulliesworld@yahoo.com>
References: <20140206192135.GB3950@kernel.dk>
In-Reply-To: <20140206192135.GB3950@kernel.dk>
Subject: RE: Fio 2.1.5 release upcoming
Date: Tue, 11 Feb 2014 05:22:07 -0600
Message-ID: <005001cf271b$807ed630$817c8290$@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

One problem I have noticed in windows is that the sequential workloads
(read/write) do not scale correctly with different thread counts. Sequential
measurements do not work correctly at all. 

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
Of Jens Axboe
Sent: Thursday, February 6, 2014 1:22 PM
To: fio@vger.kernel.org
Subject: Fio 2.1.5 release upcoming

Hi,

I've been late on this release, originally wanted it out around Christmas.
But various issues here and there prevented that. However, I now think we
are getting pretty close. It'd be great if folks running on non-linux
systems could compile and ensure that everything is in working order,
because otherwise I'm going to assume that it is...

Similarly, if you know of bugs (particularly regressions from previous
releases), speak up now so we can get them fixed before 2.1.5 is cut.

I'll wait until Monday to tag the release.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body
of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html


