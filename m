Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:16854 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2HOMyt (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Aug 2012 08:54:49 -0400
Message-ID: <502B9C16.2070404@cran.org.uk>
Date: Wed, 15 Aug 2012 13:54:46 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: "nanosleep is not implemented" messages (Win7)
References: <CAHaS=Qz5Cvmj8692=8Z4G6Vsx0ByY2RSnGShN9Y=nXvVoLYy7Q@mail.gmail.com>
In-Reply-To: <CAHaS=Qz5Cvmj8692=8Z4G6Vsx0ByY2RSnGShN9Y=nXvVoLYy7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 15/08/2012 13:43, Greg Sullivan wrote:
> When I set a job rate (rate=<rate>), I'm receiving many "nanosleep is
> not implemented" messages. Is this expected?
> Platform: Windows 7 32-bit.

It's one of the POSIX functions that haven't been implemented on Windows 
yet. I'll add it and create a new build today.

-- 
Bruce Cran
