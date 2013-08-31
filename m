Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3HaE3m (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Aug 2013 00:29:42 -0400
Date: Fri, 30 Aug 2013 22:29:40 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: --minimal does not work in client/server mode
Message-ID: <20130831042940.GT21481@kernel.dk>
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com>
 <51F683EC.4090402@kernel.dk>
 <CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
 <51F696E7.1070206@kernel.dk>
 <CAOtMX2h6mtRVQWCX2DCwoLxxcXUKWAGA8-gBfM3gu96QNKFmAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtMX2h6mtRVQWCX2DCwoLxxcXUKWAGA8-gBfM3gu96QNKFmAA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: asomers@gmail.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Aug 29 2013, asomers@gmail.com wrote:
> On Mon, Jul 29, 2013 at 10:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 07/29/2013 10:00 AM, asomers@gmail.com wrote:
> > > I found a few more things that need to be suppressed in terse mode.
> > > The updated patch is here.  In addition to working with JSON output,
> > > we also need to check that the patch doesn't break disk statistics.  I
> > > haven't tried using those at all yet.
> > >
> > > https://gist.github.com/asomers/6105396
> >
> > I would suggest making a show_thread_status_all() that does something ala:
> >
> > void show_thread_status_all()
> > {
> >    if (is_backend)
> >        fio_server_send_ts(ts, rs);
> >    else if (output_format == FIO_OUTPUT_TERSE)
> >        show_thread_status_terse(ts, rs);
> >    else if (output_format == FIO_OUTPUT_JSON) {
> >        struct json_object *tmp = show_thread_status_json(ts, rs);
> >
> >        json_array_add_value_object(array, tmp);
> >    } else
> >        show_thread_status(ts, rs);
> > }
> >
> > which should work for all. If you could check and fix the json bit too,
> > bonus points, and I'll test and commit it. Thanks!
> >
> >
> > --
> > Jens Axboe
> >
> 
> Try this new set of patches.  They get json output working in client/server
> mode. This is my third attempt to send them; your server keeps rejecting
> gmail's HTML.  Sorry for the overposts.
> 
> https://gist.github.com/asomers/6105396

Thanks! I'll take a look at this soon and hopefully get it added.

-- 
Jens Axboe

