Return-Path: <fio-owner@vger.kernel.org>
Received: from server506g.appriver.com ([50.56.144.37]:61123 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968Ab3LKRmO convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 11 Dec 2013 12:42:14 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Blktrace replay in FIO runs only 1 Job when numjobs>1 in FIO
Date: Wed, 11 Dec 2013 17:37:12 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB0AE1DD@DAGN05A-E6.exg6.exghost.com>
References: <CAEyTGCf_7AqvW45jGouruCoeKqKP7kCs0XGfNoEfGC1X3ZwsWQ@mail.gmail.com>
 <CAEyTGCcno3xUr=4n6JBiAbr56CeA75K-HpwUzHGbas4XEVCPwg@mail.gmail.com>
In-Reply-To: <CAEyTGCcno3xUr=4n6JBiAbr56CeA75K-HpwUzHGbas4XEVCPwg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lakshmi <sendtold@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

(please don't top-post)

> On Wed, Dec 4, 2013 at 11:04 AM, Lakshmi <sendtold@gmail.com> wrote:

> > I ran this job and while this job was running I ran a  Blktrace and
> > parsed it to a .bin file.
> >
> > The actual FIO run showed the results of all 8 jobs as below,

> > However when I replay the .bin trace using read_iolog, the result
> > shows only 1 job's results as below,

multiple fio jobs are entirely a user-mode concept and blktrace is operating in the kernel. It doesn't know about what's submitting i/o requests, only that they're all going to /dev/sdb (or whatever). (Check the man page for blktrace.)

z!

