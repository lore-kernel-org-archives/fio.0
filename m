Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35292 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbcGUP4G (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Jul 2016 11:56:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bQGKL-0006c0-0T
	for fio@vger.kernel.org; Thu, 21 Jul 2016 17:55:57 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 21 Jul 2016 17:55:56 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Thu, 21 Jul 2016 17:55:56 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio2gnuplot issue
Date: Thu, 21 Jul 2016 10:55:51 -0500
Message-ID: <nmqra7$5s2$1@ger.gmane.org>
References: <nlha7f$a7q$2@ger.gmane.org> <nlhb66$rd6$1@ger.gmane.org> <CALjAwxjnttcDporW3ep6hi7URVUCnD=GCwdYpmR10DHkQPTfEw@mail.gmail.com> <nm9c13$dsi$1@ger.gmane.org> <CALjAwxja9aXziSs51oHL1XYyVtbME0+6BTZ_g8v8B3hpwGG-zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I ran a couple of tests with your rev of fio2gnuplot and it seems to 
work fine with gnuplot 5.x on ubuntu 16.x - thanks~

On 2016-07-17 08:47:28 +0000, Sitsofe Wheeler said:

> On 15 July 2016 at 01:50, Saeed 
> <ionictea@gmail.com> wrote:
>> Thanks!  I suspected it must've been something with gnuplot because it seems
>> to work with Ubuntu 15.xx (running Gnuplot 4.xx) and breaks with Ubuntu
>> 16.xxx (running Gnuplot 5.xx).
>> 
>> I tried contacting Erwan for an answer on a possible update but gotten no
>> response.
> 
> I've posted some changes that seem to get things going under gnuplot 5
> for me. Could you check to see if
> https://github.com/axboe/fio/pull/208 lets things work for you on
> Ubuntu 16.04?



