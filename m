Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:19922 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3AJShZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 13:37:25 -0500
Message-ID: <50EF080D.2020405@cran.org.uk>
Date: Thu, 10 Jan 2013 18:27:25 +0000
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: problems writing on windows
References: <27A430545AF420468AEE097737EE633A0C47E3D471@MBX29.exg5.exghost.com>
In-Reply-To: <27A430545AF420468AEE097737EE633A0C47E3D471@MBX29.exg5.exghost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10/01/2013 18:00, Carl Zwanzig wrote:
> I'm having what sounds like the same problem reported by Dallas Clement back in April- writes to a physical drive don't seem to do anything

I don't know why bits of the output are missing - in 2.0.12.2 I'd expect 
an error message and a summary line at the bottom to be displayed.

I suspect the problem is that Windows blocks writes to areas of a raw 
disk which contain volumes.

-- 
Bruce Cran
