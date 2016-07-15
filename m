Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59811 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbcGOAvF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 20:51:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bNrLH-0003Hn-Aw
	for fio@vger.kernel.org; Fri, 15 Jul 2016 02:50:59 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 15 Jul 2016 02:50:59 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Fri, 15 Jul 2016 02:50:59 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio2gnuplot issue
Date: Thu, 14 Jul 2016 19:50:44 -0500
Message-ID: <nm9c13$dsi$1@ger.gmane.org>
References: <nlha7f$a7q$2@ger.gmane.org> <nlhb66$rd6$1@ger.gmane.org> <CALjAwxjnttcDporW3ep6hi7URVUCnD=GCwdYpmR10DHkQPTfEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Thanks!  I suspected it must've been something with gnuplot because it 
seems to work with Ubuntu 15.xx (running Gnuplot 4.xx) and breaks with 
Ubuntu 16.xxx (running Gnuplot 5.xx).

I tried contacting Erwan for an answer on a possible update but gotten 
no response.

On 2016-07-14 05:22:55 +0000, Sitsofe Wheeler said:

>> 
>> On 2016-07-05 21:52:47 +0000, Saeed Tea said:
>> 
>>> I'm trying generate graphs with logs create by fio using fio2gnu and keep
>>> getting this error when generating graphs for iops or bandwidth:
>>> 
>>> 1 files Selected with pattern '*_iops.log'
>>> |-> 4k.results_iops.log
>>> 
>>> Running gnuplot Rendering
>>> "/usr/share/fio//math.gpm", line 25: no datablock named $1
>>> 
>>> "/usr/share/fio//graph2D.gpm", line 25: no datablock named $1
>>> 
>>> 
>>> Rendering traces are available in the current directory
>>> 
>>> Checking the directory listing only shows this file:
>>> 
>>> $3.png
>>> 
>>> Am I missing something in fio profile??  Here's a snippet:
> 
> This happens because you have gnuplot 5 and it dropped support for the
> $1 way of passing arguments on the command line (see
> http://stackoverflow.com/a/31815067/4513656 ). To get around this both
> the .gpm and and fio2gnuplot would have to be rewritten to use a
> different means of passing parameters in. I'm not sure any method
> beyond using environment variables would work for both old and new
> versions of gnuplot...
> 
> CC'ing the original author of fio2gnuplot for comment.



