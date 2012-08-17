Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:10477 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab2HQMpS (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 08:45:18 -0400
Message-ID: <502E3CDA.1050200@cran.org.uk>
Date: Fri, 17 Aug 2012 13:45:14 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Test files being created twice as large as requested (Win7)
References: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com> <502E387D.9030901@cran.org.uk> <CAHaS=QyJhnce=qnexyaW0Sp0+Aht9sZzLTGDF36FTyvNezauXg@mail.gmail.com>
In-Reply-To: <CAHaS=QyJhnce=qnexyaW0Sp0+Aht9sZzLTGDF36FTyvNezauXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 17/08/2012 13:33, Greg Sullivan wrote:
> My config contains only one job, and it is a read, not a write. The
> only writing that should occur is the initial lay down of the test
> file.

Sorry, yes - the reads will be causing the file to be extended with zeroes.

-- 
Bruce
