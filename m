Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:55215 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab2HPHBm (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Aug 2012 03:01:42 -0400
Message-ID: <502C9ABF.3000406@cran.org.uk>
Date: Thu, 16 Aug 2012 08:01:19 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: "nanosleep is not implemented" messages (Win7)
References: <CAHaS=Qz5Cvmj8692=8Z4G6Vsx0ByY2RSnGShN9Y=nXvVoLYy7Q@mail.gmail.com> <502BEEAF.8060708@cran.org.uk> <CAHaS=QwwfXPrwoYTtgq1z+KVs9qiK839J+8J4r7mfteE==3_3w@mail.gmail.com>
In-Reply-To: <CAHaS=QwwfXPrwoYTtgq1z+KVs9qiK839J+8J4r7mfteE==3_3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 16/08/2012 00:47, Greg Sullivan wrote:
> Thanks Bruce, however it is not working at all for me. I receive the
> following whenever I attempt to run fio

Sorry, there was a bug on 32-bit versions due to overflow of a 32-bit 
time_t variable. I've fixed it and uploaded fio-2.0.8-18-g525f-1 packages.

-- 
Bruce Cran
