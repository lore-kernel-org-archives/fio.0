Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43285 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JFKST (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Oct 2012 06:18:19 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: How to perform limited IO on large file over entire extent of file?
Date: Sat, 6 Oct 2012 12:18:17 +0200
References: <CAN2qFaq_1yBQRhzg8YQ-t0ChDCAAD+oRPwbcnDcD5LJm=rFkbw@mail.gmail.com> (sfid-20121001_233815_502659_99AAB276)
In-Reply-To: <CAN2qFaq_1yBQRhzg8YQ-t0ChDCAAD+oRPwbcnDcD5LJm=rFkbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210061218.18040.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matt Hayward <matt.hayward@delphix.com>
Cc: fio@vger.kernel.org

Am Montag, 1. Oktober 2012 schrieb Matt Hayward:
> Hello,

Hi Matt,

>    I frequently want to perform a set amount (e.g. 1 GB) of random I/O
> over very large files or devices (e.g. 1 TB).
> 
>    I have noticed that when using the "size" argument to control the
> amount of I/O, it also has the side effect of constraining the I/O to
> the first "size" bytes of the file.
> 
>    Is there a way to tell FIO to perform X bytes of random I/O on a
> file of size Y and have the random I/O distributed throughout the
> extent of Y where Y > X?

How about

       offset=int
              Offset in the file to start I/O. Data before the offset will
              not be touched.

       offset_increment=int
              If this is provided, then the real offset becomes the offset
              + offset_increment * thread_number, where the thread  number
              is  a  counter  that starts at 0 and is incremented for each
              job. This option is useful if there are several  jobs  which
              are  intended  to  operate on a file in parallel in disjoint
              segments, with even spacing between the starting points.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
