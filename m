Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52580 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2JHR0z (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Oct 2012 13:26:55 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so4100340oag.19
        for <fio@vger.kernel.org>; Mon, 08 Oct 2012 10:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210061218.18040.Martin@lichtvoll.de>
References: <CAN2qFaq_1yBQRhzg8YQ-t0ChDCAAD+oRPwbcnDcD5LJm=rFkbw@mail.gmail.com>
	<201210061218.18040.Martin@lichtvoll.de>
Date: Mon, 8 Oct 2012 10:26:54 -0700
Message-ID: <CAN2qFaoLtcrh4HGSwit_BZry7yorV2y0qGh8a6XO3RHwBF43rw@mail.gmail.com>
Subject: Re: How to perform limited IO on large file over entire extent of file?
From: Matt Hayward <matt.hayward@delphix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

Hello Martin,
  Thank you for the response.
  My understanding is that offset= can cause testing to begin at a
particular offset in a file, but I believe the region of the file that
will be used for the tests are between "offset" and "offset+size."
  I want to know how to perform X bytes of random I/O between offset 0
and the end of the file, where X is not the size of the file.

On Sat, Oct 6, 2012 at 3:18 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Am Montag, 1. Oktober 2012 schrieb Matt Hayward:
> > Hello,
>
> Hi Matt,
>
> >    I frequently want to perform a set amount (e.g. 1 GB) of random I/O
> > over very large files or devices (e.g. 1 TB).
> >
> >    I have noticed that when using the "size" argument to control the
> > amount of I/O, it also has the side effect of constraining the I/O to
> > the first "size" bytes of the file.
> >
> >    Is there a way to tell FIO to perform X bytes of random I/O on a
> > file of size Y and have the random I/O distributed throughout the
> > extent of Y where Y > X?
>
> How about
>
>        offset=int
>               Offset in the file to start I/O. Data before the offset will
>               not be touched.
>
>        offset_increment=int
>               If this is provided, then the real offset becomes the offset
>               + offset_increment * thread_number, where the thread  number
>               is  a  counter  that starts at 0 and is incremented for each
>               job. This option is useful if there are several  jobs  which
>               are  intended  to  operate on a file in parallel in disjoint
>               segments, with even spacing between the starting points.
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7




--
Matthew Hayward
Director Professional Services
Delphix

M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
