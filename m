Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:24657 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYLIIDR (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Dec 2008 03:03:17 -0500
Date: Tue, 9 Dec 2008 09:03:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: terse output for IO latencies
Message-ID: <20081209080303.GR23742@kernel.dk>
References: <4DCBAA39733E8048992FB7737126041910FFD998@gsmbnbp23es.firmwide.corp.gs.com> <e2a756a20812021537j315f4f4ev95b7fa5c4d32ddcf@mail.gmail.com> <4DCBAA39733E8048992FB7737126041910FFD9BE@gsmbnbp23es.firmwide.corp.gs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCBAA39733E8048992FB7737126041910FFD9BE@gsmbnbp23es.firmwide.corp.gs.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Baur, Eric" <Eric.Baur@gs.com>
Cc: Daniel Buggie <danielabuggie@gmail.com>, fio@vger.kernel.org


Anyone care to send a proposed fix for this? Even a pseudo patch of
HOWTO addition would be appreciated, then I can take care of the rest.


On Wed, Dec 03 2008, Baur, Eric wrote:
> In my haste, I overlooked the character preceding "sec" when reading the
> source. Nonetheless, it seems preferable to maintain consistency in
> reporting of latency stats in <=us rather than jumping to <=ms after
> 1000us.
> 
> Thanks for clarifying.
> 
> -Eric
> 
> -----Original Message-----
> From: Daniel Buggie [mailto:danielabuggie@gmail.com] 
> Sent: Tuesday, December 02, 2008 6:37 PM
> To: Baur, Eric
> Cc: fio@vger.kernel.org
> Subject: Re: terse output for IO latencies
> 
> On Mon, Dec 1, 2008 at 11:45 AM, Baur, Eric <Eric.Baur@gs.com> wrote:
> > In the HOWTO for fio, the terse output for IO latencies is described
> as:
> >
> > "IO latencies: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, >=2000"
> >
> > Output from certain test runs have been observed to have more than 11
> > values for IO latencies, For example:
> >
> > 0.01%, 0.00%, 0.01%, 0.01%, 0.06%, 0.73%, 35.42%, 7.19%, 3.03%, 0.52%,
> > 2.79%, 13.67%, 32.84%, 2.86%, 0.84%, 0.02%, 0.01%, 0.00%, 0.00%,
> 0.00%,
> > 0.00%, 0.00%
> >
> > What are the proper labels for this output?
> >
> > Thanks,
> > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> I had a similar question last week (not sure if the message got eaten
> by the server or by the holiday here in the states).  From what my
> very rusty C skills and the source tell me, it appears the terse
> output gives the same values as the regular output.  The only
> difference being that the terse output cannot skip the brackets that
> have no hits.  So I believe the values can be derived from this block
> of code from the source:
> 
> static void show_lat_u(double *io_u_lat_u)
> {
>         const char *ranges[] = { "2=", "4=", "10=", "20=", "50=",
> "100=",
>                                  "250=", "500=", "750=", "1000=", };
> 
>         show_lat(io_u_lat_u, FIO_IO_U_LAT_U_NR, ranges, "usec");
> }
> 
> static void show_lat_m(double *io_u_lat_m)
> {
>         const char *ranges[] = { "2=", "4=", "10=", "20=", "50=",
> "100=",
>                                  "250=", "500=", "750=", "1000=",
> "2000=",
>                                  ">=2000=", };
> 
> In which case, the documentation should probably be updated to reflect
> that. Can anyone familiar with the code confirm this?
> 
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jens Axboe

