Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:16706 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab2HUQ4z (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Aug 2012 12:56:55 -0400
Message-ID: <5033BDD4.4070506@cran.org.uk>
Date: Tue, 21 Aug 2012 17:56:52 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Wanted to use "opendir" but not implemented on Windows
References: <CAHaS=QyW5g7bf=Y6xU2ZV1SpzKqiMGP-LnZab2y+0TYB8AwemA@mail.gmail.com>
In-Reply-To: <CAHaS=QyW5g7bf=Y6xU2ZV1SpzKqiMGP-LnZab2y+0TYB8AwemA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 19/08/2012 06:54, Greg Sullivan wrote:
> I attempted to use "opendir" to open every file in a directory, but it
> says that it's not implemented.

I've implemented a few more functions 
(opendir/closedir/readdir/openlog/closelog/syslog) - can you try 
fio-2.0.8-21-gad9c0 from http://bluestop.org/fio/ please?

-- 
Bruce Cran
