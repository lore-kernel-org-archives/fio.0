Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:45583 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab3KZLBF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Nov 2013 06:01:05 -0500
Message-ID: <52947F70.6000002@cran.org.uk>
Date: Tue, 26 Nov 2013 11:01:04 +0000
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: --server broken on Windows (2.1.1 and 2.0.14)
References: <20131126063901.GA4631@sucs.org>
In-Reply-To: <20131126063901.GA4631@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 11/26/2013 6:39 AM, Sitsofe Wheeler wrote:
> The problem with waitpid when trying to connect to an fio in server mode
> as mentioned in http://www.spinics.net/lists/fio/msg02319.html from
> August still seems to be here with the prebuilt 2.1.1 Windows binaries
> on http://www.bluestop.org/fio/ . Additionally the Windows client seems
> to be unable to read job files when connecting to the server:
> ...
>
> Does anyone have any ideas?


I've implemented waitpid() and writev() in 2.1.4 and will build new 
binaries, but --server remains broken because fio uses fork() now and 
that's almost impossible to support on Windows without resorting to Cygwin.

-- 
Bruce Cran
