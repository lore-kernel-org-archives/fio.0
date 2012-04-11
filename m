Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:51052 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab2DKAWI convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 10 Apr 2012 20:22:08 -0400
References: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
In-Reply-To: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7694153F-BA83-41AF-BCB4-C857D0E1B9BB@cran.org.uk>
From: Bruce Cran <bruce@cran.org.uk>
Subject: Re: Running FIO on Windows on given partition or raw device
Date: Wed, 11 Apr 2012 01:14:05 +0100
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Neependra Khare <neependra.khare@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10 Apr 2012, at 10:04, Neependra Khare <neependra.khare@gmail.com> wrote:

> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
> --filename=E:\filename --name=hddBaseline --stonewall
> 
> In all these cases I do not see any IO happening on "E" drive using
> "perfmon". All the IO happens on the root drive("C").

':' is a file name separator in fio (so e:\filename is writing to \filename on the current disk) so you should try escaping it, e.g. --filename=E\:\filename .

-- 
Bruce Cran