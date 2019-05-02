Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726327AbfEBPVE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 May 2019 11:21:04 -0400
Date: Thu, 2 May 2019 17:20:47 +0200
From: Lars Marowsky-Bree <lmb@suse.com>
Subject: Re: Help with HTTP engine with S3
Message-ID: <20190502152047.3mf6d3n5ul5ho7jz@suse.com>
References: <CAKRObaZ5N=trawpfu3fj8xAP6+3mLHp8Lgo0DZ6Aac56O6epww@mail.gmail.com>
 <CALjAwxgiednQRtcv7HYssQ0Xqw1x24gPd+sN5OKA7F4aqsiOuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALjAwxgiednQRtcv7HYssQ0Xqw1x24gPd+sN5OKA7F4aqsiOuA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Surendar Chandra <surendar@acm.org>, fio <fio@vger.kernel.org>

On 2019-04-19T10:32:14, Sitsofe Wheeler <sitsofe@gmail.com> wrote:

Yes, that's how this currently works.

Every IO is essentially translated to a separate object.

S3/Swift do not support overwrites, you can only PUT a single object as
a whole. (Multipart uploads are handled somewhat differently, but the
end result is the same.)

> > [create]
> > filename=/data.dat
> > rw=readwrite
> > bs=2m
> > size=50g
> > io_size=10m
> >
> > The PUT goes to /data.dat_0_2097152 signifying offset (0) and
> > xfer_buflen of 2M. Except, AWS seems to create the file
> > /data.dat_0_2097152. How do I make AWS understand this format?
> > Shouldn’t we be using RANGE requests?

"filename" is misleading. It's essentially just the prefix. The engine
is a bit of an exploit - it uses the offset/blocksize as an extension
and thus creates many separate objects.

What you want to do, S3/AWS can't do.


Regards,
    Lars

-- 
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
"Architects should open possibilities and not determine everything." (Ueli Zbinden)

